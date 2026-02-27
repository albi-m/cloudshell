/// Protocol-based connection factory.
///
/// Centralizes the protocol switch logic for creating connections
/// to hosts using the appropriate service (SSH, Telnet, or Serial).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../serial/serial_service.dart';
import '../ssh/ssh_service.dart';
import '../telnet/telnet_service.dart';
import 'connection_session.dart';

/// Reads a provider value. Works with both [Ref] and [WidgetRef].
typedef ProviderReader = T Function<T>(ProviderListenable<T> provider);

/// Creates a [ConnectionSession] for [host] using the appropriate protocol service.
///
/// Pass `ref.read` as the first argument to work from both widget and
/// notifier contexts.
Future<ConnectionSession> connectByProtocol(ProviderReader read, Host host) {
  return switch (host.protocol) {
    ProtocolType.ssh => read(sshServiceProvider).connect(host: host),
    ProtocolType.telnet => read(telnetServiceProvider).connect(host: host),
    ProtocolType.serial => read(serialServiceProvider).connect(host: host),
  };
}
