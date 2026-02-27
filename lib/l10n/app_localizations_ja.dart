// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get confirm => '確認';

  @override
  String get close => '閉じる';

  @override
  String get retry => '再試行';

  @override
  String get back => '戻る';

  @override
  String get edit => '編集';

  @override
  String get done => '完了';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get search => '検索';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get togglePasswordVisibility => 'パスワードの表示切替';

  @override
  String get togglePassphraseVisibility => 'パスフレーズの表示切替';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get none => 'なし';

  @override
  String get unknown => '不明';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get hostsTitle => 'ホスト';

  @override
  String get hostsAddTooltip => 'ホストを追加';

  @override
  String get hostsSearchHint => 'ホストを検索...';

  @override
  String get hostsEmptyTitle => 'ホストがありません';

  @override
  String get hostsEmptySubtitle => '最初のSSHサーバーを追加して始めましょう。';

  @override
  String get hostsEmptyAction => 'ホストを追加';

  @override
  String hostsNoMatchQuery(String query) {
    return '「$query」に一致するホストはありません';
  }

  @override
  String get hostsLoadingMessage => 'ホストを読み込み中...';

  @override
  String get hostsRecentHeader => '最近';

  @override
  String get hostsGroupsHeader => 'グループ';

  @override
  String get hostsFavoritesHeader => 'お気に入り';

  @override
  String get hostsAllHostsHeader => 'すべてのホスト';

  @override
  String get hostsUngroupedHeader => '未分類';

  @override
  String get hostsDeleteDialogTitle => 'ホストを削除';

  @override
  String hostsDeleteDialogMessage(String name) {
    return '「$name」を削除してもよろしいですか？';
  }

  @override
  String get hostsMenuEdit => '編集';

  @override
  String get hostsMenuDelete => '削除';

  @override
  String get hostsMenuConnect => '接続';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return '最終接続 $time';
  }

  @override
  String get hostsNeverConnected => '未接続';

  @override
  String get hostsJustNow => 'たった今';

  @override
  String get hostFormTitleNew => '新しいホスト';

  @override
  String get hostFormTitleEdit => 'ホストを編集';

  @override
  String get hostFormSave => '保存';

  @override
  String get hostFormLabelField => 'ラベル';

  @override
  String get hostFormLabelHint => '例：本番サーバー';

  @override
  String get hostFormLabelRequired => 'ラベルは必須です';

  @override
  String get hostFormHostnameField => 'ホスト名';

  @override
  String get hostFormHostnameHint => '例：192.168.1.100 または example.com';

  @override
  String get hostFormHostnameRequired => 'ホスト名は必須です';

  @override
  String get hostFormPortField => 'ポート';

  @override
  String get hostFormUsernameField => 'ユーザー名';

  @override
  String get hostFormUsernameHint => '例：root';

  @override
  String get hostFormUsernameRequired => 'ユーザー名は必須です';

  @override
  String get hostFormPasswordField => 'パスワード';

  @override
  String get hostFormPasswordHint => 'パスワードを入力';

  @override
  String get hostFormAuthMethodField => '認証方式';

  @override
  String get hostFormAuthMethodKey => '鍵';

  @override
  String get hostFormAuthMethodPassword => 'パスワード';

  @override
  String get hostFormAuthMethodKeyAndPassword => '鍵 + パスワード';

  @override
  String get hostFormKeyField => 'SSH鍵';

  @override
  String get hostFormKeyNone => 'なし';

  @override
  String get hostFormGroupField => 'グループ';

  @override
  String get hostFormGroupNone => 'グループなし';

  @override
  String get hostFormTagsField => 'タグ';

  @override
  String get hostFormTagsHint => 'タグを追加（カンマ区切り）';

  @override
  String get hostFormAdvancedSection => '詳細設定';

  @override
  String get hostFormJumpHostField => '踏み台ホスト（プロキシ）';

  @override
  String get hostFormJumpHostNone => 'なし（直接接続）';

  @override
  String get hostFormKeepAliveField => 'Keep Alive（秒）';

  @override
  String get hostFormStartupCommandField => '起動コマンド';

  @override
  String get hostFormStartupCommandHint => '接続後に実行（任意）';

  @override
  String get hostFormNotesField => 'メモ';

  @override
  String get hostFormNotesHint => 'このホストに関するメモ（任意）';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => 'シリアル';

  @override
  String get hostFormSerialPortField => 'シリアルポート';

  @override
  String get hostFormSerialPortNone => 'ポートを選択';

  @override
  String get hostFormSerialNoPortsAvailable => '利用可能なシリアルポートがありません';

  @override
  String get hostFormSerialBaudRateField => 'ボーレート';

  @override
  String get hostFormSerialDataBitsField => 'データビット';

  @override
  String get hostFormSerialStopBitsField => 'ストップビット';

  @override
  String get hostFormSerialParityField => 'パリティ';

  @override
  String get hostFormSerialFlowControlField => 'フロー制御';

  @override
  String get hostFormTestConnection => '接続テスト';

  @override
  String get hostFormTestConnectionSuccess => '接続に成功しました！';

  @override
  String hostFormTestConnectionFailed(String error) {
    return '接続に失敗しました：$error';
  }

  @override
  String get hostDetailTitle => 'ホストの詳細';

  @override
  String get hostDetailConnect => '接続';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => '編集';

  @override
  String get hostDetailDeleteTooltip => '削除';

  @override
  String get hostDetailFavoriteTooltip => 'お気に入り';

  @override
  String get hostDetailSectionConnection => '接続';

  @override
  String get hostDetailSectionAuthentication => '認証';

  @override
  String get hostDetailSectionAdvanced => '詳細設定';

  @override
  String get hostDetailSectionTags => 'タグ';

  @override
  String get hostDetailSectionNotes => 'メモ';

  @override
  String get hostDetailLabelHostname => 'ホスト名';

  @override
  String get hostDetailLabelPort => 'ポート';

  @override
  String get hostDetailLabelUsername => 'ユーザー名';

  @override
  String get hostDetailLabelAuthMethod => '認証方式';

  @override
  String get hostDetailLabelKey => '鍵';

  @override
  String get hostDetailLabelGroup => 'グループ';

  @override
  String get hostDetailLabelJumpHost => '踏み台ホスト';

  @override
  String get hostDetailLabelKeepAlive => 'Keep Alive';

  @override
  String get hostDetailLabelStartupCommand => '起動コマンド';

  @override
  String get hostDetailLabelProtocol => 'プロトコル';

  @override
  String get hostDetailLabelCreated => '作成日';

  @override
  String get hostDetailLabelUpdated => '更新日';

  @override
  String get hostDetailLabelLastConnected => '最終接続';

  @override
  String get hostDetailNotFound => 'ホストが見つかりません';

  @override
  String get hostDetailLoading => 'ホストを読み込み中...';

  @override
  String get hostDetailDeleteDialogTitle => 'ホストを削除';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return '「$name」を削除してもよろしいですか？この操作は元に戻せません。';
  }

  @override
  String get quickConnectTitle => 'クイック接続';

  @override
  String get quickConnectHint => 'ユーザー@ホスト:ポート';

  @override
  String get quickConnectHelperText => '例：root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => 'ホストを保存';

  @override
  String get quickConnectConnect => '接続';

  @override
  String get quickConnectInvalidFormat =>
      '形式が無効です。ユーザー@ホスト または ユーザー@ホスト:ポート を使用してください';

  @override
  String get groupFormTitleNew => '新しいグループ';

  @override
  String get groupFormTitleEdit => 'グループを編集';

  @override
  String get groupFormNameField => 'グループ名';

  @override
  String get groupFormNameHint => '例：本番環境';

  @override
  String get groupFormNameRequired => 'グループ名は必須です';

  @override
  String get groupFormParentField => '親グループ';

  @override
  String get groupFormParentNone => 'なし（最上位）';

  @override
  String get groupFormDeleteDialogTitle => 'グループを削除';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return '「$name」を削除しますか？このグループのホストは未分類になります。';
  }

  @override
  String get hostKeyVerifyChangedTitle => 'ホスト鍵が変更されました';

  @override
  String get hostKeyVerifyUnknownTitle => '不明なホスト';

  @override
  String get hostKeyVerifyChangedWarning =>
      '警告：このサーバーのホスト鍵が変更されました。中間者攻撃の可能性があります。';

  @override
  String get hostKeyVerifyUnknownMessage =>
      'このホストの信頼性を確認できません。接続を続行してもよろしいですか？';

  @override
  String get hostKeyVerifyLabelHost => 'ホスト';

  @override
  String get hostKeyVerifyLabelKeyType => '鍵の種類';

  @override
  String get hostKeyVerifyLabelFingerprint => 'フィンガープリント：';

  @override
  String get hostKeyVerifyFingerprintCopied => 'フィンガープリントをコピーしました（30秒後に自動消去）';

  @override
  String get hostKeyVerifyTrustAnyway => 'それでも信頼する';

  @override
  String get hostKeyVerifyTrustAndConnect => '信頼して接続';

  @override
  String get keysTitle => 'SSH鍵';

  @override
  String get keysAddTooltip => '鍵をインポート';

  @override
  String get keysImportTooltip => '鍵をインポート';

  @override
  String get keysEmptyTitle => 'SSH鍵がありません';

  @override
  String get keysEmptySubtitle => 'SSH鍵をインポートしてサーバーに認証しましょう。';

  @override
  String get keysEmptyAction => '鍵をインポート';

  @override
  String get keysSearchHint => '鍵を検索...';

  @override
  String keysNoMatchQuery(String query) {
    return '「$query」に一致する鍵はありません';
  }

  @override
  String get keysLoadingMessage => '鍵を読み込み中...';

  @override
  String get keysDeleteDialogTitle => '鍵を削除';

  @override
  String keysDeleteDialogMessage(String name) {
    return '「$name」を削除しますか？この操作は元に戻せません。';
  }

  @override
  String get keysMenuDelete => '削除';

  @override
  String keysAssociatedHosts(int count) {
    return '$count個のホスト';
  }

  @override
  String get keyDetailTitle => '鍵の詳細';

  @override
  String get keyDetailEditTooltip => '編集';

  @override
  String get keyDetailDeleteTooltip => '削除';

  @override
  String get keyDetailSectionPublicKey => '公開鍵';

  @override
  String get keyDetailCopyPublicKey => '公開鍵をコピー';

  @override
  String get keyDetailSectionFingerprint => 'フィンガープリント';

  @override
  String get keyDetailSectionAssociatedHosts => '関連付けられたホスト';

  @override
  String get keyDetailSectionDetails => '詳細';

  @override
  String get keyDetailLabelType => '種類';

  @override
  String get keyDetailLabelBits => 'ビット数';

  @override
  String get keyDetailLabelCreated => '作成日';

  @override
  String get keyDetailNotFound => '鍵が見つかりません';

  @override
  String get keyDetailLoading => '鍵を読み込み中...';

  @override
  String get keyDetailPublicKeyCopied => '公開鍵をコピーしました（30秒後に自動消去）';

  @override
  String get keyDetailFingerprintCopied => 'フィンガープリントをコピーしました（30秒後に自動消去）';

  @override
  String get keyDetailNoAssociatedHosts => 'この鍵を使用しているホストはありません';

  @override
  String get keyImportTitle => 'SSH鍵をインポート';

  @override
  String get keyImportButton => 'インポート';

  @override
  String get keyImportButtonImporting => 'インポート中...';

  @override
  String get keyImportButtonImportKey => '鍵をインポート';

  @override
  String get keyImportLabelField => 'ラベル';

  @override
  String get keyImportLabelHint => '例：マイサーバー鍵';

  @override
  String get keyImportPassphraseField => 'パスフレーズ（任意）';

  @override
  String get keyImportPassphraseHint => '鍵が暗号化されていない場合は空欄のまま';

  @override
  String get keyImportPrivateKeyField => '秘密鍵';

  @override
  String get keyImportFromFile => 'ファイルから';

  @override
  String get keyImportPaste => '貼り付け';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\nまたは PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      '対応形式：OpenSSH、PEM、PuTTY PPK（RSA、Ed25519、ECDSA）。秘密鍵はプラットフォームのキーチェーンに安全に保存され、このデバイスの外に出ることはありません。';

  @override
  String keyImportFailedToReadFile(String error) {
    return 'ファイルの読み取りに失敗しました：$error';
  }

  @override
  String get keyImportClipboardEmpty => 'クリップボードが空です';

  @override
  String get keyImportPasteOrSelectKey => '秘密鍵を貼り付けるか選択してください';

  @override
  String keyImportSuccess(String fingerprint) {
    return '鍵をインポートしました：$fingerprint';
  }

  @override
  String get terminalNoActiveSessions => 'アクティブなセッションがありません';

  @override
  String get terminalQuickConnect => 'クイック接続';

  @override
  String get terminalRecentHostsHeader => '最近のホスト';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  新しいホスト  ·  ⌘⇧N  クイック接続  ·  ⌘K  検索';

  @override
  String get terminalMobileShortcutHint => '+ をタップしてホストに接続';

  @override
  String terminalConnectingToHost(String label) {
    return '$label に接続中...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return '再接続中... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => 'キャンセル';

  @override
  String get terminalConnectionLost => '接続が切断されました';

  @override
  String get terminalSearchHint => 'ターミナルを検索...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => '閉じる (Esc)';

  @override
  String get terminalConnectionInfoTitle => '接続情報';

  @override
  String get terminalStatusReconnecting => '再接続中...';

  @override
  String get terminalStatusConnected => '接続済み';

  @override
  String get terminalStatusDisconnected => '切断済み';

  @override
  String get terminalInfoLabelHost => 'ホスト';

  @override
  String get terminalInfoLabelAddress => 'アドレス';

  @override
  String get terminalInfoLabelUsername => 'ユーザー名';

  @override
  String get terminalInfoLabelProxyJump => 'プロキシジャンプ';

  @override
  String get terminalInfoValueProxyJump => '踏み台ホスト経由';

  @override
  String get terminalInfoLabelUptime => '稼働時間';

  @override
  String get terminalInfoLabelConnectedAt => '接続日時';

  @override
  String get terminalInfoLabelSessionId => 'セッションID';

  @override
  String get terminalInfoLabelSplit => '分割';

  @override
  String get terminalInfoValueSplitHorizontal => '水平（2ペイン）';

  @override
  String get terminalInfoValueSplitVertical => '垂直（2ペイン）';

  @override
  String get terminalInfoLabelLogging => 'ログ記録';

  @override
  String get terminalInfoValueLoggingActive => '有効';

  @override
  String get terminalStatusBarDefaultDuration => '0:00';

  @override
  String get terminalStatusBarLogActive => 'LOG';

  @override
  String get terminalStatusBarLogInactive => 'Log';

  @override
  String get terminalBroadcastOnTooltip => 'ブロードキャストON — タップで切り替え、長押しでオプション';

  @override
  String get terminalBroadcastOffTooltip => 'ブロードキャストOFF — タップで切り替え、長押しでオプション';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return 'CAST ($count)';
  }

  @override
  String get terminalBroadcastCastActive => 'CAST';

  @override
  String get terminalBroadcastCastInactive => 'Cast';

  @override
  String get terminalHeaderBackTooltip => '戻る';

  @override
  String get terminalHeaderNewConnectionTooltip => '新しい接続';

  @override
  String get terminalHeaderSnippetsTooltip => 'スニペット';

  @override
  String get terminalHeaderCopyTooltip => '選択範囲をコピー';

  @override
  String get terminalHeaderPasteTooltip => '貼り付け';

  @override
  String get terminalHeaderNewTabTooltip => '新しいタブ';

  @override
  String get extraKeyEsc => 'ESC';

  @override
  String get extraKeyTab => 'TAB';

  @override
  String get extraKeyCtl => 'CTL';

  @override
  String get extraKeyAlt => 'ALT';

  @override
  String get broadcastPanelTitle => '入力のブロードキャスト';

  @override
  String get broadcastPanelDisable => '無効にする';

  @override
  String get broadcastPanelDescription => 'キーボード入力を受信するターミナルを選択してください。';

  @override
  String get broadcastPanelBroadcastToAll => 'すべてにブロードキャスト';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count個の接続済みセッション';
  }

  @override
  String get broadcastPanelActiveLabel => 'アクティブ';

  @override
  String get broadcastPanelTabConnected => '接続済み';

  @override
  String get broadcastPanelTabDisconnected => '切断済み';

  @override
  String get snippetsTitle => 'スニペット';

  @override
  String get snippetsAddTooltip => 'スニペットを追加';

  @override
  String get snippetsEmptyTitle => 'スニペットがありません';

  @override
  String get snippetsEmptySubtitle => 'よく使うコマンドを保存して素早くアクセスできます。';

  @override
  String get snippetsEmptyAction => 'スニペットを追加';

  @override
  String get snippetsSearchHint => 'スニペットを検索...';

  @override
  String snippetsNoMatchQuery(String query) {
    return '「$query」に一致するスニペットはありません';
  }

  @override
  String get snippetsLoadingMessage => 'スニペットを読み込み中...';

  @override
  String get snippetsUncategorized => '未分類';

  @override
  String get snippetsHasVariables => '変数あり';

  @override
  String get snippetsCopyCommandTooltip => 'コマンドをコピー';

  @override
  String get snippetsMenuEdit => '編集';

  @override
  String get snippetsMenuDelete => '削除';

  @override
  String get snippetsCopiedMessage => 'コマンドをコピーしました（30秒後に自動消去）';

  @override
  String get snippetsDeleteDialogTitle => 'スニペットを削除';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return '「$name」を削除してもよろしいですか？';
  }

  @override
  String get snippetDetailNotFound => 'スニペットが見つかりません';

  @override
  String get snippetDetailLoading => 'スニペットを読み込み中...';

  @override
  String get snippetDetailEditTooltip => '編集';

  @override
  String get snippetDetailDeleteTooltip => '削除';

  @override
  String get snippetDetailSectionCommand => 'コマンド';

  @override
  String get snippetDetailCopyCommandTooltip => 'コマンドをコピー';

  @override
  String get snippetDetailSectionVariables => '変数';

  @override
  String get snippetDetailSectionDescription => '説明';

  @override
  String get snippetDetailSectionDetails => '詳細';

  @override
  String get snippetDetailLabelCreated => '作成日';

  @override
  String get snippetDetailLabelUpdated => '更新日';

  @override
  String get snippetDetailCopiedMessage => 'コマンドをコピーしました（30秒後に自動消去）';

  @override
  String get snippetFormTitleEdit => 'スニペットを編集';

  @override
  String get snippetFormTitleNew => '新しいスニペット';

  @override
  String get snippetFormNameLabel => 'スニペット名';

  @override
  String get snippetFormNameHint => '例：ディスク容量を確認';

  @override
  String get snippetFormNameRequired => '名前は必須です';

  @override
  String get snippetFormCommandLabel => 'コマンド';

  @override
  String get snippetFormCommandHint => '例：df -h\n二重中括弧の変数をプレースホルダーとして使用';

  @override
  String get snippetFormCommandRequired => 'コマンドは必須です';

  @override
  String get snippetFormVariablesLabel => '変数：';

  @override
  String get snippetFormCategoryLabel => 'カテゴリ（任意）';

  @override
  String get snippetFormCategoryHint => '例：システム、Docker、ネットワーク';

  @override
  String get snippetFormDescriptionLabel => '説明（任意）';

  @override
  String get snippetFormDescriptionHint => 'このコマンドは何をしますか？';

  @override
  String get snippetFormSaveButtonEdit => 'スニペットを更新';

  @override
  String get snippetFormSaveButtonNew => 'スニペットを作成';

  @override
  String snippetFormSaveError(String error) {
    return 'スニペットの保存に失敗しました：$error';
  }

  @override
  String get snippetPickerSearchHint => 'スニペットを検索...';

  @override
  String get snippetPickerEmptyMessage => 'スニペットがありません。スニペット画面から作成してください。';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return '「$query」に一致するスニペットはありません';
  }

  @override
  String get snippetPickerLoadingError => 'スニペットの読み込みに失敗しました';

  @override
  String get snippetPickerVariableDialogTitle => '変数を入力';

  @override
  String snippetPickerVariableHint(String variable) {
    return '$variable の値を入力';
  }

  @override
  String get snippetPickerVariableInsert => '挿入';

  @override
  String get sftpSelectHostHint => 'ホストを選択...';

  @override
  String get sftpConnecting => '接続中...';

  @override
  String get sftpUploadLabel => 'アップロード';

  @override
  String get sftpDownloadLabel => 'ダウンロード';

  @override
  String get sftpNoSavedHostsTitle => '保存済みホストがありません';

  @override
  String get sftpNoSavedHostsSubtitle => 'まずホストを追加してから、ファイル転送に戻ってください。';

  @override
  String get sftpFailedToLoadHosts => 'ホストの読み込みに失敗しました';

  @override
  String sftpFailedToConnect(String error) {
    return '接続に失敗しました：$error';
  }

  @override
  String get sftpConnectToHostFirst => 'まずホストに接続してください';

  @override
  String get sftpDropFilesToUpload => 'ファイルをドロップしてアップロード';

  @override
  String get sftpTabLocal => 'ローカル';

  @override
  String get sftpTabRemote => 'リモート';

  @override
  String get sftpPaneHeaderLocal => 'ローカル';

  @override
  String get sftpPaneHeaderRemote => 'リモート';

  @override
  String get sftpLocalPermissionDenied => 'アクセスが拒否されました';

  @override
  String get sftpLocalEmptyFolder => '空のフォルダ';

  @override
  String get sftpLocalCannotOpenFolder => 'フォルダを開けません';

  @override
  String get sftpRemoteSelectHost => '閲覧するホストを選択';

  @override
  String get sftpRemoteSelectHostSubtitle => '上のドロップダウンから接続済みサーバーを選択してください';

  @override
  String get sftpRemoteEmptyDirectory => '空のディレクトリ';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return 'フォルダを開けません：$message';
  }

  @override
  String get sftpRemoteReadOnly => '読み取り専用';

  @override
  String get sftpRemoteNewFolderTooltip => '新しいフォルダ';

  @override
  String get sftpHideHiddenFiles => '隠しファイルを非表示';

  @override
  String get sftpShowHiddenFiles => '隠しファイルを表示';

  @override
  String get sftpGoUp => '上へ移動';

  @override
  String get sftpNewFolderDialogTitle => '新しいフォルダ';

  @override
  String get sftpNewFolderDialogLabel => 'フォルダ名';

  @override
  String get sftpNewFolderDialogHint => '例：new-folder';

  @override
  String get sftpNewFolderDialogCreate => '作成';

  @override
  String get sftpFileMenuEdit => '編集';

  @override
  String get sftpFileMenuPermissions => 'パーミッション';

  @override
  String get sftpFileMenuDelete => '削除';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return 'パーミッション — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => '8進数：';

  @override
  String get sftpPermissionsLabelUser => 'ユーザー';

  @override
  String get sftpPermissionsLabelGroup => 'グループ';

  @override
  String get sftpPermissionsLabelOther => 'その他';

  @override
  String get sftpPermissionsBitRead => '読み取り';

  @override
  String get sftpPermissionsBitWrite => '書き込み';

  @override
  String get sftpPermissionsBitExec => '実行';

  @override
  String get sftpPermissionsApply => '適用';

  @override
  String get sftpTransfersHeader => '転送';

  @override
  String get sftpTransfersClearDone => '完了を消去';

  @override
  String get sftpTransferStatusDone => '完了';

  @override
  String get sftpTransferStatusFailed => '失敗';

  @override
  String get remoteEditorSaveTooltip => '保存';

  @override
  String get remoteEditorFileSaved => 'ファイルを保存しました';

  @override
  String remoteEditorFailedToSave(String error) {
    return '保存に失敗しました：$error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle => '未保存の変更';

  @override
  String get remoteEditorUnsavedChangesMessage => '未保存の変更があります。破棄しますか？';

  @override
  String get remoteEditorDiscard => '破棄';

  @override
  String get remoteEditorFailedToLoadFile => 'ファイルの読み込みに失敗しました';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionAppearance => '外観';

  @override
  String get sectionConnection => '接続';

  @override
  String get sectionNotifications => '通知';

  @override
  String get sectionSecurity => 'セキュリティ';

  @override
  String get sectionTools => 'ツール';

  @override
  String get sectionData => 'データ';

  @override
  String get sectionCloudImport => 'クラウドインポート';

  @override
  String get sectionSync => '同期';

  @override
  String get sectionAbout => 'アプリについて';

  @override
  String get settingThemeTitle => 'テーマ';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeSystem => 'システム';

  @override
  String get settingTerminalThemeTitle => 'ターミナルテーマ';

  @override
  String get settingFontFamilyTitle => 'フォントファミリー';

  @override
  String get settingFontSizeTitle => 'フォントサイズ';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => 'カーソルスタイル';

  @override
  String get cursorStyleBlock => 'ブロック';

  @override
  String get cursorStyleUnderline => 'アンダーライン';

  @override
  String get cursorStyleVerticalBar => '縦棒';

  @override
  String get settingFontLigaturesTitle => 'フォントリガチャ';

  @override
  String get settingFontLigaturesEnabled => '有効（例：=> が ⇒ になります）';

  @override
  String get settingFontLigaturesDisabled => '無効';

  @override
  String get settingLanguageTitle => '言語';

  @override
  String get settingDefaultSshPortTitle => 'デフォルトSSHポート';

  @override
  String get settingConnectionTimeoutTitle => '接続タイムアウト';

  @override
  String get settingKeepAliveTitle => 'Keep Alive間隔';

  @override
  String get dialogDefaultSshPort => 'デフォルトSSHポート';

  @override
  String get dialogConnectionTimeout => '接続タイムアウト（秒）';

  @override
  String get dialogKeepAliveInterval => 'Keep Alive間隔（秒）';

  @override
  String settingTimeoutSuffix(String value) {
    return '$value秒';
  }

  @override
  String get settingCommandCompletionSoundTitle => 'コマンド完了サウンド';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return 'コマンドが$threshold秒以上かかった場合に通知';
  }

  @override
  String get settingNotificationThresholdTitle => '通知しきい値';

  @override
  String get dialogNotificationThreshold => '通知しきい値（秒）';

  @override
  String get settingKnownHostsTitle => '既知のホスト';

  @override
  String get settingKnownHostsSubtitle => '信頼済みSSHホスト鍵を管理';

  @override
  String get settingWorkspacesTitle => 'ワークスペース';

  @override
  String get settingWorkspacesSubtitle => 'タブレイアウトの保存と復元';

  @override
  String get settingPasswordGeneratorTitle => 'パスワード生成';

  @override
  String get settingPasswordGeneratorSubtitle => '安全なパスワードを生成';

  @override
  String get settingSessionLogsTitle => 'セッションログ';

  @override
  String get settingSessionLogsSubtitle => 'ターミナルセッションの記録を表示';

  @override
  String get settingImportSshConfigTitle => 'SSH設定をインポート';

  @override
  String get settingImportSshConfigSubtitle => '~/.ssh/config からホストをインポート';

  @override
  String get settingExportDataTitle => 'データをエクスポート';

  @override
  String get settingExportDataSubtitle => 'ホスト、スニペット、設定をバックアップ';

  @override
  String get settingImportDataTitle => 'データをインポート';

  @override
  String get settingImportDataSubtitle => 'バックアップファイルから復元';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle => 'Amazon Web Servicesからインスタンスをインポート';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle => 'DigitalOceanからドロップレットをインポート';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return 'バージョン $version';
  }

  @override
  String get settingPrivacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get settingPrivacyPolicySubtitle => 'データの取り扱いについて';

  @override
  String get settingTermsOfServiceTitle => '利用規約';

  @override
  String get settingTermsOfServiceSubtitle => '利用条件について';

  @override
  String get themePickerTitle => 'テーマ';

  @override
  String get terminalThemePickerTitle => 'ターミナルテーマ';

  @override
  String get terminalThemeCustomThemesHeader => 'カスタムテーマ';

  @override
  String get terminalThemeBuiltInThemesHeader => '組み込みテーマ';

  @override
  String get terminalThemeNewTheme => '新しいテーマ';

  @override
  String get terminalThemeEditTooltip => '編集';

  @override
  String get terminalThemeDeleteTooltip => '削除';

  @override
  String get fontSizePickerTitle => 'ターミナルのフォントサイズ';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => 'リセット';

  @override
  String get fontFamilyPickerTitle => 'フォントファミリー';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => 'カーソルスタイル';

  @override
  String get numberInputInvalidNumber => '有効な数値を入力してください';

  @override
  String numberInputRangeError(String min, String max) {
    return '$minから$maxの間で入力してください';
  }

  @override
  String get exportDataTitle => 'データをエクスポート';

  @override
  String get exportDataMessage =>
      'エクスポートの種類を選択してください：\n\nプレーンテキストはホスト、スニペット、設定をエクスポートします。秘密鍵は含まれません。\n\n暗号化ボールトバックアップはすべて（ホスト、鍵、パスワード、設定）を含み、お好みのパスワードで保護されます。';

  @override
  String get exportDataPlaintext => 'プレーンテキスト';

  @override
  String get exportDataEncryptedVault => '暗号化ボールト';

  @override
  String get exportDataExporting => 'データをエクスポート中...';

  @override
  String get exportDataEncrypting => '暗号化してエクスポート中...';

  @override
  String exportedToFile(String filename) {
    return 'エクスポート先：$filename';
  }

  @override
  String exportFailed(String error) {
    return 'エクスポートに失敗しました：$error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return 'ボールトのエクスポート先：$filename';
  }

  @override
  String get importDataFileDialogTitle => 'CloudShellバックアップを選択';

  @override
  String get importDataPlaintextTitle => 'プレーンテキストバックアップをインポート';

  @override
  String get importDataPlaintextMessage =>
      'インポートはバックアップファイルのデータをマージします。\n\n既存のレコードは更新され、新しいレコードが追加されます。\n\n注意：プレーンテキストバックアップにはSSH秘密鍵は含まれません。';

  @override
  String get importDataPlaintextImport => 'インポート';

  @override
  String get importDataDecryptTitle => 'ボールトバックアップを復号';

  @override
  String get importDataDecryptMessage => 'このバックアップ作成時に使用したパスワードを入力してください。';

  @override
  String get importDataDecryptConfirmLabel => '復号してインポート';

  @override
  String get importDataDecrypting => '復号してインポート中...';

  @override
  String importFailed(String error) {
    return 'インポートに失敗しました：$error';
  }

  @override
  String get encryptedExportTitle => '暗号化エクスポート';

  @override
  String get encryptedExportMessage =>
      'ボールトバックアップを暗号化するための強力なパスワードを選択してください。バックアップの復元にこのパスワードが必要です。';

  @override
  String get encryptedExportConfirmLabel => 'エクスポート';

  @override
  String get passwordDialogLabelPassword => 'パスワード';

  @override
  String get passwordDialogLabelConfirmPassword => 'パスワードを確認';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch => 'パスワードが一致しません';

  @override
  String passwordMinLength(String minLength) {
    return '最低$minLength文字';
  }

  @override
  String get biometricUnlockTitle => '生体認証ロック解除';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => '生体認証';

  @override
  String get biometricNotAvailable => 'このデバイスでは生体認証を利用できません。';

  @override
  String get vaultEncryptionTitle => '暗号化';

  @override
  String get vaultNotConfiguredSubtitle => '未設定 — サインインして有効化';

  @override
  String get vaultEncryptedUnlockedSubtitle => '暗号化済み・ロック解除済み';

  @override
  String get vaultLockedSubtitle => 'ボールトはロックされています';

  @override
  String get vaultMasterPasswordTitle => 'マスターパスワード';

  @override
  String get vaultLoadingSubtitle => '読み込み中...';

  @override
  String get vaultErrorSubtitle => 'ボールト状態の読み込みエラー';

  @override
  String get vaultEncryptionEnabled => 'ボールト暗号化が有効';

  @override
  String get vaultDialogTitle => 'ボールト';

  @override
  String get vaultLockNow => '今すぐボールトをロック';

  @override
  String get vaultLocked => 'ボールトがロックされました';

  @override
  String get vaultChangePassword => 'パスワードを変更';

  @override
  String get changePasswordTitle => 'パスワードを変更';

  @override
  String get changePasswordCurrentLabel => '現在のパスワード';

  @override
  String get changePasswordNewLabel => '新しいパスワード';

  @override
  String get changePasswordConfirmLabel => '新しいパスワードを確認';

  @override
  String get changePasswordSubmit => '変更';

  @override
  String get changePasswordMismatch => 'パスワードが一致しません';

  @override
  String get changePasswordMinLength => '最低10文字が必要です';

  @override
  String get changePasswordSuccess => 'マスターパスワードを変更しました';

  @override
  String get autoLockTitle => '自動ロック';

  @override
  String get autoLockSetUpVaultFirst => 'まずボールトを設定してください';

  @override
  String get autoLockDialogTitle => '自動ロックのタイムアウト';

  @override
  String get autoLockTimeoutNever => 'なし';

  @override
  String get autoLockTimeout1Min => '1分';

  @override
  String get autoLockTimeout5Min => '5分';

  @override
  String get autoLockTimeout15Min => '15分';

  @override
  String get autoLockTimeout30Min => '30分';

  @override
  String get autoLockTimeout1Hour => '1時間';

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
  String get syncAccountTitle => 'アカウント';

  @override
  String get syncSignedInDefault => 'サインイン済み';

  @override
  String get syncLocalOnlyTitle => 'ローカルのみ';

  @override
  String get syncLocalOnlySubtitle => 'デバイス間で同期するにはアップグレードしてください';

  @override
  String get syncCloudSyncTitle => 'クラウド同期';

  @override
  String get syncCloudSyncSubtitle => 'デバイス間で同期するにはサインインしてください';

  @override
  String get accountDialogTitle => 'アカウント';

  @override
  String get accountSignOut => 'サインアウト';

  @override
  String get accountSignedOut => 'サインアウトしました';

  @override
  String get accountDeleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountTitle => 'アカウントを削除';

  @override
  String get deleteAccountWarning => 'この操作は元に戻せません。';

  @override
  String get deleteAccountWillDelete => '以下が完全に削除されます：';

  @override
  String get deleteAccountItemAccount => '  • アカウントとログイン情報';

  @override
  String get deleteAccountItemSyncedData => '  • サーバー上のすべての同期データ';

  @override
  String get deleteAccountItemVault => '  • 暗号化ボールトの設定';

  @override
  String get deleteAccountLocalDataNote => 'ローカルデータ（ホスト、鍵、設定）はこのデバイスに残ります。';

  @override
  String get deleteAccountConfirmPrompt => '確認のため DELETE と入力してください：';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => 'アカウントを削除';

  @override
  String get deleteAccountDeleting => 'アカウントを削除中...';

  @override
  String get deleteAccountFailedDefault => 'アカウントの削除に失敗しました';

  @override
  String get deleteAccountSuccess => 'アカウントが削除されました。ローカルデータは保持されています。';

  @override
  String get syncAutoSyncTitle => '自動同期';

  @override
  String get syncUnlockVault => '同期を有効にするにはボールトのロックを解除してください';

  @override
  String get syncEvery5Minutes => '5分ごとに同期';

  @override
  String get syncDisabled => '同期は無効です';

  @override
  String get syncNeverSynced => '未同期';

  @override
  String get syncJustNow => 'たった今';

  @override
  String get syncNowTitle => '今すぐ同期';

  @override
  String get syncSyncing => '同期中...';

  @override
  String syncResult(int pulled, int pushed) {
    return '同期完了：$pulled件取得、$pushed件送信';
  }

  @override
  String syncFailed(String error) {
    return '同期に失敗しました：$error';
  }

  @override
  String get totp2faTitle => '2FA認証';

  @override
  String get totpSignInToEnable => 'サインインして有効化';

  @override
  String get totpEnabled => '有効';

  @override
  String get totpNotConfigured => '未設定';

  @override
  String get totpDisable2faTitle => '2FAを無効にしますか？';

  @override
  String get totpDisable2faMessage => 'アカウントから二要素認証が削除されます。いつでも再度有効にできます。';

  @override
  String get totpDisable2faSubmit => '無効にする';

  @override
  String get totpDisabled => '2FAが無効になりました';

  @override
  String get knownHostsTitle => '既知のホスト';

  @override
  String get knownHostsEmptyTitle => '既知のホストがありません';

  @override
  String get knownHostsEmptySubtitle =>
      '初めてサーバーに接続すると、ホスト鍵のフィンガープリントがここに保存されます。';

  @override
  String get knownHostsSearchHint => '既知のホストを検索...';

  @override
  String get knownHostsLoadingMessage => '既知のホストを読み込み中...';

  @override
  String get knownHostsRemoveTitle => '既知のホストを削除';

  @override
  String get knownHostsRemoveConfirmLabel => '削除';

  @override
  String get knownHostsMenuRemove => '削除';

  @override
  String get knownHostsFirstSeen => '初回確認';

  @override
  String get knownHostsLastSeen => '最終確認';

  @override
  String knownHostsNoMatchQuery(String query) {
    return '「$query」に一致するホストはありません';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return '$hostname:$port の信頼を削除しますか？\n\n次回の接続時にホスト鍵の確認が再度求められます。';
  }

  @override
  String get sessionLogsTitle => 'セッションログ';

  @override
  String get sessionLogsDeleteAllTooltip => 'すべてのログを削除';

  @override
  String get sessionLogsEmpty => 'セッションログがありません';

  @override
  String get sessionLogsEnableHint => 'ターミナルメニューからログ記録を有効にしてください';

  @override
  String get sessionLogsView => '表示';

  @override
  String get sessionLogsShare => '共有';

  @override
  String get sessionLogsDelete => '削除';

  @override
  String get sessionLogsShareSubject => 'CloudShellセッションログ';

  @override
  String get sessionLogsDeleteAllTitle => 'すべてのログを削除しますか？';

  @override
  String get sessionLogsDeleteAllMessage => 'すべてのセッションログファイルが完全に削除されます。';

  @override
  String get sessionLogsDeleteAllConfirm => 'すべて削除';

  @override
  String get sessionLogsShareTooltip => '共有';

  @override
  String sessionLogsReadError(String error) {
    return 'ファイルの読み取りエラー：$error';
  }

  @override
  String get customThemeEditTitle => 'テーマを編集';

  @override
  String get customThemeNewTitle => '新しいカスタムテーマ';

  @override
  String get customThemeSave => '保存';

  @override
  String get customThemeNameLabel => 'テーマ名';

  @override
  String get customThemeNameHint => '例：マイカスタムテーマ';

  @override
  String get customThemeSectionTerminalChrome => 'ターミナルクローム';

  @override
  String get customThemeSectionNormalColors => '通常色';

  @override
  String get customThemeSectionBrightColors => '明るい色';

  @override
  String get colorBackground => '背景';

  @override
  String get colorForeground => '前景';

  @override
  String get colorCursor => 'カーソル';

  @override
  String get colorSelection => '選択';

  @override
  String get colorBlack => '黒';

  @override
  String get colorRed => '赤';

  @override
  String get colorGreen => '緑';

  @override
  String get colorYellow => '黄';

  @override
  String get colorBlue => '青';

  @override
  String get colorMagenta => 'マゼンタ';

  @override
  String get colorCyan => 'シアン';

  @override
  String get colorWhite => '白';

  @override
  String get colorBrightBlack => '明るい黒';

  @override
  String get colorBrightRed => '明るい赤';

  @override
  String get colorBrightGreen => '明るい緑';

  @override
  String get colorBrightYellow => '明るい黄';

  @override
  String get colorBrightBlue => '明るい青';

  @override
  String get colorBrightMagenta => '明るいマゼンタ';

  @override
  String get colorBrightCyan => '明るいシアン';

  @override
  String get colorBrightWhite => '明るい白';

  @override
  String get customThemePreviewTitle => 'ターミナルプレビュー';

  @override
  String get customThemePreviewSelectedText => '選択テキストのプレビュー';

  @override
  String get hexColorLabel => '16進カラー';

  @override
  String get hexColorPasteTooltip => '貼り付け';

  @override
  String get hexColorInvalid => '無効な16進数';

  @override
  String get hexColorApply => '適用';

  @override
  String get customThemeNameRequired => 'テーマ名は必須です';

  @override
  String get sliderHue => 'H';

  @override
  String get sliderSaturation => 'S';

  @override
  String get sliderBrightness => 'V';

  @override
  String get sshConfigImportTitle => 'SSH設定をインポート';

  @override
  String get sshConfigImportFailed => 'SSH設定の読み取りに失敗しました';

  @override
  String get sshConfigNoHostsFound => 'ホストが見つかりません';

  @override
  String get sshConfigNoHostsFoundDetail =>
      '~/.ssh/config に有効なホストエントリが見つかりませんでした';

  @override
  String get sshConfigDeselectAll => 'すべて選択解除';

  @override
  String get sshConfigSelectAll => 'すべて選択';

  @override
  String get sshConfigImportKeys => '鍵をインポート';

  @override
  String sshConfigFoundHosts(int count) {
    return '~/.ssh/config で $count個のホストが見つかりました';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return '$count個のホストと$keys個の鍵をインポートしました';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return 'インポートに失敗しました：$error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return 'インポート ($count)';
  }

  @override
  String get legalScreenLoadError => 'ドキュメントの読み込みに失敗しました';

  @override
  String get workspacesTitle => 'ワークスペース';

  @override
  String get workspacesSaveCurrent => '現在を保存';

  @override
  String get workspacesEmptyTitle => '保存済みワークスペースがありません';

  @override
  String get workspacesEmptySubtitle =>
      '現在のタブレイアウトは自動保存されます。\n「現在を保存」で名前付きワークスペースを作成できます。';

  @override
  String workspacesLoadError(String error) {
    return 'ワークスペースの読み込みに失敗しました：$error';
  }

  @override
  String get workspacesActiveBadge => 'アクティブ';

  @override
  String get workspacesNoTerminals => 'ターミナルなし';

  @override
  String get workspacesJustNow => 'たった今';

  @override
  String get workspacesMenuSwitchTo => '切り替え';

  @override
  String get workspacesMenuRename => '名前を変更';

  @override
  String get workspacesMenuDelete => '削除';

  @override
  String get workspacesSaveTitle => 'ワークスペースを保存';

  @override
  String get workspacesSaveHint => 'ワークスペース名';

  @override
  String get workspacesSaveSave => '保存';

  @override
  String get workspacesRenameTitle => 'ワークスペースの名前を変更';

  @override
  String get workspacesRenameHint => '新しい名前';

  @override
  String get workspacesRenameSubmit => '名前を変更';

  @override
  String get workspacesDeleteTitle => 'ワークスペースを削除しますか？';

  @override
  String get workspacesDeleteSubmit => '削除';

  @override
  String workspaceTerminalCount(int count) {
    return '$count個のターミナル';
  }

  @override
  String workspaceSaved(String name) {
    return 'ワークスペース「$name」を保存しました';
  }

  @override
  String workspaceSwitching(String name) {
    return '「$name」に切り替え中...';
  }

  @override
  String workspaceLoaded(String name) {
    return 'ワークスペース「$name」を読み込みました';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return '「$name」を削除しますか？この操作は元に戻せません。';
  }

  @override
  String get awsImportTitle => 'AWS EC2からインポート';

  @override
  String get awsConnectTitle => 'AWSに接続';

  @override
  String get awsConnectSubtitle => 'AWSの認証情報を入力してEC2インスタンスをインポートします。';

  @override
  String get awsAccessKeyIdLabel => 'アクセスキーID';

  @override
  String get awsAccessKeyIdHelper => '例：AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => 'シークレットアクセスキー';

  @override
  String get awsRegionLabel => 'リージョン';

  @override
  String get awsCredentialsInfo =>
      '認証情報はこのインポートにのみ使用され、保存されません。ec2:DescribeInstances権限のみを持つIAMユーザーを使用してください。';

  @override
  String get awsFetchInstances => 'インスタンスを取得';

  @override
  String get awsFetchingInstances => 'インスタンスを取得中...';

  @override
  String get awsErrorAccessKeyRequired => 'AWSアクセスキーIDを入力してください';

  @override
  String get awsErrorSecretKeyRequired => 'AWSシークレットアクセスキーを入力してください';

  @override
  String get awsSelectInstances => 'インスタンスを選択';

  @override
  String get awsRunningOnlyFilter => '実行中のみ';

  @override
  String get awsNoRunningInstances => '実行中のインスタンスが見つかりません';

  @override
  String get awsNoInstances => 'インスタンスが見つかりません';

  @override
  String get awsConfigureImport => 'インポートを設定';

  @override
  String get awsDefaultUsernameLabel => 'デフォルトユーザー名';

  @override
  String get awsDefaultUsernameHelper => 'Amazon Linux：ec2-user、Ubuntu：ubuntu';

  @override
  String get awsInstancesToImport => 'インポートするインスタンス：';

  @override
  String get awsImporting => 'インポート中...';

  @override
  String awsImportResult(int count) {
    return 'AWS EC2から$count個のホストをインポートしました';
  }

  @override
  String awsImportHostsButton(int count) {
    return '$count個のホストをインポート';
  }

  @override
  String awsNextButton(int count) {
    return '次へ ($count)';
  }

  @override
  String get doImportTitle => 'DigitalOceanからインポート';

  @override
  String get doConnectTitle => 'DigitalOceanに接続';

  @override
  String get doConnectSubtitle =>
      'DigitalOceanの個人アクセストークンを入力してドロップレットをインポートします。';

  @override
  String get doApiTokenLabel => 'APIトークン';

  @override
  String get doApiTokenHelper => 'cloud.digitalocean.com/account/api/tokensで生成';

  @override
  String get doTokenInfo => 'トークンはこのインポートにのみ使用され、保存されません。';

  @override
  String get doFetchDroplets => 'ドロップレットを取得';

  @override
  String get doFetchingDroplets => 'ドロップレットを取得中...';

  @override
  String get doErrorTokenRequired => 'APIトークンを入力してください';

  @override
  String get doSelectDroplets => 'ドロップレットを選択';

  @override
  String get doActiveOnlyFilter => 'アクティブのみ';

  @override
  String get doNoActiveDroplets => 'アクティブなドロップレットが見つかりません';

  @override
  String get doNoDroplets => 'ドロップレットが見つかりません';

  @override
  String get doConfigureImport => 'インポートを設定';

  @override
  String get doDefaultUsernameLabel => 'デフォルトユーザー名';

  @override
  String get doDefaultUsernameHelper => 'すべてのインポートホストに使用（デフォルト：root）';

  @override
  String get doHostsToImport => 'インポートするホスト：';

  @override
  String get doImporting => 'インポート中...';

  @override
  String doImportResult(int count) {
    return 'DigitalOceanから$count個のホストをインポートしました';
  }

  @override
  String doImportHostsButton(int count) {
    return '$count個のホストをインポート';
  }

  @override
  String doNextButton(int count) {
    return '次へ ($count)';
  }

  @override
  String get loginSubtitle => 'サインインしてデバイス間で同期';

  @override
  String get loginEmailLabel => 'メールアドレス';

  @override
  String get loginPasswordLabel => 'パスワード';

  @override
  String get loginErrorEmailRequired => 'メールアドレスを入力してください';

  @override
  String get loginErrorPasswordRequired => 'パスワードを入力してください';

  @override
  String get loginSigningIn => 'サインイン中...';

  @override
  String get loginSignIn => 'サインイン';

  @override
  String get loginForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get loginCreateAccount => 'アカウントを作成';

  @override
  String get loginUseLocally => 'アカウントなしでローカルで使用';

  @override
  String get signUpSubtitle => 'アカウントを作成';

  @override
  String get signUpEmailLabel => 'メールアドレス';

  @override
  String get signUpPasswordLabel => 'パスワード（10文字以上）';

  @override
  String get signUpConfirmPasswordLabel => 'パスワードを確認';

  @override
  String get passwordStrengthWeak => '弱い';

  @override
  String get passwordStrengthFair => 'やや弱い';

  @override
  String get passwordStrengthGood => '良い';

  @override
  String get passwordStrengthStrong => '強い';

  @override
  String get passwordStrengthExcellent => '非常に強い';

  @override
  String get signUpErrorEmailRequired => 'メールアドレスを入力してください';

  @override
  String get signUpErrorPasswordRequired => 'パスワードを入力してください';

  @override
  String get signUpErrorPasswordTooShort => 'パスワードは10文字以上にしてください';

  @override
  String get signUpErrorPasswordMismatch => 'パスワードが一致しません';

  @override
  String get signUpErrorTermsRequired => '利用規約に同意してください';

  @override
  String get signUpEncryptionWarning =>
      'データはエンドツーエンドで暗号化されます。パスワードを紛失した場合、アカウントを復旧することはできません。';

  @override
  String get signUpTermsPrefix => '';

  @override
  String get signUpTermsOfService => '利用規約';

  @override
  String get signUpTermsAnd => 'と';

  @override
  String get signUpPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get signUpCreatingAccount => 'アカウントを作成中...';

  @override
  String get signUpCreateAccount => 'アカウントを作成';

  @override
  String get signUpAlreadyHaveAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get signUpSignIn => 'サインイン';

  @override
  String get signUpEncryptionNote => '暗号化：Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => 'パスワードをリセット';

  @override
  String get forgotPasswordInstructions =>
      'アカウントに関連付けられたメールアドレスを入力してください。パスワードリセットリンクをお送りします。';

  @override
  String get forgotPasswordEmailLabel => 'メールアドレス';

  @override
  String get forgotPasswordSending => '送信中...';

  @override
  String get forgotPasswordSendResetLink => 'リセットリンクを送信';

  @override
  String get forgotPasswordBackToSignIn => 'サインインに戻る';

  @override
  String get forgotPasswordErrorEmailRequired => 'メールアドレスを入力してください';

  @override
  String get forgotPasswordCheckEmail => 'メールを確認してください';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return '$email のアカウントが存在する場合、パスワードリセットリンクがまもなく届きます。';
  }

  @override
  String get forgotPasswordVaultWarning =>
      'ご注意：ゼロ知識暗号化を使用しています。アカウントのパスワードをリセットしても、ボールトのマスターパスワードは変更されません。';

  @override
  String get forgotPasswordTryAgain => '届きませんか？再試行してください';

  @override
  String get totpSetupTitle => '2FAを設定';

  @override
  String get totpSetupFailed => '2FAの設定に失敗しました';

  @override
  String get totpSetupHeading => '二要素認証';

  @override
  String get totpSetupInstructions =>
      '認証アプリ（Google Authenticator、Authyなど）でこのQRコードをスキャンしてください。';

  @override
  String get totpSetupManualEntryKey => '手動入力キー';

  @override
  String get totpSetupSecretCopied => 'シークレットをコピーしました';

  @override
  String get totpSetupEnterCode => 'アプリの6桁のコードを入力してください：';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => '確認中...';

  @override
  String get totpSetupVerifyAndEnable => '確認して有効化';

  @override
  String get totpSetupEnabled => '二要素認証が有効になりました';

  @override
  String get totpSetupErrorCodeLength => '6桁のコードを入力してください';

  @override
  String get totpSetupErrorInvalidCode => '無効なコードです。認証アプリを確認して再試行してください。';

  @override
  String get totpVerifyHeading => '二要素認証';

  @override
  String get totpVerifyInstructions => '認証アプリの6桁のコードを入力してください';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => '確認中...';

  @override
  String get totpVerifySubmit => '確認';

  @override
  String get totpVerifyHelpText =>
      '認証アプリ（Google Authenticator、Authyなど）を開いて確認コードを見つけてください。';

  @override
  String get totpVerifyErrorDefaultFailed => '確認に失敗しました';

  @override
  String get totpVerifyErrorInvalidCode => '無効なコードです。再試行してください。';

  @override
  String get adaptiveScaffoldHosts => 'ホスト';

  @override
  String get adaptiveScaffoldKeys => '鍵';

  @override
  String get adaptiveScaffoldSnippets => 'スニペット';

  @override
  String get adaptiveScaffoldTerminal => 'ターミナル';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => 'ポート転送';

  @override
  String get adaptiveScaffoldSettings => '設定';

  @override
  String get commandPaletteHint => 'ホスト、スニペットを検索、またはコマンドを入力...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return '「$query」の検索結果はありません';
  }

  @override
  String get commandPaletteHostsHeader => 'ホスト';

  @override
  String get commandPaletteSnippetsHeader => 'スニペット';

  @override
  String get commandPaletteActionsHeader => 'アクション';

  @override
  String get commandPaletteActionNewHost => '新しいホスト';

  @override
  String get commandPaletteActionQuickConnect => 'クイック接続';

  @override
  String get commandPaletteActionSettings => '設定';

  @override
  String get commandPaletteActionToggleTheme => 'テーマを切り替え';

  @override
  String get shortcutReferenceTitle => 'キーボードショートカット';

  @override
  String get shortcutCategoryGeneral => '一般';

  @override
  String get shortcutCategoryTerminal => 'ターミナル';

  @override
  String get shortcutCategoryNavigation => 'ナビゲーション';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => 'ロックを解除して続行';

  @override
  String get appLockUnlockButton => 'ロック解除';

  @override
  String get appLockUnlockWithBiometrics => '生体認証でロック解除';

  @override
  String get appLockBiometricReason => 'CloudShellのロックを解除するために認証してください';

  @override
  String get appLockFailed => '認証に失敗しました';

  @override
  String get statusOnline => 'オンライン';

  @override
  String get statusOffline => 'オフライン';

  @override
  String get statusWarning => '警告';

  @override
  String get statusIdle => '待機中';

  @override
  String get vaultUnlockTitle => 'ボールトのロック解除';

  @override
  String get vaultUnlockSubtitle => 'マスターパスワードを入力してボールトのロックを解除してください。';

  @override
  String get vaultUnlockPasswordLabel => 'マスターパスワード';

  @override
  String get vaultUnlockPasswordHint => 'マスターパスワードを入力';

  @override
  String get vaultUnlockButton => 'ロック解除';

  @override
  String get vaultUnlockUnlocking => 'ロック解除中...';

  @override
  String get vaultUnlockBiometricButton => '生体認証でロック解除';

  @override
  String get vaultUnlockForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get vaultUnlockResetTitle => 'ボールトをリセットしますか？';

  @override
  String get vaultUnlockResetMessage =>
      'リセットすると暗号化データ（保存済みパスワード、秘密鍵）がすべて削除されます。ローカルのホストと設定は保持されます。\n\nこの操作は元に戻せません。';

  @override
  String get vaultUnlockResetConfirm => 'ボールトをリセット';

  @override
  String get vaultUnlockIncorrectPassword => 'パスワードが正しくありません';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return '試行回数が多すぎます。$seconds秒後に再試行してください。';
  }

  @override
  String get masterPasswordSetupTitle => 'ボールトを設定';

  @override
  String get masterPasswordSetupSubtitle => '機密データを暗号化するためのマスターパスワードを作成してください。';

  @override
  String get masterPasswordSetupPasswordLabel => 'マスターパスワード';

  @override
  String get masterPasswordSetupPasswordHint => '10文字以上';

  @override
  String get masterPasswordSetupConfirmLabel => 'パスワードを確認';

  @override
  String get masterPasswordSetupConfirmHint => 'マスターパスワードを再入力';

  @override
  String get masterPasswordSetupButton => 'ボールトを作成';

  @override
  String get masterPasswordSetupCreating => 'ボールトを作成中...';

  @override
  String get masterPasswordSetupMinLength => '最低10文字が必要です';

  @override
  String get masterPasswordSetupMismatch => 'パスワードが一致しません';

  @override
  String get masterPasswordSetupStrengthWeak => '弱い';

  @override
  String get masterPasswordSetupStrengthFair => 'やや弱い';

  @override
  String get masterPasswordSetupStrengthGood => '良い';

  @override
  String get masterPasswordSetupStrengthStrong => '強い';

  @override
  String get masterPasswordSetupWarning =>
      'マスターパスワードは復元できません。書き留めて安全な場所に保管してください。';

  @override
  String get passwordGeneratorTitle => 'パスワード生成';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return '長さ：$length';
  }

  @override
  String get passwordGeneratorUppercase => '大文字 (A-Z)';

  @override
  String get passwordGeneratorLowercase => '小文字 (a-z)';

  @override
  String get passwordGeneratorNumbers => '数字 (0-9)';

  @override
  String get passwordGeneratorSymbols => '記号 (!@#...)';

  @override
  String get passwordGeneratorGenerate => '生成';

  @override
  String get passwordGeneratorCopy => 'コピー';

  @override
  String get passwordGeneratorCopied => 'パスワードをコピーしました（30秒後に自動消去）';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bitsビットのエントロピー';
  }

  @override
  String get onboardingWelcomeTitle => 'CloudShellへようこそ';

  @override
  String get onboardingWelcomeSubtitle => 'モダンなクロスプラットフォームSSHクライアント';

  @override
  String get onboardingSecureTitle => 'セキュリティ重視の設計';

  @override
  String get onboardingSecureSubtitle =>
      'Argon2id + AES-256-GCMによるエンドツーエンド暗号化ボールト';

  @override
  String get onboardingTerminalTitle => 'パワフルなターミナル';

  @override
  String get onboardingTerminalSubtitle => '分割ペイン、タブ、テーマ、スニペットなど';

  @override
  String get onboardingSyncTitle => 'どこでも同期';

  @override
  String get onboardingSyncSubtitle => 'ホスト、鍵、スニペットをすべてのデバイスで';

  @override
  String get onboardingGetStarted => 'はじめる';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get portForwardingTitle => 'ポート転送';

  @override
  String get portForwardingAddTooltip => 'ルールを追加';

  @override
  String get portForwardingEmptyTitle => 'ポート転送ルールがありません';

  @override
  String get portForwardingEmptySubtitle => 'SSH接続を通じてトラフィックをトンネルするルールを作成します。';

  @override
  String get portForwardingEmptyAction => 'ルールを追加';

  @override
  String get portForwardingActiveHeader => 'アクティブ';

  @override
  String get portForwardingSavedHeader => '保存済みルール';

  @override
  String get portForwardingTypeLocal => 'ローカル';

  @override
  String get portForwardingTypeRemote => 'リモート';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => '停止';

  @override
  String get portForwardingStart => '開始';

  @override
  String get portForwardingMenuEdit => '編集';

  @override
  String get portForwardingMenuDelete => '削除';

  @override
  String get portForwardingDeleteDialogTitle => 'ルールを削除';

  @override
  String get portForwardingDeleteDialogMessage => 'このポート転送ルールを削除しますか？';

  @override
  String get portForwardingLoading => 'ポート転送ルールを読み込み中...';

  @override
  String get portForwardFormTitleNew => '新しいポート転送';

  @override
  String get portForwardFormTitleEdit => 'ポート転送を編集';

  @override
  String get portForwardFormLabelField => 'ラベル';

  @override
  String get portForwardFormLabelHint => '例：データベーストンネル';

  @override
  String get portForwardFormTypeField => '種類';

  @override
  String get portForwardFormTypeLocal => 'ローカル';

  @override
  String get portForwardFormTypeRemote => 'リモート';

  @override
  String get portForwardFormTypeDynamic => 'ダイナミック (SOCKS)';

  @override
  String get portForwardFormHostField => 'ホスト';

  @override
  String get portForwardFormSelectHost => 'ホストを選択';

  @override
  String get portForwardFormNoHostsAvailable =>
      '利用可能なホストがありません。まずホストを作成してください。';

  @override
  String get portForwardFormCouldNotLoadHosts => 'ホストを読み込めませんでした。';

  @override
  String get portForwardFormLocalPortField => 'ローカルポート';

  @override
  String get portForwardFormRemotePortField => 'リモートポート';

  @override
  String get portForwardFormDestHostField => '宛先ホスト';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => '宛先ポート';

  @override
  String get portForwardFormDestPortHint => '例：5432';

  @override
  String get portForwardFormPortHint => '例：8080';

  @override
  String get portForwardFormAutoStart => '接続時に自動開始';

  @override
  String get portForwardFormAutoStartSubtitle => 'ホストに接続すると自動的にこのトンネルを開始します。';

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
  String get languageSystem => 'システムのデフォルト';
}
