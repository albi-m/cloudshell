// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get confirm => '确认';

  @override
  String get close => '关闭';

  @override
  String get retry => '重试';

  @override
  String get back => '返回';

  @override
  String get edit => '编辑';

  @override
  String get done => '完成';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get search => '搜索';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get togglePasswordVisibility => '切换密码可见性';

  @override
  String get togglePassphraseVisibility => '切换密码短语可见性';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get none => '无';

  @override
  String get unknown => '未知';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get hostsTitle => '主机';

  @override
  String get hostsAddTooltip => '添加主机';

  @override
  String get hostsSearchHint => '搜索主机...';

  @override
  String get hostsEmptyTitle => '暂无主机';

  @override
  String get hostsEmptySubtitle => '添加您的第一个 SSH 服务器以开始使用。';

  @override
  String get hostsEmptyAction => '添加主机';

  @override
  String hostsNoMatchQuery(String query) {
    return '没有匹配 \"$query\" 的主机';
  }

  @override
  String get hostsLoadingMessage => '正在加载主机...';

  @override
  String get hostsRecentHeader => '最近';

  @override
  String get hostsGroupsHeader => '分组';

  @override
  String get hostsFavoritesHeader => '收藏';

  @override
  String get hostsAllHostsHeader => '全部主机';

  @override
  String get hostsUngroupedHeader => '未分组';

  @override
  String get hostsDeleteDialogTitle => '删除主机';

  @override
  String hostsDeleteDialogMessage(String name) {
    return '确定要删除 \"$name\" 吗？';
  }

  @override
  String get hostsMenuEdit => '编辑';

  @override
  String get hostsMenuDelete => '删除';

  @override
  String get hostsMenuConnect => '连接';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return '上次连接 $time';
  }

  @override
  String get hostsNeverConnected => '从未连接';

  @override
  String get hostsJustNow => '刚刚';

  @override
  String get hostFormTitleNew => '新建主机';

  @override
  String get hostFormTitleEdit => '编辑主机';

  @override
  String get hostFormSave => '保存';

  @override
  String get hostFormLabelField => '标签';

  @override
  String get hostFormLabelHint => '例如：生产服务器';

  @override
  String get hostFormLabelRequired => '标签为必填项';

  @override
  String get hostFormHostnameField => '主机名';

  @override
  String get hostFormHostnameHint => '例如：192.168.1.100 或 example.com';

  @override
  String get hostFormHostnameRequired => '主机名为必填项';

  @override
  String get hostFormPortField => '端口';

  @override
  String get hostFormUsernameField => '用户名';

  @override
  String get hostFormUsernameHint => '例如：root';

  @override
  String get hostFormUsernameRequired => '用户名为必填项';

  @override
  String get hostFormPasswordField => '密码';

  @override
  String get hostFormPasswordHint => '输入密码';

  @override
  String get hostFormAuthMethodField => '认证方式';

  @override
  String get hostFormAuthMethodKey => '密钥';

  @override
  String get hostFormAuthMethodPassword => '密码';

  @override
  String get hostFormAuthMethodKeyAndPassword => '密钥 + 密码';

  @override
  String get hostFormKeyField => 'SSH 密钥';

  @override
  String get hostFormKeyNone => '无';

  @override
  String get hostFormGroupField => '分组';

  @override
  String get hostFormGroupNone => '未分组';

  @override
  String get hostFormTagsField => '标签';

  @override
  String get hostFormTagsHint => '添加标签（逗号分隔）';

  @override
  String get hostFormAdvancedSection => '高级';

  @override
  String get hostFormJumpHostField => '跳板机（代理）';

  @override
  String get hostFormJumpHostNone => '无（直接连接）';

  @override
  String get hostFormKeepAliveField => '保活间隔（秒）';

  @override
  String get hostFormStartupCommandField => '启动命令';

  @override
  String get hostFormStartupCommandHint => '连接后运行（可选）';

  @override
  String get hostFormNotesField => '备注';

  @override
  String get hostFormNotesHint => '关于此主机的可选备注';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => '串口';

  @override
  String get hostFormSerialPortField => '串口端口';

  @override
  String get hostFormSerialPortNone => '选择端口';

  @override
  String get hostFormSerialNoPortsAvailable => '没有可用的串口端口';

  @override
  String get hostFormSerialBaudRateField => '波特率';

  @override
  String get hostFormSerialDataBitsField => '数据位';

  @override
  String get hostFormSerialStopBitsField => '停止位';

  @override
  String get hostFormSerialParityField => '校验位';

  @override
  String get hostFormSerialFlowControlField => '流控';

  @override
  String get hostFormTestConnection => '测试连接';

  @override
  String get hostFormTestConnectionSuccess => '连接成功！';

  @override
  String hostFormTestConnectionFailed(String error) {
    return '连接失败：$error';
  }

  @override
  String get hostDetailTitle => '主机详情';

  @override
  String get hostDetailConnect => '连接';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => '编辑';

  @override
  String get hostDetailDeleteTooltip => '删除';

  @override
  String get hostDetailFavoriteTooltip => '收藏';

  @override
  String get hostDetailSectionConnection => '连接';

  @override
  String get hostDetailSectionAuthentication => '认证';

  @override
  String get hostDetailSectionAdvanced => '高级';

  @override
  String get hostDetailSectionTags => '标签';

  @override
  String get hostDetailSectionNotes => '备注';

  @override
  String get hostDetailLabelHostname => '主机名';

  @override
  String get hostDetailLabelPort => '端口';

  @override
  String get hostDetailLabelUsername => '用户名';

  @override
  String get hostDetailLabelAuthMethod => '认证方式';

  @override
  String get hostDetailLabelKey => '密钥';

  @override
  String get hostDetailLabelGroup => '分组';

  @override
  String get hostDetailLabelJumpHost => '跳板机';

  @override
  String get hostDetailLabelKeepAlive => '保活';

  @override
  String get hostDetailLabelStartupCommand => '启动命令';

  @override
  String get hostDetailLabelProtocol => '协议';

  @override
  String get hostDetailLabelCreated => '创建时间';

  @override
  String get hostDetailLabelUpdated => '更新时间';

  @override
  String get hostDetailLabelLastConnected => '上次连接';

  @override
  String get hostDetailNotFound => '未找到主机';

  @override
  String get hostDetailLoading => '正在加载主机...';

  @override
  String get hostDetailDeleteDialogTitle => '删除主机';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return '确定要删除 \"$name\" 吗？此操作无法撤销。';
  }

  @override
  String get quickConnectTitle => '快速连接';

  @override
  String get quickConnectHint => '用户名@主机:端口';

  @override
  String get quickConnectHelperText => '例如：root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => '保存主机';

  @override
  String get quickConnectConnect => '连接';

  @override
  String get quickConnectInvalidFormat => '格式无效。请使用 用户名@主机 或 用户名@主机:端口';

  @override
  String get groupFormTitleNew => '新建分组';

  @override
  String get groupFormTitleEdit => '编辑分组';

  @override
  String get groupFormNameField => '分组名称';

  @override
  String get groupFormNameHint => '例如：生产环境';

  @override
  String get groupFormNameRequired => '分组名称为必填项';

  @override
  String get groupFormParentField => '父分组';

  @override
  String get groupFormParentNone => '无（顶级）';

  @override
  String get groupFormDeleteDialogTitle => '删除分组';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return '删除 \"$name\"？该分组中的主机将变为未分组。';
  }

  @override
  String get hostKeyVerifyChangedTitle => '主机密钥已更改';

  @override
  String get hostKeyVerifyUnknownTitle => '未知主机';

  @override
  String get hostKeyVerifyChangedWarning => '警告：此服务器的主机密钥已更改。这可能表示存在中间人攻击。';

  @override
  String get hostKeyVerifyUnknownMessage => '无法验证此主机的真实性。确定要继续连接吗？';

  @override
  String get hostKeyVerifyLabelHost => '主机';

  @override
  String get hostKeyVerifyLabelKeyType => '密钥类型';

  @override
  String get hostKeyVerifyLabelFingerprint => '指纹：';

  @override
  String get hostKeyVerifyFingerprintCopied => '指纹已复制（30秒后自动清除）';

  @override
  String get hostKeyVerifyTrustAnyway => '仍然信任';

  @override
  String get hostKeyVerifyTrustAndConnect => '信任并连接';

  @override
  String get keysTitle => 'SSH 密钥';

  @override
  String get keysAddTooltip => '导入密钥';

  @override
  String get keysImportTooltip => '导入密钥';

  @override
  String get keysEmptyTitle => '暂无 SSH 密钥';

  @override
  String get keysEmptySubtitle => '导入您的 SSH 密钥以进行服务器认证。';

  @override
  String get keysEmptyAction => '导入密钥';

  @override
  String get keysSearchHint => '搜索密钥...';

  @override
  String keysNoMatchQuery(String query) {
    return '没有匹配 \"$query\" 的密钥';
  }

  @override
  String get keysLoadingMessage => '正在加载密钥...';

  @override
  String get keysDeleteDialogTitle => '删除密钥';

  @override
  String keysDeleteDialogMessage(String name) {
    return '删除 \"$name\"？此操作无法撤销。';
  }

  @override
  String get keysMenuDelete => '删除';

  @override
  String keysAssociatedHosts(int count) {
    return '$count 个主机';
  }

  @override
  String get keyDetailTitle => '密钥详情';

  @override
  String get keyDetailEditTooltip => '编辑';

  @override
  String get keyDetailDeleteTooltip => '删除';

  @override
  String get keyDetailSectionPublicKey => '公钥';

  @override
  String get keyDetailCopyPublicKey => '复制公钥';

  @override
  String get keyDetailSectionFingerprint => '指纹';

  @override
  String get keyDetailSectionAssociatedHosts => '关联主机';

  @override
  String get keyDetailSectionDetails => '详情';

  @override
  String get keyDetailLabelType => '类型';

  @override
  String get keyDetailLabelBits => '位数';

  @override
  String get keyDetailLabelCreated => '创建时间';

  @override
  String get keyDetailNotFound => '未找到密钥';

  @override
  String get keyDetailLoading => '正在加载密钥...';

  @override
  String get keyDetailPublicKeyCopied => '公钥已复制（30秒后自动清除）';

  @override
  String get keyDetailFingerprintCopied => '指纹已复制（30秒后自动清除）';

  @override
  String get keyDetailNoAssociatedHosts => '没有主机使用此密钥';

  @override
  String get keyImportTitle => '导入 SSH 密钥';

  @override
  String get keyImportButton => '导入';

  @override
  String get keyImportButtonImporting => '正在导入...';

  @override
  String get keyImportButtonImportKey => '导入密钥';

  @override
  String get keyImportLabelField => '标签';

  @override
  String get keyImportLabelHint => '例如：我的服务器密钥';

  @override
  String get keyImportPassphraseField => '密码短语（可选）';

  @override
  String get keyImportPassphraseHint => '如果密钥未加密请留空';

  @override
  String get keyImportPrivateKeyField => '私钥';

  @override
  String get keyImportFromFile => '从文件';

  @override
  String get keyImportPaste => '粘贴';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\nor PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      '支持的格式：OpenSSH、PEM、PuTTY PPK（RSA、Ed25519、ECDSA）。您的私钥安全存储在平台钥匙串中，绝不会离开此设备。';

  @override
  String keyImportFailedToReadFile(String error) {
    return '读取文件失败：$error';
  }

  @override
  String get keyImportClipboardEmpty => '剪贴板为空';

  @override
  String get keyImportPasteOrSelectKey => '请粘贴或选择私钥';

  @override
  String keyImportSuccess(String fingerprint) {
    return '密钥已导入：$fingerprint';
  }

  @override
  String get terminalNoActiveSessions => '没有活跃会话';

  @override
  String get terminalQuickConnect => '快速连接';

  @override
  String get terminalRecentHostsHeader => '最近主机';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  新建主机  ·  ⌘⇧N  快速连接  ·  ⌘K  搜索';

  @override
  String get terminalMobileShortcutHint => '点击 + 连接到主机';

  @override
  String terminalConnectingToHost(String label) {
    return '正在连接到 $label...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return '正在重连... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => '取消';

  @override
  String get terminalConnectionLost => '连接已断开';

  @override
  String get terminalSearchHint => '搜索终端...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => '关闭 (Esc)';

  @override
  String get terminalConnectionInfoTitle => '连接信息';

  @override
  String get terminalStatusReconnecting => '正在重连...';

  @override
  String get terminalStatusConnected => '已连接';

  @override
  String get terminalStatusDisconnected => '已断开';

  @override
  String get terminalInfoLabelHost => '主机';

  @override
  String get terminalInfoLabelAddress => '地址';

  @override
  String get terminalInfoLabelUsername => '用户名';

  @override
  String get terminalInfoLabelProxyJump => '代理跳转';

  @override
  String get terminalInfoValueProxyJump => '通过跳板机';

  @override
  String get terminalInfoLabelUptime => '运行时间';

  @override
  String get terminalInfoLabelConnectedAt => '连接时间';

  @override
  String get terminalInfoLabelSessionId => '会话 ID';

  @override
  String get terminalInfoLabelSplit => '分屏';

  @override
  String get terminalInfoValueSplitHorizontal => '水平（2个窗格）';

  @override
  String get terminalInfoValueSplitVertical => '垂直（2个窗格）';

  @override
  String get terminalInfoLabelLogging => '日志记录';

  @override
  String get terminalInfoValueLoggingActive => '活跃';

  @override
  String get terminalStatusBarDefaultDuration => '0:00';

  @override
  String get terminalStatusBarLogActive => '日志';

  @override
  String get terminalStatusBarLogInactive => '日志';

  @override
  String get terminalBroadcastOnTooltip => '广播已开启 — 点击切换，长按查看选项';

  @override
  String get terminalBroadcastOffTooltip => '广播已关闭 — 点击切换，长按查看选项';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return '广播 ($count)';
  }

  @override
  String get terminalBroadcastCastActive => '广播';

  @override
  String get terminalBroadcastCastInactive => '广播';

  @override
  String get terminalHeaderBackTooltip => '返回';

  @override
  String get terminalHeaderNewConnectionTooltip => '新建连接';

  @override
  String get terminalHeaderSnippetsTooltip => '代码片段';

  @override
  String get terminalHeaderCopyTooltip => '复制选中内容';

  @override
  String get terminalHeaderPasteTooltip => '粘贴';

  @override
  String get terminalHeaderNewTabTooltip => '新建标签页';

  @override
  String get extraKeyEsc => 'ESC';

  @override
  String get extraKeyTab => 'TAB';

  @override
  String get extraKeyCtl => 'CTL';

  @override
  String get extraKeyAlt => 'ALT';

  @override
  String get extraKeyBksp => 'BKSP';

  @override
  String get broadcastPanelTitle => '广播输入';

  @override
  String get broadcastPanelDisable => '禁用';

  @override
  String get broadcastPanelDescription => '选择接收您键盘输入的终端。';

  @override
  String get broadcastPanelBroadcastToAll => '广播到全部';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count 个已连接会话';
  }

  @override
  String get broadcastPanelActiveLabel => '活跃';

  @override
  String get broadcastPanelTabConnected => '已连接';

  @override
  String get broadcastPanelTabDisconnected => '已断开';

  @override
  String get snippetsTitle => '代码片段';

  @override
  String get snippetsAddTooltip => '添加代码片段';

  @override
  String get snippetsEmptyTitle => '暂无代码片段';

  @override
  String get snippetsEmptySubtitle => '保存常用命令以便快速访问。';

  @override
  String get snippetsEmptyAction => '添加代码片段';

  @override
  String get snippetsSearchHint => '搜索代码片段...';

  @override
  String snippetsNoMatchQuery(String query) {
    return '没有匹配 \"$query\" 的代码片段';
  }

  @override
  String get snippetsLoadingMessage => '正在加载代码片段...';

  @override
  String get snippetsUncategorized => '未分类';

  @override
  String get snippetsHasVariables => '包含变量';

  @override
  String get snippetsCopyCommandTooltip => '复制命令';

  @override
  String get snippetsMenuEdit => '编辑';

  @override
  String get snippetsMenuDelete => '删除';

  @override
  String get snippetsCopiedMessage => '命令已复制（30秒后自动清除）';

  @override
  String get snippetsDeleteDialogTitle => '删除代码片段';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return '确定要删除 \"$name\" 吗？';
  }

  @override
  String get snippetDetailNotFound => '未找到代码片段';

  @override
  String get snippetDetailLoading => '正在加载代码片段...';

  @override
  String get snippetDetailEditTooltip => '编辑';

  @override
  String get snippetDetailDeleteTooltip => '删除';

  @override
  String get snippetDetailSectionCommand => '命令';

  @override
  String get snippetDetailCopyCommandTooltip => '复制命令';

  @override
  String get snippetDetailSectionVariables => '变量';

  @override
  String get snippetDetailSectionDescription => '描述';

  @override
  String get snippetDetailSectionDetails => '详情';

  @override
  String get snippetDetailLabelCreated => '创建时间';

  @override
  String get snippetDetailLabelUpdated => '更新时间';

  @override
  String get snippetDetailCopiedMessage => '命令已复制（30秒后自动清除）';

  @override
  String get snippetFormTitleEdit => '编辑代码片段';

  @override
  String get snippetFormTitleNew => '新建代码片段';

  @override
  String get snippetFormNameLabel => '片段名称';

  @override
  String get snippetFormNameHint => '例如：检查磁盘空间';

  @override
  String get snippetFormNameRequired => '名称为必填项';

  @override
  String get snippetFormCommandLabel => '命令';

  @override
  String get snippetFormCommandHint => '例如：df -h\n使用双花括号变量作为占位符';

  @override
  String get snippetFormCommandRequired => '命令为必填项';

  @override
  String get snippetFormVariablesLabel => '变量：';

  @override
  String get snippetFormCategoryLabel => '分类（可选）';

  @override
  String get snippetFormCategoryHint => '例如：系统、Docker、网络';

  @override
  String get snippetFormDescriptionLabel => '描述（可选）';

  @override
  String get snippetFormDescriptionHint => '这个命令的作用是什么？';

  @override
  String get snippetFormSaveButtonEdit => '更新代码片段';

  @override
  String get snippetFormSaveButtonNew => '创建代码片段';

  @override
  String snippetFormSaveError(String error) {
    return '保存代码片段失败：$error';
  }

  @override
  String get snippetPickerSearchHint => '搜索代码片段...';

  @override
  String get snippetPickerEmptyMessage => '暂无代码片段。请从代码片段页面创建一个。';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return '没有匹配 \"$query\" 的代码片段';
  }

  @override
  String get snippetPickerLoadingError => '加载代码片段失败';

  @override
  String get snippetPickerVariableDialogTitle => '填写变量';

  @override
  String snippetPickerVariableHint(String variable) {
    return '输入 $variable 的值';
  }

  @override
  String get snippetPickerVariableInsert => '插入';

  @override
  String get sftpSelectHostHint => '选择主机...';

  @override
  String get sftpConnecting => '正在连接...';

  @override
  String get sftpUploadLabel => '上传';

  @override
  String get sftpDownloadLabel => '下载';

  @override
  String get sftpNoSavedHostsTitle => '暂无已保存的主机';

  @override
  String get sftpNoSavedHostsSubtitle => '请先添加主机，然后再回来传输文件。';

  @override
  String get sftpFailedToLoadHosts => '加载主机失败';

  @override
  String sftpFailedToConnect(String error) {
    return '连接失败：$error';
  }

  @override
  String get sftpConnectToHostFirst => '请先连接到主机';

  @override
  String get sftpDropFilesToUpload => '拖放文件以上传';

  @override
  String get sftpTabLocal => '本地';

  @override
  String get sftpTabRemote => '远程';

  @override
  String get sftpPaneHeaderLocal => '本地';

  @override
  String get sftpPaneHeaderRemote => '远程';

  @override
  String get sftpLocalPermissionDenied => '权限被拒绝';

  @override
  String get sftpLocalEmptyFolder => '空文件夹';

  @override
  String get sftpLocalCannotOpenFolder => '无法打开文件夹';

  @override
  String get sftpRemoteSelectHost => '选择要浏览的主机';

  @override
  String get sftpRemoteSelectHostSubtitle => '使用上方的下拉菜单选择已连接的服务器';

  @override
  String get sftpRemoteEmptyDirectory => '空目录';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return '无法打开文件夹：$message';
  }

  @override
  String get sftpRemoteReadOnly => '只读';

  @override
  String get sftpRemoteNewFolderTooltip => '新建文件夹';

  @override
  String get sftpHideHiddenFiles => '隐藏隐藏文件';

  @override
  String get sftpShowHiddenFiles => '显示隐藏文件';

  @override
  String get sftpGoUp => '返回上级';

  @override
  String get sftpNewFolderDialogTitle => '新建文件夹';

  @override
  String get sftpNewFolderDialogLabel => '文件夹名称';

  @override
  String get sftpNewFolderDialogHint => '例如：new-folder';

  @override
  String get sftpNewFolderDialogCreate => '创建';

  @override
  String get sftpFileMenuEdit => '编辑';

  @override
  String get sftpFileMenuPermissions => '权限';

  @override
  String get sftpFileMenuDelete => '删除';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return '权限 — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => '八进制：';

  @override
  String get sftpPermissionsLabelUser => '用户';

  @override
  String get sftpPermissionsLabelGroup => '用户组';

  @override
  String get sftpPermissionsLabelOther => '其他';

  @override
  String get sftpPermissionsBitRead => '读取';

  @override
  String get sftpPermissionsBitWrite => '写入';

  @override
  String get sftpPermissionsBitExec => '执行';

  @override
  String get sftpPermissionsApply => '应用';

  @override
  String get sftpTransfersHeader => '传输';

  @override
  String get sftpTransfersClearDone => '清除已完成';

  @override
  String get sftpTransferStatusDone => '完成';

  @override
  String get sftpTransferStatusFailed => '失败';

  @override
  String get remoteEditorSaveTooltip => '保存';

  @override
  String get remoteEditorFileSaved => '文件已保存';

  @override
  String remoteEditorFailedToSave(String error) {
    return '保存失败：$error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle => '未保存的更改';

  @override
  String get remoteEditorUnsavedChangesMessage => '您有未保存的更改。要丢弃吗？';

  @override
  String get remoteEditorDiscard => '丢弃';

  @override
  String get remoteEditorFailedToLoadFile => '加载文件失败';

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionAppearance => '外观';

  @override
  String get sectionConnection => '连接';

  @override
  String get sectionNotifications => '通知';

  @override
  String get sectionSecurity => '安全';

  @override
  String get sectionTools => '工具';

  @override
  String get sectionData => '数据';

  @override
  String get sectionCloudImport => '云端导入';

  @override
  String get sectionSync => '同步';

  @override
  String get sectionAbout => '关于';

  @override
  String get settingThemeTitle => '主题';

  @override
  String get themeModeDark => '深色';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get settingTerminalThemeTitle => '终端主题';

  @override
  String get settingFontFamilyTitle => '字体';

  @override
  String get settingFontSizeTitle => '字体大小';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => '光标样式';

  @override
  String get cursorStyleBlock => '方块';

  @override
  String get cursorStyleUnderline => '下划线';

  @override
  String get cursorStyleVerticalBar => '竖线';

  @override
  String get settingFontLigaturesTitle => '字体连字';

  @override
  String get settingFontLigaturesEnabled => '已启用（例如：=> 变为 ⇒）';

  @override
  String get settingFontLigaturesDisabled => '已禁用';

  @override
  String get settingLanguageTitle => '语言';

  @override
  String get settingDefaultSshPortTitle => '默认 SSH 端口';

  @override
  String get settingConnectionTimeoutTitle => '连接超时';

  @override
  String get settingKeepAliveTitle => '保活间隔';

  @override
  String get dialogDefaultSshPort => '默认 SSH 端口';

  @override
  String get dialogConnectionTimeout => '连接超时（秒）';

  @override
  String get dialogKeepAliveInterval => '保活间隔（秒）';

  @override
  String settingTimeoutSuffix(String value) {
    return '$value秒';
  }

  @override
  String get settingCommandCompletionSoundTitle => '命令完成提示音';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return '命令运行超过 $threshold 秒时提醒';
  }

  @override
  String get settingNotificationThresholdTitle => '通知阈值';

  @override
  String get dialogNotificationThreshold => '通知阈值（秒）';

  @override
  String get settingKnownHostsTitle => '已知主机';

  @override
  String get settingKnownHostsSubtitle => '管理受信任的 SSH 主机密钥';

  @override
  String get settingWorkspacesTitle => '工作区';

  @override
  String get settingWorkspacesSubtitle => '保存和恢复标签页布局';

  @override
  String get settingPasswordGeneratorTitle => '密码生成器';

  @override
  String get settingPasswordGeneratorSubtitle => '生成安全密码';

  @override
  String get settingSessionLogsTitle => '会话日志';

  @override
  String get settingSessionLogsSubtitle => '查看终端会话记录';

  @override
  String get settingImportSshConfigTitle => '导入 SSH 配置';

  @override
  String get settingImportSshConfigSubtitle => '从 ~/.ssh/config 导入主机';

  @override
  String get settingExportDataTitle => '导出数据';

  @override
  String get settingExportDataSubtitle => '备份主机、代码片段和设置';

  @override
  String get settingImportDataTitle => '导入数据';

  @override
  String get settingImportDataSubtitle => '从备份文件恢复';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle => '从 Amazon Web Services 导入实例';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle => '从 DigitalOcean 导入 Droplet';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return '版本 $version';
  }

  @override
  String get settingPrivacyPolicyTitle => '隐私政策';

  @override
  String get settingPrivacyPolicySubtitle => '您的数据如何被处理';

  @override
  String get settingTermsOfServiceTitle => '服务条款';

  @override
  String get settingTermsOfServiceSubtitle => '使用条款和条件';

  @override
  String get themePickerTitle => '主题';

  @override
  String get terminalThemePickerTitle => '终端主题';

  @override
  String get terminalThemeCustomThemesHeader => '自定义主题';

  @override
  String get terminalThemeBuiltInThemesHeader => '内置主题';

  @override
  String get terminalThemeNewTheme => '新建主题';

  @override
  String get terminalThemeEditTooltip => '编辑';

  @override
  String get terminalThemeDeleteTooltip => '删除';

  @override
  String get fontSizePickerTitle => '终端字体大小';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => '重置';

  @override
  String get fontFamilyPickerTitle => '字体';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => '光标样式';

  @override
  String get numberInputInvalidNumber => '请输入有效数字';

  @override
  String numberInputRangeError(String min, String max) {
    return '必须在 $min 到 $max 之间';
  }

  @override
  String get exportDataTitle => '导出数据';

  @override
  String get exportDataMessage =>
      '选择导出类型：\n\n明文导出包含主机、代码片段和设置。不包含私钥。\n\n加密保险库备份包含所有内容 — 主机、密钥、密码和设置 — 使用您选择的密码进行保护。';

  @override
  String get exportDataPlaintext => '明文';

  @override
  String get exportDataEncryptedVault => '加密保险库';

  @override
  String get exportDataExporting => '正在导出数据...';

  @override
  String get exportDataEncrypting => '正在加密并导出...';

  @override
  String exportedToFile(String filename) {
    return '已导出到：$filename';
  }

  @override
  String exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return '保险库已导出到：$filename';
  }

  @override
  String get importDataFileDialogTitle => '选择 CloudShell 备份';

  @override
  String get importDataPlaintextTitle => '导入明文备份';

  @override
  String get importDataPlaintextMessage =>
      '导入将合并备份文件中的数据。\n\n现有记录将被更新，新记录将被添加。\n\n注意：明文备份不包含 SSH 私钥。';

  @override
  String get importDataPlaintextImport => '导入';

  @override
  String get importDataDecryptTitle => '解密保险库备份';

  @override
  String get importDataDecryptMessage => '输入创建此备份时使用的密码。';

  @override
  String get importDataDecryptConfirmLabel => '解密并导入';

  @override
  String get importDataDecrypting => '正在解密并导入...';

  @override
  String importFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get encryptedExportTitle => '加密导出';

  @override
  String get encryptedExportMessage => '选择一个强密码来加密您的保险库备份。恢复备份时需要此密码。';

  @override
  String get encryptedExportConfirmLabel => '导出';

  @override
  String get passwordDialogLabelPassword => '密码';

  @override
  String get passwordDialogLabelConfirmPassword => '确认密码';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch => '密码不匹配';

  @override
  String passwordMinLength(String minLength) {
    return '最少 $minLength 个字符';
  }

  @override
  String get biometricUnlockTitle => '生物识别解锁';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => '生物识别';

  @override
  String get biometricNotAvailable => '此设备不支持生物识别认证。';

  @override
  String get vaultEncryptionTitle => '加密';

  @override
  String get vaultNotConfiguredSubtitle => '未配置 — 登录以启用';

  @override
  String get vaultEncryptedUnlockedSubtitle => '已加密并解锁';

  @override
  String get vaultLockedSubtitle => '保险库已锁定';

  @override
  String get vaultMasterPasswordTitle => '主密码';

  @override
  String get vaultLoadingSubtitle => '加载中...';

  @override
  String get vaultErrorSubtitle => '加载保险库状态时出错';

  @override
  String get vaultEncryptionEnabled => '保险库加密已启用';

  @override
  String get vaultDialogTitle => '保险库';

  @override
  String get vaultLockNow => '立即锁定保险库';

  @override
  String get vaultLocked => '保险库已锁定';

  @override
  String get vaultChangePassword => '更改密码';

  @override
  String get changePasswordTitle => '更改密码';

  @override
  String get changePasswordCurrentLabel => '当前密码';

  @override
  String get changePasswordNewLabel => '新密码';

  @override
  String get changePasswordConfirmLabel => '确认新密码';

  @override
  String get changePasswordSubmit => '更改';

  @override
  String get changePasswordMismatch => '密码不匹配';

  @override
  String get changePasswordMinLength => '最少需要10个字符';

  @override
  String get changePasswordSuccess => '主密码已成功更改';

  @override
  String get autoLockTitle => '自动锁定';

  @override
  String get autoLockSetUpVaultFirst => '请先设置保险库';

  @override
  String get autoLockDialogTitle => '自动锁定超时';

  @override
  String get autoLockTimeoutNever => '从不';

  @override
  String get autoLockTimeout1Min => '1分钟';

  @override
  String get autoLockTimeout5Min => '5分钟';

  @override
  String get autoLockTimeout15Min => '15分钟';

  @override
  String get autoLockTimeout30Min => '30分钟';

  @override
  String get autoLockTimeout1Hour => '1小时';

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
  String get syncAccountTitle => '账户';

  @override
  String get syncSignedInDefault => '已登录';

  @override
  String get syncLocalOnlyTitle => '仅本地';

  @override
  String get syncLocalOnlySubtitle => '升级以跨设备同步';

  @override
  String get syncCloudSyncTitle => '云端同步';

  @override
  String get syncCloudSyncSubtitle => '登录以跨设备同步';

  @override
  String get accountDialogTitle => '账户';

  @override
  String get accountSignOut => '退出登录';

  @override
  String get accountSignedOut => '已退出登录';

  @override
  String get accountDeleteAccount => '删除账户';

  @override
  String get deleteAccountTitle => '删除账户';

  @override
  String get deleteAccountWarning => '此操作无法撤销。';

  @override
  String get deleteAccountWillDelete => '这将永久删除：';

  @override
  String get deleteAccountItemAccount => '  • 您的账户和登录信息';

  @override
  String get deleteAccountItemSyncedData => '  • 服务器上所有同步的数据';

  @override
  String get deleteAccountItemVault => '  • 加密保险库配置';

  @override
  String get deleteAccountLocalDataNote => '本地数据（主机、密钥、设置）将保留在此设备上。';

  @override
  String get deleteAccountConfirmPrompt => '输入 DELETE 以确认：';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => '删除账户';

  @override
  String get deleteAccountDeleting => '正在删除账户...';

  @override
  String get deleteAccountFailedDefault => '删除账户失败';

  @override
  String get deleteAccountSuccess => '账户已删除。本地数据已保留。';

  @override
  String get syncAutoSyncTitle => '自动同步';

  @override
  String get syncUnlockVault => '解锁保险库以启用同步';

  @override
  String get syncEvery5Minutes => '每5分钟同步一次';

  @override
  String get syncDisabled => '同步已禁用';

  @override
  String get syncNeverSynced => '从未同步';

  @override
  String get syncJustNow => '刚刚';

  @override
  String get syncNowTitle => '立即同步';

  @override
  String get syncSyncing => '正在同步...';

  @override
  String syncResult(int pulled, int pushed) {
    return '已同步：拉取 $pulled 项，推送 $pushed 项';
  }

  @override
  String syncFailed(String error) {
    return '同步失败：$error';
  }

  @override
  String get totp2faTitle => '双因素认证';

  @override
  String get totpSignInToEnable => '登录以启用';

  @override
  String get totpEnabled => '已启用';

  @override
  String get totpNotConfigured => '未配置';

  @override
  String get totpDisable2faTitle => '禁用双因素认证？';

  @override
  String get totpDisable2faMessage => '这将从您的账户中移除双因素认证。您可以随时重新启用。';

  @override
  String get totpDisable2faSubmit => '禁用';

  @override
  String get totpDisabled => '双因素认证已禁用';

  @override
  String get knownHostsTitle => '已知主机';

  @override
  String get knownHostsEmptyTitle => '暂无已知主机';

  @override
  String get knownHostsEmptySubtitle => '首次连接服务器时，主机密钥指纹将保存在这里。';

  @override
  String get knownHostsSearchHint => '搜索已知主机...';

  @override
  String get knownHostsLoadingMessage => '正在加载已知主机...';

  @override
  String get knownHostsRemoveTitle => '移除已知主机';

  @override
  String get knownHostsRemoveConfirmLabel => '移除';

  @override
  String get knownHostsMenuRemove => '移除';

  @override
  String get knownHostsFirstSeen => '首次发现';

  @override
  String get knownHostsLastSeen => '最后发现';

  @override
  String knownHostsNoMatchQuery(String query) {
    return '没有匹配 \"$query\" 的主机';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return '移除对 $hostname:$port 的信任？\n\n下次连接时将要求您重新验证主机密钥。';
  }

  @override
  String get sessionLogsTitle => '会话日志';

  @override
  String get sessionLogsDeleteAllTooltip => '删除所有日志';

  @override
  String get sessionLogsEmpty => '暂无会话日志';

  @override
  String get sessionLogsEnableHint => '从终端菜单启用日志记录';

  @override
  String get sessionLogsView => '查看';

  @override
  String get sessionLogsShare => '分享';

  @override
  String get sessionLogsDelete => '删除';

  @override
  String get sessionLogsShareSubject => 'CloudShell 会话日志';

  @override
  String get sessionLogsDeleteAllTitle => '删除所有日志？';

  @override
  String get sessionLogsDeleteAllMessage => '这将永久删除所有会话日志文件。';

  @override
  String get sessionLogsDeleteAllConfirm => '全部删除';

  @override
  String get sessionLogsShareTooltip => '分享';

  @override
  String sessionLogsReadError(String error) {
    return '读取文件时出错：$error';
  }

  @override
  String get customThemeEditTitle => '编辑主题';

  @override
  String get customThemeNewTitle => '新建自定义主题';

  @override
  String get customThemeSave => '保存';

  @override
  String get customThemeNameLabel => '主题名称';

  @override
  String get customThemeNameHint => '例如：我的自定义主题';

  @override
  String get customThemeSectionTerminalChrome => '终端外观';

  @override
  String get customThemeSectionNormalColors => '普通颜色';

  @override
  String get customThemeSectionBrightColors => '明亮颜色';

  @override
  String get colorBackground => '背景';

  @override
  String get colorForeground => '前景';

  @override
  String get colorCursor => '光标';

  @override
  String get colorSelection => '选区';

  @override
  String get colorBlack => '黑色';

  @override
  String get colorRed => '红色';

  @override
  String get colorGreen => '绿色';

  @override
  String get colorYellow => '黄色';

  @override
  String get colorBlue => '蓝色';

  @override
  String get colorMagenta => '品红色';

  @override
  String get colorCyan => '青色';

  @override
  String get colorWhite => '白色';

  @override
  String get colorBrightBlack => '亮黑色';

  @override
  String get colorBrightRed => '亮红色';

  @override
  String get colorBrightGreen => '亮绿色';

  @override
  String get colorBrightYellow => '亮黄色';

  @override
  String get colorBrightBlue => '亮蓝色';

  @override
  String get colorBrightMagenta => '亮品红色';

  @override
  String get colorBrightCyan => '亮青色';

  @override
  String get colorBrightWhite => '亮白色';

  @override
  String get customThemePreviewTitle => '终端预览';

  @override
  String get customThemePreviewSelectedText => '选中文本预览';

  @override
  String get hexColorLabel => '十六进制颜色';

  @override
  String get hexColorPasteTooltip => '粘贴';

  @override
  String get hexColorInvalid => '无效的十六进制值';

  @override
  String get hexColorApply => '应用';

  @override
  String get customThemeNameRequired => '主题名称为必填项';

  @override
  String get sliderHue => '色相';

  @override
  String get sliderSaturation => '饱和度';

  @override
  String get sliderBrightness => '明度';

  @override
  String get sshConfigImportTitle => '导入 SSH 配置';

  @override
  String get sshConfigImportFailed => '读取 SSH 配置失败';

  @override
  String get sshConfigNoHostsFound => '未找到主机';

  @override
  String get sshConfigNoHostsFoundDetail => '在 ~/.ssh/config 中未找到有效的主机条目';

  @override
  String get sshConfigDeselectAll => '取消全选';

  @override
  String get sshConfigSelectAll => '全选';

  @override
  String get sshConfigImportKeys => '导入密钥';

  @override
  String sshConfigFoundHosts(int count) {
    return '在 ~/.ssh/config 中找到 $count 个主机';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return '已导入 $count 个主机和 $keys 个密钥';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return '导入失败：$error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return '导入 ($count)';
  }

  @override
  String get legalScreenLoadError => '加载文档失败';

  @override
  String get workspacesTitle => '工作区';

  @override
  String get workspacesSaveCurrent => '保存当前';

  @override
  String get workspacesEmptyTitle => '暂无已保存的工作区';

  @override
  String get workspacesEmptySubtitle => '您当前的标签页布局会自动保存。\n使用「保存当前」来创建命名工作区。';

  @override
  String workspacesLoadError(String error) {
    return '加载工作区失败：$error';
  }

  @override
  String get workspacesActiveBadge => '活跃';

  @override
  String get workspacesNoTerminals => '无终端';

  @override
  String get workspacesJustNow => '刚刚';

  @override
  String get workspacesMenuSwitchTo => '切换到';

  @override
  String get workspacesMenuRename => '重命名';

  @override
  String get workspacesMenuDelete => '删除';

  @override
  String get workspacesSaveTitle => '保存工作区';

  @override
  String get workspacesSaveHint => '工作区名称';

  @override
  String get workspacesSaveSave => '保存';

  @override
  String get workspacesRenameTitle => '重命名工作区';

  @override
  String get workspacesRenameHint => '新名称';

  @override
  String get workspacesRenameSubmit => '重命名';

  @override
  String get workspacesDeleteTitle => '删除工作区？';

  @override
  String get workspacesDeleteSubmit => '删除';

  @override
  String workspaceTerminalCount(int count) {
    return '$count 个终端';
  }

  @override
  String workspaceSaved(String name) {
    return '工作区 \"$name\" 已保存';
  }

  @override
  String workspaceSwitching(String name) {
    return '正在切换到 \"$name\"...';
  }

  @override
  String workspaceLoaded(String name) {
    return '工作区 \"$name\" 已加载';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return '删除 \"$name\"？此操作无法撤销。';
  }

  @override
  String get awsImportTitle => '从 AWS EC2 导入';

  @override
  String get awsConnectTitle => '连接到 AWS';

  @override
  String get awsConnectSubtitle => '输入您的 AWS 凭证以导入 EC2 实例。';

  @override
  String get awsAccessKeyIdLabel => '访问密钥 ID';

  @override
  String get awsAccessKeyIdHelper => '例如：AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => '秘密访问密钥';

  @override
  String get awsRegionLabel => '区域';

  @override
  String get awsCredentialsInfo =>
      '凭证仅用于此次导入，不会被存储。请使用仅具有 ec2:DescribeInstances 权限的 IAM 用户。';

  @override
  String get awsFetchInstances => '获取实例';

  @override
  String get awsFetchingInstances => '正在获取实例...';

  @override
  String get awsErrorAccessKeyRequired => '请输入您的 AWS 访问密钥 ID';

  @override
  String get awsErrorSecretKeyRequired => '请输入您的 AWS 秘密访问密钥';

  @override
  String get awsSelectInstances => '选择实例';

  @override
  String get awsRunningOnlyFilter => '仅运行中';

  @override
  String get awsNoRunningInstances => '未找到运行中的实例';

  @override
  String get awsNoInstances => '未找到实例';

  @override
  String get awsConfigureImport => '配置导入';

  @override
  String get awsDefaultUsernameLabel => '默认用户名';

  @override
  String get awsDefaultUsernameHelper => 'Amazon Linux：ec2-user，Ubuntu：ubuntu';

  @override
  String get awsInstancesToImport => '要导入的实例：';

  @override
  String get awsImporting => '正在导入...';

  @override
  String awsImportResult(int count) {
    return '已从 AWS EC2 导入 $count 个主机';
  }

  @override
  String awsImportHostsButton(int count) {
    return '导入 $count 个主机';
  }

  @override
  String awsNextButton(int count) {
    return '下一步 ($count)';
  }

  @override
  String get doImportTitle => '从 DigitalOcean 导入';

  @override
  String get doConnectTitle => '连接到 DigitalOcean';

  @override
  String get doConnectSubtitle => '输入您的 DigitalOcean 个人访问令牌以导入 Droplet。';

  @override
  String get doApiTokenLabel => 'API 令牌';

  @override
  String get doApiTokenHelper =>
      '在 cloud.digitalocean.com/account/api/tokens 生成';

  @override
  String get doTokenInfo => '您的令牌仅用于此次导入，不会被存储。';

  @override
  String get doFetchDroplets => '获取 Droplet';

  @override
  String get doFetchingDroplets => '正在获取 Droplet...';

  @override
  String get doErrorTokenRequired => '请输入您的 API 令牌';

  @override
  String get doSelectDroplets => '选择 Droplet';

  @override
  String get doActiveOnlyFilter => '仅活跃';

  @override
  String get doNoActiveDroplets => '未找到活跃的 Droplet';

  @override
  String get doNoDroplets => '未找到 Droplet';

  @override
  String get doConfigureImport => '配置导入';

  @override
  String get doDefaultUsernameLabel => '默认用户名';

  @override
  String get doDefaultUsernameHelper => '用于所有导入的主机（默认：root）';

  @override
  String get doHostsToImport => '要导入的主机：';

  @override
  String get doImporting => '正在导入...';

  @override
  String doImportResult(int count) {
    return '已从 DigitalOcean 导入 $count 个主机';
  }

  @override
  String doImportHostsButton(int count) {
    return '导入 $count 个主机';
  }

  @override
  String doNextButton(int count) {
    return '下一步 ($count)';
  }

  @override
  String get loginSubtitle => '登录以跨设备同步';

  @override
  String get loginEmailLabel => '电子邮件';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get loginErrorEmailRequired => '请输入您的电子邮件地址';

  @override
  String get loginErrorPasswordRequired => '请输入您的密码';

  @override
  String get loginSigningIn => '正在登录...';

  @override
  String get loginSignIn => '登录';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginCreateAccount => '创建账户';

  @override
  String get loginUseLocally => '无需账户，本地使用';

  @override
  String get signUpSubtitle => '创建您的账户';

  @override
  String get signUpEmailLabel => '电子邮件';

  @override
  String get signUpPasswordLabel => '密码（最少10个字符）';

  @override
  String get signUpConfirmPasswordLabel => '确认密码';

  @override
  String get passwordStrengthWeak => '弱';

  @override
  String get passwordStrengthFair => '一般';

  @override
  String get passwordStrengthGood => '良好';

  @override
  String get passwordStrengthStrong => '强';

  @override
  String get passwordStrengthExcellent => '极强';

  @override
  String get signUpErrorEmailRequired => '请输入您的电子邮件地址';

  @override
  String get signUpErrorPasswordRequired => '请输入密码';

  @override
  String get signUpErrorPasswordTooShort => '密码必须至少10个字符';

  @override
  String get signUpErrorPasswordMismatch => '密码不匹配';

  @override
  String get signUpErrorTermsRequired => '请接受服务条款';

  @override
  String get signUpEncryptionWarning => '您的数据采用端到端加密。如果您忘记密码，我们无法恢复您的账户。';

  @override
  String get signUpTermsPrefix => '我接受';

  @override
  String get signUpTermsOfService => '服务条款';

  @override
  String get signUpTermsAnd => '和';

  @override
  String get signUpPrivacyPolicy => '隐私政策';

  @override
  String get signUpCreatingAccount => '正在创建账户...';

  @override
  String get signUpCreateAccount => '创建账户';

  @override
  String get signUpAlreadyHaveAccount => '已有账户？';

  @override
  String get signUpSignIn => '登录';

  @override
  String get signUpEncryptionNote => '加密：Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => '重置密码';

  @override
  String get forgotPasswordInstructions => '输入与您账户关联的电子邮件，我们将发送密码重置链接。';

  @override
  String get forgotPasswordEmailLabel => '电子邮件';

  @override
  String get forgotPasswordSending => '正在发送...';

  @override
  String get forgotPasswordSendResetLink => '发送重置链接';

  @override
  String get forgotPasswordBackToSignIn => '返回登录';

  @override
  String get forgotPasswordErrorEmailRequired => '请输入您的电子邮件地址';

  @override
  String get forgotPasswordCheckEmail => '检查您的邮箱';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return '如果存在 $email 对应的账户，您将很快收到密码重置链接。';
  }

  @override
  String get forgotPasswordVaultWarning =>
      '请注意：我们使用零知识加密。如果您重置账户密码，您的保险库主密码不会改变。';

  @override
  String get forgotPasswordTryAgain => '没有收到？请重试';

  @override
  String get resetPasswordTitle => 'Set New Password';

  @override
  String get resetPasswordInstructions =>
      'Enter your new password below. This will also reset your encryption vault.';

  @override
  String get resetPasswordNewLabel => 'New Password';

  @override
  String get resetPasswordConfirmLabel => 'Confirm Password';

  @override
  String get resetPasswordSubmit => 'Set New Password';

  @override
  String get resetPasswordUpdating => 'Updating...';

  @override
  String get resetPasswordVaultWarning =>
      'Setting a new password will reset your encryption vault. Data encrypted with your old password cannot be recovered.';

  @override
  String get resetPasswordSuccess => 'Password updated successfully';

  @override
  String get resetPasswordMismatch => 'Passwords do not match';

  @override
  String get resetPasswordTooShort => 'Password must be at least 10 characters';

  @override
  String get totpSetupTitle => '设置双因素认证';

  @override
  String get totpSetupFailed => '设置双因素认证失败';

  @override
  String get totpSetupHeading => '双因素认证';

  @override
  String get totpSetupInstructions =>
      '使用您的认证器应用（Google Authenticator、Authy 等）扫描此二维码。';

  @override
  String get totpSetupManualEntryKey => '手动输入密钥';

  @override
  String get totpSetupSecretCopied => '密钥已复制';

  @override
  String get totpSetupEnterCode => '输入您应用中的6位验证码：';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => '正在验证...';

  @override
  String get totpSetupVerifyAndEnable => '验证并启用';

  @override
  String get totpSetupEnabled => '双因素认证已启用';

  @override
  String get totpSetupErrorCodeLength => '请输入6位验证码';

  @override
  String get totpSetupErrorInvalidCode => '验证码无效。请检查您的认证器应用并重试。';

  @override
  String get totpVerifyHeading => '双因素认证';

  @override
  String get totpVerifyInstructions => '输入您认证器应用中的6位验证码';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => '正在验证...';

  @override
  String get totpVerifySubmit => '验证';

  @override
  String get totpVerifyHelpText =>
      '打开您的认证器应用（Google Authenticator、Authy 等）以查找验证码。';

  @override
  String get totpVerifyErrorDefaultFailed => '验证失败';

  @override
  String get totpVerifyErrorInvalidCode => '验证码无效。请重试。';

  @override
  String get adaptiveScaffoldHosts => '主机';

  @override
  String get adaptiveScaffoldKeys => '密钥';

  @override
  String get adaptiveScaffoldSnippets => '代码片段';

  @override
  String get adaptiveScaffoldTerminal => '终端';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => '端口转发';

  @override
  String get adaptiveScaffoldSettings => '设置';

  @override
  String get commandPaletteHint => '搜索主机、代码片段，或输入命令...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return '没有 \"$query\" 的结果';
  }

  @override
  String get commandPaletteHostsHeader => '主机';

  @override
  String get commandPaletteSnippetsHeader => '代码片段';

  @override
  String get commandPaletteActionsHeader => '操作';

  @override
  String get commandPaletteActionNewHost => '新建主机';

  @override
  String get commandPaletteActionQuickConnect => '快速连接';

  @override
  String get commandPaletteActionSettings => '设置';

  @override
  String get commandPaletteActionToggleTheme => '切换主题';

  @override
  String get shortcutReferenceTitle => '键盘快捷键';

  @override
  String get shortcutCategoryGeneral => '通用';

  @override
  String get shortcutCategoryTerminal => '终端';

  @override
  String get shortcutCategoryNavigation => '导航';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => '解锁以继续';

  @override
  String get appLockUnlockButton => '解锁';

  @override
  String get appLockUnlockWithBiometrics => '使用生物识别解锁';

  @override
  String get appLockBiometricReason => '认证以解锁 CloudShell';

  @override
  String get appLockFailed => '认证失败';

  @override
  String get statusOnline => '在线';

  @override
  String get statusOffline => '离线';

  @override
  String get statusWarning => '警告';

  @override
  String get statusIdle => '空闲';

  @override
  String get vaultUnlockTitle => '解锁保险库';

  @override
  String get vaultUnlockSubtitle => '输入您的主密码以解锁保险库。';

  @override
  String get vaultUnlockPasswordLabel => '主密码';

  @override
  String get vaultUnlockPasswordHint => '输入主密码';

  @override
  String get vaultUnlockButton => '解锁';

  @override
  String get vaultUnlockUnlocking => '正在解锁...';

  @override
  String get vaultUnlockBiometricButton => '使用生物识别解锁';

  @override
  String get vaultUnlockForgotPassword => '忘记密码？';

  @override
  String get vaultUnlockResetTitle => '重置保险库？';

  @override
  String get vaultUnlockResetMessage =>
      '重置将删除所有加密数据（已保存的密码、私钥）。本地主机和设置将被保留。\n\n此操作无法撤销。';

  @override
  String get vaultUnlockResetConfirm => '重置保险库';

  @override
  String get vaultUnlockIncorrectPassword => '密码错误';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return '尝试次数过多。请在 $seconds 秒后重试。';
  }

  @override
  String get masterPasswordSetupTitle => '设置保险库';

  @override
  String get masterPasswordSetupSubtitle => '创建主密码以加密您的敏感数据。';

  @override
  String get masterPasswordSetupPasswordLabel => '主密码';

  @override
  String get masterPasswordSetupPasswordHint => '最少10个字符';

  @override
  String get masterPasswordSetupConfirmLabel => '确认密码';

  @override
  String get masterPasswordSetupConfirmHint => '再次输入主密码';

  @override
  String get masterPasswordSetupButton => '创建保险库';

  @override
  String get masterPasswordSetupCreating => '正在创建保险库...';

  @override
  String get masterPasswordSetupMinLength => '最少需要10个字符';

  @override
  String get masterPasswordSetupMismatch => '密码不匹配';

  @override
  String get masterPasswordSetupStrengthWeak => '弱';

  @override
  String get masterPasswordSetupStrengthFair => '一般';

  @override
  String get masterPasswordSetupStrengthGood => '良好';

  @override
  String get masterPasswordSetupStrengthStrong => '强';

  @override
  String get masterPasswordSetupWarning => '您的主密码无法恢复。请将其记下并妥善保管。';

  @override
  String get passwordGeneratorTitle => '密码生成器';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return '长度：$length';
  }

  @override
  String get passwordGeneratorUppercase => '大写字母 (A-Z)';

  @override
  String get passwordGeneratorLowercase => '小写字母 (a-z)';

  @override
  String get passwordGeneratorNumbers => '数字 (0-9)';

  @override
  String get passwordGeneratorSymbols => '符号 (!@#...)';

  @override
  String get passwordGeneratorGenerate => '生成';

  @override
  String get passwordGeneratorCopy => '复制';

  @override
  String get passwordGeneratorCopied => '密码已复制（30秒后自动清除）';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bits 位熵';
  }

  @override
  String get onboardingWelcomeTitle => '欢迎使用 CloudShell';

  @override
  String get onboardingWelcomeSubtitle => '一个现代化的跨平台 SSH 客户端';

  @override
  String get onboardingSecureTitle => '安全设计';

  @override
  String get onboardingSecureSubtitle => '采用 Argon2id + AES-256-GCM 的端到端加密保险库';

  @override
  String get onboardingTerminalTitle => '强大的终端';

  @override
  String get onboardingTerminalSubtitle => '分屏、标签页、主题、代码片段等';

  @override
  String get onboardingSyncTitle => '随处同步';

  @override
  String get onboardingSyncSubtitle => '您的主机、密钥和代码片段 — 在所有设备上';

  @override
  String get onboardingGetStarted => '开始使用';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get portForwardingTitle => '端口转发';

  @override
  String get portForwardingAddTooltip => '添加规则';

  @override
  String get portForwardingEmptyTitle => '暂无端口转发规则';

  @override
  String get portForwardingEmptySubtitle => '创建规则以通过 SSH 连接进行流量隧道。';

  @override
  String get portForwardingEmptyAction => '添加规则';

  @override
  String get portForwardingActiveHeader => '活跃';

  @override
  String get portForwardingSavedHeader => '已保存的规则';

  @override
  String get portForwardingTypeLocal => '本地';

  @override
  String get portForwardingTypeRemote => '远程';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => '停止';

  @override
  String get portForwardingStart => '启动';

  @override
  String get portForwardingMenuEdit => '编辑';

  @override
  String get portForwardingMenuDelete => '删除';

  @override
  String get portForwardingDeleteDialogTitle => '删除规则';

  @override
  String get portForwardingDeleteDialogMessage => '删除此端口转发规则？';

  @override
  String get portForwardingLoading => '正在加载端口转发规则...';

  @override
  String get portForwardFormTitleNew => '新建端口转发';

  @override
  String get portForwardFormTitleEdit => '编辑端口转发';

  @override
  String get portForwardFormLabelField => '标签';

  @override
  String get portForwardFormLabelHint => '例如：数据库隧道';

  @override
  String get portForwardFormTypeField => '类型';

  @override
  String get portForwardFormTypeLocal => '本地';

  @override
  String get portForwardFormTypeRemote => '远程';

  @override
  String get portForwardFormTypeDynamic => '动态 (SOCKS)';

  @override
  String get portForwardFormHostField => '主机';

  @override
  String get portForwardFormSelectHost => '选择主机';

  @override
  String get portForwardFormNoHostsAvailable => '没有可用的主机。请先创建主机。';

  @override
  String get portForwardFormCouldNotLoadHosts => '无法加载主机。';

  @override
  String get portForwardFormLocalPortField => '本地端口';

  @override
  String get portForwardFormRemotePortField => '远程端口';

  @override
  String get portForwardFormDestHostField => '目标主机';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => '目标端口';

  @override
  String get portForwardFormDestPortHint => '例如：5432';

  @override
  String get portForwardFormPortHint => '例如：8080';

  @override
  String get portForwardFormAutoStart => '连接时自动启动';

  @override
  String get portForwardFormAutoStartSubtitle => '连接到主机时自动启动此隧道。';

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
  String get languageSystem => '系统默认';
}
