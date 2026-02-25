/// AWS EC2 instance import service for CloudShell.
///
/// Uses the EC2 DescribeInstances API with AWS Signature V4
/// authentication to list instances and convert them to host
/// entries for import into the local database.
library;

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:xml/xml.dart';

import '../../core/errors/app_exception.dart';
import 'aws_signer.dart';

/// Represents an AWS EC2 instance.
class Ec2Instance {
  const Ec2Instance({
    required this.instanceId,
    required this.state,
    this.publicIp,
    this.privateIp,
    this.name,
    this.keyName,
    this.platform,
    this.instanceType,
    this.region,
  });

  final String instanceId;
  final String state;
  final String? publicIp;
  final String? privateIp;
  final String? name;
  final String? keyName;
  final String? platform;
  final String? instanceType;
  final String? region;

  String get displayName => name ?? instanceId;
  String get connectIp => publicIp ?? privateIp ?? '';
  bool get isRunning => state == 'running';
  bool get isLinux => platform != 'windows';

  /// Suggests a default SSH username based on AMI name hints.
  String get suggestedUsername {
    final n = (name ?? '').toLowerCase();
    if (n.contains('ubuntu')) return 'ubuntu';
    if (n.contains('debian')) return 'admin';
    if (n.contains('centos')) return 'centos';
    if (n.contains('fedora')) return 'fedora';
    if (n.contains('rhel') || n.contains('red hat')) return 'ec2-user';
    if (n.contains('suse')) return 'ec2-user';
    return 'ec2-user'; // Default for Amazon Linux
  }
}

/// Common AWS regions for the dropdown picker.
const awsRegions = [
  'us-east-1',
  'us-east-2',
  'us-west-1',
  'us-west-2',
  'eu-west-1',
  'eu-west-2',
  'eu-west-3',
  'eu-central-1',
  'eu-north-1',
  'ap-southeast-1',
  'ap-southeast-2',
  'ap-northeast-1',
  'ap-northeast-2',
  'ap-south-1',
  'sa-east-1',
  'ca-central-1',
  'me-south-1',
  'af-south-1',
];

/// Service for fetching EC2 instances from the AWS API.
class AwsImportService {
  AwsImportService({
    required this.accessKeyId,
    required this.secretAccessKey,
    required this.region,
  });

  static final _log = Logger();

  final String accessKeyId;
  final String secretAccessKey;
  final String region;

  /// Fetches all EC2 instances in the configured region.
  Future<List<Ec2Instance>> listInstances() async {
    final dio = Dio();
    try {
      final uri = Uri.parse(
        'https://ec2.$region.amazonaws.com/'
        '?Action=DescribeInstances&Version=2016-11-15',
      );

      final signer = AwsSigner(
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        region: region,
        service: 'ec2',
      );

      final signedHeaders = signer.signGetRequest(uri);

      final response = await dio.getUri<String>(
        uri,
        options: Options(
          headers: signedHeaders,
          responseType: ResponseType.plain,
        ),
      );

      if (response.data == null) {
        throw const CloudImportException('Empty response from AWS');
      }

      return _parseDescribeInstancesResponse(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw const CloudImportException(
            'Invalid AWS credentials. Check your access key and secret.');
      }
      // Try to extract error message from XML response
      final errorMsg = _extractAwsError(e.response?.data?.toString());
      throw CloudImportException(
          errorMsg ?? 'Failed to fetch instances: ${e.message}', e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw CloudImportException('Failed to fetch instances', e);
    } finally {
      dio.close();
    }
  }

  List<Ec2Instance> _parseDescribeInstancesResponse(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final instances = <Ec2Instance>[];

    // Navigate: DescribeInstancesResponse > reservationSet > item > instancesSet > item
    final reservations = document.findAllElements('item');
    for (final item in reservations) {
      // Check if this is an instance item (has instanceId)
      final instanceIdEl = item.getElement('instanceId');
      if (instanceIdEl == null) continue;

      final instanceId = instanceIdEl.innerText;
      final state = item
              .getElement('instanceState')
              ?.getElement('name')
              ?.innerText ??
          'unknown';
      final publicIp = item.getElement('ipAddress')?.innerText;
      final privateIp = item.getElement('privateIpAddress')?.innerText;
      final instanceType = item.getElement('instanceType')?.innerText;
      final keyName = item.getElement('keyName')?.innerText;
      final platform = item.getElement('platform')?.innerText;

      // Extract Name tag
      String? name;
      final tagSet = item.getElement('tagSet');
      if (tagSet != null) {
        for (final tag in tagSet.findElements('item')) {
          final key = tag.getElement('key')?.innerText;
          if (key == 'Name') {
            name = tag.getElement('value')?.innerText;
            break;
          }
        }
      }

      instances.add(Ec2Instance(
        instanceId: instanceId,
        state: state,
        publicIp: publicIp,
        privateIp: privateIp,
        name: name,
        keyName: keyName,
        platform: platform,
        instanceType: instanceType,
        region: region,
      ));
    }

    return instances;
  }

  String? _extractAwsError(String? responseBody) {
    if (responseBody == null) return null;
    try {
      final doc = XmlDocument.parse(responseBody);
      final message = doc.findAllElements('Message').firstOrNull;
      return message?.innerText;
    } catch (e, stackTrace) {
      _log.d('Failed to parse AWS error XML response', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
