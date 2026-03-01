// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get confirm => '확인';

  @override
  String get close => '닫기';

  @override
  String get retry => '재시도';

  @override
  String get back => '뒤로';

  @override
  String get edit => '편집';

  @override
  String get done => '완료';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get search => '검색';

  @override
  String get clearSearch => '검색 지우기';

  @override
  String get togglePasswordVisibility => '비밀번호 표시 전환';

  @override
  String get togglePassphraseVisibility => '암호 구문 표시 전환';

  @override
  String get ok => '확인';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String get enabled => '활성화됨';

  @override
  String get disabled => '비활성화됨';

  @override
  String get none => '없음';

  @override
  String get unknown => '알 수 없음';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get hostsTitle => '호스트';

  @override
  String get hostsAddTooltip => '호스트 추가';

  @override
  String get hostsSearchHint => '호스트 검색...';

  @override
  String get hostsEmptyTitle => '호스트 없음';

  @override
  String get hostsEmptySubtitle => '시작하려면 첫 번째 SSH 서버를 추가하세요.';

  @override
  String get hostsEmptyAction => '호스트 추가';

  @override
  String hostsNoMatchQuery(String query) {
    return '\"$query\"와 일치하는 호스트 없음';
  }

  @override
  String get hostsLoadingMessage => '호스트 로딩 중...';

  @override
  String get hostsRecentHeader => '최근';

  @override
  String get hostsGroupsHeader => '그룹';

  @override
  String get hostsFavoritesHeader => '즐겨찾기';

  @override
  String get hostsAllHostsHeader => '모든 호스트';

  @override
  String get hostsUngroupedHeader => '그룹 없음';

  @override
  String get hostsDeleteDialogTitle => '호스트 삭제';

  @override
  String hostsDeleteDialogMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get hostsMenuEdit => '편집';

  @override
  String get hostsMenuDelete => '삭제';

  @override
  String get hostsMenuConnect => '연결';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return '마지막 연결 $time';
  }

  @override
  String get hostsNeverConnected => '연결한 적 없음';

  @override
  String get hostsJustNow => '방금';

  @override
  String get hostFormTitleNew => '새 호스트';

  @override
  String get hostFormTitleEdit => '호스트 편집';

  @override
  String get hostFormSave => '저장';

  @override
  String get hostFormLabelField => '레이블';

  @override
  String get hostFormLabelHint => '예: 운영 서버';

  @override
  String get hostFormLabelRequired => '레이블은 필수입니다';

  @override
  String get hostFormHostnameField => '호스트명';

  @override
  String get hostFormHostnameHint => '예: 192.168.1.100 또는 example.com';

  @override
  String get hostFormHostnameRequired => '호스트명은 필수입니다';

  @override
  String get hostFormPortField => '포트';

  @override
  String get hostFormUsernameField => '사용자명';

  @override
  String get hostFormUsernameHint => '예: root';

  @override
  String get hostFormUsernameRequired => '사용자명은 필수입니다';

  @override
  String get hostFormPasswordField => '비밀번호';

  @override
  String get hostFormPasswordHint => '비밀번호 입력';

  @override
  String get hostFormAuthMethodField => '인증 방식';

  @override
  String get hostFormAuthMethodKey => '키';

  @override
  String get hostFormAuthMethodPassword => '비밀번호';

  @override
  String get hostFormAuthMethodKeyAndPassword => '키 + 비밀번호';

  @override
  String get hostFormKeyField => 'SSH 키';

  @override
  String get hostFormKeyNone => '없음';

  @override
  String get hostFormGroupField => '그룹';

  @override
  String get hostFormGroupNone => '그룹 없음';

  @override
  String get hostFormTagsField => '태그';

  @override
  String get hostFormTagsHint => '태그 추가 (쉼표로 구분)';

  @override
  String get hostFormAdvancedSection => '고급';

  @override
  String get hostFormJumpHostField => '점프 호스트 (프록시)';

  @override
  String get hostFormJumpHostNone => '없음 (직접 연결)';

  @override
  String get hostFormKeepAliveField => '연결 유지 (초)';

  @override
  String get hostFormStartupCommandField => '시작 명령';

  @override
  String get hostFormStartupCommandHint => '연결 후 실행 (선택사항)';

  @override
  String get hostFormNotesField => '메모';

  @override
  String get hostFormNotesHint => '이 호스트에 대한 선택적 메모';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => '시리얼';

  @override
  String get hostFormSerialPortField => '시리얼 포트';

  @override
  String get hostFormSerialPortNone => '포트 선택';

  @override
  String get hostFormSerialNoPortsAvailable => '사용 가능한 시리얼 포트 없음';

  @override
  String get hostFormSerialBaudRateField => '보드 레이트';

  @override
  String get hostFormSerialDataBitsField => '데이터 비트';

  @override
  String get hostFormSerialStopBitsField => '정지 비트';

  @override
  String get hostFormSerialParityField => '패리티';

  @override
  String get hostFormSerialFlowControlField => '흐름 제어';

  @override
  String get hostFormTestConnection => '연결 테스트';

  @override
  String get hostFormTestConnectionSuccess => '연결 성공!';

  @override
  String hostFormTestConnectionFailed(String error) {
    return '연결 실패: $error';
  }

  @override
  String get hostDetailTitle => '호스트 상세';

  @override
  String get hostDetailConnect => '연결';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => '편집';

  @override
  String get hostDetailDeleteTooltip => '삭제';

  @override
  String get hostDetailFavoriteTooltip => '즐겨찾기';

  @override
  String get hostDetailSectionConnection => '연결';

  @override
  String get hostDetailSectionAuthentication => '인증';

  @override
  String get hostDetailSectionAdvanced => '고급';

  @override
  String get hostDetailSectionTags => '태그';

  @override
  String get hostDetailSectionNotes => '메모';

  @override
  String get hostDetailLabelHostname => '호스트명';

  @override
  String get hostDetailLabelPort => '포트';

  @override
  String get hostDetailLabelUsername => '사용자명';

  @override
  String get hostDetailLabelAuthMethod => '인증 방식';

  @override
  String get hostDetailLabelKey => '키';

  @override
  String get hostDetailLabelGroup => '그룹';

  @override
  String get hostDetailLabelJumpHost => '점프 호스트';

  @override
  String get hostDetailLabelKeepAlive => '연결 유지';

  @override
  String get hostDetailLabelStartupCommand => '시작 명령';

  @override
  String get hostDetailLabelProtocol => '프로토콜';

  @override
  String get hostDetailLabelCreated => '생성일';

  @override
  String get hostDetailLabelUpdated => '수정일';

  @override
  String get hostDetailLabelLastConnected => '마지막 연결';

  @override
  String get hostDetailNotFound => '호스트를 찾을 수 없음';

  @override
  String get hostDetailLoading => '호스트 로딩 중...';

  @override
  String get hostDetailDeleteDialogTitle => '호스트 삭제';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get quickConnectTitle => '빠른 연결';

  @override
  String get quickConnectHint => '사용자@호스트:포트';

  @override
  String get quickConnectHelperText => '예: root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => '호스트 저장';

  @override
  String get quickConnectConnect => '연결';

  @override
  String get quickConnectInvalidFormat =>
      '잘못된 형식입니다. 사용자@호스트 또는 사용자@호스트:포트 형식을 사용하세요';

  @override
  String get groupFormTitleNew => '새 그룹';

  @override
  String get groupFormTitleEdit => '그룹 편집';

  @override
  String get groupFormNameField => '그룹 이름';

  @override
  String get groupFormNameHint => '예: 운영 환경';

  @override
  String get groupFormNameRequired => '그룹 이름은 필수입니다';

  @override
  String get groupFormParentField => '상위 그룹';

  @override
  String get groupFormParentNone => '없음 (최상위)';

  @override
  String get groupFormDeleteDialogTitle => '그룹 삭제';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 그룹의 호스트는 그룹 없음 상태가 됩니다.';
  }

  @override
  String get hostKeyVerifyChangedTitle => '호스트 키 변경됨';

  @override
  String get hostKeyVerifyUnknownTitle => '알 수 없는 호스트';

  @override
  String get hostKeyVerifyChangedWarning =>
      '경고: 이 서버의 호스트 키가 변경되었습니다. 이는 중간자 공격을 나타낼 수 있습니다.';

  @override
  String get hostKeyVerifyUnknownMessage =>
      '이 호스트의 진위를 확인할 수 없습니다. 연결을 계속하시겠습니까?';

  @override
  String get hostKeyVerifyLabelHost => '호스트';

  @override
  String get hostKeyVerifyLabelKeyType => '키 유형';

  @override
  String get hostKeyVerifyLabelFingerprint => '지문:';

  @override
  String get hostKeyVerifyFingerprintCopied => '지문 복사됨 (30초 후 자동 삭제)';

  @override
  String get hostKeyVerifyTrustAnyway => '그래도 신뢰';

  @override
  String get hostKeyVerifyTrustAndConnect => '신뢰 및 연결';

  @override
  String get keysTitle => 'SSH 키';

  @override
  String get keysAddTooltip => '키 가져오기';

  @override
  String get keysImportTooltip => '키 가져오기';

  @override
  String get keysEmptyTitle => 'SSH 키 없음';

  @override
  String get keysEmptySubtitle => '서버 인증을 위해 SSH 키를 가져오세요.';

  @override
  String get keysEmptyAction => '키 가져오기';

  @override
  String get keysSearchHint => '키 검색...';

  @override
  String keysNoMatchQuery(String query) {
    return '\"$query\"와 일치하는 키 없음';
  }

  @override
  String get keysLoadingMessage => '키 로딩 중...';

  @override
  String get keysDeleteDialogTitle => '키 삭제';

  @override
  String keysDeleteDialogMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 되돌릴 수 없습니다.';
  }

  @override
  String get keysMenuDelete => '삭제';

  @override
  String keysAssociatedHosts(int count) {
    return '$count개 호스트';
  }

  @override
  String get keyDetailTitle => '키 상세';

  @override
  String get keyDetailEditTooltip => '편집';

  @override
  String get keyDetailDeleteTooltip => '삭제';

  @override
  String get keyDetailSectionPublicKey => '공개 키';

  @override
  String get keyDetailCopyPublicKey => '공개 키 복사';

  @override
  String get keyDetailSectionFingerprint => '지문';

  @override
  String get keyDetailSectionAssociatedHosts => '연결된 호스트';

  @override
  String get keyDetailSectionDetails => '상세 정보';

  @override
  String get keyDetailLabelType => '유형';

  @override
  String get keyDetailLabelBits => '비트';

  @override
  String get keyDetailLabelCreated => '생성일';

  @override
  String get keyDetailNotFound => '키를 찾을 수 없음';

  @override
  String get keyDetailLoading => '키 로딩 중...';

  @override
  String get keyDetailPublicKeyCopied => '공개 키 복사됨 (30초 후 자동 삭제)';

  @override
  String get keyDetailFingerprintCopied => '지문 복사됨 (30초 후 자동 삭제)';

  @override
  String get keyDetailNoAssociatedHosts => '이 키를 사용하는 호스트 없음';

  @override
  String get keyImportTitle => 'SSH 키 가져오기';

  @override
  String get keyImportButton => '가져오기';

  @override
  String get keyImportButtonImporting => '가져오는 중...';

  @override
  String get keyImportButtonImportKey => '키 가져오기';

  @override
  String get keyImportLabelField => '레이블';

  @override
  String get keyImportLabelHint => '예: 내 서버 키';

  @override
  String get keyImportPassphraseField => '암호 구문 (선택사항)';

  @override
  String get keyImportPassphraseHint => '키가 암호화되지 않은 경우 비워두세요';

  @override
  String get keyImportPrivateKeyField => '개인 키';

  @override
  String get keyImportFromFile => '파일에서';

  @override
  String get keyImportPaste => '붙여넣기';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\nor PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      '지원 형식: OpenSSH, PEM, PuTTY PPK (RSA, Ed25519, ECDSA). 개인 키는 플랫폼 키체인에 안전하게 저장되며 이 기기를 떠나지 않습니다.';

  @override
  String keyImportFailedToReadFile(String error) {
    return '파일 읽기 실패: $error';
  }

  @override
  String get keyImportClipboardEmpty => '클립보드가 비어 있습니다';

  @override
  String get keyImportPasteOrSelectKey => '개인 키를 붙여넣거나 선택하세요';

  @override
  String keyImportSuccess(String fingerprint) {
    return '키 가져오기 완료: $fingerprint';
  }

  @override
  String get terminalNoActiveSessions => '활성 세션 없음';

  @override
  String get terminalQuickConnect => '빠른 연결';

  @override
  String get terminalRecentHostsHeader => '최근 호스트';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  새 호스트  ·  ⌘⇧N  빠른 연결  ·  ⌘K  검색';

  @override
  String get terminalMobileShortcutHint => '+를 눌러 호스트에 연결';

  @override
  String terminalConnectingToHost(String label) {
    return '$label에 연결 중...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return '재연결 중... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => '취소';

  @override
  String get terminalConnectionLost => '연결이 끊어짐';

  @override
  String get terminalSearchHint => '터미널 검색...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => '닫기 (Esc)';

  @override
  String get terminalConnectionInfoTitle => '연결 정보';

  @override
  String get terminalStatusReconnecting => '재연결 중...';

  @override
  String get terminalStatusConnected => '연결됨';

  @override
  String get terminalStatusDisconnected => '연결 끊김';

  @override
  String get terminalInfoLabelHost => '호스트';

  @override
  String get terminalInfoLabelAddress => '주소';

  @override
  String get terminalInfoLabelUsername => '사용자명';

  @override
  String get terminalInfoLabelProxyJump => '프록시 점프';

  @override
  String get terminalInfoValueProxyJump => '배스천 호스트 경유';

  @override
  String get terminalInfoLabelUptime => '가동 시간';

  @override
  String get terminalInfoLabelConnectedAt => '연결 시간';

  @override
  String get terminalInfoLabelSessionId => '세션 ID';

  @override
  String get terminalInfoLabelSplit => '분할';

  @override
  String get terminalInfoValueSplitHorizontal => '가로 (2개 창)';

  @override
  String get terminalInfoValueSplitVertical => '세로 (2개 창)';

  @override
  String get terminalInfoLabelLogging => '로깅';

  @override
  String get terminalInfoValueLoggingActive => '활성';

  @override
  String get terminalStatusBarDefaultDuration => '0:00';

  @override
  String get terminalStatusBarLogActive => '로그';

  @override
  String get terminalStatusBarLogInactive => '로그';

  @override
  String get terminalBroadcastOnTooltip => '브로드캐스트 켜짐 — 탭하여 전환, 길게 눌러 옵션 보기';

  @override
  String get terminalBroadcastOffTooltip => '브로드캐스트 꺼짐 — 탭하여 전환, 길게 눌러 옵션 보기';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return '브로드캐스트 ($count)';
  }

  @override
  String get terminalBroadcastCastActive => '브로드캐스트';

  @override
  String get terminalBroadcastCastInactive => '브로드캐스트';

  @override
  String get terminalHeaderBackTooltip => '뒤로';

  @override
  String get terminalHeaderNewConnectionTooltip => '새 연결';

  @override
  String get terminalHeaderSnippetsTooltip => '스니펫';

  @override
  String get terminalHeaderCopyTooltip => '선택 항목 복사';

  @override
  String get terminalHeaderPasteTooltip => '붙여넣기';

  @override
  String get terminalHeaderNewTabTooltip => '새 탭';

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
  String get broadcastPanelTitle => '브로드캐스트 입력';

  @override
  String get broadcastPanelDisable => '비활성화';

  @override
  String get broadcastPanelDescription => '키보드 입력을 받을 터미널을 선택하세요.';

  @override
  String get broadcastPanelBroadcastToAll => '전체에 브로드캐스트';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count개 연결된 세션';
  }

  @override
  String get broadcastPanelActiveLabel => '활성';

  @override
  String get broadcastPanelTabConnected => '연결됨';

  @override
  String get broadcastPanelTabDisconnected => '연결 끊김';

  @override
  String get snippetsTitle => '스니펫';

  @override
  String get snippetsAddTooltip => '스니펫 추가';

  @override
  String get snippetsEmptyTitle => '스니펫 없음';

  @override
  String get snippetsEmptySubtitle => '자주 사용하는 명령을 저장하여 빠르게 접근하세요.';

  @override
  String get snippetsEmptyAction => '스니펫 추가';

  @override
  String get snippetsSearchHint => '스니펫 검색...';

  @override
  String snippetsNoMatchQuery(String query) {
    return '\"$query\"와 일치하는 스니펫 없음';
  }

  @override
  String get snippetsLoadingMessage => '스니펫 로딩 중...';

  @override
  String get snippetsUncategorized => '미분류';

  @override
  String get snippetsHasVariables => '변수 포함';

  @override
  String get snippetsCopyCommandTooltip => '명령 복사';

  @override
  String get snippetsMenuEdit => '편집';

  @override
  String get snippetsMenuDelete => '삭제';

  @override
  String get snippetsCopiedMessage => '명령 복사됨 (30초 후 자동 삭제)';

  @override
  String get snippetsDeleteDialogTitle => '스니펫 삭제';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get snippetDetailNotFound => '스니펫을 찾을 수 없음';

  @override
  String get snippetDetailLoading => '스니펫 로딩 중...';

  @override
  String get snippetDetailEditTooltip => '편집';

  @override
  String get snippetDetailDeleteTooltip => '삭제';

  @override
  String get snippetDetailSectionCommand => '명령';

  @override
  String get snippetDetailCopyCommandTooltip => '명령 복사';

  @override
  String get snippetDetailSectionVariables => '변수';

  @override
  String get snippetDetailSectionDescription => '설명';

  @override
  String get snippetDetailSectionDetails => '상세 정보';

  @override
  String get snippetDetailLabelCreated => '생성일';

  @override
  String get snippetDetailLabelUpdated => '수정일';

  @override
  String get snippetDetailCopiedMessage => '명령 복사됨 (30초 후 자동 삭제)';

  @override
  String get snippetFormTitleEdit => '스니펫 편집';

  @override
  String get snippetFormTitleNew => '새 스니펫';

  @override
  String get snippetFormNameLabel => '스니펫 이름';

  @override
  String get snippetFormNameHint => '예: 디스크 공간 확인';

  @override
  String get snippetFormNameRequired => '이름은 필수입니다';

  @override
  String get snippetFormCommandLabel => '명령';

  @override
  String get snippetFormCommandHint => '예: df -h\n이중 중괄호 변수를 자리 표시자로 사용';

  @override
  String get snippetFormCommandRequired => '명령은 필수입니다';

  @override
  String get snippetFormVariablesLabel => '변수:';

  @override
  String get snippetFormCategoryLabel => '카테고리 (선택사항)';

  @override
  String get snippetFormCategoryHint => '예: 시스템, Docker, 네트워크';

  @override
  String get snippetFormDescriptionLabel => '설명 (선택사항)';

  @override
  String get snippetFormDescriptionHint => '이 명령은 무엇을 하나요?';

  @override
  String get snippetFormSaveButtonEdit => '스니펫 업데이트';

  @override
  String get snippetFormSaveButtonNew => '스니펫 만들기';

  @override
  String snippetFormSaveError(String error) {
    return '스니펫 저장 실패: $error';
  }

  @override
  String get snippetPickerSearchHint => '스니펫 검색...';

  @override
  String get snippetPickerEmptyMessage => '스니펫이 없습니다. 스니펫 화면에서 만들어 주세요.';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return '\"$query\"와 일치하는 스니펫 없음';
  }

  @override
  String get snippetPickerLoadingError => '스니펫 로딩 실패';

  @override
  String get snippetPickerVariableDialogTitle => '변수 입력';

  @override
  String snippetPickerVariableHint(String variable) {
    return '$variable의 값을 입력하세요';
  }

  @override
  String get snippetPickerVariableInsert => '삽입';

  @override
  String get sftpSelectHostHint => '호스트 선택...';

  @override
  String get sftpConnecting => '연결 중...';

  @override
  String get sftpUploadLabel => '업로드';

  @override
  String get sftpDownloadLabel => '다운로드';

  @override
  String get sftpNoSavedHostsTitle => '저장된 호스트 없음';

  @override
  String get sftpNoSavedHostsSubtitle => '먼저 호스트를 추가한 후 파일 전송을 시작하세요.';

  @override
  String get sftpFailedToLoadHosts => '호스트 로딩 실패';

  @override
  String sftpFailedToConnect(String error) {
    return '연결 실패: $error';
  }

  @override
  String get sftpConnectToHostFirst => '먼저 호스트에 연결하세요';

  @override
  String get sftpDropFilesToUpload => '파일을 여기에 놓아 업로드';

  @override
  String get sftpTabLocal => '로컬';

  @override
  String get sftpTabRemote => '원격';

  @override
  String get sftpPaneHeaderLocal => '로컬';

  @override
  String get sftpPaneHeaderRemote => '원격';

  @override
  String get sftpLocalPermissionDenied => '권한 거부됨';

  @override
  String get sftpLocalEmptyFolder => '빈 폴더';

  @override
  String get sftpLocalCannotOpenFolder => '폴더를 열 수 없음';

  @override
  String get sftpRemoteSelectHost => '탐색할 호스트를 선택하세요';

  @override
  String get sftpRemoteSelectHostSubtitle => '위의 드롭다운에서 연결된 서버를 선택하세요';

  @override
  String get sftpRemoteEmptyDirectory => '빈 디렉토리';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return '폴더를 열 수 없음: $message';
  }

  @override
  String get sftpRemoteReadOnly => '읽기 전용';

  @override
  String get sftpRemoteNewFolderTooltip => '새 폴더';

  @override
  String get sftpHideHiddenFiles => '숨김 파일 숨기기';

  @override
  String get sftpShowHiddenFiles => '숨김 파일 표시';

  @override
  String get sftpGoUp => '상위로 이동';

  @override
  String get sftpNewFolderDialogTitle => '새 폴더';

  @override
  String get sftpNewFolderDialogLabel => '폴더 이름';

  @override
  String get sftpNewFolderDialogHint => '예: new-folder';

  @override
  String get sftpNewFolderDialogCreate => '만들기';

  @override
  String get sftpFileMenuEdit => '편집';

  @override
  String get sftpFileMenuPermissions => '권한';

  @override
  String get sftpFileMenuDelete => '삭제';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return '권한 — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => '8진수: ';

  @override
  String get sftpPermissionsLabelUser => '사용자';

  @override
  String get sftpPermissionsLabelGroup => '그룹';

  @override
  String get sftpPermissionsLabelOther => '기타';

  @override
  String get sftpPermissionsBitRead => '읽기';

  @override
  String get sftpPermissionsBitWrite => '쓰기';

  @override
  String get sftpPermissionsBitExec => '실행';

  @override
  String get sftpPermissionsApply => '적용';

  @override
  String get sftpTransfersHeader => '전송';

  @override
  String get sftpTransfersClearDone => '완료 항목 지우기';

  @override
  String get sftpTransferStatusDone => '완료';

  @override
  String get sftpTransferStatusFailed => '실패';

  @override
  String get remoteEditorSaveTooltip => '저장';

  @override
  String get remoteEditorFileSaved => '파일 저장됨';

  @override
  String remoteEditorFailedToSave(String error) {
    return '저장 실패: $error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle => '저장되지 않은 변경사항';

  @override
  String get remoteEditorUnsavedChangesMessage =>
      '저장되지 않은 변경사항이 있습니다. 취소하시겠습니까?';

  @override
  String get remoteEditorDiscard => '취소';

  @override
  String get remoteEditorFailedToLoadFile => '파일 로딩 실패';

  @override
  String get settingsTitle => '설정';

  @override
  String get sectionAppearance => '외관';

  @override
  String get sectionConnection => '연결';

  @override
  String get sectionNotifications => '알림';

  @override
  String get sectionSecurity => '보안';

  @override
  String get sectionTools => '도구';

  @override
  String get sectionData => '데이터';

  @override
  String get sectionCloudImport => '클라우드 가져오기';

  @override
  String get sectionSync => '동기화';

  @override
  String get sectionAbout => '정보';

  @override
  String get settingThemeTitle => '테마';

  @override
  String get themeModeDark => '다크';

  @override
  String get themeModeLight => '라이트';

  @override
  String get themeModeSystem => '시스템';

  @override
  String get settingTerminalThemeTitle => '터미널 테마';

  @override
  String get settingFontFamilyTitle => '글꼴';

  @override
  String get settingFontSizeTitle => '글꼴 크기';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => '커서 스타일';

  @override
  String get cursorStyleBlock => '블록';

  @override
  String get cursorStyleUnderline => '밑줄';

  @override
  String get cursorStyleVerticalBar => '세로줄';

  @override
  String get settingFontLigaturesTitle => '글꼴 합자';

  @override
  String get settingFontLigaturesEnabled => '활성화됨 (예: => 가 ⇒ 로 표시)';

  @override
  String get settingFontLigaturesDisabled => '비활성화됨';

  @override
  String get settingLanguageTitle => '언어';

  @override
  String get settingDefaultSshPortTitle => '기본 SSH 포트';

  @override
  String get settingConnectionTimeoutTitle => '연결 시간 제한';

  @override
  String get settingKeepAliveTitle => '연결 유지 간격';

  @override
  String get dialogDefaultSshPort => '기본 SSH 포트';

  @override
  String get dialogConnectionTimeout => '연결 시간 제한 (초)';

  @override
  String get dialogKeepAliveInterval => '연결 유지 간격 (초)';

  @override
  String settingTimeoutSuffix(String value) {
    return '$value초';
  }

  @override
  String get settingCommandCompletionSoundTitle => '명령 완료 소리';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return '명령 실행 시간이 $threshold초 초과 시 알림';
  }

  @override
  String get settingNotificationThresholdTitle => '알림 임계값';

  @override
  String get dialogNotificationThreshold => '알림 임계값 (초)';

  @override
  String get settingKnownHostsTitle => '알려진 호스트';

  @override
  String get settingKnownHostsSubtitle => '신뢰할 수 있는 SSH 호스트 키 관리';

  @override
  String get settingWorkspacesTitle => '작업 공간';

  @override
  String get settingWorkspacesSubtitle => '탭 레이아웃 저장 및 복원';

  @override
  String get settingPasswordGeneratorTitle => '비밀번호 생성기';

  @override
  String get settingPasswordGeneratorSubtitle => '안전한 비밀번호 생성';

  @override
  String get settingSessionLogsTitle => '세션 로그';

  @override
  String get settingSessionLogsSubtitle => '터미널 세션 기록 보기';

  @override
  String get settingImportSshConfigTitle => 'SSH 설정 가져오기';

  @override
  String get settingImportSshConfigSubtitle => '~/.ssh/config에서 호스트 가져오기';

  @override
  String get settingExportDataTitle => '데이터 내보내기';

  @override
  String get settingExportDataSubtitle => '호스트, 스니펫 및 설정 백업';

  @override
  String get settingImportDataTitle => '데이터 가져오기';

  @override
  String get settingImportDataSubtitle => '백업 파일에서 복원';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle => 'Amazon Web Services에서 인스턴스 가져오기';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle => 'DigitalOcean에서 드롭릿 가져오기';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return '버전 $version';
  }

  @override
  String get settingPrivacyPolicyTitle => '개인정보 처리방침';

  @override
  String get settingPrivacyPolicySubtitle => '데이터 처리 방법';

  @override
  String get settingTermsOfServiceTitle => '서비스 약관';

  @override
  String get settingTermsOfServiceSubtitle => '이용 약관 및 조건';

  @override
  String get themePickerTitle => '테마';

  @override
  String get terminalThemePickerTitle => '터미널 테마';

  @override
  String get terminalThemeCustomThemesHeader => '사용자 정의 테마';

  @override
  String get terminalThemeBuiltInThemesHeader => '기본 제공 테마';

  @override
  String get terminalThemeNewTheme => '새 테마';

  @override
  String get terminalThemeEditTooltip => '편집';

  @override
  String get terminalThemeDeleteTooltip => '삭제';

  @override
  String get fontSizePickerTitle => '터미널 글꼴 크기';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => '초기화';

  @override
  String get fontFamilyPickerTitle => '글꼴';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => '커서 스타일';

  @override
  String get numberInputInvalidNumber => '유효한 숫자를 입력하세요';

  @override
  String numberInputRangeError(String min, String max) {
    return '$min에서 $max 사이여야 합니다';
  }

  @override
  String get exportDataTitle => '데이터 내보내기';

  @override
  String get exportDataMessage =>
      '내보내기 유형을 선택하세요:\n\n일반 텍스트는 호스트, 스니펫 및 설정을 내보냅니다. 개인 키는 포함되지 않습니다.\n\n암호화된 금고 백업은 모든 것을 포함합니다 — 호스트, 키, 비밀번호 및 설정 — 선택한 비밀번호로 보호됩니다.';

  @override
  String get exportDataPlaintext => '일반 텍스트';

  @override
  String get exportDataEncryptedVault => '암호화된 금고';

  @override
  String get exportDataExporting => '데이터 내보내는 중...';

  @override
  String get exportDataEncrypting => '암호화 및 내보내기 중...';

  @override
  String exportedToFile(String filename) {
    return '내보내기 완료: $filename';
  }

  @override
  String exportFailed(String error) {
    return '내보내기 실패: $error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return '금고 내보내기 완료: $filename';
  }

  @override
  String get importDataFileDialogTitle => 'CloudShell 백업 선택';

  @override
  String get importDataPlaintextTitle => '일반 텍스트 백업 가져오기';

  @override
  String get importDataPlaintextMessage =>
      '가져오기는 백업 파일의 데이터를 병합합니다.\n\n기존 레코드는 업데이트되고 새 레코드는 추가됩니다.\n\n참고: 일반 텍스트 백업에는 SSH 개인 키가 포함되지 않습니다.';

  @override
  String get importDataPlaintextImport => '가져오기';

  @override
  String get importDataDecryptTitle => '금고 백업 복호화';

  @override
  String get importDataDecryptMessage => '이 백업을 만들 때 사용한 비밀번호를 입력하세요.';

  @override
  String get importDataDecryptConfirmLabel => '복호화 및 가져오기';

  @override
  String get importDataDecrypting => '복호화 및 가져오기 중...';

  @override
  String importFailed(String error) {
    return '가져오기 실패: $error';
  }

  @override
  String get encryptedExportTitle => '암호화된 내보내기';

  @override
  String get encryptedExportMessage =>
      '금고 백업을 암호화할 강력한 비밀번호를 선택하세요. 백업을 복원하려면 이 비밀번호가 필요합니다.';

  @override
  String get encryptedExportConfirmLabel => '내보내기';

  @override
  String get passwordDialogLabelPassword => '비밀번호';

  @override
  String get passwordDialogLabelConfirmPassword => '비밀번호 확인';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String passwordMinLength(String minLength) {
    return '최소 $minLength자';
  }

  @override
  String get biometricUnlockTitle => '생체 인증 잠금 해제';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => '생체 인증';

  @override
  String get biometricNotAvailable => '이 기기에서는 생체 인증을 사용할 수 없습니다.';

  @override
  String get vaultEncryptionTitle => '암호화';

  @override
  String get vaultNotConfiguredSubtitle => '설정되지 않음 — 로그인하여 활성화';

  @override
  String get vaultEncryptedUnlockedSubtitle => '암호화됨 및 잠금 해제됨';

  @override
  String get vaultLockedSubtitle => '금고가 잠겨 있음';

  @override
  String get vaultMasterPasswordTitle => '마스터 비밀번호';

  @override
  String get vaultLoadingSubtitle => '로딩 중...';

  @override
  String get vaultErrorSubtitle => '금고 상태 로딩 중 오류';

  @override
  String get vaultEncryptionEnabled => '금고 암호화 활성화됨';

  @override
  String get vaultDialogTitle => '금고';

  @override
  String get vaultLockNow => '지금 금고 잠그기';

  @override
  String get vaultLocked => '금고가 잠겼습니다';

  @override
  String get vaultChangePassword => '비밀번호 변경';

  @override
  String get changePasswordTitle => '비밀번호 변경';

  @override
  String get changePasswordCurrentLabel => '현재 비밀번호';

  @override
  String get changePasswordNewLabel => '새 비밀번호';

  @override
  String get changePasswordConfirmLabel => '새 비밀번호 확인';

  @override
  String get changePasswordSubmit => '변경';

  @override
  String get changePasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get changePasswordMinLength => '최소 10자 필요';

  @override
  String get changePasswordSuccess => '마스터 비밀번호가 성공적으로 변경되었습니다';

  @override
  String get autoLockTitle => '자동 잠금';

  @override
  String get autoLockSetUpVaultFirst => '먼저 금고를 설정하세요';

  @override
  String get autoLockDialogTitle => '자동 잠금 시간';

  @override
  String get autoLockTimeoutNever => '사용 안 함';

  @override
  String get autoLockTimeout1Min => '1분';

  @override
  String get autoLockTimeout5Min => '5분';

  @override
  String get autoLockTimeout15Min => '15분';

  @override
  String get autoLockTimeout30Min => '30분';

  @override
  String get autoLockTimeout1Hour => '1시간';

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
  String get syncAccountTitle => '계정';

  @override
  String get syncSignedInDefault => '로그인됨';

  @override
  String get syncLocalOnlyTitle => '로컬 전용';

  @override
  String get syncLocalOnlySubtitle => '기기 간 동기화하려면 업그레이드';

  @override
  String get syncCloudSyncTitle => '클라우드 동기화';

  @override
  String get syncCloudSyncSubtitle => '기기 간 동기화하려면 로그인';

  @override
  String get accountDialogTitle => '계정';

  @override
  String get accountSignOut => '로그아웃';

  @override
  String get accountSignedOut => '로그아웃됨';

  @override
  String get accountDeleteAccount => '계정 삭제';

  @override
  String get deleteAccountTitle => '계정 삭제';

  @override
  String get deleteAccountWarning => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteAccountWillDelete => '다음이 영구적으로 삭제됩니다:';

  @override
  String get deleteAccountItemAccount => '  • 계정 및 로그인 정보';

  @override
  String get deleteAccountItemSyncedData => '  • 서버의 모든 동기화된 데이터';

  @override
  String get deleteAccountItemVault => '  • 암호화 금고 구성';

  @override
  String get deleteAccountLocalDataNote => '로컬 데이터 (호스트, 키, 설정)는 이 기기에 유지됩니다.';

  @override
  String get deleteAccountConfirmPrompt => '확인하려면 DELETE를 입력하세요:';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => '계정 삭제';

  @override
  String get deleteAccountDeleting => '계정 삭제 중...';

  @override
  String get deleteAccountFailedDefault => '계정 삭제 실패';

  @override
  String get deleteAccountSuccess => '계정이 삭제되었습니다. 로컬 데이터는 유지됩니다.';

  @override
  String get syncAutoSyncTitle => '자동 동기화';

  @override
  String get syncUnlockVault => '동기화를 활성화하려면 금고 잠금 해제';

  @override
  String get syncEvery5Minutes => '5분마다 동기화';

  @override
  String get syncDisabled => '동기화 비활성화됨';

  @override
  String get syncNeverSynced => '동기화한 적 없음';

  @override
  String get syncJustNow => '방금';

  @override
  String get syncNowTitle => '지금 동기화';

  @override
  String get syncSyncing => '동기화 중...';

  @override
  String syncResult(int pulled, int pushed) {
    return '동기화 완료: $pulled개 가져옴, $pushed개 보냄';
  }

  @override
  String syncFailed(String error) {
    return '동기화 실패: $error';
  }

  @override
  String get totp2faTitle => '2단계 인증';

  @override
  String get totpSignInToEnable => '활성화하려면 로그인';

  @override
  String get totpEnabled => '활성화됨';

  @override
  String get totpNotConfigured => '설정되지 않음';

  @override
  String get totpDisable2faTitle => '2단계 인증 비활성화?';

  @override
  String get totpDisable2faMessage =>
      '계정에서 2단계 인증이 제거됩니다. 언제든지 다시 활성화할 수 있습니다.';

  @override
  String get totpDisable2faSubmit => '비활성화';

  @override
  String get totpDisabled => '2단계 인증 비활성화됨';

  @override
  String get knownHostsTitle => '알려진 호스트';

  @override
  String get knownHostsEmptyTitle => '알려진 호스트 없음';

  @override
  String get knownHostsEmptySubtitle => '처음 서버에 연결할 때 호스트 키 지문이 여기에 저장됩니다.';

  @override
  String get knownHostsSearchHint => '알려진 호스트 검색...';

  @override
  String get knownHostsLoadingMessage => '알려진 호스트 로딩 중...';

  @override
  String get knownHostsRemoveTitle => '알려진 호스트 제거';

  @override
  String get knownHostsRemoveConfirmLabel => '제거';

  @override
  String get knownHostsMenuRemove => '제거';

  @override
  String get knownHostsFirstSeen => '처음 발견';

  @override
  String get knownHostsLastSeen => '마지막 발견';

  @override
  String knownHostsNoMatchQuery(String query) {
    return '\"$query\"와 일치하는 호스트 없음';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return '$hostname:$port에 대한 신뢰를 제거하시겠습니까?\n\n다음 연결 시 호스트 키를 다시 확인해야 합니다.';
  }

  @override
  String get sessionLogsTitle => '세션 로그';

  @override
  String get sessionLogsDeleteAllTooltip => '모든 로그 삭제';

  @override
  String get sessionLogsEmpty => '세션 로그 없음';

  @override
  String get sessionLogsEnableHint => '터미널 메뉴에서 로깅 활성화';

  @override
  String get sessionLogsView => '보기';

  @override
  String get sessionLogsShare => '공유';

  @override
  String get sessionLogsDelete => '삭제';

  @override
  String get sessionLogsShareSubject => 'CloudShell 세션 로그';

  @override
  String get sessionLogsDeleteAllTitle => '모든 로그를 삭제하시겠습니까?';

  @override
  String get sessionLogsDeleteAllMessage => '모든 세션 로그 파일이 영구적으로 삭제됩니다.';

  @override
  String get sessionLogsDeleteAllConfirm => '모두 삭제';

  @override
  String get sessionLogsShareTooltip => '공유';

  @override
  String sessionLogsReadError(String error) {
    return '파일 읽기 오류: $error';
  }

  @override
  String get customThemeEditTitle => '테마 편집';

  @override
  String get customThemeNewTitle => '새 사용자 정의 테마';

  @override
  String get customThemeSave => '저장';

  @override
  String get customThemeNameLabel => '테마 이름';

  @override
  String get customThemeNameHint => '예: 내 커스텀 테마';

  @override
  String get customThemeSectionTerminalChrome => '터미널 크롬';

  @override
  String get customThemeSectionNormalColors => '일반 색상';

  @override
  String get customThemeSectionBrightColors => '밝은 색상';

  @override
  String get colorBackground => '배경';

  @override
  String get colorForeground => '전경';

  @override
  String get colorCursor => '커서';

  @override
  String get colorSelection => '선택 영역';

  @override
  String get colorBlack => '검정';

  @override
  String get colorRed => '빨강';

  @override
  String get colorGreen => '초록';

  @override
  String get colorYellow => '노랑';

  @override
  String get colorBlue => '파랑';

  @override
  String get colorMagenta => '마젠타';

  @override
  String get colorCyan => '시안';

  @override
  String get colorWhite => '흰색';

  @override
  String get colorBrightBlack => '밝은 검정';

  @override
  String get colorBrightRed => '밝은 빨강';

  @override
  String get colorBrightGreen => '밝은 초록';

  @override
  String get colorBrightYellow => '밝은 노랑';

  @override
  String get colorBrightBlue => '밝은 파랑';

  @override
  String get colorBrightMagenta => '밝은 마젠타';

  @override
  String get colorBrightCyan => '밝은 시안';

  @override
  String get colorBrightWhite => '밝은 흰색';

  @override
  String get customThemePreviewTitle => '터미널 미리보기';

  @override
  String get customThemePreviewSelectedText => '선택된 텍스트 미리보기';

  @override
  String get hexColorLabel => '16진수 색상';

  @override
  String get hexColorPasteTooltip => '붙여넣기';

  @override
  String get hexColorInvalid => '잘못된 16진수';

  @override
  String get hexColorApply => '적용';

  @override
  String get customThemeNameRequired => '테마 이름은 필수입니다';

  @override
  String get sliderHue => '색상';

  @override
  String get sliderSaturation => '채도';

  @override
  String get sliderBrightness => '명도';

  @override
  String get sshConfigImportTitle => 'SSH 설정 가져오기';

  @override
  String get sshConfigImportFailed => 'SSH 설정 읽기 실패';

  @override
  String get sshConfigNoHostsFound => '호스트를 찾을 수 없음';

  @override
  String get sshConfigNoHostsFoundDetail =>
      '~/.ssh/config에서 유효한 호스트 항목을 찾을 수 없습니다';

  @override
  String get sshConfigDeselectAll => '전체 선택 해제';

  @override
  String get sshConfigSelectAll => '전체 선택';

  @override
  String get sshConfigImportKeys => '키 가져오기';

  @override
  String sshConfigFoundHosts(int count) {
    return '~/.ssh/config에서 $count개 호스트 발견';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return '$count개 호스트, $keys개 키 가져옴';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return '가져오기 실패: $error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return '가져오기 ($count)';
  }

  @override
  String get legalScreenLoadError => '문서 로딩 실패';

  @override
  String get workspacesTitle => '작업 공간';

  @override
  String get workspacesSaveCurrent => '현재 저장';

  @override
  String get workspacesEmptyTitle => '저장된 작업 공간 없음';

  @override
  String get workspacesEmptySubtitle =>
      '현재 탭 레이아웃이 자동으로 저장됩니다.\n\"현재 저장\"을 사용하여 이름이 지정된 작업 공간을 만드세요.';

  @override
  String workspacesLoadError(String error) {
    return '작업 공간 로딩 실패: $error';
  }

  @override
  String get workspacesActiveBadge => '활성';

  @override
  String get workspacesNoTerminals => '터미널 없음';

  @override
  String get workspacesJustNow => '방금';

  @override
  String get workspacesMenuSwitchTo => '전환';

  @override
  String get workspacesMenuRename => '이름 변경';

  @override
  String get workspacesMenuDelete => '삭제';

  @override
  String get workspacesSaveTitle => '작업 공간 저장';

  @override
  String get workspacesSaveHint => '작업 공간 이름';

  @override
  String get workspacesSaveSave => '저장';

  @override
  String get workspacesRenameTitle => '작업 공간 이름 변경';

  @override
  String get workspacesRenameHint => '새 이름';

  @override
  String get workspacesRenameSubmit => '이름 변경';

  @override
  String get workspacesDeleteTitle => '작업 공간 삭제?';

  @override
  String get workspacesDeleteSubmit => '삭제';

  @override
  String workspaceTerminalCount(int count) {
    return '$count개 터미널';
  }

  @override
  String workspaceSaved(String name) {
    return '작업 공간 \"$name\" 저장됨';
  }

  @override
  String workspaceSwitching(String name) {
    return '\"$name\"(으)로 전환 중...';
  }

  @override
  String workspaceLoaded(String name) {
    return '작업 공간 \"$name\" 로드됨';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 되돌릴 수 없습니다.';
  }

  @override
  String get awsImportTitle => 'AWS EC2에서 가져오기';

  @override
  String get awsConnectTitle => 'AWS에 연결';

  @override
  String get awsConnectSubtitle => 'EC2 인스턴스를 가져오려면 AWS 자격 증명을 입력하세요.';

  @override
  String get awsAccessKeyIdLabel => '액세스 키 ID';

  @override
  String get awsAccessKeyIdHelper => '예: AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => '비밀 액세스 키';

  @override
  String get awsRegionLabel => '리전';

  @override
  String get awsCredentialsInfo =>
      '자격 증명은 이번 가져오기에만 사용되며 저장되지 않습니다. ec2:DescribeInstances 권한만 있는 IAM 사용자를 사용하세요.';

  @override
  String get awsFetchInstances => '인스턴스 가져오기';

  @override
  String get awsFetchingInstances => '인스턴스 가져오는 중...';

  @override
  String get awsErrorAccessKeyRequired => 'AWS 액세스 키 ID를 입력하세요';

  @override
  String get awsErrorSecretKeyRequired => 'AWS 비밀 액세스 키를 입력하세요';

  @override
  String get awsSelectInstances => '인스턴스 선택';

  @override
  String get awsRunningOnlyFilter => '실행 중만';

  @override
  String get awsNoRunningInstances => '실행 중인 인스턴스 없음';

  @override
  String get awsNoInstances => '인스턴스 없음';

  @override
  String get awsConfigureImport => '가져오기 설정';

  @override
  String get awsDefaultUsernameLabel => '기본 사용자명';

  @override
  String get awsDefaultUsernameHelper =>
      'Amazon Linux: ec2-user, Ubuntu: ubuntu';

  @override
  String get awsInstancesToImport => '가져올 인스턴스:';

  @override
  String get awsImporting => '가져오는 중...';

  @override
  String awsImportResult(int count) {
    return 'AWS EC2에서 $count개 호스트 가져옴';
  }

  @override
  String awsImportHostsButton(int count) {
    return '$count개 호스트 가져오기';
  }

  @override
  String awsNextButton(int count) {
    return '다음 ($count)';
  }

  @override
  String get doImportTitle => 'DigitalOcean에서 가져오기';

  @override
  String get doConnectTitle => 'DigitalOcean에 연결';

  @override
  String get doConnectSubtitle => '드롭릿을 가져오려면 DigitalOcean 개인 액세스 토큰을 입력하세요.';

  @override
  String get doApiTokenLabel => 'API 토큰';

  @override
  String get doApiTokenHelper =>
      'cloud.digitalocean.com/account/api/tokens에서 생성';

  @override
  String get doTokenInfo => '토큰은 이번 가져오기에만 사용되며 저장되지 않습니다.';

  @override
  String get doFetchDroplets => '드롭릿 가져오기';

  @override
  String get doFetchingDroplets => '드롭릿 가져오는 중...';

  @override
  String get doErrorTokenRequired => 'API 토큰을 입력하세요';

  @override
  String get doSelectDroplets => '드롭릿 선택';

  @override
  String get doActiveOnlyFilter => '활성만';

  @override
  String get doNoActiveDroplets => '활성 드롭릿 없음';

  @override
  String get doNoDroplets => '드롭릿 없음';

  @override
  String get doConfigureImport => '가져오기 설정';

  @override
  String get doDefaultUsernameLabel => '기본 사용자명';

  @override
  String get doDefaultUsernameHelper => '모든 가져온 호스트에 사용 (기본값: root)';

  @override
  String get doHostsToImport => '가져올 호스트:';

  @override
  String get doImporting => '가져오는 중...';

  @override
  String doImportResult(int count) {
    return 'DigitalOcean에서 $count개 호스트 가져옴';
  }

  @override
  String doImportHostsButton(int count) {
    return '$count개 호스트 가져오기';
  }

  @override
  String doNextButton(int count) {
    return '다음 ($count)';
  }

  @override
  String get loginSubtitle => '기기 간 동기화하려면 로그인';

  @override
  String get loginEmailLabel => '이메일';

  @override
  String get loginPasswordLabel => '비밀번호';

  @override
  String get loginErrorEmailRequired => '이메일 주소를 입력하세요';

  @override
  String get loginErrorPasswordRequired => '비밀번호를 입력하세요';

  @override
  String get loginSigningIn => '로그인 중...';

  @override
  String get loginSignIn => '로그인';

  @override
  String get loginForgotPassword => '비밀번호 찾기';

  @override
  String get loginCreateAccount => '계정 만들기';

  @override
  String get loginUseLocally => '계정 없이 로컬로 사용';

  @override
  String get signUpSubtitle => '계정 만들기';

  @override
  String get signUpEmailLabel => '이메일';

  @override
  String get signUpPasswordLabel => '비밀번호 (최소 10자)';

  @override
  String get signUpConfirmPasswordLabel => '비밀번호 확인';

  @override
  String get passwordStrengthWeak => '약함';

  @override
  String get passwordStrengthFair => '보통';

  @override
  String get passwordStrengthGood => '양호';

  @override
  String get passwordStrengthStrong => '강함';

  @override
  String get passwordStrengthExcellent => '매우 강함';

  @override
  String get signUpErrorEmailRequired => '이메일 주소를 입력하세요';

  @override
  String get signUpErrorPasswordRequired => '비밀번호를 입력하세요';

  @override
  String get signUpErrorPasswordTooShort => '비밀번호는 최소 10자여야 합니다';

  @override
  String get signUpErrorPasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get signUpErrorTermsRequired => '서비스 약관에 동의해 주세요';

  @override
  String get signUpEncryptionWarning =>
      '데이터는 종단간 암호화됩니다. 비밀번호를 분실하면 계정을 복구할 수 없습니다.';

  @override
  String get signUpTermsPrefix => '동의합니다 ';

  @override
  String get signUpTermsOfService => '서비스 약관';

  @override
  String get signUpTermsAnd => ' 및 ';

  @override
  String get signUpPrivacyPolicy => '개인정보 처리방침';

  @override
  String get signUpCreatingAccount => '계정 생성 중...';

  @override
  String get signUpCreateAccount => '계정 만들기';

  @override
  String get signUpAlreadyHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get signUpSignIn => '로그인';

  @override
  String get signUpEncryptionNote => '암호화: Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => '비밀번호 재설정';

  @override
  String get forgotPasswordInstructions =>
      '계정에 연결된 이메일을 입력하시면 비밀번호 재설정 링크를 보내드립니다.';

  @override
  String get forgotPasswordEmailLabel => '이메일';

  @override
  String get forgotPasswordSending => '전송 중...';

  @override
  String get forgotPasswordSendResetLink => '재설정 링크 보내기';

  @override
  String get forgotPasswordBackToSignIn => '로그인으로 돌아가기';

  @override
  String get forgotPasswordErrorEmailRequired => '이메일 주소를 입력하세요';

  @override
  String get forgotPasswordCheckEmail => '이메일을 확인하세요';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return '$email에 해당하는 계정이 있으면 곧 비밀번호 재설정 링크를 받으실 것입니다.';
  }

  @override
  String get forgotPasswordVaultWarning =>
      '참고: 제로 지식 암호화를 사용합니다. 계정 비밀번호를 재설정해도 금고 마스터 비밀번호는 변경되지 않습니다.';

  @override
  String get forgotPasswordTryAgain => '받지 못하셨나요? 다시 시도';

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
  String get totpSetupTitle => '2단계 인증 설정';

  @override
  String get totpSetupFailed => '2단계 인증 설정 실패';

  @override
  String get totpSetupHeading => '2단계 인증';

  @override
  String get totpSetupInstructions =>
      '인증 앱 (Google Authenticator, Authy 등)으로 이 QR 코드를 스캔하세요.';

  @override
  String get totpSetupManualEntryKey => '수동 입력 키';

  @override
  String get totpSetupSecretCopied => '비밀 키 복사됨';

  @override
  String get totpSetupEnterCode => '앱에서 6자리 코드를 입력하세요:';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => '확인 중...';

  @override
  String get totpSetupVerifyAndEnable => '확인 및 활성화';

  @override
  String get totpSetupEnabled => '2단계 인증이 활성화되었습니다';

  @override
  String get totpSetupErrorCodeLength => '6자리 코드를 입력하세요';

  @override
  String get totpSetupErrorInvalidCode => '잘못된 코드입니다. 인증 앱을 확인하고 다시 시도하세요.';

  @override
  String get totpVerifyHeading => '2단계 인증';

  @override
  String get totpVerifyInstructions => '인증 앱의 6자리 코드를 입력하세요';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => '확인 중...';

  @override
  String get totpVerifySubmit => '확인';

  @override
  String get totpVerifyHelpText =>
      '인증 앱 (Google Authenticator, Authy 등)을 열어 인증 코드를 확인하세요.';

  @override
  String get totpVerifyErrorDefaultFailed => '인증 실패';

  @override
  String get totpVerifyErrorInvalidCode => '잘못된 코드입니다. 다시 시도하세요.';

  @override
  String get adaptiveScaffoldHosts => '호스트';

  @override
  String get adaptiveScaffoldKeys => '키';

  @override
  String get adaptiveScaffoldSnippets => '스니펫';

  @override
  String get adaptiveScaffoldTerminal => '터미널';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => '포트 포워딩';

  @override
  String get adaptiveScaffoldSettings => '설정';

  @override
  String get commandPaletteHint => '호스트, 스니펫 검색 또는 명령 입력...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return '\"$query\"에 대한 결과 없음';
  }

  @override
  String get commandPaletteHostsHeader => '호스트';

  @override
  String get commandPaletteSnippetsHeader => '스니펫';

  @override
  String get commandPaletteActionsHeader => '작업';

  @override
  String get commandPaletteActionNewHost => '새 호스트';

  @override
  String get commandPaletteActionQuickConnect => '빠른 연결';

  @override
  String get commandPaletteActionSettings => '설정';

  @override
  String get commandPaletteActionToggleTheme => '테마 전환';

  @override
  String get shortcutReferenceTitle => '키보드 단축키';

  @override
  String get shortcutCategoryGeneral => '일반';

  @override
  String get shortcutCategoryTerminal => '터미널';

  @override
  String get shortcutCategoryNavigation => '탐색';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => '잠금 해제하여 계속';

  @override
  String get appLockUnlockButton => '잠금 해제';

  @override
  String get appLockUnlockWithBiometrics => '생체 인증으로 잠금 해제';

  @override
  String get appLockBiometricReason => 'CloudShell 잠금 해제를 위한 인증';

  @override
  String get appLockFailed => '인증 실패';

  @override
  String get statusOnline => '온라인';

  @override
  String get statusOffline => '오프라인';

  @override
  String get statusWarning => '경고';

  @override
  String get statusIdle => '유휴';

  @override
  String get vaultUnlockTitle => '금고 잠금 해제';

  @override
  String get vaultUnlockSubtitle => '금고를 잠금 해제하려면 마스터 비밀번호를 입력하세요.';

  @override
  String get vaultUnlockPasswordLabel => '마스터 비밀번호';

  @override
  String get vaultUnlockPasswordHint => '마스터 비밀번호 입력';

  @override
  String get vaultUnlockButton => '잠금 해제';

  @override
  String get vaultUnlockUnlocking => '잠금 해제 중...';

  @override
  String get vaultUnlockBiometricButton => '생체 인증으로 잠금 해제';

  @override
  String get vaultUnlockForgotPassword => '비밀번호 찾기';

  @override
  String get vaultUnlockResetTitle => '금고 초기화?';

  @override
  String get vaultUnlockResetMessage =>
      '초기화하면 모든 암호화된 데이터 (저장된 비밀번호, 개인 키)가 삭제됩니다. 로컬 호스트 및 설정은 유지됩니다.\n\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get vaultUnlockResetConfirm => '금고 초기화';

  @override
  String get vaultUnlockIncorrectPassword => '잘못된 비밀번호';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return '시도 횟수 초과. $seconds초 후에 다시 시도하세요.';
  }

  @override
  String get masterPasswordSetupTitle => '금고 설정';

  @override
  String get masterPasswordSetupSubtitle => '민감한 데이터를 암호화하기 위한 마스터 비밀번호를 만드세요.';

  @override
  String get masterPasswordSetupPasswordLabel => '마스터 비밀번호';

  @override
  String get masterPasswordSetupPasswordHint => '최소 10자';

  @override
  String get masterPasswordSetupConfirmLabel => '비밀번호 확인';

  @override
  String get masterPasswordSetupConfirmHint => '마스터 비밀번호 다시 입력';

  @override
  String get masterPasswordSetupButton => '금고 만들기';

  @override
  String get masterPasswordSetupCreating => '금고 생성 중...';

  @override
  String get masterPasswordSetupMinLength => '최소 10자 필요';

  @override
  String get masterPasswordSetupMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get masterPasswordSetupStrengthWeak => '약함';

  @override
  String get masterPasswordSetupStrengthFair => '보통';

  @override
  String get masterPasswordSetupStrengthGood => '양호';

  @override
  String get masterPasswordSetupStrengthStrong => '강함';

  @override
  String get masterPasswordSetupWarning =>
      '마스터 비밀번호는 복구할 수 없습니다. 적어두고 안전하게 보관하세요.';

  @override
  String get passwordGeneratorTitle => '비밀번호 생성기';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return '길이: $length';
  }

  @override
  String get passwordGeneratorUppercase => '대문자 (A-Z)';

  @override
  String get passwordGeneratorLowercase => '소문자 (a-z)';

  @override
  String get passwordGeneratorNumbers => '숫자 (0-9)';

  @override
  String get passwordGeneratorSymbols => '기호 (!@#...)';

  @override
  String get passwordGeneratorGenerate => '생성';

  @override
  String get passwordGeneratorCopy => '복사';

  @override
  String get passwordGeneratorCopied => '비밀번호 복사됨 (30초 후 자동 삭제)';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bits비트 엔트로피';
  }

  @override
  String get onboardingWelcomeTitle => 'CloudShell에 오신 것을 환영합니다';

  @override
  String get onboardingWelcomeSubtitle => '현대적인 크로스 플랫폼 SSH 클라이언트';

  @override
  String get onboardingSecureTitle => '보안 중심 설계';

  @override
  String get onboardingSecureSubtitle => 'Argon2id + AES-256-GCM 종단간 암호화 금고';

  @override
  String get onboardingTerminalTitle => '강력한 터미널';

  @override
  String get onboardingTerminalSubtitle => '분할 창, 탭, 테마, 스니펫 등';

  @override
  String get onboardingSyncTitle => '어디서나 동기화';

  @override
  String get onboardingSyncSubtitle => '호스트, 키, 스니펫 — 모든 기기에서';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get portForwardingTitle => '포트 포워딩';

  @override
  String get portForwardingAddTooltip => '규칙 추가';

  @override
  String get portForwardingEmptyTitle => '포트 포워딩 규칙 없음';

  @override
  String get portForwardingEmptySubtitle => 'SSH 연결을 통해 트래픽을 터널링하는 규칙을 만드세요.';

  @override
  String get portForwardingEmptyAction => '규칙 추가';

  @override
  String get portForwardingActiveHeader => '활성';

  @override
  String get portForwardingSavedHeader => '저장된 규칙';

  @override
  String get portForwardingTypeLocal => '로컬';

  @override
  String get portForwardingTypeRemote => '원격';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => '중지';

  @override
  String get portForwardingStart => '시작';

  @override
  String get portForwardingMenuEdit => '편집';

  @override
  String get portForwardingMenuDelete => '삭제';

  @override
  String get portForwardingDeleteDialogTitle => '규칙 삭제';

  @override
  String get portForwardingDeleteDialogMessage => '이 포트 포워딩 규칙을 삭제하시겠습니까?';

  @override
  String get portForwardingLoading => '포트 포워딩 규칙 로딩 중...';

  @override
  String get portForwardFormTitleNew => '새 포트 포워드';

  @override
  String get portForwardFormTitleEdit => '포트 포워드 편집';

  @override
  String get portForwardFormLabelField => '레이블';

  @override
  String get portForwardFormLabelHint => '예: 데이터베이스 터널';

  @override
  String get portForwardFormTypeField => '유형';

  @override
  String get portForwardFormTypeLocal => '로컬';

  @override
  String get portForwardFormTypeRemote => '원격';

  @override
  String get portForwardFormTypeDynamic => '동적 (SOCKS)';

  @override
  String get portForwardFormHostField => '호스트';

  @override
  String get portForwardFormSelectHost => '호스트 선택';

  @override
  String get portForwardFormNoHostsAvailable => '사용 가능한 호스트 없음. 먼저 호스트를 만드세요.';

  @override
  String get portForwardFormCouldNotLoadHosts => '호스트를 로드할 수 없습니다.';

  @override
  String get portForwardFormLocalPortField => '로컬 포트';

  @override
  String get portForwardFormRemotePortField => '원격 포트';

  @override
  String get portForwardFormDestHostField => '대상 호스트';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => '대상 포트';

  @override
  String get portForwardFormDestPortHint => '예: 5432';

  @override
  String get portForwardFormPortHint => '예: 8080';

  @override
  String get portForwardFormAutoStart => '연결 시 자동 시작';

  @override
  String get portForwardFormAutoStartSubtitle => '호스트에 연결할 때 이 터널을 자동으로 시작합니다.';

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
  String get languageSystem => '시스템 기본값';
}
