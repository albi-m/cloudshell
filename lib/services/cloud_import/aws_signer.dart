/// Minimal AWS Signature V4 signer for CloudShell.
///
/// Implements the AWS Signature Version 4 signing process for
/// making authenticated requests to AWS APIs (EC2, etc.).
/// Only supports GET requests with query-string parameters.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Signs AWS API requests using Signature Version 4.
class AwsSigner {
  AwsSigner({
    required this.accessKeyId,
    required this.secretAccessKey,
    required this.region,
    required this.service,
  });

  final String accessKeyId;
  final String secretAccessKey;
  final String region;
  final String service;

  /// Signs a GET request and returns the headers to include.
  ///
  /// The [uri] should be the full URL including query parameters.
  /// Returns a map of headers to add to the request.
  Map<String, String> signGetRequest(Uri uri) {
    final now = DateTime.now().toUtc();
    final dateStamp = _formatDate(now);
    final amzDate = _formatDateTime(now);
    final host = uri.host;

    // Canonical headers
    final canonicalHeaders = 'host:$host\nx-amz-date:$amzDate\n';
    const signedHeaders = 'host;x-amz-date';

    // Canonical query string (sorted)
    final queryParams = Map<String, String>.from(uri.queryParameters);
    final sortedKeys = queryParams.keys.toList()..sort();
    final canonicalQueryString = sortedKeys
        .map((k) =>
            '${Uri.encodeQueryComponent(k)}=${Uri.encodeQueryComponent(queryParams[k]!)}')
        .join('&');

    // Hash of empty payload (GET request)
    final payloadHash = sha256.convert([]).toString();

    // Canonical request
    final canonicalRequest = [
      'GET',
      uri.path.isEmpty ? '/' : uri.path,
      canonicalQueryString,
      canonicalHeaders,
      signedHeaders,
      payloadHash,
    ].join('\n');

    // String to sign
    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    // Signing key
    final signingKey = _deriveSigningKey(dateStamp);

    // Signature
    final signature = Hmac(sha256, signingKey)
        .convert(utf8.encode(stringToSign))
        .toString();

    // Authorization header
    final authorization =
        'AWS4-HMAC-SHA256 Credential=$accessKeyId/$credentialScope, '
        'SignedHeaders=$signedHeaders, Signature=$signature';

    return {
      'Authorization': authorization,
      'X-Amz-Date': amzDate,
      'Host': host,
    };
  }

  Uint8List _deriveSigningKey(String dateStamp) {
    final kDate = _hmacSha256(
        utf8.encode('AWS4$secretAccessKey'), utf8.encode(dateStamp));
    final kRegion = _hmacSha256(kDate, utf8.encode(region));
    final kService = _hmacSha256(kRegion, utf8.encode(service));
    return _hmacSha256(kService, utf8.encode('aws4_request'));
  }

  Uint8List _hmacSha256(List<int> key, List<int> data) {
    final hmac = Hmac(sha256, key);
    return Uint8List.fromList(hmac.convert(data).bytes);
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';

  String _formatDateTime(DateTime dt) =>
      '${_formatDate(dt)}T${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}${dt.second.toString().padLeft(2, '0')}Z';
}
