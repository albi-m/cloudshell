// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HostsTable extends Hosts with TableInfo<$HostsTable, Host> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(22),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AuthMethodType, int> authMethod =
      GeneratedColumn<int>(
        'auth_method',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AuthMethodType>($HostsTable.$converterauthMethod);
  static const VerificationMeta _keyIdMeta = const VerificationMeta('keyId');
  @override
  late final GeneratedColumn<String> keyId = GeneratedColumn<String>(
    'key_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startupCommandMeta = const VerificationMeta(
    'startupCommand',
  );
  @override
  late final GeneratedColumn<String> startupCommand = GeneratedColumn<String>(
    'startup_command',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keepAliveSecondsMeta = const VerificationMeta(
    'keepAliveSeconds',
  );
  @override
  late final GeneratedColumn<int> keepAliveSeconds = GeneratedColumn<int>(
    'keep_alive_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _jumpHostIdMeta = const VerificationMeta(
    'jumpHostId',
  );
  @override
  late final GeneratedColumn<String> jumpHostId = GeneratedColumn<String>(
    'jump_host_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _encodingMeta = const VerificationMeta(
    'encoding',
  );
  @override
  late final GeneratedColumn<String> encoding = GeneratedColumn<String>(
    'encoding',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastConnectedAtMeta = const VerificationMeta(
    'lastConnectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastConnectedAt =
      GeneratedColumn<DateTime>(
        'last_connected_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProtocolType, int> protocol =
      GeneratedColumn<int>(
        'protocol',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ProtocolType>($HostsTable.$converterprotocol);
  static const VerificationMeta _serialPortMeta = const VerificationMeta(
    'serialPort',
  );
  @override
  late final GeneratedColumn<String> serialPort = GeneratedColumn<String>(
    'serial_port',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialBaudRateMeta = const VerificationMeta(
    'serialBaudRate',
  );
  @override
  late final GeneratedColumn<int> serialBaudRate = GeneratedColumn<int>(
    'serial_baud_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialDataBitsMeta = const VerificationMeta(
    'serialDataBits',
  );
  @override
  late final GeneratedColumn<int> serialDataBits = GeneratedColumn<int>(
    'serial_data_bits',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialStopBitsMeta = const VerificationMeta(
    'serialStopBits',
  );
  @override
  late final GeneratedColumn<int> serialStopBits = GeneratedColumn<int>(
    'serial_stop_bits',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialParityMeta = const VerificationMeta(
    'serialParity',
  );
  @override
  late final GeneratedColumn<String> serialParity = GeneratedColumn<String>(
    'serial_parity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialFlowControlMeta = const VerificationMeta(
    'serialFlowControl',
  );
  @override
  late final GeneratedColumn<String> serialFlowControl =
      GeneratedColumn<String>(
        'serial_flow_control',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    hostname,
    port,
    username,
    authMethod,
    keyId,
    groupId,
    tags,
    startupCommand,
    keepAliveSeconds,
    jumpHostId,
    encoding,
    notes,
    sortOrder,
    isFavorite,
    lastConnectedAt,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
    protocol,
    serialPort,
    serialBaudRate,
    serialDataBits,
    serialStopBits,
    serialParity,
    serialFlowControl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hosts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Host> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    } else if (isInserting) {
      context.missing(_hostnameMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('key_id')) {
      context.handle(
        _keyIdMeta,
        keyId.isAcceptableOrUnknown(data['key_id']!, _keyIdMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('startup_command')) {
      context.handle(
        _startupCommandMeta,
        startupCommand.isAcceptableOrUnknown(
          data['startup_command']!,
          _startupCommandMeta,
        ),
      );
    }
    if (data.containsKey('keep_alive_seconds')) {
      context.handle(
        _keepAliveSecondsMeta,
        keepAliveSeconds.isAcceptableOrUnknown(
          data['keep_alive_seconds']!,
          _keepAliveSecondsMeta,
        ),
      );
    }
    if (data.containsKey('jump_host_id')) {
      context.handle(
        _jumpHostIdMeta,
        jumpHostId.isAcceptableOrUnknown(
          data['jump_host_id']!,
          _jumpHostIdMeta,
        ),
      );
    }
    if (data.containsKey('encoding')) {
      context.handle(
        _encodingMeta,
        encoding.isAcceptableOrUnknown(data['encoding']!, _encodingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_connected_at')) {
      context.handle(
        _lastConnectedAtMeta,
        lastConnectedAt.isAcceptableOrUnknown(
          data['last_connected_at']!,
          _lastConnectedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('serial_port')) {
      context.handle(
        _serialPortMeta,
        serialPort.isAcceptableOrUnknown(data['serial_port']!, _serialPortMeta),
      );
    }
    if (data.containsKey('serial_baud_rate')) {
      context.handle(
        _serialBaudRateMeta,
        serialBaudRate.isAcceptableOrUnknown(
          data['serial_baud_rate']!,
          _serialBaudRateMeta,
        ),
      );
    }
    if (data.containsKey('serial_data_bits')) {
      context.handle(
        _serialDataBitsMeta,
        serialDataBits.isAcceptableOrUnknown(
          data['serial_data_bits']!,
          _serialDataBitsMeta,
        ),
      );
    }
    if (data.containsKey('serial_stop_bits')) {
      context.handle(
        _serialStopBitsMeta,
        serialStopBits.isAcceptableOrUnknown(
          data['serial_stop_bits']!,
          _serialStopBitsMeta,
        ),
      );
    }
    if (data.containsKey('serial_parity')) {
      context.handle(
        _serialParityMeta,
        serialParity.isAcceptableOrUnknown(
          data['serial_parity']!,
          _serialParityMeta,
        ),
      );
    }
    if (data.containsKey('serial_flow_control')) {
      context.handle(
        _serialFlowControlMeta,
        serialFlowControl.isAcceptableOrUnknown(
          data['serial_flow_control']!,
          _serialFlowControlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Host map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Host(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      authMethod: $HostsTable.$converterauthMethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}auth_method'],
        )!,
      ),
      keyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_id'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      startupCommand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}startup_command'],
      ),
      keepAliveSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}keep_alive_seconds'],
      )!,
      jumpHostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jump_host_id'],
      ),
      encoding: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encoding'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastConnectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_connected_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      protocol: $HostsTable.$converterprotocol.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}protocol'],
        )!,
      ),
      serialPort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_port'],
      ),
      serialBaudRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial_baud_rate'],
      ),
      serialDataBits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial_data_bits'],
      ),
      serialStopBits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial_stop_bits'],
      ),
      serialParity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_parity'],
      ),
      serialFlowControl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_flow_control'],
      ),
    );
  }

  @override
  $HostsTable createAlias(String alias) {
    return $HostsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AuthMethodType, int, int> $converterauthMethod =
      const EnumIndexConverter<AuthMethodType>(AuthMethodType.values);
  static JsonTypeConverter2<ProtocolType, int, int> $converterprotocol =
      const EnumIndexConverter<ProtocolType>(ProtocolType.values);
}

class Host extends DataClass implements Insertable<Host> {
  /// Unique identifier (UUID v4).
  final String id;

  /// User-facing display name.
  final String label;

  /// Hostname or IP address.
  final String hostname;

  /// SSH port number (default 22).
  final int port;

  /// SSH username for authentication.
  final String username;

  /// Authentication method selection.
  final AuthMethodType authMethod;

  /// Foreign key reference to the SSH key used for auth.
  final String? keyId;

  /// Foreign key reference to the host group.
  final String? groupId;

  /// Comma-separated tags for search and filtering.
  final String tags;

  /// Command to execute automatically on connect.
  final String? startupCommand;

  /// Keep-alive interval in seconds.
  final int keepAliveSeconds;

  /// Foreign key reference to another host used as a jump host.
  final String? jumpHostId;

  /// Character encoding override (default UTF-8).
  final String? encoding;

  /// User notes about this host.
  final String? notes;

  /// Manual sort order for drag-and-drop reordering.
  final int sortOrder;

  /// Whether this host is marked as favorite.
  final bool isFavorite;

  /// Timestamp of the last successful connection.
  final DateTime? lastConnectedAt;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Record last-modified timestamp.
  final DateTime updatedAt;

  /// Lamport clock for sync conflict resolution.
  final int syncVersion;

  /// Soft-delete tombstone flag.
  final bool isDeleted;

  /// Connection protocol (SSH, Telnet, Serial). Defaults to SSH.
  final ProtocolType protocol;

  /// Serial port device path (e.g. /dev/ttyUSB0, COM3).
  final String? serialPort;

  /// Serial baud rate (e.g. 9600, 115200).
  final int? serialBaudRate;

  /// Serial data bits (5, 6, 7, or 8).
  final int? serialDataBits;

  /// Serial stop bits (1 or 2).
  final int? serialStopBits;

  /// Serial parity mode (none, odd, even, mark, space).
  final String? serialParity;

  /// Serial flow control (none, hardware, software).
  final String? serialFlowControl;
  const Host({
    required this.id,
    required this.label,
    required this.hostname,
    required this.port,
    required this.username,
    required this.authMethod,
    this.keyId,
    this.groupId,
    required this.tags,
    this.startupCommand,
    required this.keepAliveSeconds,
    this.jumpHostId,
    this.encoding,
    this.notes,
    required this.sortOrder,
    required this.isFavorite,
    this.lastConnectedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.syncVersion,
    required this.isDeleted,
    required this.protocol,
    this.serialPort,
    this.serialBaudRate,
    this.serialDataBits,
    this.serialStopBits,
    this.serialParity,
    this.serialFlowControl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['hostname'] = Variable<String>(hostname);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    {
      map['auth_method'] = Variable<int>(
        $HostsTable.$converterauthMethod.toSql(authMethod),
      );
    }
    if (!nullToAbsent || keyId != null) {
      map['key_id'] = Variable<String>(keyId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || startupCommand != null) {
      map['startup_command'] = Variable<String>(startupCommand);
    }
    map['keep_alive_seconds'] = Variable<int>(keepAliveSeconds);
    if (!nullToAbsent || jumpHostId != null) {
      map['jump_host_id'] = Variable<String>(jumpHostId);
    }
    if (!nullToAbsent || encoding != null) {
      map['encoding'] = Variable<String>(encoding);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastConnectedAt != null) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_version'] = Variable<int>(syncVersion);
    map['is_deleted'] = Variable<bool>(isDeleted);
    {
      map['protocol'] = Variable<int>(
        $HostsTable.$converterprotocol.toSql(protocol),
      );
    }
    if (!nullToAbsent || serialPort != null) {
      map['serial_port'] = Variable<String>(serialPort);
    }
    if (!nullToAbsent || serialBaudRate != null) {
      map['serial_baud_rate'] = Variable<int>(serialBaudRate);
    }
    if (!nullToAbsent || serialDataBits != null) {
      map['serial_data_bits'] = Variable<int>(serialDataBits);
    }
    if (!nullToAbsent || serialStopBits != null) {
      map['serial_stop_bits'] = Variable<int>(serialStopBits);
    }
    if (!nullToAbsent || serialParity != null) {
      map['serial_parity'] = Variable<String>(serialParity);
    }
    if (!nullToAbsent || serialFlowControl != null) {
      map['serial_flow_control'] = Variable<String>(serialFlowControl);
    }
    return map;
  }

  HostsCompanion toCompanion(bool nullToAbsent) {
    return HostsCompanion(
      id: Value(id),
      label: Value(label),
      hostname: Value(hostname),
      port: Value(port),
      username: Value(username),
      authMethod: Value(authMethod),
      keyId: keyId == null && nullToAbsent
          ? const Value.absent()
          : Value(keyId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      tags: Value(tags),
      startupCommand: startupCommand == null && nullToAbsent
          ? const Value.absent()
          : Value(startupCommand),
      keepAliveSeconds: Value(keepAliveSeconds),
      jumpHostId: jumpHostId == null && nullToAbsent
          ? const Value.absent()
          : Value(jumpHostId),
      encoding: encoding == null && nullToAbsent
          ? const Value.absent()
          : Value(encoding),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      isFavorite: Value(isFavorite),
      lastConnectedAt: lastConnectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnectedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncVersion: Value(syncVersion),
      isDeleted: Value(isDeleted),
      protocol: Value(protocol),
      serialPort: serialPort == null && nullToAbsent
          ? const Value.absent()
          : Value(serialPort),
      serialBaudRate: serialBaudRate == null && nullToAbsent
          ? const Value.absent()
          : Value(serialBaudRate),
      serialDataBits: serialDataBits == null && nullToAbsent
          ? const Value.absent()
          : Value(serialDataBits),
      serialStopBits: serialStopBits == null && nullToAbsent
          ? const Value.absent()
          : Value(serialStopBits),
      serialParity: serialParity == null && nullToAbsent
          ? const Value.absent()
          : Value(serialParity),
      serialFlowControl: serialFlowControl == null && nullToAbsent
          ? const Value.absent()
          : Value(serialFlowControl),
    );
  }

  factory Host.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Host(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      hostname: serializer.fromJson<String>(json['hostname']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      authMethod: $HostsTable.$converterauthMethod.fromJson(
        serializer.fromJson<int>(json['authMethod']),
      ),
      keyId: serializer.fromJson<String?>(json['keyId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      tags: serializer.fromJson<String>(json['tags']),
      startupCommand: serializer.fromJson<String?>(json['startupCommand']),
      keepAliveSeconds: serializer.fromJson<int>(json['keepAliveSeconds']),
      jumpHostId: serializer.fromJson<String?>(json['jumpHostId']),
      encoding: serializer.fromJson<String?>(json['encoding']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastConnectedAt: serializer.fromJson<DateTime?>(json['lastConnectedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      protocol: $HostsTable.$converterprotocol.fromJson(
        serializer.fromJson<int>(json['protocol']),
      ),
      serialPort: serializer.fromJson<String?>(json['serialPort']),
      serialBaudRate: serializer.fromJson<int?>(json['serialBaudRate']),
      serialDataBits: serializer.fromJson<int?>(json['serialDataBits']),
      serialStopBits: serializer.fromJson<int?>(json['serialStopBits']),
      serialParity: serializer.fromJson<String?>(json['serialParity']),
      serialFlowControl: serializer.fromJson<String?>(
        json['serialFlowControl'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'hostname': serializer.toJson<String>(hostname),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'authMethod': serializer.toJson<int>(
        $HostsTable.$converterauthMethod.toJson(authMethod),
      ),
      'keyId': serializer.toJson<String?>(keyId),
      'groupId': serializer.toJson<String?>(groupId),
      'tags': serializer.toJson<String>(tags),
      'startupCommand': serializer.toJson<String?>(startupCommand),
      'keepAliveSeconds': serializer.toJson<int>(keepAliveSeconds),
      'jumpHostId': serializer.toJson<String?>(jumpHostId),
      'encoding': serializer.toJson<String?>(encoding),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastConnectedAt': serializer.toJson<DateTime?>(lastConnectedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'protocol': serializer.toJson<int>(
        $HostsTable.$converterprotocol.toJson(protocol),
      ),
      'serialPort': serializer.toJson<String?>(serialPort),
      'serialBaudRate': serializer.toJson<int?>(serialBaudRate),
      'serialDataBits': serializer.toJson<int?>(serialDataBits),
      'serialStopBits': serializer.toJson<int?>(serialStopBits),
      'serialParity': serializer.toJson<String?>(serialParity),
      'serialFlowControl': serializer.toJson<String?>(serialFlowControl),
    };
  }

  Host copyWith({
    String? id,
    String? label,
    String? hostname,
    int? port,
    String? username,
    AuthMethodType? authMethod,
    Value<String?> keyId = const Value.absent(),
    Value<String?> groupId = const Value.absent(),
    String? tags,
    Value<String?> startupCommand = const Value.absent(),
    int? keepAliveSeconds,
    Value<String?> jumpHostId = const Value.absent(),
    Value<String?> encoding = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    bool? isFavorite,
    Value<DateTime?> lastConnectedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
    bool? isDeleted,
    ProtocolType? protocol,
    Value<String?> serialPort = const Value.absent(),
    Value<int?> serialBaudRate = const Value.absent(),
    Value<int?> serialDataBits = const Value.absent(),
    Value<int?> serialStopBits = const Value.absent(),
    Value<String?> serialParity = const Value.absent(),
    Value<String?> serialFlowControl = const Value.absent(),
  }) => Host(
    id: id ?? this.id,
    label: label ?? this.label,
    hostname: hostname ?? this.hostname,
    port: port ?? this.port,
    username: username ?? this.username,
    authMethod: authMethod ?? this.authMethod,
    keyId: keyId.present ? keyId.value : this.keyId,
    groupId: groupId.present ? groupId.value : this.groupId,
    tags: tags ?? this.tags,
    startupCommand: startupCommand.present
        ? startupCommand.value
        : this.startupCommand,
    keepAliveSeconds: keepAliveSeconds ?? this.keepAliveSeconds,
    jumpHostId: jumpHostId.present ? jumpHostId.value : this.jumpHostId,
    encoding: encoding.present ? encoding.value : this.encoding,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    isFavorite: isFavorite ?? this.isFavorite,
    lastConnectedAt: lastConnectedAt.present
        ? lastConnectedAt.value
        : this.lastConnectedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncVersion: syncVersion ?? this.syncVersion,
    isDeleted: isDeleted ?? this.isDeleted,
    protocol: protocol ?? this.protocol,
    serialPort: serialPort.present ? serialPort.value : this.serialPort,
    serialBaudRate: serialBaudRate.present
        ? serialBaudRate.value
        : this.serialBaudRate,
    serialDataBits: serialDataBits.present
        ? serialDataBits.value
        : this.serialDataBits,
    serialStopBits: serialStopBits.present
        ? serialStopBits.value
        : this.serialStopBits,
    serialParity: serialParity.present ? serialParity.value : this.serialParity,
    serialFlowControl: serialFlowControl.present
        ? serialFlowControl.value
        : this.serialFlowControl,
  );
  Host copyWithCompanion(HostsCompanion data) {
    return Host(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      authMethod: data.authMethod.present
          ? data.authMethod.value
          : this.authMethod,
      keyId: data.keyId.present ? data.keyId.value : this.keyId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      tags: data.tags.present ? data.tags.value : this.tags,
      startupCommand: data.startupCommand.present
          ? data.startupCommand.value
          : this.startupCommand,
      keepAliveSeconds: data.keepAliveSeconds.present
          ? data.keepAliveSeconds.value
          : this.keepAliveSeconds,
      jumpHostId: data.jumpHostId.present
          ? data.jumpHostId.value
          : this.jumpHostId,
      encoding: data.encoding.present ? data.encoding.value : this.encoding,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastConnectedAt: data.lastConnectedAt.present
          ? data.lastConnectedAt.value
          : this.lastConnectedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      protocol: data.protocol.present ? data.protocol.value : this.protocol,
      serialPort: data.serialPort.present
          ? data.serialPort.value
          : this.serialPort,
      serialBaudRate: data.serialBaudRate.present
          ? data.serialBaudRate.value
          : this.serialBaudRate,
      serialDataBits: data.serialDataBits.present
          ? data.serialDataBits.value
          : this.serialDataBits,
      serialStopBits: data.serialStopBits.present
          ? data.serialStopBits.value
          : this.serialStopBits,
      serialParity: data.serialParity.present
          ? data.serialParity.value
          : this.serialParity,
      serialFlowControl: data.serialFlowControl.present
          ? data.serialFlowControl.value
          : this.serialFlowControl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Host(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('authMethod: $authMethod, ')
          ..write('keyId: $keyId, ')
          ..write('groupId: $groupId, ')
          ..write('tags: $tags, ')
          ..write('startupCommand: $startupCommand, ')
          ..write('keepAliveSeconds: $keepAliveSeconds, ')
          ..write('jumpHostId: $jumpHostId, ')
          ..write('encoding: $encoding, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('protocol: $protocol, ')
          ..write('serialPort: $serialPort, ')
          ..write('serialBaudRate: $serialBaudRate, ')
          ..write('serialDataBits: $serialDataBits, ')
          ..write('serialStopBits: $serialStopBits, ')
          ..write('serialParity: $serialParity, ')
          ..write('serialFlowControl: $serialFlowControl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    label,
    hostname,
    port,
    username,
    authMethod,
    keyId,
    groupId,
    tags,
    startupCommand,
    keepAliveSeconds,
    jumpHostId,
    encoding,
    notes,
    sortOrder,
    isFavorite,
    lastConnectedAt,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
    protocol,
    serialPort,
    serialBaudRate,
    serialDataBits,
    serialStopBits,
    serialParity,
    serialFlowControl,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Host &&
          other.id == this.id &&
          other.label == this.label &&
          other.hostname == this.hostname &&
          other.port == this.port &&
          other.username == this.username &&
          other.authMethod == this.authMethod &&
          other.keyId == this.keyId &&
          other.groupId == this.groupId &&
          other.tags == this.tags &&
          other.startupCommand == this.startupCommand &&
          other.keepAliveSeconds == this.keepAliveSeconds &&
          other.jumpHostId == this.jumpHostId &&
          other.encoding == this.encoding &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.isFavorite == this.isFavorite &&
          other.lastConnectedAt == this.lastConnectedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncVersion == this.syncVersion &&
          other.isDeleted == this.isDeleted &&
          other.protocol == this.protocol &&
          other.serialPort == this.serialPort &&
          other.serialBaudRate == this.serialBaudRate &&
          other.serialDataBits == this.serialDataBits &&
          other.serialStopBits == this.serialStopBits &&
          other.serialParity == this.serialParity &&
          other.serialFlowControl == this.serialFlowControl);
}

class HostsCompanion extends UpdateCompanion<Host> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> hostname;
  final Value<int> port;
  final Value<String> username;
  final Value<AuthMethodType> authMethod;
  final Value<String?> keyId;
  final Value<String?> groupId;
  final Value<String> tags;
  final Value<String?> startupCommand;
  final Value<int> keepAliveSeconds;
  final Value<String?> jumpHostId;
  final Value<String?> encoding;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<bool> isFavorite;
  final Value<DateTime?> lastConnectedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> syncVersion;
  final Value<bool> isDeleted;
  final Value<ProtocolType> protocol;
  final Value<String?> serialPort;
  final Value<int?> serialBaudRate;
  final Value<int?> serialDataBits;
  final Value<int?> serialStopBits;
  final Value<String?> serialParity;
  final Value<String?> serialFlowControl;
  final Value<int> rowid;
  const HostsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.hostname = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.authMethod = const Value.absent(),
    this.keyId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.tags = const Value.absent(),
    this.startupCommand = const Value.absent(),
    this.keepAliveSeconds = const Value.absent(),
    this.jumpHostId = const Value.absent(),
    this.encoding = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.protocol = const Value.absent(),
    this.serialPort = const Value.absent(),
    this.serialBaudRate = const Value.absent(),
    this.serialDataBits = const Value.absent(),
    this.serialStopBits = const Value.absent(),
    this.serialParity = const Value.absent(),
    this.serialFlowControl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HostsCompanion.insert({
    required String id,
    required String label,
    required String hostname,
    this.port = const Value.absent(),
    required String username,
    required AuthMethodType authMethod,
    this.keyId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.tags = const Value.absent(),
    this.startupCommand = const Value.absent(),
    this.keepAliveSeconds = const Value.absent(),
    this.jumpHostId = const Value.absent(),
    this.encoding = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.protocol = const Value.absent(),
    this.serialPort = const Value.absent(),
    this.serialBaudRate = const Value.absent(),
    this.serialDataBits = const Value.absent(),
    this.serialStopBits = const Value.absent(),
    this.serialParity = const Value.absent(),
    this.serialFlowControl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       hostname = Value(hostname),
       username = Value(username),
       authMethod = Value(authMethod),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Host> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? hostname,
    Expression<int>? port,
    Expression<String>? username,
    Expression<int>? authMethod,
    Expression<String>? keyId,
    Expression<String>? groupId,
    Expression<String>? tags,
    Expression<String>? startupCommand,
    Expression<int>? keepAliveSeconds,
    Expression<String>? jumpHostId,
    Expression<String>? encoding,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<bool>? isFavorite,
    Expression<DateTime>? lastConnectedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? isDeleted,
    Expression<int>? protocol,
    Expression<String>? serialPort,
    Expression<int>? serialBaudRate,
    Expression<int>? serialDataBits,
    Expression<int>? serialStopBits,
    Expression<String>? serialParity,
    Expression<String>? serialFlowControl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (hostname != null) 'hostname': hostname,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (authMethod != null) 'auth_method': authMethod,
      if (keyId != null) 'key_id': keyId,
      if (groupId != null) 'group_id': groupId,
      if (tags != null) 'tags': tags,
      if (startupCommand != null) 'startup_command': startupCommand,
      if (keepAliveSeconds != null) 'keep_alive_seconds': keepAliveSeconds,
      if (jumpHostId != null) 'jump_host_id': jumpHostId,
      if (encoding != null) 'encoding': encoding,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastConnectedAt != null) 'last_connected_at': lastConnectedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (protocol != null) 'protocol': protocol,
      if (serialPort != null) 'serial_port': serialPort,
      if (serialBaudRate != null) 'serial_baud_rate': serialBaudRate,
      if (serialDataBits != null) 'serial_data_bits': serialDataBits,
      if (serialStopBits != null) 'serial_stop_bits': serialStopBits,
      if (serialParity != null) 'serial_parity': serialParity,
      if (serialFlowControl != null) 'serial_flow_control': serialFlowControl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HostsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? hostname,
    Value<int>? port,
    Value<String>? username,
    Value<AuthMethodType>? authMethod,
    Value<String?>? keyId,
    Value<String?>? groupId,
    Value<String>? tags,
    Value<String?>? startupCommand,
    Value<int>? keepAliveSeconds,
    Value<String?>? jumpHostId,
    Value<String?>? encoding,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<bool>? isFavorite,
    Value<DateTime?>? lastConnectedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? syncVersion,
    Value<bool>? isDeleted,
    Value<ProtocolType>? protocol,
    Value<String?>? serialPort,
    Value<int?>? serialBaudRate,
    Value<int?>? serialDataBits,
    Value<int?>? serialStopBits,
    Value<String?>? serialParity,
    Value<String?>? serialFlowControl,
    Value<int>? rowid,
  }) {
    return HostsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      username: username ?? this.username,
      authMethod: authMethod ?? this.authMethod,
      keyId: keyId ?? this.keyId,
      groupId: groupId ?? this.groupId,
      tags: tags ?? this.tags,
      startupCommand: startupCommand ?? this.startupCommand,
      keepAliveSeconds: keepAliveSeconds ?? this.keepAliveSeconds,
      jumpHostId: jumpHostId ?? this.jumpHostId,
      encoding: encoding ?? this.encoding,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      isFavorite: isFavorite ?? this.isFavorite,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      isDeleted: isDeleted ?? this.isDeleted,
      protocol: protocol ?? this.protocol,
      serialPort: serialPort ?? this.serialPort,
      serialBaudRate: serialBaudRate ?? this.serialBaudRate,
      serialDataBits: serialDataBits ?? this.serialDataBits,
      serialStopBits: serialStopBits ?? this.serialStopBits,
      serialParity: serialParity ?? this.serialParity,
      serialFlowControl: serialFlowControl ?? this.serialFlowControl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (authMethod.present) {
      map['auth_method'] = Variable<int>(
        $HostsTable.$converterauthMethod.toSql(authMethod.value),
      );
    }
    if (keyId.present) {
      map['key_id'] = Variable<String>(keyId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (startupCommand.present) {
      map['startup_command'] = Variable<String>(startupCommand.value);
    }
    if (keepAliveSeconds.present) {
      map['keep_alive_seconds'] = Variable<int>(keepAliveSeconds.value);
    }
    if (jumpHostId.present) {
      map['jump_host_id'] = Variable<String>(jumpHostId.value);
    }
    if (encoding.present) {
      map['encoding'] = Variable<String>(encoding.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastConnectedAt.present) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (protocol.present) {
      map['protocol'] = Variable<int>(
        $HostsTable.$converterprotocol.toSql(protocol.value),
      );
    }
    if (serialPort.present) {
      map['serial_port'] = Variable<String>(serialPort.value);
    }
    if (serialBaudRate.present) {
      map['serial_baud_rate'] = Variable<int>(serialBaudRate.value);
    }
    if (serialDataBits.present) {
      map['serial_data_bits'] = Variable<int>(serialDataBits.value);
    }
    if (serialStopBits.present) {
      map['serial_stop_bits'] = Variable<int>(serialStopBits.value);
    }
    if (serialParity.present) {
      map['serial_parity'] = Variable<String>(serialParity.value);
    }
    if (serialFlowControl.present) {
      map['serial_flow_control'] = Variable<String>(serialFlowControl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HostsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('authMethod: $authMethod, ')
          ..write('keyId: $keyId, ')
          ..write('groupId: $groupId, ')
          ..write('tags: $tags, ')
          ..write('startupCommand: $startupCommand, ')
          ..write('keepAliveSeconds: $keepAliveSeconds, ')
          ..write('jumpHostId: $jumpHostId, ')
          ..write('encoding: $encoding, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('protocol: $protocol, ')
          ..write('serialPort: $serialPort, ')
          ..write('serialBaudRate: $serialBaudRate, ')
          ..write('serialDataBits: $serialDataBits, ')
          ..write('serialStopBits: $serialStopBits, ')
          ..write('serialParity: $serialParity, ')
          ..write('serialFlowControl: $serialFlowControl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HostGroupsTable extends HostGroups
    with TableInfo<$HostGroupsTable, HostGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HostGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentGroupIdMeta = const VerificationMeta(
    'parentGroupId',
  );
  @override
  late final GeneratedColumn<String> parentGroupId = GeneratedColumn<String>(
    'parent_group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultUsernameMeta = const VerificationMeta(
    'defaultUsername',
  );
  @override
  late final GeneratedColumn<String> defaultUsername = GeneratedColumn<String>(
    'default_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultPortMeta = const VerificationMeta(
    'defaultPort',
  );
  @override
  late final GeneratedColumn<int> defaultPort = GeneratedColumn<int>(
    'default_port',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultKeyIdMeta = const VerificationMeta(
    'defaultKeyId',
  );
  @override
  late final GeneratedColumn<String> defaultKeyId = GeneratedColumn<String>(
    'default_key_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentGroupId,
    defaultUsername,
    defaultPort,
    defaultKeyId,
    sortOrder,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'host_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<HostGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_group_id')) {
      context.handle(
        _parentGroupIdMeta,
        parentGroupId.isAcceptableOrUnknown(
          data['parent_group_id']!,
          _parentGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('default_username')) {
      context.handle(
        _defaultUsernameMeta,
        defaultUsername.isAcceptableOrUnknown(
          data['default_username']!,
          _defaultUsernameMeta,
        ),
      );
    }
    if (data.containsKey('default_port')) {
      context.handle(
        _defaultPortMeta,
        defaultPort.isAcceptableOrUnknown(
          data['default_port']!,
          _defaultPortMeta,
        ),
      );
    }
    if (data.containsKey('default_key_id')) {
      context.handle(
        _defaultKeyIdMeta,
        defaultKeyId.isAcceptableOrUnknown(
          data['default_key_id']!,
          _defaultKeyIdMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HostGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HostGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_group_id'],
      ),
      defaultUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_username'],
      ),
      defaultPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_port'],
      ),
      defaultKeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_key_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $HostGroupsTable createAlias(String alias) {
    return $HostGroupsTable(attachedDatabase, alias);
  }
}

class HostGroup extends DataClass implements Insertable<HostGroup> {
  /// Unique identifier (UUID v4).
  final String id;

  /// Display name for the group.
  final String name;

  /// Parent group ID for nested groups.
  final String? parentGroupId;

  /// Default username inherited by hosts in this group.
  final String? defaultUsername;

  /// Default SSH port inherited by hosts in this group.
  final int? defaultPort;

  /// Default SSH key inherited by hosts in this group.
  final String? defaultKeyId;

  /// Sort order for manual ordering.
  final int sortOrder;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Record last-modified timestamp.
  final DateTime updatedAt;

  /// Lamport clock for sync conflict resolution.
  final int syncVersion;

  /// Soft-delete tombstone flag.
  final bool isDeleted;
  const HostGroup({
    required this.id,
    required this.name,
    this.parentGroupId,
    this.defaultUsername,
    this.defaultPort,
    this.defaultKeyId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.syncVersion,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentGroupId != null) {
      map['parent_group_id'] = Variable<String>(parentGroupId);
    }
    if (!nullToAbsent || defaultUsername != null) {
      map['default_username'] = Variable<String>(defaultUsername);
    }
    if (!nullToAbsent || defaultPort != null) {
      map['default_port'] = Variable<int>(defaultPort);
    }
    if (!nullToAbsent || defaultKeyId != null) {
      map['default_key_id'] = Variable<String>(defaultKeyId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_version'] = Variable<int>(syncVersion);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  HostGroupsCompanion toCompanion(bool nullToAbsent) {
    return HostGroupsCompanion(
      id: Value(id),
      name: Value(name),
      parentGroupId: parentGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentGroupId),
      defaultUsername: defaultUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultUsername),
      defaultPort: defaultPort == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPort),
      defaultKeyId: defaultKeyId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultKeyId),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncVersion: Value(syncVersion),
      isDeleted: Value(isDeleted),
    );
  }

  factory HostGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HostGroup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentGroupId: serializer.fromJson<String?>(json['parentGroupId']),
      defaultUsername: serializer.fromJson<String?>(json['defaultUsername']),
      defaultPort: serializer.fromJson<int?>(json['defaultPort']),
      defaultKeyId: serializer.fromJson<String?>(json['defaultKeyId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentGroupId': serializer.toJson<String?>(parentGroupId),
      'defaultUsername': serializer.toJson<String?>(defaultUsername),
      'defaultPort': serializer.toJson<int?>(defaultPort),
      'defaultKeyId': serializer.toJson<String?>(defaultKeyId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  HostGroup copyWith({
    String? id,
    String? name,
    Value<String?> parentGroupId = const Value.absent(),
    Value<String?> defaultUsername = const Value.absent(),
    Value<int?> defaultPort = const Value.absent(),
    Value<String?> defaultKeyId = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
    bool? isDeleted,
  }) => HostGroup(
    id: id ?? this.id,
    name: name ?? this.name,
    parentGroupId: parentGroupId.present
        ? parentGroupId.value
        : this.parentGroupId,
    defaultUsername: defaultUsername.present
        ? defaultUsername.value
        : this.defaultUsername,
    defaultPort: defaultPort.present ? defaultPort.value : this.defaultPort,
    defaultKeyId: defaultKeyId.present ? defaultKeyId.value : this.defaultKeyId,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncVersion: syncVersion ?? this.syncVersion,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  HostGroup copyWithCompanion(HostGroupsCompanion data) {
    return HostGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentGroupId: data.parentGroupId.present
          ? data.parentGroupId.value
          : this.parentGroupId,
      defaultUsername: data.defaultUsername.present
          ? data.defaultUsername.value
          : this.defaultUsername,
      defaultPort: data.defaultPort.present
          ? data.defaultPort.value
          : this.defaultPort,
      defaultKeyId: data.defaultKeyId.present
          ? data.defaultKeyId.value
          : this.defaultKeyId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HostGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentGroupId: $parentGroupId, ')
          ..write('defaultUsername: $defaultUsername, ')
          ..write('defaultPort: $defaultPort, ')
          ..write('defaultKeyId: $defaultKeyId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentGroupId,
    defaultUsername,
    defaultPort,
    defaultKeyId,
    sortOrder,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HostGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentGroupId == this.parentGroupId &&
          other.defaultUsername == this.defaultUsername &&
          other.defaultPort == this.defaultPort &&
          other.defaultKeyId == this.defaultKeyId &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncVersion == this.syncVersion &&
          other.isDeleted == this.isDeleted);
}

class HostGroupsCompanion extends UpdateCompanion<HostGroup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentGroupId;
  final Value<String?> defaultUsername;
  final Value<int?> defaultPort;
  final Value<String?> defaultKeyId;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> syncVersion;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const HostGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentGroupId = const Value.absent(),
    this.defaultUsername = const Value.absent(),
    this.defaultPort = const Value.absent(),
    this.defaultKeyId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HostGroupsCompanion.insert({
    required String id,
    required String name,
    this.parentGroupId = const Value.absent(),
    this.defaultUsername = const Value.absent(),
    this.defaultPort = const Value.absent(),
    this.defaultKeyId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HostGroup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentGroupId,
    Expression<String>? defaultUsername,
    Expression<int>? defaultPort,
    Expression<String>? defaultKeyId,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentGroupId != null) 'parent_group_id': parentGroupId,
      if (defaultUsername != null) 'default_username': defaultUsername,
      if (defaultPort != null) 'default_port': defaultPort,
      if (defaultKeyId != null) 'default_key_id': defaultKeyId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HostGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentGroupId,
    Value<String?>? defaultUsername,
    Value<int?>? defaultPort,
    Value<String?>? defaultKeyId,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? syncVersion,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return HostGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentGroupId: parentGroupId ?? this.parentGroupId,
      defaultUsername: defaultUsername ?? this.defaultUsername,
      defaultPort: defaultPort ?? this.defaultPort,
      defaultKeyId: defaultKeyId ?? this.defaultKeyId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentGroupId.present) {
      map['parent_group_id'] = Variable<String>(parentGroupId.value);
    }
    if (defaultUsername.present) {
      map['default_username'] = Variable<String>(defaultUsername.value);
    }
    if (defaultPort.present) {
      map['default_port'] = Variable<int>(defaultPort.value);
    }
    if (defaultKeyId.present) {
      map['default_key_id'] = Variable<String>(defaultKeyId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HostGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentGroupId: $parentGroupId, ')
          ..write('defaultUsername: $defaultUsername, ')
          ..write('defaultPort: $defaultPort, ')
          ..write('defaultKeyId: $defaultKeyId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SshKeysTable extends SshKeys with TableInfo<$SshKeysTable, SshKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SshKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<KeyTypeEnum, int> keyType =
      GeneratedColumn<int>(
        'key_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<KeyTypeEnum>($SshKeysTable.$converterkeyType);
  static const VerificationMeta _keyBitsMeta = const VerificationMeta(
    'keyBits',
  );
  @override
  late final GeneratedColumn<int> keyBits = GeneratedColumn<int>(
    'key_bits',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _privateKeyRefMeta = const VerificationMeta(
    'privateKeyRef',
  );
  @override
  late final GeneratedColumn<String> privateKeyRef = GeneratedColumn<String>(
    'private_key_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasPassphraseMeta = const VerificationMeta(
    'hasPassphrase',
  );
  @override
  late final GeneratedColumn<bool> hasPassphrase = GeneratedColumn<bool>(
    'has_passphrase',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_passphrase" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    keyType,
    keyBits,
    publicKey,
    privateKeyRef,
    fingerprint,
    hasPassphrase,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ssh_keys';
  @override
  VerificationContext validateIntegrity(
    Insertable<SshKey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('key_bits')) {
      context.handle(
        _keyBitsMeta,
        keyBits.isAcceptableOrUnknown(data['key_bits']!, _keyBitsMeta),
      );
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('private_key_ref')) {
      context.handle(
        _privateKeyRefMeta,
        privateKeyRef.isAcceptableOrUnknown(
          data['private_key_ref']!,
          _privateKeyRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_privateKeyRefMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('has_passphrase')) {
      context.handle(
        _hasPassphraseMeta,
        hasPassphrase.isAcceptableOrUnknown(
          data['has_passphrase']!,
          _hasPassphraseMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SshKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SshKey(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      keyType: $SshKeysTable.$converterkeyType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}key_type'],
        )!,
      ),
      keyBits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}key_bits'],
      ),
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_key'],
      )!,
      privateKeyRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}private_key_ref'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      hasPassphrase: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_passphrase'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $SshKeysTable createAlias(String alias) {
    return $SshKeysTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<KeyTypeEnum, int, int> $converterkeyType =
      const EnumIndexConverter<KeyTypeEnum>(KeyTypeEnum.values);
}

class SshKey extends DataClass implements Insertable<SshKey> {
  /// Unique identifier (UUID v4).
  final String id;

  /// User-facing display name.
  final String label;

  /// Key algorithm type.
  final KeyTypeEnum keyType;

  /// Key size in bits (e.g., 2048, 4096 for RSA; 256 for Ed25519).
  final int? keyBits;

  /// The public key string.
  final String publicKey;

  /// Reference key for retrieving private key from secure storage.
  final String privateKeyRef;

  /// SHA256 fingerprint of the public key.
  final String fingerprint;

  /// Whether the private key is protected by a passphrase.
  final bool hasPassphrase;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Record last-modified timestamp.
  final DateTime updatedAt;

  /// Lamport clock for sync conflict resolution.
  final int syncVersion;

  /// Soft-delete tombstone flag.
  final bool isDeleted;
  const SshKey({
    required this.id,
    required this.label,
    required this.keyType,
    this.keyBits,
    required this.publicKey,
    required this.privateKeyRef,
    required this.fingerprint,
    required this.hasPassphrase,
    required this.createdAt,
    required this.updatedAt,
    required this.syncVersion,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    {
      map['key_type'] = Variable<int>(
        $SshKeysTable.$converterkeyType.toSql(keyType),
      );
    }
    if (!nullToAbsent || keyBits != null) {
      map['key_bits'] = Variable<int>(keyBits);
    }
    map['public_key'] = Variable<String>(publicKey);
    map['private_key_ref'] = Variable<String>(privateKeyRef);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['has_passphrase'] = Variable<bool>(hasPassphrase);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_version'] = Variable<int>(syncVersion);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  SshKeysCompanion toCompanion(bool nullToAbsent) {
    return SshKeysCompanion(
      id: Value(id),
      label: Value(label),
      keyType: Value(keyType),
      keyBits: keyBits == null && nullToAbsent
          ? const Value.absent()
          : Value(keyBits),
      publicKey: Value(publicKey),
      privateKeyRef: Value(privateKeyRef),
      fingerprint: Value(fingerprint),
      hasPassphrase: Value(hasPassphrase),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncVersion: Value(syncVersion),
      isDeleted: Value(isDeleted),
    );
  }

  factory SshKey.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SshKey(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      keyType: $SshKeysTable.$converterkeyType.fromJson(
        serializer.fromJson<int>(json['keyType']),
      ),
      keyBits: serializer.fromJson<int?>(json['keyBits']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      privateKeyRef: serializer.fromJson<String>(json['privateKeyRef']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      hasPassphrase: serializer.fromJson<bool>(json['hasPassphrase']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'keyType': serializer.toJson<int>(
        $SshKeysTable.$converterkeyType.toJson(keyType),
      ),
      'keyBits': serializer.toJson<int?>(keyBits),
      'publicKey': serializer.toJson<String>(publicKey),
      'privateKeyRef': serializer.toJson<String>(privateKeyRef),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'hasPassphrase': serializer.toJson<bool>(hasPassphrase),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  SshKey copyWith({
    String? id,
    String? label,
    KeyTypeEnum? keyType,
    Value<int?> keyBits = const Value.absent(),
    String? publicKey,
    String? privateKeyRef,
    String? fingerprint,
    bool? hasPassphrase,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
    bool? isDeleted,
  }) => SshKey(
    id: id ?? this.id,
    label: label ?? this.label,
    keyType: keyType ?? this.keyType,
    keyBits: keyBits.present ? keyBits.value : this.keyBits,
    publicKey: publicKey ?? this.publicKey,
    privateKeyRef: privateKeyRef ?? this.privateKeyRef,
    fingerprint: fingerprint ?? this.fingerprint,
    hasPassphrase: hasPassphrase ?? this.hasPassphrase,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncVersion: syncVersion ?? this.syncVersion,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  SshKey copyWithCompanion(SshKeysCompanion data) {
    return SshKey(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      keyType: data.keyType.present ? data.keyType.value : this.keyType,
      keyBits: data.keyBits.present ? data.keyBits.value : this.keyBits,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      privateKeyRef: data.privateKeyRef.present
          ? data.privateKeyRef.value
          : this.privateKeyRef,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      hasPassphrase: data.hasPassphrase.present
          ? data.hasPassphrase.value
          : this.hasPassphrase,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SshKey(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('keyType: $keyType, ')
          ..write('keyBits: $keyBits, ')
          ..write('publicKey: $publicKey, ')
          ..write('privateKeyRef: $privateKeyRef, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('hasPassphrase: $hasPassphrase, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    keyType,
    keyBits,
    publicKey,
    privateKeyRef,
    fingerprint,
    hasPassphrase,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SshKey &&
          other.id == this.id &&
          other.label == this.label &&
          other.keyType == this.keyType &&
          other.keyBits == this.keyBits &&
          other.publicKey == this.publicKey &&
          other.privateKeyRef == this.privateKeyRef &&
          other.fingerprint == this.fingerprint &&
          other.hasPassphrase == this.hasPassphrase &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncVersion == this.syncVersion &&
          other.isDeleted == this.isDeleted);
}

class SshKeysCompanion extends UpdateCompanion<SshKey> {
  final Value<String> id;
  final Value<String> label;
  final Value<KeyTypeEnum> keyType;
  final Value<int?> keyBits;
  final Value<String> publicKey;
  final Value<String> privateKeyRef;
  final Value<String> fingerprint;
  final Value<bool> hasPassphrase;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> syncVersion;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const SshKeysCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.keyType = const Value.absent(),
    this.keyBits = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.privateKeyRef = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.hasPassphrase = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SshKeysCompanion.insert({
    required String id,
    required String label,
    required KeyTypeEnum keyType,
    this.keyBits = const Value.absent(),
    required String publicKey,
    required String privateKeyRef,
    required String fingerprint,
    this.hasPassphrase = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       keyType = Value(keyType),
       publicKey = Value(publicKey),
       privateKeyRef = Value(privateKeyRef),
       fingerprint = Value(fingerprint),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SshKey> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<int>? keyType,
    Expression<int>? keyBits,
    Expression<String>? publicKey,
    Expression<String>? privateKeyRef,
    Expression<String>? fingerprint,
    Expression<bool>? hasPassphrase,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (keyType != null) 'key_type': keyType,
      if (keyBits != null) 'key_bits': keyBits,
      if (publicKey != null) 'public_key': publicKey,
      if (privateKeyRef != null) 'private_key_ref': privateKeyRef,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (hasPassphrase != null) 'has_passphrase': hasPassphrase,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SshKeysCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<KeyTypeEnum>? keyType,
    Value<int?>? keyBits,
    Value<String>? publicKey,
    Value<String>? privateKeyRef,
    Value<String>? fingerprint,
    Value<bool>? hasPassphrase,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? syncVersion,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return SshKeysCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      keyType: keyType ?? this.keyType,
      keyBits: keyBits ?? this.keyBits,
      publicKey: publicKey ?? this.publicKey,
      privateKeyRef: privateKeyRef ?? this.privateKeyRef,
      fingerprint: fingerprint ?? this.fingerprint,
      hasPassphrase: hasPassphrase ?? this.hasPassphrase,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (keyType.present) {
      map['key_type'] = Variable<int>(
        $SshKeysTable.$converterkeyType.toSql(keyType.value),
      );
    }
    if (keyBits.present) {
      map['key_bits'] = Variable<int>(keyBits.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (privateKeyRef.present) {
      map['private_key_ref'] = Variable<String>(privateKeyRef.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (hasPassphrase.present) {
      map['has_passphrase'] = Variable<bool>(hasPassphrase.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SshKeysCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('keyType: $keyType, ')
          ..write('keyBits: $keyBits, ')
          ..write('publicKey: $publicKey, ')
          ..write('privateKeyRef: $privateKeyRef, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('hasPassphrase: $hasPassphrase, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets with TableInfo<$SnippetsTable, Snippet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commandMeta = const VerificationMeta(
    'command',
  );
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
    'command',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _variablesMeta = const VerificationMeta(
    'variables',
  );
  @override
  late final GeneratedColumn<String> variables = GeneratedColumn<String>(
    'variables',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    command,
    category,
    variables,
    description,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snippet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('command')) {
      context.handle(
        _commandMeta,
        command.isAcceptableOrUnknown(data['command']!, _commandMeta),
      );
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('variables')) {
      context.handle(
        _variablesMeta,
        variables.isAcceptableOrUnknown(data['variables']!, _variablesMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snippet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snippet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      command: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      variables: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variables'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class Snippet extends DataClass implements Insertable<Snippet> {
  /// Unique identifier (UUID v4).
  final String id;

  /// Display name for the snippet.
  final String name;

  /// The actual command text.
  final String command;

  /// Category for grouping (e.g., "System", "Docker", "Network").
  final String? category;

  /// JSON-encoded list of variable placeholder names.
  final String variables;

  /// Optional description of what the snippet does.
  final String? description;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Record last-modified timestamp.
  final DateTime updatedAt;

  /// Lamport clock for sync conflict resolution.
  final int syncVersion;

  /// Soft-delete tombstone flag.
  final bool isDeleted;
  const Snippet({
    required this.id,
    required this.name,
    required this.command,
    this.category,
    required this.variables,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.syncVersion,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['command'] = Variable<String>(command);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['variables'] = Variable<String>(variables);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_version'] = Variable<int>(syncVersion);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      name: Value(name),
      command: Value(command),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      variables: Value(variables),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncVersion: Value(syncVersion),
      isDeleted: Value(isDeleted),
    );
  }

  factory Snippet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snippet(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      command: serializer.fromJson<String>(json['command']),
      category: serializer.fromJson<String?>(json['category']),
      variables: serializer.fromJson<String>(json['variables']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'command': serializer.toJson<String>(command),
      'category': serializer.toJson<String?>(category),
      'variables': serializer.toJson<String>(variables),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Snippet copyWith({
    String? id,
    String? name,
    String? command,
    Value<String?> category = const Value.absent(),
    String? variables,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
    bool? isDeleted,
  }) => Snippet(
    id: id ?? this.id,
    name: name ?? this.name,
    command: command ?? this.command,
    category: category.present ? category.value : this.category,
    variables: variables ?? this.variables,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncVersion: syncVersion ?? this.syncVersion,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Snippet copyWithCompanion(SnippetsCompanion data) {
    return Snippet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      command: data.command.present ? data.command.value : this.command,
      category: data.category.present ? data.category.value : this.category,
      variables: data.variables.present ? data.variables.value : this.variables,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snippet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('command: $command, ')
          ..write('category: $category, ')
          ..write('variables: $variables, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    command,
    category,
    variables,
    description,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snippet &&
          other.id == this.id &&
          other.name == this.name &&
          other.command == this.command &&
          other.category == this.category &&
          other.variables == this.variables &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncVersion == this.syncVersion &&
          other.isDeleted == this.isDeleted);
}

class SnippetsCompanion extends UpdateCompanion<Snippet> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> command;
  final Value<String?> category;
  final Value<String> variables;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> syncVersion;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.command = const Value.absent(),
    this.category = const Value.absent(),
    this.variables = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetsCompanion.insert({
    required String id,
    required String name,
    required String command,
    this.category = const Value.absent(),
    this.variables = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       command = Value(command),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Snippet> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? command,
    Expression<String>? category,
    Expression<String>? variables,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (command != null) 'command': command,
      if (category != null) 'category': category,
      if (variables != null) 'variables': variables,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? command,
    Value<String?>? category,
    Value<String>? variables,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? syncVersion,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return SnippetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      command: command ?? this.command,
      category: category ?? this.category,
      variables: variables ?? this.variables,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (variables.present) {
      map['variables'] = Variable<String>(variables.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('command: $command, ')
          ..write('category: $category, ')
          ..write('variables: $variables, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PortForwardsTable extends PortForwards
    with TableInfo<$PortForwardsTable, PortForward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PortForwardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PortForwardTypeEnum, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PortForwardTypeEnum>($PortForwardsTable.$convertertype);
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcePortMeta = const VerificationMeta(
    'sourcePort',
  );
  @override
  late final GeneratedColumn<int> sourcePort = GeneratedColumn<int>(
    'source_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationHostMeta = const VerificationMeta(
    'destinationHost',
  );
  @override
  late final GeneratedColumn<String> destinationHost = GeneratedColumn<String>(
    'destination_host',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationPortMeta = const VerificationMeta(
    'destinationPort',
  );
  @override
  late final GeneratedColumn<int> destinationPort = GeneratedColumn<int>(
    'destination_port',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoStartMeta = const VerificationMeta(
    'autoStart',
  );
  @override
  late final GeneratedColumn<bool> autoStart = GeneratedColumn<bool>(
    'auto_start',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    type,
    hostId,
    sourcePort,
    destinationHost,
    destinationPort,
    autoStart,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'port_forwards';
  @override
  VerificationContext validateIntegrity(
    Insertable<PortForward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('source_port')) {
      context.handle(
        _sourcePortMeta,
        sourcePort.isAcceptableOrUnknown(data['source_port']!, _sourcePortMeta),
      );
    } else if (isInserting) {
      context.missing(_sourcePortMeta);
    }
    if (data.containsKey('destination_host')) {
      context.handle(
        _destinationHostMeta,
        destinationHost.isAcceptableOrUnknown(
          data['destination_host']!,
          _destinationHostMeta,
        ),
      );
    }
    if (data.containsKey('destination_port')) {
      context.handle(
        _destinationPortMeta,
        destinationPort.isAcceptableOrUnknown(
          data['destination_port']!,
          _destinationPortMeta,
        ),
      );
    }
    if (data.containsKey('auto_start')) {
      context.handle(
        _autoStartMeta,
        autoStart.isAcceptableOrUnknown(data['auto_start']!, _autoStartMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PortForward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PortForward(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      type: $PortForwardsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      sourcePort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_port'],
      )!,
      destinationHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_host'],
      ),
      destinationPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}destination_port'],
      ),
      autoStart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $PortForwardsTable createAlias(String alias) {
    return $PortForwardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PortForwardTypeEnum, int, int> $convertertype =
      const EnumIndexConverter<PortForwardTypeEnum>(PortForwardTypeEnum.values);
}

class PortForward extends DataClass implements Insertable<PortForward> {
  /// Unique identifier (UUID v4).
  final String id;

  /// User-facing display name.
  final String label;

  /// Tunnel type (local, remote, or dynamic SOCKS proxy).
  final PortForwardTypeEnum type;

  /// Foreign key to the host this rule applies to.
  final String hostId;

  /// Source port on the local or remote side.
  final int sourcePort;

  /// Destination host for local/remote forwarding.
  final String? destinationHost;

  /// Destination port for local/remote forwarding.
  final int? destinationPort;

  /// Whether to start this tunnel automatically on connect.
  final bool autoStart;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Record last-modified timestamp.
  final DateTime updatedAt;

  /// Lamport clock for sync conflict resolution.
  final int syncVersion;

  /// Soft-delete tombstone flag.
  final bool isDeleted;
  const PortForward({
    required this.id,
    required this.label,
    required this.type,
    required this.hostId,
    required this.sourcePort,
    this.destinationHost,
    this.destinationPort,
    required this.autoStart,
    required this.createdAt,
    required this.updatedAt,
    required this.syncVersion,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    {
      map['type'] = Variable<int>(
        $PortForwardsTable.$convertertype.toSql(type),
      );
    }
    map['host_id'] = Variable<String>(hostId);
    map['source_port'] = Variable<int>(sourcePort);
    if (!nullToAbsent || destinationHost != null) {
      map['destination_host'] = Variable<String>(destinationHost);
    }
    if (!nullToAbsent || destinationPort != null) {
      map['destination_port'] = Variable<int>(destinationPort);
    }
    map['auto_start'] = Variable<bool>(autoStart);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_version'] = Variable<int>(syncVersion);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  PortForwardsCompanion toCompanion(bool nullToAbsent) {
    return PortForwardsCompanion(
      id: Value(id),
      label: Value(label),
      type: Value(type),
      hostId: Value(hostId),
      sourcePort: Value(sourcePort),
      destinationHost: destinationHost == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationHost),
      destinationPort: destinationPort == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationPort),
      autoStart: Value(autoStart),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncVersion: Value(syncVersion),
      isDeleted: Value(isDeleted),
    );
  }

  factory PortForward.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PortForward(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      type: $PortForwardsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      hostId: serializer.fromJson<String>(json['hostId']),
      sourcePort: serializer.fromJson<int>(json['sourcePort']),
      destinationHost: serializer.fromJson<String?>(json['destinationHost']),
      destinationPort: serializer.fromJson<int?>(json['destinationPort']),
      autoStart: serializer.fromJson<bool>(json['autoStart']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'type': serializer.toJson<int>(
        $PortForwardsTable.$convertertype.toJson(type),
      ),
      'hostId': serializer.toJson<String>(hostId),
      'sourcePort': serializer.toJson<int>(sourcePort),
      'destinationHost': serializer.toJson<String?>(destinationHost),
      'destinationPort': serializer.toJson<int?>(destinationPort),
      'autoStart': serializer.toJson<bool>(autoStart),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  PortForward copyWith({
    String? id,
    String? label,
    PortForwardTypeEnum? type,
    String? hostId,
    int? sourcePort,
    Value<String?> destinationHost = const Value.absent(),
    Value<int?> destinationPort = const Value.absent(),
    bool? autoStart,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
    bool? isDeleted,
  }) => PortForward(
    id: id ?? this.id,
    label: label ?? this.label,
    type: type ?? this.type,
    hostId: hostId ?? this.hostId,
    sourcePort: sourcePort ?? this.sourcePort,
    destinationHost: destinationHost.present
        ? destinationHost.value
        : this.destinationHost,
    destinationPort: destinationPort.present
        ? destinationPort.value
        : this.destinationPort,
    autoStart: autoStart ?? this.autoStart,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncVersion: syncVersion ?? this.syncVersion,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  PortForward copyWithCompanion(PortForwardsCompanion data) {
    return PortForward(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      type: data.type.present ? data.type.value : this.type,
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      sourcePort: data.sourcePort.present
          ? data.sourcePort.value
          : this.sourcePort,
      destinationHost: data.destinationHost.present
          ? data.destinationHost.value
          : this.destinationHost,
      destinationPort: data.destinationPort.present
          ? data.destinationPort.value
          : this.destinationPort,
      autoStart: data.autoStart.present ? data.autoStart.value : this.autoStart,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PortForward(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('hostId: $hostId, ')
          ..write('sourcePort: $sourcePort, ')
          ..write('destinationHost: $destinationHost, ')
          ..write('destinationPort: $destinationPort, ')
          ..write('autoStart: $autoStart, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    type,
    hostId,
    sourcePort,
    destinationHost,
    destinationPort,
    autoStart,
    createdAt,
    updatedAt,
    syncVersion,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PortForward &&
          other.id == this.id &&
          other.label == this.label &&
          other.type == this.type &&
          other.hostId == this.hostId &&
          other.sourcePort == this.sourcePort &&
          other.destinationHost == this.destinationHost &&
          other.destinationPort == this.destinationPort &&
          other.autoStart == this.autoStart &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncVersion == this.syncVersion &&
          other.isDeleted == this.isDeleted);
}

class PortForwardsCompanion extends UpdateCompanion<PortForward> {
  final Value<String> id;
  final Value<String> label;
  final Value<PortForwardTypeEnum> type;
  final Value<String> hostId;
  final Value<int> sourcePort;
  final Value<String?> destinationHost;
  final Value<int?> destinationPort;
  final Value<bool> autoStart;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> syncVersion;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const PortForwardsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.type = const Value.absent(),
    this.hostId = const Value.absent(),
    this.sourcePort = const Value.absent(),
    this.destinationHost = const Value.absent(),
    this.destinationPort = const Value.absent(),
    this.autoStart = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PortForwardsCompanion.insert({
    required String id,
    required String label,
    required PortForwardTypeEnum type,
    required String hostId,
    required int sourcePort,
    this.destinationHost = const Value.absent(),
    this.destinationPort = const Value.absent(),
    this.autoStart = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncVersion = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       type = Value(type),
       hostId = Value(hostId),
       sourcePort = Value(sourcePort),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PortForward> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<int>? type,
    Expression<String>? hostId,
    Expression<int>? sourcePort,
    Expression<String>? destinationHost,
    Expression<int>? destinationPort,
    Expression<bool>? autoStart,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (type != null) 'type': type,
      if (hostId != null) 'host_id': hostId,
      if (sourcePort != null) 'source_port': sourcePort,
      if (destinationHost != null) 'destination_host': destinationHost,
      if (destinationPort != null) 'destination_port': destinationPort,
      if (autoStart != null) 'auto_start': autoStart,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PortForwardsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<PortForwardTypeEnum>? type,
    Value<String>? hostId,
    Value<int>? sourcePort,
    Value<String?>? destinationHost,
    Value<int?>? destinationPort,
    Value<bool>? autoStart,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? syncVersion,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return PortForwardsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      hostId: hostId ?? this.hostId,
      sourcePort: sourcePort ?? this.sourcePort,
      destinationHost: destinationHost ?? this.destinationHost,
      destinationPort: destinationPort ?? this.destinationPort,
      autoStart: autoStart ?? this.autoStart,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $PortForwardsTable.$convertertype.toSql(type.value),
      );
    }
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (sourcePort.present) {
      map['source_port'] = Variable<int>(sourcePort.value);
    }
    if (destinationHost.present) {
      map['destination_host'] = Variable<String>(destinationHost.value);
    }
    if (destinationPort.present) {
      map['destination_port'] = Variable<int>(destinationPort.value);
    }
    if (autoStart.present) {
      map['auto_start'] = Variable<bool>(autoStart.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PortForwardsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('hostId: $hostId, ')
          ..write('sourcePort: $sourcePort, ')
          ..write('destinationHost: $destinationHost, ')
          ..write('destinationPort: $destinationPort, ')
          ..write('autoStart: $autoStart, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnownHostsTable extends KnownHosts
    with TableInfo<$KnownHostsTable, KnownHost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnownHostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyTypeMeta = const VerificationMeta(
    'keyType',
  );
  @override
  late final GeneratedColumn<String> keyType = GeneratedColumn<String>(
    'key_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTrustedMeta = const VerificationMeta(
    'isTrusted',
  );
  @override
  late final GeneratedColumn<bool> isTrusted = GeneratedColumn<bool>(
    'is_trusted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_trusted" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _firstSeenMeta = const VerificationMeta(
    'firstSeen',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeen = GeneratedColumn<DateTime>(
    'first_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hostname,
    port,
    keyType,
    fingerprint,
    publicKey,
    isTrusted,
    firstSeen,
    lastSeen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'known_hosts';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnownHost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    } else if (isInserting) {
      context.missing(_hostnameMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('key_type')) {
      context.handle(
        _keyTypeMeta,
        keyType.isAcceptableOrUnknown(data['key_type']!, _keyTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_keyTypeMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('is_trusted')) {
      context.handle(
        _isTrustedMeta,
        isTrusted.isAcceptableOrUnknown(data['is_trusted']!, _isTrustedMeta),
      );
    }
    if (data.containsKey('first_seen')) {
      context.handle(
        _firstSeenMeta,
        firstSeen.isAcceptableOrUnknown(data['first_seen']!, _firstSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_firstSeenMeta);
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnownHost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnownHost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      keyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_type'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_key'],
      )!,
      isTrusted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_trusted'],
      )!,
      firstSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen'],
      )!,
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      )!,
    );
  }

  @override
  $KnownHostsTable createAlias(String alias) {
    return $KnownHostsTable(attachedDatabase, alias);
  }
}

class KnownHost extends DataClass implements Insertable<KnownHost> {
  /// Unique identifier (UUID v4).
  final String id;

  /// Hostname or IP address of the server.
  final String hostname;

  /// SSH port number.
  final int port;

  /// Key algorithm type string (e.g., "ssh-ed25519", "ssh-rsa").
  final String keyType;

  /// SHA256 fingerprint of the host's public key.
  final String fingerprint;

  /// Full host public key string.
  final String publicKey;

  /// Whether the user has explicitly trusted this fingerprint.
  final bool isTrusted;

  /// Timestamp when this fingerprint was first seen.
  final DateTime firstSeen;

  /// Timestamp of the most recent connection to this host.
  final DateTime lastSeen;
  const KnownHost({
    required this.id,
    required this.hostname,
    required this.port,
    required this.keyType,
    required this.fingerprint,
    required this.publicKey,
    required this.isTrusted,
    required this.firstSeen,
    required this.lastSeen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hostname'] = Variable<String>(hostname);
    map['port'] = Variable<int>(port);
    map['key_type'] = Variable<String>(keyType);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['public_key'] = Variable<String>(publicKey);
    map['is_trusted'] = Variable<bool>(isTrusted);
    map['first_seen'] = Variable<DateTime>(firstSeen);
    map['last_seen'] = Variable<DateTime>(lastSeen);
    return map;
  }

  KnownHostsCompanion toCompanion(bool nullToAbsent) {
    return KnownHostsCompanion(
      id: Value(id),
      hostname: Value(hostname),
      port: Value(port),
      keyType: Value(keyType),
      fingerprint: Value(fingerprint),
      publicKey: Value(publicKey),
      isTrusted: Value(isTrusted),
      firstSeen: Value(firstSeen),
      lastSeen: Value(lastSeen),
    );
  }

  factory KnownHost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnownHost(
      id: serializer.fromJson<String>(json['id']),
      hostname: serializer.fromJson<String>(json['hostname']),
      port: serializer.fromJson<int>(json['port']),
      keyType: serializer.fromJson<String>(json['keyType']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      isTrusted: serializer.fromJson<bool>(json['isTrusted']),
      firstSeen: serializer.fromJson<DateTime>(json['firstSeen']),
      lastSeen: serializer.fromJson<DateTime>(json['lastSeen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hostname': serializer.toJson<String>(hostname),
      'port': serializer.toJson<int>(port),
      'keyType': serializer.toJson<String>(keyType),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'publicKey': serializer.toJson<String>(publicKey),
      'isTrusted': serializer.toJson<bool>(isTrusted),
      'firstSeen': serializer.toJson<DateTime>(firstSeen),
      'lastSeen': serializer.toJson<DateTime>(lastSeen),
    };
  }

  KnownHost copyWith({
    String? id,
    String? hostname,
    int? port,
    String? keyType,
    String? fingerprint,
    String? publicKey,
    bool? isTrusted,
    DateTime? firstSeen,
    DateTime? lastSeen,
  }) => KnownHost(
    id: id ?? this.id,
    hostname: hostname ?? this.hostname,
    port: port ?? this.port,
    keyType: keyType ?? this.keyType,
    fingerprint: fingerprint ?? this.fingerprint,
    publicKey: publicKey ?? this.publicKey,
    isTrusted: isTrusted ?? this.isTrusted,
    firstSeen: firstSeen ?? this.firstSeen,
    lastSeen: lastSeen ?? this.lastSeen,
  );
  KnownHost copyWithCompanion(KnownHostsCompanion data) {
    return KnownHost(
      id: data.id.present ? data.id.value : this.id,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      port: data.port.present ? data.port.value : this.port,
      keyType: data.keyType.present ? data.keyType.value : this.keyType,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      isTrusted: data.isTrusted.present ? data.isTrusted.value : this.isTrusted,
      firstSeen: data.firstSeen.present ? data.firstSeen.value : this.firstSeen,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnownHost(')
          ..write('id: $id, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('publicKey: $publicKey, ')
          ..write('isTrusted: $isTrusted, ')
          ..write('firstSeen: $firstSeen, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hostname,
    port,
    keyType,
    fingerprint,
    publicKey,
    isTrusted,
    firstSeen,
    lastSeen,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnownHost &&
          other.id == this.id &&
          other.hostname == this.hostname &&
          other.port == this.port &&
          other.keyType == this.keyType &&
          other.fingerprint == this.fingerprint &&
          other.publicKey == this.publicKey &&
          other.isTrusted == this.isTrusted &&
          other.firstSeen == this.firstSeen &&
          other.lastSeen == this.lastSeen);
}

class KnownHostsCompanion extends UpdateCompanion<KnownHost> {
  final Value<String> id;
  final Value<String> hostname;
  final Value<int> port;
  final Value<String> keyType;
  final Value<String> fingerprint;
  final Value<String> publicKey;
  final Value<bool> isTrusted;
  final Value<DateTime> firstSeen;
  final Value<DateTime> lastSeen;
  final Value<int> rowid;
  const KnownHostsCompanion({
    this.id = const Value.absent(),
    this.hostname = const Value.absent(),
    this.port = const Value.absent(),
    this.keyType = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.isTrusted = const Value.absent(),
    this.firstSeen = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnownHostsCompanion.insert({
    required String id,
    required String hostname,
    required int port,
    required String keyType,
    required String fingerprint,
    required String publicKey,
    this.isTrusted = const Value.absent(),
    required DateTime firstSeen,
    required DateTime lastSeen,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       hostname = Value(hostname),
       port = Value(port),
       keyType = Value(keyType),
       fingerprint = Value(fingerprint),
       publicKey = Value(publicKey),
       firstSeen = Value(firstSeen),
       lastSeen = Value(lastSeen);
  static Insertable<KnownHost> custom({
    Expression<String>? id,
    Expression<String>? hostname,
    Expression<int>? port,
    Expression<String>? keyType,
    Expression<String>? fingerprint,
    Expression<String>? publicKey,
    Expression<bool>? isTrusted,
    Expression<DateTime>? firstSeen,
    Expression<DateTime>? lastSeen,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hostname != null) 'hostname': hostname,
      if (port != null) 'port': port,
      if (keyType != null) 'key_type': keyType,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (publicKey != null) 'public_key': publicKey,
      if (isTrusted != null) 'is_trusted': isTrusted,
      if (firstSeen != null) 'first_seen': firstSeen,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnownHostsCompanion copyWith({
    Value<String>? id,
    Value<String>? hostname,
    Value<int>? port,
    Value<String>? keyType,
    Value<String>? fingerprint,
    Value<String>? publicKey,
    Value<bool>? isTrusted,
    Value<DateTime>? firstSeen,
    Value<DateTime>? lastSeen,
    Value<int>? rowid,
  }) {
    return KnownHostsCompanion(
      id: id ?? this.id,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      keyType: keyType ?? this.keyType,
      fingerprint: fingerprint ?? this.fingerprint,
      publicKey: publicKey ?? this.publicKey,
      isTrusted: isTrusted ?? this.isTrusted,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (keyType.present) {
      map['key_type'] = Variable<String>(keyType.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (isTrusted.present) {
      map['is_trusted'] = Variable<bool>(isTrusted.value);
    }
    if (firstSeen.present) {
      map['first_seen'] = Variable<DateTime>(firstSeen.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnownHostsCompanion(')
          ..write('id: $id, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('publicKey: $publicKey, ')
          ..write('isTrusted: $isTrusted, ')
          ..write('firstSeen: $firstSeen, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecretsTable extends Secrets with TableInfo<$SecretsTable, Secret> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecretsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedValueMeta = const VerificationMeta(
    'encryptedValue',
  );
  @override
  late final GeneratedColumn<String> encryptedValue = GeneratedColumn<String>(
    'encrypted_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<String> nonce = GeneratedColumn<String>(
    'nonce',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, encryptedValue, nonce, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'secrets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Secret> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('encrypted_value')) {
      context.handle(
        _encryptedValueMeta,
        encryptedValue.isAcceptableOrUnknown(
          data['encrypted_value']!,
          _encryptedValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedValueMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
        _nonceMeta,
        nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta),
      );
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Secret map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Secret(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      encryptedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_value'],
      )!,
      nonce: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nonce'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SecretsTable createAlias(String alias) {
    return $SecretsTable(attachedDatabase, alias);
  }
}

class Secret extends DataClass implements Insertable<Secret> {
  /// Secret key name (unique identifier, e.g. "cloudshell_ssh_key_{id}").
  final String key;

  /// AES-256-GCM encrypted value (base64-encoded ciphertext + MAC tag).
  final String encryptedValue;

  /// AES-256-GCM nonce/IV used for this entry (base64-encoded, 12 bytes).
  final String nonce;

  /// Record creation/update timestamp.
  final DateTime updatedAt;
  const Secret({
    required this.key,
    required this.encryptedValue,
    required this.nonce,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['encrypted_value'] = Variable<String>(encryptedValue);
    map['nonce'] = Variable<String>(nonce);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SecretsCompanion toCompanion(bool nullToAbsent) {
    return SecretsCompanion(
      key: Value(key),
      encryptedValue: Value(encryptedValue),
      nonce: Value(nonce),
      updatedAt: Value(updatedAt),
    );
  }

  factory Secret.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Secret(
      key: serializer.fromJson<String>(json['key']),
      encryptedValue: serializer.fromJson<String>(json['encryptedValue']),
      nonce: serializer.fromJson<String>(json['nonce']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'encryptedValue': serializer.toJson<String>(encryptedValue),
      'nonce': serializer.toJson<String>(nonce),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Secret copyWith({
    String? key,
    String? encryptedValue,
    String? nonce,
    DateTime? updatedAt,
  }) => Secret(
    key: key ?? this.key,
    encryptedValue: encryptedValue ?? this.encryptedValue,
    nonce: nonce ?? this.nonce,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Secret copyWithCompanion(SecretsCompanion data) {
    return Secret(
      key: data.key.present ? data.key.value : this.key,
      encryptedValue: data.encryptedValue.present
          ? data.encryptedValue.value
          : this.encryptedValue,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Secret(')
          ..write('key: $key, ')
          ..write('encryptedValue: $encryptedValue, ')
          ..write('nonce: $nonce, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, encryptedValue, nonce, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Secret &&
          other.key == this.key &&
          other.encryptedValue == this.encryptedValue &&
          other.nonce == this.nonce &&
          other.updatedAt == this.updatedAt);
}

class SecretsCompanion extends UpdateCompanion<Secret> {
  final Value<String> key;
  final Value<String> encryptedValue;
  final Value<String> nonce;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SecretsCompanion({
    this.key = const Value.absent(),
    this.encryptedValue = const Value.absent(),
    this.nonce = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SecretsCompanion.insert({
    required String key,
    required String encryptedValue,
    required String nonce,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       encryptedValue = Value(encryptedValue),
       nonce = Value(nonce),
       updatedAt = Value(updatedAt);
  static Insertable<Secret> custom({
    Expression<String>? key,
    Expression<String>? encryptedValue,
    Expression<String>? nonce,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (encryptedValue != null) 'encrypted_value': encryptedValue,
      if (nonce != null) 'nonce': nonce,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SecretsCompanion copyWith({
    Value<String>? key,
    Value<String>? encryptedValue,
    Value<String>? nonce,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SecretsCompanion(
      key: key ?? this.key,
      encryptedValue: encryptedValue ?? this.encryptedValue,
      nonce: nonce ?? this.nonce,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (encryptedValue.present) {
      map['encrypted_value'] = Variable<String>(encryptedValue.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecretsCompanion(')
          ..write('key: $key, ')
          ..write('encryptedValue: $encryptedValue, ')
          ..write('nonce: $nonce, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  /// Setting key name (unique identifier).
  final String key;

  /// Setting value (string-encoded).
  final String value;

  /// Record last-modified timestamp.
  final DateTime updatedAt;
  const Setting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      Setting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncVersionMeta = const VerificationMeta(
    'lastSyncVersion',
  );
  @override
  late final GeneratedColumn<int> lastSyncVersion = GeneratedColumn<int>(
    'last_sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityType,
    lastSyncVersion,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('last_sync_version')) {
      context.handle(
        _lastSyncVersionMeta,
        lastSyncVersion.isAcceptableOrUnknown(
          data['last_sync_version']!,
          _lastSyncVersionMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      lastSyncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_version'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  /// Entity type name (primary key): 'host', 'ssh_key', 'group', etc.
  final String entityType;

  /// Last sync version successfully pulled from the server.
  final int lastSyncVersion;

  /// Timestamp of last successful sync.
  final DateTime? lastSyncAt;
  const SyncMetadataData({
    required this.entityType,
    required this.lastSyncVersion,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['last_sync_version'] = Variable<int>(lastSyncVersion);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      entityType: Value(entityType),
      lastSyncVersion: Value(lastSyncVersion),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      entityType: serializer.fromJson<String>(json['entityType']),
      lastSyncVersion: serializer.fromJson<int>(json['lastSyncVersion']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'lastSyncVersion': serializer.toJson<int>(lastSyncVersion),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  SyncMetadataData copyWith({
    String? entityType,
    int? lastSyncVersion,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => SyncMetadataData(
    entityType: entityType ?? this.entityType,
    lastSyncVersion: lastSyncVersion ?? this.lastSyncVersion,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      lastSyncVersion: data.lastSyncVersion.present
          ? data.lastSyncVersion.value
          : this.lastSyncVersion,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('entityType: $entityType, ')
          ..write('lastSyncVersion: $lastSyncVersion, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, lastSyncVersion, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.entityType == this.entityType &&
          other.lastSyncVersion == this.lastSyncVersion &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> entityType;
  final Value<int> lastSyncVersion;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.entityType = const Value.absent(),
    this.lastSyncVersion = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String entityType,
    this.lastSyncVersion = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? entityType,
    Expression<int>? lastSyncVersion,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (lastSyncVersion != null) 'last_sync_version': lastSyncVersion,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? entityType,
    Value<int>? lastSyncVersion,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      entityType: entityType ?? this.entityType,
      lastSyncVersion: lastSyncVersion ?? this.lastSyncVersion,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (lastSyncVersion.present) {
      map['last_sync_version'] = Variable<int>(lastSyncVersion.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('entityType: $entityType, ')
          ..write('lastSyncVersion: $lastSyncVersion, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncOperation, int> operation =
      GeneratedColumn<int>(
        'operation',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SyncOperation>($SyncQueueTable.$converteroperation);
  static const VerificationMeta _encryptedPayloadMeta = const VerificationMeta(
    'encryptedPayload',
  );
  @override
  late final GeneratedColumn<String> encryptedPayload = GeneratedColumn<String>(
    'encrypted_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    encryptedPayload,
    syncVersion,
    queuedAt,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('encrypted_payload')) {
      context.handle(
        _encryptedPayloadMeta,
        encryptedPayload.isAcceptableOrUnknown(
          data['encrypted_payload']!,
          _encryptedPayloadMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_queuedAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: $SyncQueueTable.$converteroperation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}operation'],
        )!,
      ),
      encryptedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_payload'],
      ),
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncOperation, int, int> $converteroperation =
      const EnumIndexConverter<SyncOperation>(SyncOperation.values);
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  /// Auto-incrementing ID.
  final int id;

  /// Entity type: 'host', 'ssh_key', 'group', 'snippet', 'port_forward'.
  final String entityType;

  /// Local UUID of the entity.
  final String entityId;

  /// Type of change.
  final SyncOperation operation;

  /// Pre-encrypted payload ready to push (null for deletes).
  final String? encryptedPayload;

  /// Sync version at time of queuing.
  final int syncVersion;

  /// When the change was queued.
  final DateTime queuedAt;

  /// Number of push retry attempts.
  final int retryCount;
  const SyncQueueData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.encryptedPayload,
    required this.syncVersion,
    required this.queuedAt,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    {
      map['operation'] = Variable<int>(
        $SyncQueueTable.$converteroperation.toSql(operation),
      );
    }
    if (!nullToAbsent || encryptedPayload != null) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload);
    }
    map['sync_version'] = Variable<int>(syncVersion);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      encryptedPayload: encryptedPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedPayload),
      syncVersion: Value(syncVersion),
      queuedAt: Value(queuedAt),
      retryCount: Value(retryCount),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: $SyncQueueTable.$converteroperation.fromJson(
        serializer.fromJson<int>(json['operation']),
      ),
      encryptedPayload: serializer.fromJson<String?>(json['encryptedPayload']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<int>(
        $SyncQueueTable.$converteroperation.toJson(operation),
      ),
      'encryptedPayload': serializer.toJson<String?>(encryptedPayload),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? entityType,
    String? entityId,
    SyncOperation? operation,
    Value<String?> encryptedPayload = const Value.absent(),
    int? syncVersion,
    DateTime? queuedAt,
    int? retryCount,
  }) => SyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    encryptedPayload: encryptedPayload.present
        ? encryptedPayload.value
        : this.encryptedPayload,
    syncVersion: syncVersion ?? this.syncVersion,
    queuedAt: queuedAt ?? this.queuedAt,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      encryptedPayload: data.encryptedPayload.present
          ? data.encryptedPayload.value
          : this.encryptedPayload,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    encryptedPayload,
    syncVersion,
    queuedAt,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.encryptedPayload == this.encryptedPayload &&
          other.syncVersion == this.syncVersion &&
          other.queuedAt == this.queuedAt &&
          other.retryCount == this.retryCount);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<SyncOperation> operation;
  final Value<String?> encryptedPayload;
  final Value<int> syncVersion;
  final Value<DateTime> queuedAt;
  final Value<int> retryCount;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.encryptedPayload = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    this.encryptedPayload = const Value.absent(),
    this.syncVersion = const Value.absent(),
    required DateTime queuedAt,
    this.retryCount = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       queuedAt = Value(queuedAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? operation,
    Expression<String>? encryptedPayload,
    Expression<int>? syncVersion,
    Expression<DateTime>? queuedAt,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<SyncOperation>? operation,
    Value<String?>? encryptedPayload,
    Value<int>? syncVersion,
    Value<DateTime>? queuedAt,
    Value<int>? retryCount,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      syncVersion: syncVersion ?? this.syncVersion,
      queuedAt: queuedAt ?? this.queuedAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<int>(
        $SyncQueueTable.$converteroperation.toSql(operation.value),
      );
    }
    if (encryptedPayload.present) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

class $WorkspacesTable extends Workspaces
    with TableInfo<$WorkspacesTable, Workspace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkspacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _layoutJsonMeta = const VerificationMeta(
    'layoutJson',
  );
  @override
  late final GeneratedColumn<String> layoutJson = GeneratedColumn<String>(
    'layout_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    layoutJson,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workspaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workspace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('layout_json')) {
      context.handle(
        _layoutJsonMeta,
        layoutJson.isAcceptableOrUnknown(data['layout_json']!, _layoutJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutJsonMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workspace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workspace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      layoutJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_json'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkspacesTable createAlias(String alias) {
    return $WorkspacesTable(attachedDatabase, alias);
  }
}

class Workspace extends DataClass implements Insertable<Workspace> {
  /// Unique workspace identifier (UUID).
  final String id;

  /// User-assigned workspace name.
  final String name;

  /// JSON-encoded layout state (page tabs, terminal host refs, active tab).
  final String layoutJson;

  /// Whether this is the currently active workspace.
  final bool isActive;

  /// When this workspace was first created.
  final DateTime createdAt;

  /// When this workspace was last modified.
  final DateTime updatedAt;
  const Workspace({
    required this.id,
    required this.name,
    required this.layoutJson,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['layout_json'] = Variable<String>(layoutJson);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkspacesCompanion toCompanion(bool nullToAbsent) {
    return WorkspacesCompanion(
      id: Value(id),
      name: Value(name),
      layoutJson: Value(layoutJson),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Workspace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workspace(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      layoutJson: serializer.fromJson<String>(json['layoutJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'layoutJson': serializer.toJson<String>(layoutJson),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Workspace copyWith({
    String? id,
    String? name,
    String? layoutJson,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Workspace(
    id: id ?? this.id,
    name: name ?? this.name,
    layoutJson: layoutJson ?? this.layoutJson,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Workspace copyWithCompanion(WorkspacesCompanion data) {
    return Workspace(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      layoutJson: data.layoutJson.present
          ? data.layoutJson.value
          : this.layoutJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workspace(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('layoutJson: $layoutJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, layoutJson, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workspace &&
          other.id == this.id &&
          other.name == this.name &&
          other.layoutJson == this.layoutJson &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkspacesCompanion extends UpdateCompanion<Workspace> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> layoutJson;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkspacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.layoutJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkspacesCompanion.insert({
    required String id,
    required String name,
    required String layoutJson,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       layoutJson = Value(layoutJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Workspace> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? layoutJson,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (layoutJson != null) 'layout_json': layoutJson,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkspacesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? layoutJson,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkspacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      layoutJson: layoutJson ?? this.layoutJson,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (layoutJson.present) {
      map['layout_json'] = Variable<String>(layoutJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkspacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('layoutJson: $layoutJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HostsTable hosts = $HostsTable(this);
  late final $HostGroupsTable hostGroups = $HostGroupsTable(this);
  late final $SshKeysTable sshKeys = $SshKeysTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  late final $PortForwardsTable portForwards = $PortForwardsTable(this);
  late final $KnownHostsTable knownHosts = $KnownHostsTable(this);
  late final $SecretsTable secrets = $SecretsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $WorkspacesTable workspaces = $WorkspacesTable(this);
  late final Index idxHostsIsDeleted = Index(
    'idx_hosts_is_deleted',
    'CREATE INDEX idx_hosts_is_deleted ON hosts (is_deleted)',
  );
  late final Index idxHostsGroup = Index(
    'idx_hosts_group',
    'CREATE INDEX idx_hosts_group ON hosts (is_deleted, group_id)',
  );
  late final Index idxHostsLastConnected = Index(
    'idx_hosts_last_connected',
    'CREATE INDEX idx_hosts_last_connected ON hosts (last_connected_at)',
  );
  late final Index idxHostsFavorite = Index(
    'idx_hosts_favorite',
    'CREATE INDEX idx_hosts_favorite ON hosts (is_favorite)',
  );
  late final Index idxGroupsParent = Index(
    'idx_groups_parent',
    'CREATE INDEX idx_groups_parent ON host_groups (parent_group_id, is_deleted)',
  );
  late final Index idxSnippetsCategory = Index(
    'idx_snippets_category',
    'CREATE INDEX idx_snippets_category ON snippets (category, is_deleted)',
  );
  late final Index idxKnownHostsLookup = Index(
    'idx_known_hosts_lookup',
    'CREATE INDEX idx_known_hosts_lookup ON known_hosts (hostname, port, is_trusted)',
  );
  late final GroupDao groupDao = GroupDao(this as AppDatabase);
  late final HostDao hostDao = HostDao(this as AppDatabase);
  late final KeyDao keyDao = KeyDao(this as AppDatabase);
  late final KnownHostDao knownHostDao = KnownHostDao(this as AppDatabase);
  late final PortForwardDao portForwardDao = PortForwardDao(
    this as AppDatabase,
  );
  late final SecretsDao secretsDao = SecretsDao(this as AppDatabase);
  late final SnippetDao snippetDao = SnippetDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final SyncMetadataDao syncMetadataDao = SyncMetadataDao(
    this as AppDatabase,
  );
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  late final WorkspaceDao workspaceDao = WorkspaceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hosts,
    hostGroups,
    sshKeys,
    snippets,
    portForwards,
    knownHosts,
    secrets,
    settings,
    syncMetadata,
    syncQueue,
    workspaces,
    idxHostsIsDeleted,
    idxHostsGroup,
    idxHostsLastConnected,
    idxHostsFavorite,
    idxGroupsParent,
    idxSnippetsCategory,
    idxKnownHostsLookup,
  ];
}

typedef $$HostsTableCreateCompanionBuilder =
    HostsCompanion Function({
      required String id,
      required String label,
      required String hostname,
      Value<int> port,
      required String username,
      required AuthMethodType authMethod,
      Value<String?> keyId,
      Value<String?> groupId,
      Value<String> tags,
      Value<String?> startupCommand,
      Value<int> keepAliveSeconds,
      Value<String?> jumpHostId,
      Value<String?> encoding,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<bool> isFavorite,
      Value<DateTime?> lastConnectedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<ProtocolType> protocol,
      Value<String?> serialPort,
      Value<int?> serialBaudRate,
      Value<int?> serialDataBits,
      Value<int?> serialStopBits,
      Value<String?> serialParity,
      Value<String?> serialFlowControl,
      Value<int> rowid,
    });
typedef $$HostsTableUpdateCompanionBuilder =
    HostsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> hostname,
      Value<int> port,
      Value<String> username,
      Value<AuthMethodType> authMethod,
      Value<String?> keyId,
      Value<String?> groupId,
      Value<String> tags,
      Value<String?> startupCommand,
      Value<int> keepAliveSeconds,
      Value<String?> jumpHostId,
      Value<String?> encoding,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<bool> isFavorite,
      Value<DateTime?> lastConnectedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<ProtocolType> protocol,
      Value<String?> serialPort,
      Value<int?> serialBaudRate,
      Value<int?> serialDataBits,
      Value<int?> serialStopBits,
      Value<String?> serialParity,
      Value<String?> serialFlowControl,
      Value<int> rowid,
    });

class $$HostsTableFilterComposer extends Composer<_$AppDatabase, $HostsTable> {
  $$HostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AuthMethodType, AuthMethodType, int>
  get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get keyId => $composableBuilder(
    column: $table.keyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startupCommand => $composableBuilder(
    column: $table.startupCommand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get keepAliveSeconds => $composableBuilder(
    column: $table.keepAliveSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jumpHostId => $composableBuilder(
    column: $table.jumpHostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encoding => $composableBuilder(
    column: $table.encoding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProtocolType, ProtocolType, int>
  get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get serialPort => $composableBuilder(
    column: $table.serialPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serialBaudRate => $composableBuilder(
    column: $table.serialBaudRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serialDataBits => $composableBuilder(
    column: $table.serialDataBits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serialStopBits => $composableBuilder(
    column: $table.serialStopBits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialParity => $composableBuilder(
    column: $table.serialParity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialFlowControl => $composableBuilder(
    column: $table.serialFlowControl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HostsTableOrderingComposer
    extends Composer<_$AppDatabase, $HostsTable> {
  $$HostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyId => $composableBuilder(
    column: $table.keyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startupCommand => $composableBuilder(
    column: $table.startupCommand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get keepAliveSeconds => $composableBuilder(
    column: $table.keepAliveSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jumpHostId => $composableBuilder(
    column: $table.jumpHostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encoding => $composableBuilder(
    column: $table.encoding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialPort => $composableBuilder(
    column: $table.serialPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serialBaudRate => $composableBuilder(
    column: $table.serialBaudRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serialDataBits => $composableBuilder(
    column: $table.serialDataBits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serialStopBits => $composableBuilder(
    column: $table.serialStopBits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialParity => $composableBuilder(
    column: $table.serialParity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialFlowControl => $composableBuilder(
    column: $table.serialFlowControl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HostsTable> {
  $$HostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AuthMethodType, int> get authMethod =>
      $composableBuilder(
        column: $table.authMethod,
        builder: (column) => column,
      );

  GeneratedColumn<String> get keyId =>
      $composableBuilder(column: $table.keyId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get startupCommand => $composableBuilder(
    column: $table.startupCommand,
    builder: (column) => column,
  );

  GeneratedColumn<int> get keepAliveSeconds => $composableBuilder(
    column: $table.keepAliveSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jumpHostId => $composableBuilder(
    column: $table.jumpHostId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encoding =>
      $composableBuilder(column: $table.encoding, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProtocolType, int> get protocol =>
      $composableBuilder(column: $table.protocol, builder: (column) => column);

  GeneratedColumn<String> get serialPort => $composableBuilder(
    column: $table.serialPort,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serialBaudRate => $composableBuilder(
    column: $table.serialBaudRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serialDataBits => $composableBuilder(
    column: $table.serialDataBits,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serialStopBits => $composableBuilder(
    column: $table.serialStopBits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serialParity => $composableBuilder(
    column: $table.serialParity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serialFlowControl => $composableBuilder(
    column: $table.serialFlowControl,
    builder: (column) => column,
  );
}

class $$HostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HostsTable,
          Host,
          $$HostsTableFilterComposer,
          $$HostsTableOrderingComposer,
          $$HostsTableAnnotationComposer,
          $$HostsTableCreateCompanionBuilder,
          $$HostsTableUpdateCompanionBuilder,
          (Host, BaseReferences<_$AppDatabase, $HostsTable, Host>),
          Host,
          PrefetchHooks Function()
        > {
  $$HostsTableTableManager(_$AppDatabase db, $HostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> hostname = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<AuthMethodType> authMethod = const Value.absent(),
                Value<String?> keyId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> startupCommand = const Value.absent(),
                Value<int> keepAliveSeconds = const Value.absent(),
                Value<String?> jumpHostId = const Value.absent(),
                Value<String?> encoding = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastConnectedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<ProtocolType> protocol = const Value.absent(),
                Value<String?> serialPort = const Value.absent(),
                Value<int?> serialBaudRate = const Value.absent(),
                Value<int?> serialDataBits = const Value.absent(),
                Value<int?> serialStopBits = const Value.absent(),
                Value<String?> serialParity = const Value.absent(),
                Value<String?> serialFlowControl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HostsCompanion(
                id: id,
                label: label,
                hostname: hostname,
                port: port,
                username: username,
                authMethod: authMethod,
                keyId: keyId,
                groupId: groupId,
                tags: tags,
                startupCommand: startupCommand,
                keepAliveSeconds: keepAliveSeconds,
                jumpHostId: jumpHostId,
                encoding: encoding,
                notes: notes,
                sortOrder: sortOrder,
                isFavorite: isFavorite,
                lastConnectedAt: lastConnectedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                protocol: protocol,
                serialPort: serialPort,
                serialBaudRate: serialBaudRate,
                serialDataBits: serialDataBits,
                serialStopBits: serialStopBits,
                serialParity: serialParity,
                serialFlowControl: serialFlowControl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String hostname,
                Value<int> port = const Value.absent(),
                required String username,
                required AuthMethodType authMethod,
                Value<String?> keyId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> startupCommand = const Value.absent(),
                Value<int> keepAliveSeconds = const Value.absent(),
                Value<String?> jumpHostId = const Value.absent(),
                Value<String?> encoding = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastConnectedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<ProtocolType> protocol = const Value.absent(),
                Value<String?> serialPort = const Value.absent(),
                Value<int?> serialBaudRate = const Value.absent(),
                Value<int?> serialDataBits = const Value.absent(),
                Value<int?> serialStopBits = const Value.absent(),
                Value<String?> serialParity = const Value.absent(),
                Value<String?> serialFlowControl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HostsCompanion.insert(
                id: id,
                label: label,
                hostname: hostname,
                port: port,
                username: username,
                authMethod: authMethod,
                keyId: keyId,
                groupId: groupId,
                tags: tags,
                startupCommand: startupCommand,
                keepAliveSeconds: keepAliveSeconds,
                jumpHostId: jumpHostId,
                encoding: encoding,
                notes: notes,
                sortOrder: sortOrder,
                isFavorite: isFavorite,
                lastConnectedAt: lastConnectedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                protocol: protocol,
                serialPort: serialPort,
                serialBaudRate: serialBaudRate,
                serialDataBits: serialDataBits,
                serialStopBits: serialStopBits,
                serialParity: serialParity,
                serialFlowControl: serialFlowControl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HostsTable,
      Host,
      $$HostsTableFilterComposer,
      $$HostsTableOrderingComposer,
      $$HostsTableAnnotationComposer,
      $$HostsTableCreateCompanionBuilder,
      $$HostsTableUpdateCompanionBuilder,
      (Host, BaseReferences<_$AppDatabase, $HostsTable, Host>),
      Host,
      PrefetchHooks Function()
    >;
typedef $$HostGroupsTableCreateCompanionBuilder =
    HostGroupsCompanion Function({
      required String id,
      required String name,
      Value<String?> parentGroupId,
      Value<String?> defaultUsername,
      Value<int?> defaultPort,
      Value<String?> defaultKeyId,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$HostGroupsTableUpdateCompanionBuilder =
    HostGroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentGroupId,
      Value<String?> defaultUsername,
      Value<int?> defaultPort,
      Value<String?> defaultKeyId,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$HostGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $HostGroupsTable> {
  $$HostGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentGroupId => $composableBuilder(
    column: $table.parentGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultUsername => $composableBuilder(
    column: $table.defaultUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultPort => $composableBuilder(
    column: $table.defaultPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultKeyId => $composableBuilder(
    column: $table.defaultKeyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HostGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $HostGroupsTable> {
  $$HostGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentGroupId => $composableBuilder(
    column: $table.parentGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultUsername => $composableBuilder(
    column: $table.defaultUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultPort => $composableBuilder(
    column: $table.defaultPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultKeyId => $composableBuilder(
    column: $table.defaultKeyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HostGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HostGroupsTable> {
  $$HostGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentGroupId => $composableBuilder(
    column: $table.parentGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultUsername => $composableBuilder(
    column: $table.defaultUsername,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultPort => $composableBuilder(
    column: $table.defaultPort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultKeyId => $composableBuilder(
    column: $table.defaultKeyId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$HostGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HostGroupsTable,
          HostGroup,
          $$HostGroupsTableFilterComposer,
          $$HostGroupsTableOrderingComposer,
          $$HostGroupsTableAnnotationComposer,
          $$HostGroupsTableCreateCompanionBuilder,
          $$HostGroupsTableUpdateCompanionBuilder,
          (
            HostGroup,
            BaseReferences<_$AppDatabase, $HostGroupsTable, HostGroup>,
          ),
          HostGroup,
          PrefetchHooks Function()
        > {
  $$HostGroupsTableTableManager(_$AppDatabase db, $HostGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HostGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HostGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HostGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentGroupId = const Value.absent(),
                Value<String?> defaultUsername = const Value.absent(),
                Value<int?> defaultPort = const Value.absent(),
                Value<String?> defaultKeyId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HostGroupsCompanion(
                id: id,
                name: name,
                parentGroupId: parentGroupId,
                defaultUsername: defaultUsername,
                defaultPort: defaultPort,
                defaultKeyId: defaultKeyId,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentGroupId = const Value.absent(),
                Value<String?> defaultUsername = const Value.absent(),
                Value<int?> defaultPort = const Value.absent(),
                Value<String?> defaultKeyId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HostGroupsCompanion.insert(
                id: id,
                name: name,
                parentGroupId: parentGroupId,
                defaultUsername: defaultUsername,
                defaultPort: defaultPort,
                defaultKeyId: defaultKeyId,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HostGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HostGroupsTable,
      HostGroup,
      $$HostGroupsTableFilterComposer,
      $$HostGroupsTableOrderingComposer,
      $$HostGroupsTableAnnotationComposer,
      $$HostGroupsTableCreateCompanionBuilder,
      $$HostGroupsTableUpdateCompanionBuilder,
      (HostGroup, BaseReferences<_$AppDatabase, $HostGroupsTable, HostGroup>),
      HostGroup,
      PrefetchHooks Function()
    >;
typedef $$SshKeysTableCreateCompanionBuilder =
    SshKeysCompanion Function({
      required String id,
      required String label,
      required KeyTypeEnum keyType,
      Value<int?> keyBits,
      required String publicKey,
      required String privateKeyRef,
      required String fingerprint,
      Value<bool> hasPassphrase,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$SshKeysTableUpdateCompanionBuilder =
    SshKeysCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<KeyTypeEnum> keyType,
      Value<int?> keyBits,
      Value<String> publicKey,
      Value<String> privateKeyRef,
      Value<String> fingerprint,
      Value<bool> hasPassphrase,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$SshKeysTableFilterComposer
    extends Composer<_$AppDatabase, $SshKeysTable> {
  $$SshKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<KeyTypeEnum, KeyTypeEnum, int> get keyType =>
      $composableBuilder(
        column: $table.keyType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get keyBits => $composableBuilder(
    column: $table.keyBits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get privateKeyRef => $composableBuilder(
    column: $table.privateKeyRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPassphrase => $composableBuilder(
    column: $table.hasPassphrase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SshKeysTableOrderingComposer
    extends Composer<_$AppDatabase, $SshKeysTable> {
  $$SshKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get keyBits => $composableBuilder(
    column: $table.keyBits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get privateKeyRef => $composableBuilder(
    column: $table.privateKeyRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPassphrase => $composableBuilder(
    column: $table.hasPassphrase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SshKeysTableAnnotationComposer
    extends Composer<_$AppDatabase, $SshKeysTable> {
  $$SshKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<KeyTypeEnum, int> get keyType =>
      $composableBuilder(column: $table.keyType, builder: (column) => column);

  GeneratedColumn<int> get keyBits =>
      $composableBuilder(column: $table.keyBits, builder: (column) => column);

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<String> get privateKeyRef => $composableBuilder(
    column: $table.privateKeyRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPassphrase => $composableBuilder(
    column: $table.hasPassphrase,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SshKeysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SshKeysTable,
          SshKey,
          $$SshKeysTableFilterComposer,
          $$SshKeysTableOrderingComposer,
          $$SshKeysTableAnnotationComposer,
          $$SshKeysTableCreateCompanionBuilder,
          $$SshKeysTableUpdateCompanionBuilder,
          (SshKey, BaseReferences<_$AppDatabase, $SshKeysTable, SshKey>),
          SshKey,
          PrefetchHooks Function()
        > {
  $$SshKeysTableTableManager(_$AppDatabase db, $SshKeysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SshKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SshKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SshKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<KeyTypeEnum> keyType = const Value.absent(),
                Value<int?> keyBits = const Value.absent(),
                Value<String> publicKey = const Value.absent(),
                Value<String> privateKeyRef = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<bool> hasPassphrase = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SshKeysCompanion(
                id: id,
                label: label,
                keyType: keyType,
                keyBits: keyBits,
                publicKey: publicKey,
                privateKeyRef: privateKeyRef,
                fingerprint: fingerprint,
                hasPassphrase: hasPassphrase,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required KeyTypeEnum keyType,
                Value<int?> keyBits = const Value.absent(),
                required String publicKey,
                required String privateKeyRef,
                required String fingerprint,
                Value<bool> hasPassphrase = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SshKeysCompanion.insert(
                id: id,
                label: label,
                keyType: keyType,
                keyBits: keyBits,
                publicKey: publicKey,
                privateKeyRef: privateKeyRef,
                fingerprint: fingerprint,
                hasPassphrase: hasPassphrase,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SshKeysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SshKeysTable,
      SshKey,
      $$SshKeysTableFilterComposer,
      $$SshKeysTableOrderingComposer,
      $$SshKeysTableAnnotationComposer,
      $$SshKeysTableCreateCompanionBuilder,
      $$SshKeysTableUpdateCompanionBuilder,
      (SshKey, BaseReferences<_$AppDatabase, $SshKeysTable, SshKey>),
      SshKey,
      PrefetchHooks Function()
    >;
typedef $$SnippetsTableCreateCompanionBuilder =
    SnippetsCompanion Function({
      required String id,
      required String name,
      required String command,
      Value<String?> category,
      Value<String> variables,
      Value<String?> description,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$SnippetsTableUpdateCompanionBuilder =
    SnippetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> command,
      Value<String?> category,
      Value<String> variables,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$SnippetsTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variables => $composableBuilder(
    column: $table.variables,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnippetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variables => $composableBuilder(
    column: $table.variables,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnippetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get variables =>
      $composableBuilder(column: $table.variables, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SnippetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnippetsTable,
          Snippet,
          $$SnippetsTableFilterComposer,
          $$SnippetsTableOrderingComposer,
          $$SnippetsTableAnnotationComposer,
          $$SnippetsTableCreateCompanionBuilder,
          $$SnippetsTableUpdateCompanionBuilder,
          (Snippet, BaseReferences<_$AppDatabase, $SnippetsTable, Snippet>),
          Snippet,
          PrefetchHooks Function()
        > {
  $$SnippetsTableTableManager(_$AppDatabase db, $SnippetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> command = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> variables = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion(
                id: id,
                name: name,
                command: command,
                category: category,
                variables: variables,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String command,
                Value<String?> category = const Value.absent(),
                Value<String> variables = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion.insert(
                id: id,
                name: name,
                command: command,
                category: category,
                variables: variables,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnippetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnippetsTable,
      Snippet,
      $$SnippetsTableFilterComposer,
      $$SnippetsTableOrderingComposer,
      $$SnippetsTableAnnotationComposer,
      $$SnippetsTableCreateCompanionBuilder,
      $$SnippetsTableUpdateCompanionBuilder,
      (Snippet, BaseReferences<_$AppDatabase, $SnippetsTable, Snippet>),
      Snippet,
      PrefetchHooks Function()
    >;
typedef $$PortForwardsTableCreateCompanionBuilder =
    PortForwardsCompanion Function({
      required String id,
      required String label,
      required PortForwardTypeEnum type,
      required String hostId,
      required int sourcePort,
      Value<String?> destinationHost,
      Value<int?> destinationPort,
      Value<bool> autoStart,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$PortForwardsTableUpdateCompanionBuilder =
    PortForwardsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<PortForwardTypeEnum> type,
      Value<String> hostId,
      Value<int> sourcePort,
      Value<String?> destinationHost,
      Value<int?> destinationPort,
      Value<bool> autoStart,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> syncVersion,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$PortForwardsTableFilterComposer
    extends Composer<_$AppDatabase, $PortForwardsTable> {
  $$PortForwardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PortForwardTypeEnum, PortForwardTypeEnum, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourcePort => $composableBuilder(
    column: $table.sourcePort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationHost => $composableBuilder(
    column: $table.destinationHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get destinationPort => $composableBuilder(
    column: $table.destinationPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStart => $composableBuilder(
    column: $table.autoStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PortForwardsTableOrderingComposer
    extends Composer<_$AppDatabase, $PortForwardsTable> {
  $$PortForwardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourcePort => $composableBuilder(
    column: $table.sourcePort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationHost => $composableBuilder(
    column: $table.destinationHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get destinationPort => $composableBuilder(
    column: $table.destinationPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStart => $composableBuilder(
    column: $table.autoStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PortForwardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PortForwardsTable> {
  $$PortForwardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PortForwardTypeEnum, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<int> get sourcePort => $composableBuilder(
    column: $table.sourcePort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationHost => $composableBuilder(
    column: $table.destinationHost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get destinationPort => $composableBuilder(
    column: $table.destinationPort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStart =>
      $composableBuilder(column: $table.autoStart, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PortForwardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PortForwardsTable,
          PortForward,
          $$PortForwardsTableFilterComposer,
          $$PortForwardsTableOrderingComposer,
          $$PortForwardsTableAnnotationComposer,
          $$PortForwardsTableCreateCompanionBuilder,
          $$PortForwardsTableUpdateCompanionBuilder,
          (
            PortForward,
            BaseReferences<_$AppDatabase, $PortForwardsTable, PortForward>,
          ),
          PortForward,
          PrefetchHooks Function()
        > {
  $$PortForwardsTableTableManager(_$AppDatabase db, $PortForwardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PortForwardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PortForwardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PortForwardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<PortForwardTypeEnum> type = const Value.absent(),
                Value<String> hostId = const Value.absent(),
                Value<int> sourcePort = const Value.absent(),
                Value<String?> destinationHost = const Value.absent(),
                Value<int?> destinationPort = const Value.absent(),
                Value<bool> autoStart = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortForwardsCompanion(
                id: id,
                label: label,
                type: type,
                hostId: hostId,
                sourcePort: sourcePort,
                destinationHost: destinationHost,
                destinationPort: destinationPort,
                autoStart: autoStart,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required PortForwardTypeEnum type,
                required String hostId,
                required int sourcePort,
                Value<String?> destinationHost = const Value.absent(),
                Value<int?> destinationPort = const Value.absent(),
                Value<bool> autoStart = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> syncVersion = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortForwardsCompanion.insert(
                id: id,
                label: label,
                type: type,
                hostId: hostId,
                sourcePort: sourcePort,
                destinationHost: destinationHost,
                destinationPort: destinationPort,
                autoStart: autoStart,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncVersion: syncVersion,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PortForwardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PortForwardsTable,
      PortForward,
      $$PortForwardsTableFilterComposer,
      $$PortForwardsTableOrderingComposer,
      $$PortForwardsTableAnnotationComposer,
      $$PortForwardsTableCreateCompanionBuilder,
      $$PortForwardsTableUpdateCompanionBuilder,
      (
        PortForward,
        BaseReferences<_$AppDatabase, $PortForwardsTable, PortForward>,
      ),
      PortForward,
      PrefetchHooks Function()
    >;
typedef $$KnownHostsTableCreateCompanionBuilder =
    KnownHostsCompanion Function({
      required String id,
      required String hostname,
      required int port,
      required String keyType,
      required String fingerprint,
      required String publicKey,
      Value<bool> isTrusted,
      required DateTime firstSeen,
      required DateTime lastSeen,
      Value<int> rowid,
    });
typedef $$KnownHostsTableUpdateCompanionBuilder =
    KnownHostsCompanion Function({
      Value<String> id,
      Value<String> hostname,
      Value<int> port,
      Value<String> keyType,
      Value<String> fingerprint,
      Value<String> publicKey,
      Value<bool> isTrusted,
      Value<DateTime> firstSeen,
      Value<DateTime> lastSeen,
      Value<int> rowid,
    });

class $$KnownHostsTableFilterComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTrusted => $composableBuilder(
    column: $table.isTrusted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeen => $composableBuilder(
    column: $table.firstSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnownHostsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTrusted => $composableBuilder(
    column: $table.isTrusted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeen => $composableBuilder(
    column: $table.firstSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnownHostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get keyType =>
      $composableBuilder(column: $table.keyType, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<bool> get isTrusted =>
      $composableBuilder(column: $table.isTrusted, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeen =>
      $composableBuilder(column: $table.firstSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);
}

class $$KnownHostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnownHostsTable,
          KnownHost,
          $$KnownHostsTableFilterComposer,
          $$KnownHostsTableOrderingComposer,
          $$KnownHostsTableAnnotationComposer,
          $$KnownHostsTableCreateCompanionBuilder,
          $$KnownHostsTableUpdateCompanionBuilder,
          (
            KnownHost,
            BaseReferences<_$AppDatabase, $KnownHostsTable, KnownHost>,
          ),
          KnownHost,
          PrefetchHooks Function()
        > {
  $$KnownHostsTableTableManager(_$AppDatabase db, $KnownHostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnownHostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnownHostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnownHostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> hostname = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> keyType = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String> publicKey = const Value.absent(),
                Value<bool> isTrusted = const Value.absent(),
                Value<DateTime> firstSeen = const Value.absent(),
                Value<DateTime> lastSeen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnownHostsCompanion(
                id: id,
                hostname: hostname,
                port: port,
                keyType: keyType,
                fingerprint: fingerprint,
                publicKey: publicKey,
                isTrusted: isTrusted,
                firstSeen: firstSeen,
                lastSeen: lastSeen,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String hostname,
                required int port,
                required String keyType,
                required String fingerprint,
                required String publicKey,
                Value<bool> isTrusted = const Value.absent(),
                required DateTime firstSeen,
                required DateTime lastSeen,
                Value<int> rowid = const Value.absent(),
              }) => KnownHostsCompanion.insert(
                id: id,
                hostname: hostname,
                port: port,
                keyType: keyType,
                fingerprint: fingerprint,
                publicKey: publicKey,
                isTrusted: isTrusted,
                firstSeen: firstSeen,
                lastSeen: lastSeen,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnownHostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnownHostsTable,
      KnownHost,
      $$KnownHostsTableFilterComposer,
      $$KnownHostsTableOrderingComposer,
      $$KnownHostsTableAnnotationComposer,
      $$KnownHostsTableCreateCompanionBuilder,
      $$KnownHostsTableUpdateCompanionBuilder,
      (KnownHost, BaseReferences<_$AppDatabase, $KnownHostsTable, KnownHost>),
      KnownHost,
      PrefetchHooks Function()
    >;
typedef $$SecretsTableCreateCompanionBuilder =
    SecretsCompanion Function({
      required String key,
      required String encryptedValue,
      required String nonce,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SecretsTableUpdateCompanionBuilder =
    SecretsCompanion Function({
      Value<String> key,
      Value<String> encryptedValue,
      Value<String> nonce,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SecretsTableFilterComposer
    extends Composer<_$AppDatabase, $SecretsTable> {
  $$SecretsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedValue => $composableBuilder(
    column: $table.encryptedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SecretsTableOrderingComposer
    extends Composer<_$AppDatabase, $SecretsTable> {
  $$SecretsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedValue => $composableBuilder(
    column: $table.encryptedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SecretsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecretsTable> {
  $$SecretsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get encryptedValue => $composableBuilder(
    column: $table.encryptedValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SecretsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SecretsTable,
          Secret,
          $$SecretsTableFilterComposer,
          $$SecretsTableOrderingComposer,
          $$SecretsTableAnnotationComposer,
          $$SecretsTableCreateCompanionBuilder,
          $$SecretsTableUpdateCompanionBuilder,
          (Secret, BaseReferences<_$AppDatabase, $SecretsTable, Secret>),
          Secret,
          PrefetchHooks Function()
        > {
  $$SecretsTableTableManager(_$AppDatabase db, $SecretsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecretsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecretsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecretsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> encryptedValue = const Value.absent(),
                Value<String> nonce = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SecretsCompanion(
                key: key,
                encryptedValue: encryptedValue,
                nonce: nonce,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String encryptedValue,
                required String nonce,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SecretsCompanion.insert(
                key: key,
                encryptedValue: encryptedValue,
                nonce: nonce,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SecretsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SecretsTable,
      Secret,
      $$SecretsTableFilterComposer,
      $$SecretsTableOrderingComposer,
      $$SecretsTableAnnotationComposer,
      $$SecretsTableCreateCompanionBuilder,
      $$SecretsTableUpdateCompanionBuilder,
      (Secret, BaseReferences<_$AppDatabase, $SecretsTable, Secret>),
      Secret,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String entityType,
      Value<int> lastSyncVersion,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> entityType,
      Value<int> lastSyncVersion,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncVersion => $composableBuilder(
    column: $table.lastSyncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncVersion => $composableBuilder(
    column: $table.lastSyncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncVersion => $composableBuilder(
    column: $table.lastSyncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<int> lastSyncVersion = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                entityType: entityType,
                lastSyncVersion: lastSyncVersion,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                Value<int> lastSyncVersion = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                entityType: entityType,
                lastSyncVersion: lastSyncVersion,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityId,
      required SyncOperation operation,
      Value<String?> encryptedPayload,
      Value<int> syncVersion,
      required DateTime queuedAt,
      Value<int> retryCount,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<SyncOperation> operation,
      Value<String?> encryptedPayload,
      Value<int> syncVersion,
      Value<DateTime> queuedAt,
      Value<int> retryCount,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncOperation, SyncOperation, int>
  get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOperation, int> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<SyncOperation> operation = const Value.absent(),
                Value<String?> encryptedPayload = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                encryptedPayload: encryptedPayload,
                syncVersion: syncVersion,
                queuedAt: queuedAt,
                retryCount: retryCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required SyncOperation operation,
                Value<String?> encryptedPayload = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                required DateTime queuedAt,
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                encryptedPayload: encryptedPayload,
                syncVersion: syncVersion,
                queuedAt: queuedAt,
                retryCount: retryCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$WorkspacesTableCreateCompanionBuilder =
    WorkspacesCompanion Function({
      required String id,
      required String name,
      required String layoutJson,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkspacesTableUpdateCompanionBuilder =
    WorkspacesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> layoutJson,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WorkspacesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkspacesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkspacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkspacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkspacesTable,
          Workspace,
          $$WorkspacesTableFilterComposer,
          $$WorkspacesTableOrderingComposer,
          $$WorkspacesTableAnnotationComposer,
          $$WorkspacesTableCreateCompanionBuilder,
          $$WorkspacesTableUpdateCompanionBuilder,
          (
            Workspace,
            BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>,
          ),
          Workspace,
          PrefetchHooks Function()
        > {
  $$WorkspacesTableTableManager(_$AppDatabase db, $WorkspacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkspacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkspacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkspacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> layoutJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion(
                id: id,
                name: name,
                layoutJson: layoutJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String layoutJson,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion.insert(
                id: id,
                name: name,
                layoutJson: layoutJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkspacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkspacesTable,
      Workspace,
      $$WorkspacesTableFilterComposer,
      $$WorkspacesTableOrderingComposer,
      $$WorkspacesTableAnnotationComposer,
      $$WorkspacesTableCreateCompanionBuilder,
      $$WorkspacesTableUpdateCompanionBuilder,
      (Workspace, BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>),
      Workspace,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HostsTableTableManager get hosts =>
      $$HostsTableTableManager(_db, _db.hosts);
  $$HostGroupsTableTableManager get hostGroups =>
      $$HostGroupsTableTableManager(_db, _db.hostGroups);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db, _db.sshKeys);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
  $$PortForwardsTableTableManager get portForwards =>
      $$PortForwardsTableTableManager(_db, _db.portForwards);
  $$KnownHostsTableTableManager get knownHosts =>
      $$KnownHostsTableTableManager(_db, _db.knownHosts);
  $$SecretsTableTableManager get secrets =>
      $$SecretsTableTableManager(_db, _db.secrets);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$WorkspacesTableTableManager get workspaces =>
      $$WorkspacesTableTableManager(_db, _db.workspaces);
}
