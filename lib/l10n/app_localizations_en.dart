// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get search => 'Search';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get none => 'None';

  @override
  String get unknown => 'Unknown';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get hostsTitle => 'Hosts';

  @override
  String get hostsAddTooltip => 'Add host';

  @override
  String get hostsSearchHint => 'Search hosts...';

  @override
  String get hostsEmptyTitle => 'No hosts yet';

  @override
  String get hostsEmptySubtitle => 'Add your first SSH server to get started.';

  @override
  String get hostsEmptyAction => 'Add Host';

  @override
  String hostsNoMatchQuery(String query) {
    return 'No hosts match \"$query\"';
  }

  @override
  String get hostsLoadingMessage => 'Loading hosts...';

  @override
  String get hostsRecentHeader => 'RECENT';

  @override
  String get hostsGroupsHeader => 'GROUPS';

  @override
  String get hostsFavoritesHeader => 'FAVORITES';

  @override
  String get hostsAllHostsHeader => 'ALL HOSTS';

  @override
  String get hostsUngroupedHeader => 'UNGROUPED';

  @override
  String get hostsDeleteDialogTitle => 'Delete Host';

  @override
  String hostsDeleteDialogMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get hostsMenuEdit => 'Edit';

  @override
  String get hostsMenuDelete => 'Delete';

  @override
  String get hostsMenuConnect => 'Connect';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return 'Last connected $time';
  }

  @override
  String get hostsNeverConnected => 'Never connected';

  @override
  String get hostsJustNow => 'Just now';

  @override
  String get hostFormTitleNew => 'New Host';

  @override
  String get hostFormTitleEdit => 'Edit Host';

  @override
  String get hostFormSave => 'Save';

  @override
  String get hostFormLabelField => 'Label';

  @override
  String get hostFormLabelHint => 'e.g., Production Server';

  @override
  String get hostFormLabelRequired => 'Label is required';

  @override
  String get hostFormHostnameField => 'Hostname';

  @override
  String get hostFormHostnameHint => 'e.g., 192.168.1.100 or example.com';

  @override
  String get hostFormHostnameRequired => 'Hostname is required';

  @override
  String get hostFormPortField => 'Port';

  @override
  String get hostFormUsernameField => 'Username';

  @override
  String get hostFormUsernameHint => 'e.g., root';

  @override
  String get hostFormUsernameRequired => 'Username is required';

  @override
  String get hostFormPasswordField => 'Password';

  @override
  String get hostFormPasswordHint => 'Enter password';

  @override
  String get hostFormAuthMethodField => 'Auth Method';

  @override
  String get hostFormAuthMethodKey => 'Key';

  @override
  String get hostFormAuthMethodPassword => 'Password';

  @override
  String get hostFormAuthMethodKeyAndPassword => 'Key + Password';

  @override
  String get hostFormKeyField => 'SSH Key';

  @override
  String get hostFormKeyNone => 'None';

  @override
  String get hostFormGroupField => 'Group';

  @override
  String get hostFormGroupNone => 'No group';

  @override
  String get hostFormTagsField => 'Tags';

  @override
  String get hostFormTagsHint => 'Add tags (comma separated)';

  @override
  String get hostFormAdvancedSection => 'Advanced';

  @override
  String get hostFormJumpHostField => 'Jump Host (Proxy)';

  @override
  String get hostFormJumpHostNone => 'None (direct connection)';

  @override
  String get hostFormKeepAliveField => 'Keep Alive (seconds)';

  @override
  String get hostFormStartupCommandField => 'Startup Command';

  @override
  String get hostFormStartupCommandHint => 'Run after connecting (optional)';

  @override
  String get hostFormNotesField => 'Notes';

  @override
  String get hostFormNotesHint => 'Optional notes about this host';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => 'Serial';

  @override
  String get hostFormSerialPortField => 'Serial Port';

  @override
  String get hostFormSerialPortNone => 'Select port';

  @override
  String get hostFormSerialNoPortsAvailable => 'No serial ports available';

  @override
  String get hostFormSerialBaudRateField => 'Baud Rate';

  @override
  String get hostFormSerialDataBitsField => 'Data Bits';

  @override
  String get hostFormSerialStopBitsField => 'Stop Bits';

  @override
  String get hostFormSerialParityField => 'Parity';

  @override
  String get hostFormSerialFlowControlField => 'Flow Control';

  @override
  String get hostFormTestConnection => 'Test Connection';

  @override
  String get hostFormTestConnectionSuccess => 'Connection successful!';

  @override
  String hostFormTestConnectionFailed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get hostDetailTitle => 'Host Details';

  @override
  String get hostDetailConnect => 'Connect';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => 'Edit';

  @override
  String get hostDetailDeleteTooltip => 'Delete';

  @override
  String get hostDetailFavoriteTooltip => 'Favorite';

  @override
  String get hostDetailSectionConnection => 'Connection';

  @override
  String get hostDetailSectionAuthentication => 'Authentication';

  @override
  String get hostDetailSectionAdvanced => 'Advanced';

  @override
  String get hostDetailSectionTags => 'Tags';

  @override
  String get hostDetailSectionNotes => 'Notes';

  @override
  String get hostDetailLabelHostname => 'Hostname';

  @override
  String get hostDetailLabelPort => 'Port';

  @override
  String get hostDetailLabelUsername => 'Username';

  @override
  String get hostDetailLabelAuthMethod => 'Auth Method';

  @override
  String get hostDetailLabelKey => 'Key';

  @override
  String get hostDetailLabelGroup => 'Group';

  @override
  String get hostDetailLabelJumpHost => 'Jump Host';

  @override
  String get hostDetailLabelKeepAlive => 'Keep Alive';

  @override
  String get hostDetailLabelStartupCommand => 'Startup Command';

  @override
  String get hostDetailLabelProtocol => 'Protocol';

  @override
  String get hostDetailLabelCreated => 'Created';

  @override
  String get hostDetailLabelUpdated => 'Updated';

  @override
  String get hostDetailLabelLastConnected => 'Last Connected';

  @override
  String get hostDetailNotFound => 'Host not found';

  @override
  String get hostDetailLoading => 'Loading host...';

  @override
  String get hostDetailDeleteDialogTitle => 'Delete Host';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get quickConnectTitle => 'Quick Connect';

  @override
  String get quickConnectHint => 'user@host:port';

  @override
  String get quickConnectHelperText => 'e.g., root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => 'Save host';

  @override
  String get quickConnectConnect => 'Connect';

  @override
  String get quickConnectInvalidFormat =>
      'Invalid format. Use user@host or user@host:port';

  @override
  String get groupFormTitleNew => 'New Group';

  @override
  String get groupFormTitleEdit => 'Edit Group';

  @override
  String get groupFormNameField => 'Group Name';

  @override
  String get groupFormNameHint => 'e.g., Production';

  @override
  String get groupFormNameRequired => 'Group name is required';

  @override
  String get groupFormParentField => 'Parent Group';

  @override
  String get groupFormParentNone => 'None (top level)';

  @override
  String get groupFormDeleteDialogTitle => 'Delete Group';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return 'Delete \"$name\"? Hosts in this group will become ungrouped.';
  }

  @override
  String get hostKeyVerifyChangedTitle => 'Host Key Changed';

  @override
  String get hostKeyVerifyUnknownTitle => 'Unknown Host';

  @override
  String get hostKeyVerifyChangedWarning =>
      'WARNING: The host key for this server has changed. This could indicate a man-in-the-middle attack.';

  @override
  String get hostKeyVerifyUnknownMessage =>
      'The authenticity of this host cannot be verified. Are you sure you want to continue connecting?';

  @override
  String get hostKeyVerifyLabelHost => 'Host';

  @override
  String get hostKeyVerifyLabelKeyType => 'Key Type';

  @override
  String get hostKeyVerifyLabelFingerprint => 'Fingerprint:';

  @override
  String get hostKeyVerifyFingerprintCopied =>
      'Fingerprint copied (auto-clears in 30s)';

  @override
  String get hostKeyVerifyTrustAnyway => 'Trust Anyway';

  @override
  String get hostKeyVerifyTrustAndConnect => 'Trust & Connect';

  @override
  String get keysTitle => 'SSH Keys';

  @override
  String get keysAddTooltip => 'Import key';

  @override
  String get keysImportTooltip => 'Import key';

  @override
  String get keysEmptyTitle => 'No SSH keys';

  @override
  String get keysEmptySubtitle =>
      'Import your SSH keys to authenticate with servers.';

  @override
  String get keysEmptyAction => 'Import Key';

  @override
  String get keysSearchHint => 'Search keys...';

  @override
  String keysNoMatchQuery(String query) {
    return 'No keys match \"$query\"';
  }

  @override
  String get keysLoadingMessage => 'Loading keys...';

  @override
  String get keysDeleteDialogTitle => 'Delete Key';

  @override
  String keysDeleteDialogMessage(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get keysMenuDelete => 'Delete';

  @override
  String keysAssociatedHosts(int count) {
    return '$count host(s)';
  }

  @override
  String get keyDetailTitle => 'Key Details';

  @override
  String get keyDetailEditTooltip => 'Edit';

  @override
  String get keyDetailDeleteTooltip => 'Delete';

  @override
  String get keyDetailSectionPublicKey => 'Public Key';

  @override
  String get keyDetailCopyPublicKey => 'Copy public key';

  @override
  String get keyDetailSectionFingerprint => 'Fingerprint';

  @override
  String get keyDetailSectionAssociatedHosts => 'Associated Hosts';

  @override
  String get keyDetailSectionDetails => 'Details';

  @override
  String get keyDetailLabelType => 'Type';

  @override
  String get keyDetailLabelBits => 'Bits';

  @override
  String get keyDetailLabelCreated => 'Created';

  @override
  String get keyDetailNotFound => 'Key not found';

  @override
  String get keyDetailLoading => 'Loading key...';

  @override
  String get keyDetailPublicKeyCopied =>
      'Public key copied (auto-clears in 30s)';

  @override
  String get keyDetailFingerprintCopied =>
      'Fingerprint copied (auto-clears in 30s)';

  @override
  String get keyDetailNoAssociatedHosts => 'No hosts use this key';

  @override
  String get keyImportTitle => 'Import SSH Key';

  @override
  String get keyImportButton => 'Import';

  @override
  String get keyImportButtonImporting => 'Importing...';

  @override
  String get keyImportButtonImportKey => 'Import Key';

  @override
  String get keyImportLabelField => 'Label';

  @override
  String get keyImportLabelHint => 'e.g., My Server Key';

  @override
  String get keyImportPassphraseField => 'Passphrase (optional)';

  @override
  String get keyImportPassphraseHint => 'Leave empty if key is not encrypted';

  @override
  String get keyImportPrivateKeyField => 'Private Key';

  @override
  String get keyImportFromFile => 'From File';

  @override
  String get keyImportPaste => 'Paste';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\nor PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      'Supported formats: OpenSSH, PEM, PuTTY PPK (RSA, Ed25519, ECDSA). Your private key is stored securely in the platform keychain and never leaves this device.';

  @override
  String keyImportFailedToReadFile(String error) {
    return 'Failed to read file: $error';
  }

  @override
  String get keyImportClipboardEmpty => 'Clipboard is empty';

  @override
  String get keyImportPasteOrSelectKey =>
      'Please paste or select a private key';

  @override
  String keyImportSuccess(String fingerprint) {
    return 'Key imported: $fingerprint';
  }

  @override
  String get terminalNoActiveSessions => 'No active sessions';

  @override
  String get terminalQuickConnect => 'Quick Connect';

  @override
  String get terminalRecentHostsHeader => 'RECENT HOSTS';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  New Host  ·  ⌘⇧N  Quick Connect  ·  ⌘K  Search';

  @override
  String get terminalMobileShortcutHint => 'Tap + to connect to a host';

  @override
  String terminalConnectingToHost(String label) {
    return 'Connecting to $label...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return 'Reconnecting... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => 'Cancel';

  @override
  String get terminalConnectionLost => 'Connection lost';

  @override
  String get terminalSearchHint => 'Search terminal...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => 'Close (Esc)';

  @override
  String get terminalConnectionInfoTitle => 'Connection Info';

  @override
  String get terminalStatusReconnecting => 'Reconnecting...';

  @override
  String get terminalStatusConnected => 'Connected';

  @override
  String get terminalStatusDisconnected => 'Disconnected';

  @override
  String get terminalInfoLabelHost => 'Host';

  @override
  String get terminalInfoLabelAddress => 'Address';

  @override
  String get terminalInfoLabelUsername => 'Username';

  @override
  String get terminalInfoLabelProxyJump => 'Proxy Jump';

  @override
  String get terminalInfoValueProxyJump => 'Via bastion host';

  @override
  String get terminalInfoLabelUptime => 'Uptime';

  @override
  String get terminalInfoLabelConnectedAt => 'Connected At';

  @override
  String get terminalInfoLabelSessionId => 'Session ID';

  @override
  String get terminalInfoLabelSplit => 'Split';

  @override
  String get terminalInfoValueSplitHorizontal => 'Horizontal (2 panes)';

  @override
  String get terminalInfoValueSplitVertical => 'Vertical (2 panes)';

  @override
  String get terminalInfoLabelLogging => 'Logging';

  @override
  String get terminalInfoValueLoggingActive => 'Active';

  @override
  String get terminalStatusBarDefaultDuration => '0:00';

  @override
  String get terminalStatusBarLogActive => 'LOG';

  @override
  String get terminalStatusBarLogInactive => 'Log';

  @override
  String get terminalBroadcastOnTooltip =>
      'Broadcast ON — tap to toggle, long-press for options';

  @override
  String get terminalBroadcastOffTooltip =>
      'Broadcast OFF — tap to toggle, long-press for options';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return 'CAST ($count)';
  }

  @override
  String get terminalBroadcastCastActive => 'CAST';

  @override
  String get terminalBroadcastCastInactive => 'Cast';

  @override
  String get terminalHeaderBackTooltip => 'Back';

  @override
  String get terminalHeaderNewConnectionTooltip => 'New connection';

  @override
  String get terminalHeaderSnippetsTooltip => 'Snippets';

  @override
  String get terminalHeaderCopyTooltip => 'Copy selection';

  @override
  String get terminalHeaderPasteTooltip => 'Paste';

  @override
  String get terminalHeaderNewTabTooltip => 'New tab';

  @override
  String get extraKeyEsc => 'ESC';

  @override
  String get extraKeyTab => 'TAB';

  @override
  String get extraKeyCtl => 'CTL';

  @override
  String get extraKeyAlt => 'ALT';

  @override
  String get broadcastPanelTitle => 'Broadcast Input';

  @override
  String get broadcastPanelDisable => 'Disable';

  @override
  String get broadcastPanelDescription =>
      'Select which terminals receive your keyboard input.';

  @override
  String get broadcastPanelBroadcastToAll => 'Broadcast to All';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count connected sessions';
  }

  @override
  String get broadcastPanelActiveLabel => 'ACTIVE';

  @override
  String get broadcastPanelTabConnected => 'Connected';

  @override
  String get broadcastPanelTabDisconnected => 'Disconnected';

  @override
  String get snippetsTitle => 'Snippets';

  @override
  String get snippetsAddTooltip => 'Add snippet';

  @override
  String get snippetsEmptyTitle => 'No snippets';

  @override
  String get snippetsEmptySubtitle =>
      'Save frequently used commands for quick access.';

  @override
  String get snippetsEmptyAction => 'Add Snippet';

  @override
  String get snippetsSearchHint => 'Search snippets...';

  @override
  String snippetsNoMatchQuery(String query) {
    return 'No snippets match \"$query\"';
  }

  @override
  String get snippetsLoadingMessage => 'Loading snippets...';

  @override
  String get snippetsUncategorized => 'Uncategorized';

  @override
  String get snippetsHasVariables => 'Has variables';

  @override
  String get snippetsCopyCommandTooltip => 'Copy command';

  @override
  String get snippetsMenuEdit => 'Edit';

  @override
  String get snippetsMenuDelete => 'Delete';

  @override
  String get snippetsCopiedMessage => 'Command copied (auto-clears in 30s)';

  @override
  String get snippetsDeleteDialogTitle => 'Delete Snippet';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get snippetDetailNotFound => 'Snippet not found';

  @override
  String get snippetDetailLoading => 'Loading snippet...';

  @override
  String get snippetDetailEditTooltip => 'Edit';

  @override
  String get snippetDetailDeleteTooltip => 'Delete';

  @override
  String get snippetDetailSectionCommand => 'Command';

  @override
  String get snippetDetailCopyCommandTooltip => 'Copy command';

  @override
  String get snippetDetailSectionVariables => 'Variables';

  @override
  String get snippetDetailSectionDescription => 'Description';

  @override
  String get snippetDetailSectionDetails => 'Details';

  @override
  String get snippetDetailLabelCreated => 'Created';

  @override
  String get snippetDetailLabelUpdated => 'Updated';

  @override
  String get snippetDetailCopiedMessage =>
      'Command copied (auto-clears in 30s)';

  @override
  String get snippetFormTitleEdit => 'Edit Snippet';

  @override
  String get snippetFormTitleNew => 'New Snippet';

  @override
  String get snippetFormNameLabel => 'Snippet Name';

  @override
  String get snippetFormNameHint => 'e.g., Check disk space';

  @override
  String get snippetFormNameRequired => 'Name is required';

  @override
  String get snippetFormCommandLabel => 'Command';

  @override
  String get snippetFormCommandHint =>
      'e.g., df -h\nUse double-brace variables as placeholders';

  @override
  String get snippetFormCommandRequired => 'Command is required';

  @override
  String get snippetFormVariablesLabel => 'Variables:';

  @override
  String get snippetFormCategoryLabel => 'Category (optional)';

  @override
  String get snippetFormCategoryHint => 'e.g., System, Docker, Network';

  @override
  String get snippetFormDescriptionLabel => 'Description (optional)';

  @override
  String get snippetFormDescriptionHint => 'What does this command do?';

  @override
  String get snippetFormSaveButtonEdit => 'Update Snippet';

  @override
  String get snippetFormSaveButtonNew => 'Create Snippet';

  @override
  String snippetFormSaveError(String error) {
    return 'Failed to save snippet: $error';
  }

  @override
  String get snippetPickerSearchHint => 'Search snippets...';

  @override
  String get snippetPickerEmptyMessage =>
      'No snippets. Create one from the Snippets screen.';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return 'No snippets match \"$query\"';
  }

  @override
  String get snippetPickerLoadingError => 'Failed to load snippets';

  @override
  String get snippetPickerVariableDialogTitle => 'Fill Variables';

  @override
  String snippetPickerVariableHint(String variable) {
    return 'Enter value for $variable';
  }

  @override
  String get snippetPickerVariableInsert => 'Insert';

  @override
  String get sftpSelectHostHint => 'Select host...';

  @override
  String get sftpConnecting => 'Connecting...';

  @override
  String get sftpUploadLabel => 'Upload';

  @override
  String get sftpDownloadLabel => 'Download';

  @override
  String get sftpNoSavedHostsTitle => 'No saved hosts';

  @override
  String get sftpNoSavedHostsSubtitle =>
      'Add a host first, then come back to transfer files.';

  @override
  String get sftpFailedToLoadHosts => 'Failed to load hosts';

  @override
  String sftpFailedToConnect(String error) {
    return 'Failed to connect: $error';
  }

  @override
  String get sftpConnectToHostFirst => 'Connect to a host first';

  @override
  String get sftpDropFilesToUpload => 'Drop files to upload';

  @override
  String get sftpTabLocal => 'Local';

  @override
  String get sftpTabRemote => 'Remote';

  @override
  String get sftpPaneHeaderLocal => 'LOCAL';

  @override
  String get sftpPaneHeaderRemote => 'REMOTE';

  @override
  String get sftpLocalPermissionDenied => 'Permission denied';

  @override
  String get sftpLocalEmptyFolder => 'Empty folder';

  @override
  String get sftpLocalCannotOpenFolder => 'Cannot open folder';

  @override
  String get sftpRemoteSelectHost => 'Select a host to browse';

  @override
  String get sftpRemoteSelectHostSubtitle =>
      'Use the dropdown above to pick a connected server';

  @override
  String get sftpRemoteEmptyDirectory => 'Empty directory';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return 'Cannot open folder: $message';
  }

  @override
  String get sftpRemoteReadOnly => 'Read-only';

  @override
  String get sftpRemoteNewFolderTooltip => 'New folder';

  @override
  String get sftpHideHiddenFiles => 'Hide hidden files';

  @override
  String get sftpShowHiddenFiles => 'Show hidden files';

  @override
  String get sftpGoUp => 'Go up';

  @override
  String get sftpNewFolderDialogTitle => 'New Folder';

  @override
  String get sftpNewFolderDialogLabel => 'Folder name';

  @override
  String get sftpNewFolderDialogHint => 'e.g., new-folder';

  @override
  String get sftpNewFolderDialogCreate => 'Create';

  @override
  String get sftpFileMenuEdit => 'Edit';

  @override
  String get sftpFileMenuPermissions => 'Permissions';

  @override
  String get sftpFileMenuDelete => 'Delete';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return 'Permissions — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => 'Octal: ';

  @override
  String get sftpPermissionsLabelUser => 'User';

  @override
  String get sftpPermissionsLabelGroup => 'Group';

  @override
  String get sftpPermissionsLabelOther => 'Other';

  @override
  String get sftpPermissionsBitRead => 'Read';

  @override
  String get sftpPermissionsBitWrite => 'Write';

  @override
  String get sftpPermissionsBitExec => 'Exec';

  @override
  String get sftpPermissionsApply => 'Apply';

  @override
  String get sftpTransfersHeader => 'Transfers';

  @override
  String get sftpTransfersClearDone => 'Clear done';

  @override
  String get sftpTransferStatusDone => 'Done';

  @override
  String get sftpTransferStatusFailed => 'Failed';

  @override
  String get remoteEditorSaveTooltip => 'Save';

  @override
  String get remoteEditorFileSaved => 'File saved';

  @override
  String remoteEditorFailedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle => 'Unsaved Changes';

  @override
  String get remoteEditorUnsavedChangesMessage =>
      'You have unsaved changes. Discard them?';

  @override
  String get remoteEditorDiscard => 'Discard';

  @override
  String get remoteEditorFailedToLoadFile => 'Failed to load file';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionConnection => 'Connection';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get sectionSecurity => 'Security';

  @override
  String get sectionTools => 'Tools';

  @override
  String get sectionData => 'Data';

  @override
  String get sectionCloudImport => 'Cloud Import';

  @override
  String get sectionSync => 'Sync';

  @override
  String get sectionAbout => 'About';

  @override
  String get settingThemeTitle => 'Theme';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeSystem => 'System';

  @override
  String get settingTerminalThemeTitle => 'Terminal Theme';

  @override
  String get settingFontFamilyTitle => 'Font Family';

  @override
  String get settingFontSizeTitle => 'Font Size';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => 'Cursor Style';

  @override
  String get cursorStyleBlock => 'Block';

  @override
  String get cursorStyleUnderline => 'Underline';

  @override
  String get cursorStyleVerticalBar => 'Vertical Bar';

  @override
  String get settingFontLigaturesTitle => 'Font Ligatures';

  @override
  String get settingFontLigaturesEnabled => 'Enabled (e.g., => becomes ⇒)';

  @override
  String get settingFontLigaturesDisabled => 'Disabled';

  @override
  String get settingLanguageTitle => 'Language';

  @override
  String get settingDefaultSshPortTitle => 'Default SSH Port';

  @override
  String get settingConnectionTimeoutTitle => 'Connection Timeout';

  @override
  String get settingKeepAliveTitle => 'Keep Alive Interval';

  @override
  String get dialogDefaultSshPort => 'Default SSH Port';

  @override
  String get dialogConnectionTimeout => 'Connection Timeout (seconds)';

  @override
  String get dialogKeepAliveInterval => 'Keep Alive Interval (seconds)';

  @override
  String settingTimeoutSuffix(String value) {
    return '${value}s';
  }

  @override
  String get settingCommandCompletionSoundTitle => 'Command Completion Sound';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return 'Alert when commands run > ${threshold}s';
  }

  @override
  String get settingNotificationThresholdTitle => 'Notification Threshold';

  @override
  String get dialogNotificationThreshold => 'Notification Threshold (seconds)';

  @override
  String get settingKnownHostsTitle => 'Known Hosts';

  @override
  String get settingKnownHostsSubtitle => 'Manage trusted SSH host keys';

  @override
  String get settingWorkspacesTitle => 'Workspaces';

  @override
  String get settingWorkspacesSubtitle => 'Save and restore tab layouts';

  @override
  String get settingPasswordGeneratorTitle => 'Password Generator';

  @override
  String get settingPasswordGeneratorSubtitle => 'Generate secure passwords';

  @override
  String get settingSessionLogsTitle => 'Session Logs';

  @override
  String get settingSessionLogsSubtitle => 'View terminal session recordings';

  @override
  String get settingImportSshConfigTitle => 'Import SSH Config';

  @override
  String get settingImportSshConfigSubtitle =>
      'Import hosts from ~/.ssh/config';

  @override
  String get settingExportDataTitle => 'Export Data';

  @override
  String get settingExportDataSubtitle =>
      'Backup hosts, snippets, and settings';

  @override
  String get settingImportDataTitle => 'Import Data';

  @override
  String get settingImportDataSubtitle => 'Restore from a backup file';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle =>
      'Import instances from Amazon Web Services';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle => 'Import droplets from DigitalOcean';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return 'Version $version';
  }

  @override
  String get settingPrivacyPolicyTitle => 'Privacy Policy';

  @override
  String get settingPrivacyPolicySubtitle => 'How your data is handled';

  @override
  String get settingTermsOfServiceTitle => 'Terms of Service';

  @override
  String get settingTermsOfServiceSubtitle => 'Usage terms and conditions';

  @override
  String get themePickerTitle => 'Theme';

  @override
  String get terminalThemePickerTitle => 'Terminal Theme';

  @override
  String get terminalThemeCustomThemesHeader => 'CUSTOM THEMES';

  @override
  String get terminalThemeBuiltInThemesHeader => 'BUILT-IN THEMES';

  @override
  String get terminalThemeNewTheme => 'New Theme';

  @override
  String get terminalThemeEditTooltip => 'Edit';

  @override
  String get terminalThemeDeleteTooltip => 'Delete';

  @override
  String get fontSizePickerTitle => 'Terminal Font Size';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => 'Reset';

  @override
  String get fontFamilyPickerTitle => 'Font Family';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => 'Cursor Style';

  @override
  String get numberInputInvalidNumber => 'Enter a valid number';

  @override
  String numberInputRangeError(String min, String max) {
    return 'Must be between $min and $max';
  }

  @override
  String get exportDataTitle => 'Export Data';

  @override
  String get exportDataMessage =>
      'Choose export type:\n\nPlaintext exports hosts, snippets, and settings. Private keys are NOT included.\n\nEncrypted vault backup includes everything — hosts, keys, passwords, and settings — protected with a password you choose.';

  @override
  String get exportDataPlaintext => 'Plaintext';

  @override
  String get exportDataEncryptedVault => 'Encrypted Vault';

  @override
  String get exportDataExporting => 'Exporting data...';

  @override
  String get exportDataEncrypting => 'Encrypting and exporting...';

  @override
  String exportedToFile(String filename) {
    return 'Exported to: $filename';
  }

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return 'Vault exported to: $filename';
  }

  @override
  String get importDataFileDialogTitle => 'Select CloudShell Backup';

  @override
  String get importDataPlaintextTitle => 'Import Plaintext Backup';

  @override
  String get importDataPlaintextMessage =>
      'Import will merge data from the backup file.\n\nExisting records will be updated, new records will be added.\n\nNote: Plaintext backups do not include private SSH keys.';

  @override
  String get importDataPlaintextImport => 'Import';

  @override
  String get importDataDecryptTitle => 'Decrypt Vault Backup';

  @override
  String get importDataDecryptMessage =>
      'Enter the password used when creating this backup.';

  @override
  String get importDataDecryptConfirmLabel => 'Decrypt & Import';

  @override
  String get importDataDecrypting => 'Decrypting and importing...';

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get encryptedExportTitle => 'Encrypted Export';

  @override
  String get encryptedExportMessage =>
      'Choose a strong password to encrypt your vault backup. You will need this password to restore the backup.';

  @override
  String get encryptedExportConfirmLabel => 'Export';

  @override
  String get passwordDialogLabelPassword => 'Password';

  @override
  String get passwordDialogLabelConfirmPassword => 'Confirm password';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String passwordMinLength(String minLength) {
    return 'Minimum $minLength characters';
  }

  @override
  String get biometricUnlockTitle => 'Biometric Unlock';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => 'biometrics';

  @override
  String get biometricNotAvailable =>
      'Biometric authentication is not available on this device.';

  @override
  String get vaultEncryptionTitle => 'Encryption';

  @override
  String get vaultNotConfiguredSubtitle => 'Not configured — sign in to enable';

  @override
  String get vaultEncryptedUnlockedSubtitle => 'Encrypted and unlocked';

  @override
  String get vaultLockedSubtitle => 'Vault is locked';

  @override
  String get vaultMasterPasswordTitle => 'Master Password';

  @override
  String get vaultLoadingSubtitle => 'Loading...';

  @override
  String get vaultErrorSubtitle => 'Error loading vault state';

  @override
  String get vaultEncryptionEnabled => 'Vault encryption enabled';

  @override
  String get vaultDialogTitle => 'Vault';

  @override
  String get vaultLockNow => 'Lock Vault Now';

  @override
  String get vaultLocked => 'Vault locked';

  @override
  String get vaultChangePassword => 'Change Password';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordCurrentLabel => 'Current Password';

  @override
  String get changePasswordNewLabel => 'New Password';

  @override
  String get changePasswordConfirmLabel => 'Confirm New Password';

  @override
  String get changePasswordSubmit => 'Change';

  @override
  String get changePasswordMismatch => 'Passwords do not match';

  @override
  String get changePasswordMinLength => 'Minimum 10 characters required';

  @override
  String get changePasswordSuccess => 'Master password changed successfully';

  @override
  String get autoLockTitle => 'Auto-Lock';

  @override
  String get autoLockSetUpVaultFirst => 'Set up vault first';

  @override
  String get autoLockDialogTitle => 'Auto-Lock Timeout';

  @override
  String get autoLockTimeoutNever => 'Never';

  @override
  String get autoLockTimeout1Min => '1 minute';

  @override
  String get autoLockTimeout5Min => '5 minutes';

  @override
  String get autoLockTimeout15Min => '15 minutes';

  @override
  String get autoLockTimeout30Min => '30 minutes';

  @override
  String get autoLockTimeout1Hour => '1 hour';

  @override
  String get appLockGracePeriodTitle => 'Lock Delay';

  @override
  String get appLockGracePeriodEnableBiometricFirst =>
      'Enable biometric lock first';

  @override
  String get appLockGracePeriodDialogTitle => 'Lock Delay After Background';

  @override
  String get appLockGracePeriodImmediate => 'Immediately';

  @override
  String get appLockGracePeriod30Seconds => '30 seconds';

  @override
  String get appLockGracePeriod1Minute => '1 minute';

  @override
  String get appLockGracePeriod5Minutes => '5 minutes';

  @override
  String get appLockGracePeriod15Minutes => '15 minutes';

  @override
  String get syncAccountTitle => 'Account';

  @override
  String get syncSignedInDefault => 'Signed in';

  @override
  String get syncLocalOnlyTitle => 'Local Only';

  @override
  String get syncLocalOnlySubtitle => 'Upgrade to sync across devices';

  @override
  String get syncCloudSyncTitle => 'Cloud Sync';

  @override
  String get syncCloudSyncSubtitle => 'Sign in to sync across devices';

  @override
  String get accountDialogTitle => 'Account';

  @override
  String get accountSignOut => 'Sign Out';

  @override
  String get accountSignedOut => 'Signed out';

  @override
  String get accountDeleteAccount => 'Delete Account';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountWarning => 'This action cannot be undone.';

  @override
  String get deleteAccountWillDelete => 'This will permanently delete:';

  @override
  String get deleteAccountItemAccount => '  • Your account and login';

  @override
  String get deleteAccountItemSyncedData => '  • All synced data on the server';

  @override
  String get deleteAccountItemVault => '  • Encryption vault configuration';

  @override
  String get deleteAccountLocalDataNote =>
      'Local data (hosts, keys, settings) will remain on this device.';

  @override
  String get deleteAccountConfirmPrompt => 'Type DELETE to confirm:';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => 'Delete Account';

  @override
  String get deleteAccountDeleting => 'Deleting account...';

  @override
  String get deleteAccountFailedDefault => 'Failed to delete account';

  @override
  String get deleteAccountSuccess => 'Account deleted. Local data preserved.';

  @override
  String get syncAutoSyncTitle => 'Auto Sync';

  @override
  String get syncUnlockVault => 'Unlock vault to enable sync';

  @override
  String get syncEvery5Minutes => 'Sync every 5 minutes';

  @override
  String get syncDisabled => 'Sync is disabled';

  @override
  String get syncNeverSynced => 'Never synced';

  @override
  String get syncJustNow => 'Just now';

  @override
  String get syncNowTitle => 'Sync Now';

  @override
  String get syncSyncing => 'Syncing...';

  @override
  String syncResult(int pulled, int pushed) {
    return 'Synced: $pulled pulled, $pushed pushed';
  }

  @override
  String syncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get totp2faTitle => '2FA Authentication';

  @override
  String get totpSignInToEnable => 'Sign in to enable';

  @override
  String get totpEnabled => 'Enabled';

  @override
  String get totpNotConfigured => 'Not configured';

  @override
  String get totpDisable2faTitle => 'Disable 2FA?';

  @override
  String get totpDisable2faMessage =>
      'This will remove two-factor authentication from your account. You can re-enable it at any time.';

  @override
  String get totpDisable2faSubmit => 'Disable';

  @override
  String get totpDisabled => '2FA disabled';

  @override
  String get knownHostsTitle => 'Known Hosts';

  @override
  String get knownHostsEmptyTitle => 'No known hosts';

  @override
  String get knownHostsEmptySubtitle =>
      'Host key fingerprints are saved here when you connect to a server for the first time.';

  @override
  String get knownHostsSearchHint => 'Search known hosts...';

  @override
  String get knownHostsLoadingMessage => 'Loading known hosts...';

  @override
  String get knownHostsRemoveTitle => 'Remove Known Host';

  @override
  String get knownHostsRemoveConfirmLabel => 'Remove';

  @override
  String get knownHostsMenuRemove => 'Remove';

  @override
  String get knownHostsFirstSeen => 'First seen';

  @override
  String get knownHostsLastSeen => 'Last seen';

  @override
  String knownHostsNoMatchQuery(String query) {
    return 'No hosts match \"$query\"';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return 'Remove trust for $hostname:$port?\n\nYou will be asked to verify the host key again on next connection.';
  }

  @override
  String get sessionLogsTitle => 'Session Logs';

  @override
  String get sessionLogsDeleteAllTooltip => 'Delete all logs';

  @override
  String get sessionLogsEmpty => 'No session logs';

  @override
  String get sessionLogsEnableHint => 'Enable logging from the terminal menu';

  @override
  String get sessionLogsView => 'View';

  @override
  String get sessionLogsShare => 'Share';

  @override
  String get sessionLogsDelete => 'Delete';

  @override
  String get sessionLogsShareSubject => 'CloudShell Session Log';

  @override
  String get sessionLogsDeleteAllTitle => 'Delete All Logs?';

  @override
  String get sessionLogsDeleteAllMessage =>
      'This will permanently delete all session log files.';

  @override
  String get sessionLogsDeleteAllConfirm => 'Delete All';

  @override
  String get sessionLogsShareTooltip => 'Share';

  @override
  String sessionLogsReadError(String error) {
    return 'Error reading file: $error';
  }

  @override
  String get customThemeEditTitle => 'Edit Theme';

  @override
  String get customThemeNewTitle => 'New Custom Theme';

  @override
  String get customThemeSave => 'Save';

  @override
  String get customThemeNameLabel => 'Theme Name';

  @override
  String get customThemeNameHint => 'e.g., My Custom Theme';

  @override
  String get customThemeSectionTerminalChrome => 'Terminal Chrome';

  @override
  String get customThemeSectionNormalColors => 'Normal Colors';

  @override
  String get customThemeSectionBrightColors => 'Bright Colors';

  @override
  String get colorBackground => 'Background';

  @override
  String get colorForeground => 'Foreground';

  @override
  String get colorCursor => 'Cursor';

  @override
  String get colorSelection => 'Selection';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorRed => 'Red';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorMagenta => 'Magenta';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorWhite => 'White';

  @override
  String get colorBrightBlack => 'Bright Black';

  @override
  String get colorBrightRed => 'Bright Red';

  @override
  String get colorBrightGreen => 'Bright Green';

  @override
  String get colorBrightYellow => 'Bright Yellow';

  @override
  String get colorBrightBlue => 'Bright Blue';

  @override
  String get colorBrightMagenta => 'Bright Magenta';

  @override
  String get colorBrightCyan => 'Bright Cyan';

  @override
  String get colorBrightWhite => 'Bright White';

  @override
  String get customThemePreviewTitle => 'Terminal Preview';

  @override
  String get customThemePreviewSelectedText => 'Selected text preview';

  @override
  String get hexColorLabel => 'Hex Color';

  @override
  String get hexColorPasteTooltip => 'Paste';

  @override
  String get hexColorInvalid => 'Invalid hex';

  @override
  String get hexColorApply => 'Apply';

  @override
  String get customThemeNameRequired => 'Theme name is required';

  @override
  String get sliderHue => 'H';

  @override
  String get sliderSaturation => 'S';

  @override
  String get sliderBrightness => 'V';

  @override
  String get sshConfigImportTitle => 'Import SSH Config';

  @override
  String get sshConfigImportFailed => 'Failed to read SSH config';

  @override
  String get sshConfigNoHostsFound => 'No hosts found';

  @override
  String get sshConfigNoHostsFoundDetail =>
      'No valid host entries were found in ~/.ssh/config';

  @override
  String get sshConfigDeselectAll => 'Deselect All';

  @override
  String get sshConfigSelectAll => 'Select All';

  @override
  String get sshConfigImportKeys => 'Import keys';

  @override
  String sshConfigFoundHosts(int count) {
    return 'Found $count host(s) in ~/.ssh/config';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return 'Imported $count host(s) and $keys key(s)';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return 'Import failed: $error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return 'Import ($count)';
  }

  @override
  String get legalScreenLoadError => 'Failed to load document';

  @override
  String get workspacesTitle => 'Workspaces';

  @override
  String get workspacesSaveCurrent => 'Save Current';

  @override
  String get workspacesEmptyTitle => 'No saved workspaces';

  @override
  String get workspacesEmptySubtitle =>
      'Your current tab layout is auto-saved.\nUse \"Save Current\" to create a named workspace.';

  @override
  String workspacesLoadError(String error) {
    return 'Failed to load workspaces: $error';
  }

  @override
  String get workspacesActiveBadge => 'ACTIVE';

  @override
  String get workspacesNoTerminals => 'No terminals';

  @override
  String get workspacesJustNow => 'Just now';

  @override
  String get workspacesMenuSwitchTo => 'Switch to';

  @override
  String get workspacesMenuRename => 'Rename';

  @override
  String get workspacesMenuDelete => 'Delete';

  @override
  String get workspacesSaveTitle => 'Save Workspace';

  @override
  String get workspacesSaveHint => 'Workspace name';

  @override
  String get workspacesSaveSave => 'Save';

  @override
  String get workspacesRenameTitle => 'Rename Workspace';

  @override
  String get workspacesRenameHint => 'New name';

  @override
  String get workspacesRenameSubmit => 'Rename';

  @override
  String get workspacesDeleteTitle => 'Delete Workspace?';

  @override
  String get workspacesDeleteSubmit => 'Delete';

  @override
  String workspaceTerminalCount(int count) {
    return '$count terminal(s)';
  }

  @override
  String workspaceSaved(String name) {
    return 'Workspace \"$name\" saved';
  }

  @override
  String workspaceSwitching(String name) {
    return 'Switching to \"$name\"...';
  }

  @override
  String workspaceLoaded(String name) {
    return 'Workspace \"$name\" loaded';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get awsImportTitle => 'Import from AWS EC2';

  @override
  String get awsConnectTitle => 'Connect to AWS';

  @override
  String get awsConnectSubtitle =>
      'Enter your AWS credentials to import EC2 instances.';

  @override
  String get awsAccessKeyIdLabel => 'Access Key ID';

  @override
  String get awsAccessKeyIdHelper => 'e.g. AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => 'Secret Access Key';

  @override
  String get awsRegionLabel => 'Region';

  @override
  String get awsCredentialsInfo =>
      'Credentials are only used for this import and are not stored. Use an IAM user with ec2:DescribeInstances permission only.';

  @override
  String get awsFetchInstances => 'Fetch Instances';

  @override
  String get awsFetchingInstances => 'Fetching instances...';

  @override
  String get awsErrorAccessKeyRequired => 'Enter your AWS Access Key ID';

  @override
  String get awsErrorSecretKeyRequired => 'Enter your AWS Secret Access Key';

  @override
  String get awsSelectInstances => 'Select Instances';

  @override
  String get awsRunningOnlyFilter => 'Running only';

  @override
  String get awsNoRunningInstances => 'No running instances found';

  @override
  String get awsNoInstances => 'No instances found';

  @override
  String get awsConfigureImport => 'Configure Import';

  @override
  String get awsDefaultUsernameLabel => 'Default Username';

  @override
  String get awsDefaultUsernameHelper =>
      'Amazon Linux: ec2-user, Ubuntu: ubuntu';

  @override
  String get awsInstancesToImport => 'Instances to import:';

  @override
  String get awsImporting => 'Importing...';

  @override
  String awsImportResult(int count) {
    return 'Imported $count host(s) from AWS EC2';
  }

  @override
  String awsImportHostsButton(int count) {
    return 'Import $count Host(s)';
  }

  @override
  String awsNextButton(int count) {
    return 'Next ($count)';
  }

  @override
  String get doImportTitle => 'Import from DigitalOcean';

  @override
  String get doConnectTitle => 'Connect to DigitalOcean';

  @override
  String get doConnectSubtitle =>
      'Enter your DigitalOcean personal access token to import droplets.';

  @override
  String get doApiTokenLabel => 'API Token';

  @override
  String get doApiTokenHelper =>
      'Generate at cloud.digitalocean.com/account/api/tokens';

  @override
  String get doTokenInfo =>
      'Your token is only used for this import and is not stored.';

  @override
  String get doFetchDroplets => 'Fetch Droplets';

  @override
  String get doFetchingDroplets => 'Fetching droplets...';

  @override
  String get doErrorTokenRequired => 'Enter your API token';

  @override
  String get doSelectDroplets => 'Select Droplets';

  @override
  String get doActiveOnlyFilter => 'Active only';

  @override
  String get doNoActiveDroplets => 'No active droplets found';

  @override
  String get doNoDroplets => 'No droplets found';

  @override
  String get doConfigureImport => 'Configure Import';

  @override
  String get doDefaultUsernameLabel => 'Default Username';

  @override
  String get doDefaultUsernameHelper =>
      'Used for all imported hosts (default: root)';

  @override
  String get doHostsToImport => 'Hosts to import:';

  @override
  String get doImporting => 'Importing...';

  @override
  String doImportResult(int count) {
    return 'Imported $count host(s) from DigitalOcean';
  }

  @override
  String doImportHostsButton(int count) {
    return 'Import $count Host(s)';
  }

  @override
  String doNextButton(int count) {
    return 'Next ($count)';
  }

  @override
  String get loginSubtitle => 'Sign in to sync across devices';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginErrorEmailRequired => 'Enter your email address';

  @override
  String get loginErrorPasswordRequired => 'Enter your password';

  @override
  String get loginSigningIn => 'Signing in...';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginCreateAccount => 'Create Account';

  @override
  String get loginUseLocally => 'Use locally without an account';

  @override
  String get signUpSubtitle => 'Create your account';

  @override
  String get signUpEmailLabel => 'Email';

  @override
  String get signUpPasswordLabel => 'Password (min 10 characters)';

  @override
  String get signUpConfirmPasswordLabel => 'Confirm Password';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordStrengthExcellent => 'Excellent';

  @override
  String get signUpErrorEmailRequired => 'Enter your email address';

  @override
  String get signUpErrorPasswordRequired => 'Enter a password';

  @override
  String get signUpErrorPasswordTooShort =>
      'Password must be at least 10 characters';

  @override
  String get signUpErrorPasswordMismatch => 'Passwords do not match';

  @override
  String get signUpErrorTermsRequired => 'Please accept the terms of service';

  @override
  String get signUpEncryptionWarning =>
      'Your data is encrypted end-to-end. We cannot recover your account if you lose your password.';

  @override
  String get signUpTermsPrefix => 'I accept the ';

  @override
  String get signUpTermsOfService => 'Terms of Service';

  @override
  String get signUpTermsAnd => ' and ';

  @override
  String get signUpPrivacyPolicy => 'Privacy Policy';

  @override
  String get signUpCreatingAccount => 'Creating account...';

  @override
  String get signUpCreateAccount => 'Create Account';

  @override
  String get signUpAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get signUpSignIn => 'Sign In';

  @override
  String get signUpEncryptionNote => 'Encryption: Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => 'Reset your password';

  @override
  String get forgotPasswordInstructions =>
      'Enter the email associated with your account and we\'ll send a password reset link.';

  @override
  String get forgotPasswordEmailLabel => 'Email';

  @override
  String get forgotPasswordSending => 'Sending...';

  @override
  String get forgotPasswordSendResetLink => 'Send Reset Link';

  @override
  String get forgotPasswordBackToSignIn => 'Back to Sign In';

  @override
  String get forgotPasswordErrorEmailRequired => 'Enter your email address';

  @override
  String get forgotPasswordCheckEmail => 'Check Your Email';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return 'If an account exists for $email, you\'ll receive a password reset link shortly.';
  }

  @override
  String get forgotPasswordVaultWarning =>
      'Remember: We use zero-knowledge encryption. If you reset your account password, your vault master password remains unchanged.';

  @override
  String get forgotPasswordTryAgain => 'Didn\'t receive it? Try again';

  @override
  String get totpSetupTitle => 'Set Up 2FA';

  @override
  String get totpSetupFailed => 'Failed to set up 2FA';

  @override
  String get totpSetupHeading => 'Two-Factor Authentication';

  @override
  String get totpSetupInstructions =>
      'Scan this QR code with your authenticator app (Google Authenticator, Authy, etc.).';

  @override
  String get totpSetupManualEntryKey => 'Manual entry key';

  @override
  String get totpSetupSecretCopied => 'Secret copied';

  @override
  String get totpSetupEnterCode => 'Enter the 6-digit code from your app:';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => 'Verifying...';

  @override
  String get totpSetupVerifyAndEnable => 'Verify & Enable';

  @override
  String get totpSetupEnabled => 'Two-factor authentication enabled';

  @override
  String get totpSetupErrorCodeLength => 'Enter a 6-digit code';

  @override
  String get totpSetupErrorInvalidCode =>
      'Invalid code. Check your authenticator app and try again.';

  @override
  String get totpVerifyHeading => 'Two-Factor Authentication';

  @override
  String get totpVerifyInstructions =>
      'Enter the 6-digit code from your authenticator app';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => 'Verifying...';

  @override
  String get totpVerifySubmit => 'Verify';

  @override
  String get totpVerifyHelpText =>
      'Open your authenticator app (Google Authenticator, Authy, etc.) to find your verification code.';

  @override
  String get totpVerifyErrorDefaultFailed => 'Verification failed';

  @override
  String get totpVerifyErrorInvalidCode => 'Invalid code. Try again.';

  @override
  String get adaptiveScaffoldHosts => 'Hosts';

  @override
  String get adaptiveScaffoldKeys => 'Keys';

  @override
  String get adaptiveScaffoldSnippets => 'Snippets';

  @override
  String get adaptiveScaffoldTerminal => 'Terminal';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => 'Port Forwarding';

  @override
  String get adaptiveScaffoldSettings => 'Settings';

  @override
  String get commandPaletteHint =>
      'Search hosts, snippets, or type a command...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get commandPaletteHostsHeader => 'Hosts';

  @override
  String get commandPaletteSnippetsHeader => 'Snippets';

  @override
  String get commandPaletteActionsHeader => 'Actions';

  @override
  String get commandPaletteActionNewHost => 'New Host';

  @override
  String get commandPaletteActionQuickConnect => 'Quick Connect';

  @override
  String get commandPaletteActionSettings => 'Settings';

  @override
  String get commandPaletteActionToggleTheme => 'Toggle Theme';

  @override
  String get shortcutReferenceTitle => 'Keyboard Shortcuts';

  @override
  String get shortcutCategoryGeneral => 'General';

  @override
  String get shortcutCategoryTerminal => 'Terminal';

  @override
  String get shortcutCategoryNavigation => 'Navigation';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => 'Unlock to continue';

  @override
  String get appLockUnlockButton => 'Unlock';

  @override
  String get appLockUnlockWithBiometrics => 'Unlock with biometrics';

  @override
  String get appLockBiometricReason => 'Authenticate to unlock CloudShell';

  @override
  String get appLockFailed => 'Authentication failed';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusWarning => 'Warning';

  @override
  String get statusIdle => 'Idle';

  @override
  String get vaultUnlockTitle => 'Unlock Vault';

  @override
  String get vaultUnlockSubtitle =>
      'Enter your master password to unlock the vault.';

  @override
  String get vaultUnlockPasswordLabel => 'Master Password';

  @override
  String get vaultUnlockPasswordHint => 'Enter master password';

  @override
  String get vaultUnlockButton => 'Unlock';

  @override
  String get vaultUnlockUnlocking => 'Unlocking...';

  @override
  String get vaultUnlockBiometricButton => 'Unlock with biometrics';

  @override
  String get vaultUnlockForgotPassword => 'Forgot password?';

  @override
  String get vaultUnlockResetTitle => 'Reset Vault?';

  @override
  String get vaultUnlockResetMessage =>
      'Resetting will delete all encrypted data (saved passwords, private keys). Local hosts and settings will be preserved.\n\nThis action cannot be undone.';

  @override
  String get vaultUnlockResetConfirm => 'Reset Vault';

  @override
  String get vaultUnlockIncorrectPassword => 'Incorrect password';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return 'Too many attempts. Try again in ${seconds}s.';
  }

  @override
  String get masterPasswordSetupTitle => 'Set Up Vault';

  @override
  String get masterPasswordSetupSubtitle =>
      'Create a master password to encrypt your sensitive data.';

  @override
  String get masterPasswordSetupPasswordLabel => 'Master Password';

  @override
  String get masterPasswordSetupPasswordHint => 'Minimum 10 characters';

  @override
  String get masterPasswordSetupConfirmLabel => 'Confirm Password';

  @override
  String get masterPasswordSetupConfirmHint => 'Re-enter master password';

  @override
  String get masterPasswordSetupButton => 'Create Vault';

  @override
  String get masterPasswordSetupCreating => 'Creating vault...';

  @override
  String get masterPasswordSetupMinLength => 'Minimum 10 characters required';

  @override
  String get masterPasswordSetupMismatch => 'Passwords do not match';

  @override
  String get masterPasswordSetupStrengthWeak => 'Weak';

  @override
  String get masterPasswordSetupStrengthFair => 'Fair';

  @override
  String get masterPasswordSetupStrengthGood => 'Good';

  @override
  String get masterPasswordSetupStrengthStrong => 'Strong';

  @override
  String get masterPasswordSetupWarning =>
      'Your master password cannot be recovered. Write it down and store it safely.';

  @override
  String get passwordGeneratorTitle => 'Password Generator';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return 'Length: $length';
  }

  @override
  String get passwordGeneratorUppercase => 'Uppercase (A-Z)';

  @override
  String get passwordGeneratorLowercase => 'Lowercase (a-z)';

  @override
  String get passwordGeneratorNumbers => 'Numbers (0-9)';

  @override
  String get passwordGeneratorSymbols => 'Symbols (!@#...)';

  @override
  String get passwordGeneratorGenerate => 'Generate';

  @override
  String get passwordGeneratorCopy => 'Copy';

  @override
  String get passwordGeneratorCopied => 'Password copied (auto-clears in 30s)';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bits bits of entropy';
  }

  @override
  String get onboardingWelcomeTitle => 'Welcome to CloudShell';

  @override
  String get onboardingWelcomeSubtitle => 'A modern, cross-platform SSH client';

  @override
  String get onboardingSecureTitle => 'Secure by Design';

  @override
  String get onboardingSecureSubtitle =>
      'End-to-end encrypted vault with Argon2id + AES-256-GCM';

  @override
  String get onboardingTerminalTitle => 'Powerful Terminal';

  @override
  String get onboardingTerminalSubtitle =>
      'Split panes, tabs, themes, snippets, and more';

  @override
  String get onboardingSyncTitle => 'Sync Everywhere';

  @override
  String get onboardingSyncSubtitle =>
      'Your hosts, keys, and snippets — on all your devices';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get portForwardingTitle => 'Port Forwarding';

  @override
  String get portForwardingAddTooltip => 'Add rule';

  @override
  String get portForwardingEmptyTitle => 'No port forwarding rules';

  @override
  String get portForwardingEmptySubtitle =>
      'Create rules to tunnel traffic through SSH connections.';

  @override
  String get portForwardingEmptyAction => 'Add Rule';

  @override
  String get portForwardingActiveHeader => 'ACTIVE';

  @override
  String get portForwardingSavedHeader => 'SAVED RULES';

  @override
  String get portForwardingTypeLocal => 'Local';

  @override
  String get portForwardingTypeRemote => 'Remote';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => 'Stop';

  @override
  String get portForwardingStart => 'Start';

  @override
  String get portForwardingMenuEdit => 'Edit';

  @override
  String get portForwardingMenuDelete => 'Delete';

  @override
  String get portForwardingDeleteDialogTitle => 'Delete Rule';

  @override
  String get portForwardingDeleteDialogMessage =>
      'Delete this port forwarding rule?';

  @override
  String get portForwardingLoading => 'Loading port forwarding rules...';

  @override
  String get portForwardFormTitleNew => 'New Port Forward';

  @override
  String get portForwardFormTitleEdit => 'Edit Port Forward';

  @override
  String get portForwardFormLabelField => 'Label';

  @override
  String get portForwardFormLabelHint => 'e.g., Database Tunnel';

  @override
  String get portForwardFormTypeField => 'Type';

  @override
  String get portForwardFormTypeLocal => 'Local';

  @override
  String get portForwardFormTypeRemote => 'Remote';

  @override
  String get portForwardFormTypeDynamic => 'Dynamic (SOCKS)';

  @override
  String get portForwardFormHostField => 'Host';

  @override
  String get portForwardFormSelectHost => 'Select a host';

  @override
  String get portForwardFormNoHostsAvailable =>
      'No hosts available. Create a host first.';

  @override
  String get portForwardFormCouldNotLoadHosts => 'Could not load hosts.';

  @override
  String get portForwardFormLocalPortField => 'Local Port';

  @override
  String get portForwardFormRemotePortField => 'Remote Port';

  @override
  String get portForwardFormDestHostField => 'Destination Host';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => 'Dest Port';

  @override
  String get portForwardFormDestPortHint => 'e.g., 5432';

  @override
  String get portForwardFormPortHint => 'e.g., 8080';

  @override
  String get portForwardFormAutoStart => 'Auto-start on connect';

  @override
  String get portForwardFormAutoStartSubtitle =>
      'Start this tunnel automatically when connecting to the host.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageChinese => '中文';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageSystem => 'System Default';
}
