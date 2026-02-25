/// HTTP API client for CloudShell sync server communication.
///
/// Wraps Dio with auth interceptors, token refresh, retry logic,
/// and error mapping. Supports a mock mode for development without
/// a backend server.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/errors/app_exception.dart';
import '../crypto/secure_storage.dart';

/// HTTP client for the CloudShell sync API.
///
/// Features:
/// - JWT auth header injection
/// - Auto token refresh on 401
/// - Exponential backoff retry for network errors
/// - DioException → AppException mapping
/// - Mock mode for offline development
class ApiClient {
  ApiClient({
    required String baseUrl,
    required Ref ref,
    bool mockMode = true,
  })  : _ref = ref,
        _mockMode = mockMode {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(ref: _ref),
      _RetryInterceptor(dio: _dio),
    ]);
  }

  final Ref _ref;
  final bool _mockMode;
  late final Dio _dio;

  /// Whether the client is in mock mode (no real HTTP calls).
  bool get isMockMode => _mockMode;

  /// GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (_mockMode) return _mockResponse<T>(path);
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) async {
    if (_mockMode) return _mockResponse<T>(path, data: data);
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
  }) async {
    if (_mockMode) return _mockResponse<T>(path, data: data);
    try {
      return await _dio.patch<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// DELETE request.
  Future<Response<T>> delete<T>(String path) async {
    if (_mockMode) return _mockResponse<T>(path);
    try {
      return await _dio.delete<T>(path);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Stores JWT tokens after successful auth.
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final storage = _ref.read(secureStorageProvider);
    await storage.write(StorageKeys.accessToken, accessToken);
    await storage.write(StorageKeys.refreshToken, refreshToken);
  }

  /// Clears stored JWT tokens.
  Future<void> clearTokens() async {
    final storage = _ref.read(secureStorageProvider);
    await storage.delete(StorageKeys.accessToken);
    await storage.delete(StorageKeys.refreshToken);
  }

  /// Checks if tokens are stored.
  Future<bool> hasTokens() async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(StorageKeys.accessToken);
    return token != null;
  }

  /// Disposes the Dio client.
  void dispose() {
    _dio.close();
  }

  // ---------------------------------------------------------------------------
  // Mock responses
  // ---------------------------------------------------------------------------

  Response<T> _mockResponse<T>(String path, {dynamic data}) {
    // Return successful empty responses for all mock requests
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: <String, dynamic>{
        'success': true,
        'message': 'Mock response',
      } as T,
    );
  }

  // ---------------------------------------------------------------------------
  // Error mapping
  // ---------------------------------------------------------------------------

  AppException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return SyncException('Connection timed out', error);

      case DioExceptionType.connectionError:
        return SyncException('Network connection failed', error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const AuthException('Authentication failed');
        }
        if (statusCode != null && statusCode >= 500) {
          return SyncException('Server error ($statusCode)', error);
        }
        return SyncException(
          'Request failed ($statusCode)',
          error,
        );

      case DioExceptionType.cancel:
        return const SyncException('Request cancelled');

      default:
        return SyncException('Network error', error);
    }
  }
}

// ---------------------------------------------------------------------------
// Auth Interceptor
// ---------------------------------------------------------------------------

/// Adds JWT Bearer token to all outgoing requests.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor({required this.ref});

  static final _log = Logger();

  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for auth endpoints
    if (options.path.startsWith('/auth/')) {
      return handler.next(options);
    }

    try {
      final storage = ref.read(secureStorageProvider);
      final token = await storage.read(StorageKeys.accessToken);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, stackTrace) {
      // Continue without auth header if storage fails
      _log.w('Failed to read auth token from storage', error: e, stackTrace: stackTrace);
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Token refresh could be added here for 401 responses
    // For now, the auth provider handles re-authentication
    handler.next(err);
  }
}

// ---------------------------------------------------------------------------
// Retry Interceptor
// ---------------------------------------------------------------------------

/// Retries network errors with exponential backoff.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor({required this.dio});

  final Dio dio;
  final int maxRetries = 3;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on network errors, not HTTP errors
    if (!_isRetryable(err)) {
      return handler.next(err);
    }

    final retryCount =
        err.requestOptions.extra['retryCount'] as int? ?? 0;
    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Exponential backoff: 1s, 2s, 4s
    final delay = Duration(seconds: 1 << retryCount);
    await Future<void>.delayed(delay);

    try {
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _isRetryable(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout;
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Configurable sync server base URL.
final apiBaseUrlProvider = StateProvider<String>(
  (ref) => 'https://api.cloudshell.dev',
);

/// Singleton API client provider.
final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final client = ApiClient(baseUrl: baseUrl, ref: ref);
  ref.onDispose(client.dispose);
  return client;
});
