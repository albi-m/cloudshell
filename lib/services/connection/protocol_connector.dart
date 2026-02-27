/// Protocol-based connection factory.
///
/// Centralizes the protocol switch logic for creating connections
/// to hosts using the appropriate service (SSH, Telnet, or Serial).
library;

import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

import '../../data/database/app_database.dart';
import '../../data/database/tables/hosts_table.dart';
import '../serial/serial_service.dart';
import '../ssh/ssh_service.dart';
import '../telnet/telnet_service.dart';
import 'connection_session.dart';

/// Generic provider reader function signature.
///
/// Accepts both `Ref.read` and `WidgetRef.read` so [connectByProtocol]
/// can be called from notifiers and widget callbacks alike.
typedef ProviderReader = T Function<T>(ProviderListenable<T> provider);

/// Creates a [ConnectionSession] for [host] by dispatching to the correct protocol service.
///
/// Switches on [Host.protocol] to select SSH, Telnet, or Serial. Pass `ref.read`
/// as [read] so this function works from both widget and notifier contexts.
/// Throws if the underlying service fails to establish the connection.
Future<ConnectionSession> connectByProtocol(ProviderReader read, Host host) {
  return switch (host.protocol) {
    ProtocolType.ssh => read(sshServiceProvider).connect(host: host),
    ProtocolType.telnet => read(telnetServiceProvider).connect(host: host),
    ProtocolType.serial => read(serialServiceProvider).connect(host: host),
  };
}
