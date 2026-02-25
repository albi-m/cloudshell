/// DigitalOcean droplet import service for CloudShell.
///
/// Uses the DigitalOcean API v2 to list droplets and convert
/// them to host entries for import into the local database.
library;

import 'package:dio/dio.dart';

import '../../core/errors/app_exception.dart';

/// Represents a DigitalOcean droplet.
class DoDroplet {
  const DoDroplet({
    required this.id,
    required this.name,
    required this.status,
    this.publicIpv4,
    this.privateIpv4,
    this.region,
    this.image,
    this.sizeSlug,
  });

  final int id;
  final String name;
  final String status;
  final String? publicIpv4;
  final String? privateIpv4;
  final String? region;
  final String? image;
  final String? sizeSlug;

  bool get isActive => status == 'active';
  String get connectIp => publicIpv4 ?? privateIpv4 ?? '';

  /// Suggests a default SSH username based on the image name.
  String get suggestedUsername {
    final img = (image ?? '').toLowerCase();
    if (img.contains('ubuntu')) return 'ubuntu';
    if (img.contains('debian')) return 'admin';
    if (img.contains('fedora')) return 'fedora';
    if (img.contains('centos')) return 'centos';
    if (img.contains('freebsd')) return 'freebsd';
    return 'root';
  }
}

/// Service for fetching droplets from the DigitalOcean API.
class DoImportService {
  DoImportService({required this.apiToken});

  final String apiToken;

  /// Fetches all droplets from the DigitalOcean account.
  Future<List<DoDroplet>> listDroplets() async {
    final dio = Dio();
    try {
      dio.options.headers['Authorization'] = 'Bearer $apiToken';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.get<Map<String, dynamic>>(
        'https://api.digitalocean.com/v2/droplets?per_page=200',
      );

      final data = response.data;
      if (data == null || data['droplets'] == null) {
        throw const CloudImportException('Invalid API response');
      }

      final droplets = (data['droplets'] as List)
          .map((d) => DoDroplet(
                id: d['id'] as int,
                name: d['name'] as String,
                status: d['status'] as String,
                publicIpv4: _extractIp(d['networks'], 'public'),
                privateIpv4: _extractIp(d['networks'], 'private'),
                region: (d['region'] as Map?)?['slug'] as String?,
                image: (d['image'] as Map?)?['slug'] as String?,
                sizeSlug: d['size_slug'] as String?,
              ))
          .toList();

      return droplets;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const CloudImportException(
            'Invalid API token. Check your token and try again.');
      }
      throw CloudImportException(
          'Failed to fetch droplets: ${e.message}', e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw CloudImportException('Failed to fetch droplets', e);
    } finally {
      dio.close();
    }
  }

  String? _extractIp(dynamic networks, String type) {
    if (networks == null) return null;
    final v4 = (networks as Map)['v4'] as List?;
    if (v4 == null) return null;
    for (final net in v4) {
      if ((net as Map)['type'] == type) return net['ip_address'] as String?;
    }
    return null;
  }
}
