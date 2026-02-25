// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get close => 'Schließen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get back => 'Zurück';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get done => 'Fertig';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get search => 'Suchen';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get none => 'Keine';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get hostsTitle => 'Hosts';

  @override
  String get hostsAddTooltip => 'Host hinzufügen';

  @override
  String get hostsSearchHint => 'Hosts suchen...';

  @override
  String get hostsEmptyTitle => 'Noch keine Hosts';

  @override
  String get hostsEmptySubtitle =>
      'Füge deinen ersten SSH-Server hinzu, um loszulegen.';

  @override
  String get hostsEmptyAction => 'Host hinzufügen';

  @override
  String hostsNoMatchQuery(String query) {
    return 'Keine Hosts stimmen mit \"$query\" überein';
  }

  @override
  String get hostsLoadingMessage => 'Hosts werden geladen...';

  @override
  String get hostsRecentHeader => 'ZULETZT VERWENDET';

  @override
  String get hostsGroupsHeader => 'GRUPPEN';

  @override
  String get hostsFavoritesHeader => 'FAVORITEN';

  @override
  String get hostsAllHostsHeader => 'ALLE HOSTS';

  @override
  String get hostsUngroupedHeader => 'NICHT GRUPPIERT';

  @override
  String get hostsDeleteDialogTitle => 'Host löschen';

  @override
  String hostsDeleteDialogMessage(String name) {
    return 'Bist du sicher, dass du \"$name\" löschen möchtest?';
  }

  @override
  String get hostsMenuEdit => 'Bearbeiten';

  @override
  String get hostsMenuDelete => 'Löschen';

  @override
  String get hostsMenuConnect => 'Verbinden';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return 'Letzte Verbindung $time';
  }

  @override
  String get hostsNeverConnected => 'Nie verbunden';

  @override
  String get hostsJustNow => 'Gerade eben';

  @override
  String get hostFormTitleNew => 'Neuer Host';

  @override
  String get hostFormTitleEdit => 'Host bearbeiten';

  @override
  String get hostFormSave => 'Speichern';

  @override
  String get hostFormLabelField => 'Bezeichnung';

  @override
  String get hostFormLabelHint => 'z.B. Produktionsserver';

  @override
  String get hostFormLabelRequired => 'Bezeichnung ist erforderlich';

  @override
  String get hostFormHostnameField => 'Hostname';

  @override
  String get hostFormHostnameHint => 'z.B. 192.168.1.100 oder beispiel.de';

  @override
  String get hostFormHostnameRequired => 'Hostname ist erforderlich';

  @override
  String get hostFormPortField => 'Port';

  @override
  String get hostFormUsernameField => 'Benutzername';

  @override
  String get hostFormUsernameHint => 'z.B. root';

  @override
  String get hostFormUsernameRequired => 'Benutzername ist erforderlich';

  @override
  String get hostFormPasswordField => 'Passwort';

  @override
  String get hostFormPasswordHint => 'Passwort eingeben';

  @override
  String get hostFormAuthMethodField => 'Authentifizierungsmethode';

  @override
  String get hostFormAuthMethodKey => 'Schlüssel';

  @override
  String get hostFormAuthMethodPassword => 'Passwort';

  @override
  String get hostFormAuthMethodKeyAndPassword => 'Schlüssel + Passwort';

  @override
  String get hostFormKeyField => 'SSH-Schlüssel';

  @override
  String get hostFormKeyNone => 'Keiner';

  @override
  String get hostFormGroupField => 'Gruppe';

  @override
  String get hostFormGroupNone => 'Keine Gruppe';

  @override
  String get hostFormTagsField => 'Tags';

  @override
  String get hostFormTagsHint => 'Tags hinzufügen (kommagetrennt)';

  @override
  String get hostFormAdvancedSection => 'Erweitert';

  @override
  String get hostFormJumpHostField => 'Jump-Host (Proxy)';

  @override
  String get hostFormJumpHostNone => 'Keiner (Direktverbindung)';

  @override
  String get hostFormKeepAliveField => 'Keep Alive (Sekunden)';

  @override
  String get hostFormStartupCommandField => 'Startbefehl';

  @override
  String get hostFormStartupCommandHint =>
      'Nach Verbindung ausführen (optional)';

  @override
  String get hostFormNotesField => 'Notizen';

  @override
  String get hostFormNotesHint => 'Optionale Notizen zu diesem Host';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => 'Seriell';

  @override
  String get hostFormSerialPortField => 'Serieller Port';

  @override
  String get hostFormSerialPortNone => 'Port auswählen';

  @override
  String get hostFormSerialNoPortsAvailable =>
      'Keine seriellen Ports verfügbar';

  @override
  String get hostFormSerialBaudRateField => 'Baudrate';

  @override
  String get hostFormSerialDataBitsField => 'Datenbits';

  @override
  String get hostFormSerialStopBitsField => 'Stoppbits';

  @override
  String get hostFormSerialParityField => 'Parität';

  @override
  String get hostFormSerialFlowControlField => 'Flusskontrolle';

  @override
  String get hostFormTestConnection => 'Verbindung testen';

  @override
  String get hostFormTestConnectionSuccess => 'Verbindung erfolgreich!';

  @override
  String hostFormTestConnectionFailed(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get hostDetailTitle => 'Host-Details';

  @override
  String get hostDetailConnect => 'Verbinden';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => 'Bearbeiten';

  @override
  String get hostDetailDeleteTooltip => 'Löschen';

  @override
  String get hostDetailFavoriteTooltip => 'Favorit';

  @override
  String get hostDetailSectionConnection => 'Verbindung';

  @override
  String get hostDetailSectionAuthentication => 'Authentifizierung';

  @override
  String get hostDetailSectionAdvanced => 'Erweitert';

  @override
  String get hostDetailSectionTags => 'Tags';

  @override
  String get hostDetailSectionNotes => 'Notizen';

  @override
  String get hostDetailLabelHostname => 'Hostname';

  @override
  String get hostDetailLabelPort => 'Port';

  @override
  String get hostDetailLabelUsername => 'Benutzername';

  @override
  String get hostDetailLabelAuthMethod => 'Authentifizierungsmethode';

  @override
  String get hostDetailLabelKey => 'Schlüssel';

  @override
  String get hostDetailLabelGroup => 'Gruppe';

  @override
  String get hostDetailLabelJumpHost => 'Jump-Host';

  @override
  String get hostDetailLabelKeepAlive => 'Keep Alive';

  @override
  String get hostDetailLabelStartupCommand => 'Startbefehl';

  @override
  String get hostDetailLabelProtocol => 'Protokoll';

  @override
  String get hostDetailLabelCreated => 'Erstellt';

  @override
  String get hostDetailLabelUpdated => 'Aktualisiert';

  @override
  String get hostDetailLabelLastConnected => 'Letzte Verbindung';

  @override
  String get hostDetailNotFound => 'Host nicht gefunden';

  @override
  String get hostDetailLoading => 'Host wird geladen...';

  @override
  String get hostDetailDeleteDialogTitle => 'Host löschen';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return 'Bist du sicher, dass du \"$name\" löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get quickConnectTitle => 'Schnellverbindung';

  @override
  String get quickConnectHint => 'benutzer@host:port';

  @override
  String get quickConnectHelperText => 'z.B. root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => 'Host speichern';

  @override
  String get quickConnectConnect => 'Verbinden';

  @override
  String get quickConnectInvalidFormat =>
      'Ungültiges Format. Verwende benutzer@host oder benutzer@host:port';

  @override
  String get groupFormTitleNew => 'Neue Gruppe';

  @override
  String get groupFormTitleEdit => 'Gruppe bearbeiten';

  @override
  String get groupFormNameField => 'Gruppenname';

  @override
  String get groupFormNameHint => 'z.B. Produktion';

  @override
  String get groupFormNameRequired => 'Gruppenname ist erforderlich';

  @override
  String get groupFormParentField => 'Übergeordnete Gruppe';

  @override
  String get groupFormParentNone => 'Keine (überste Ebene)';

  @override
  String get groupFormDeleteDialogTitle => 'Gruppe löschen';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return '\"$name\" löschen? Hosts in dieser Gruppe werden nicht mehr gruppiert.';
  }

  @override
  String get hostKeyVerifyChangedTitle => 'Host-Schlüssel geändert';

  @override
  String get hostKeyVerifyUnknownTitle => 'Unbekannter Host';

  @override
  String get hostKeyVerifyChangedWarning =>
      'WARNUNG: Der Host-Schlüssel dieses Servers hat sich geändert. Dies könnte auf einen Man-in-the-Middle-Angriff hindeuten.';

  @override
  String get hostKeyVerifyUnknownMessage =>
      'Die Authentizität dieses Hosts kann nicht überprüft werden. Bist du sicher, dass du die Verbindung fortsetzen möchtest?';

  @override
  String get hostKeyVerifyLabelHost => 'Host';

  @override
  String get hostKeyVerifyLabelKeyType => 'Schlüsseltyp';

  @override
  String get hostKeyVerifyLabelFingerprint => 'Fingerabdruck:';

  @override
  String get hostKeyVerifyFingerprintCopied =>
      'Fingerabdruck kopiert (wird in 30s automatisch gelöscht)';

  @override
  String get hostKeyVerifyTrustAnyway => 'Trotzdem vertrauen';

  @override
  String get hostKeyVerifyTrustAndConnect => 'Vertrauen & Verbinden';

  @override
  String get keysTitle => 'SSH-Schlüssel';

  @override
  String get keysAddTooltip => 'Schlüssel importieren';

  @override
  String get keysImportTooltip => 'Schlüssel importieren';

  @override
  String get keysEmptyTitle => 'Keine SSH-Schlüssel';

  @override
  String get keysEmptySubtitle =>
      'Importiere deine SSH-Schlüssel, um dich bei Servern zu authentifizieren.';

  @override
  String get keysEmptyAction => 'Schlüssel importieren';

  @override
  String get keysSearchHint => 'Schlüssel suchen...';

  @override
  String keysNoMatchQuery(String query) {
    return 'Keine Schlüssel stimmen mit \"$query\" überein';
  }

  @override
  String get keysLoadingMessage => 'Schlüssel werden geladen...';

  @override
  String get keysDeleteDialogTitle => 'Schlüssel löschen';

  @override
  String keysDeleteDialogMessage(String name) {
    return '\"$name\" löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get keysMenuDelete => 'Löschen';

  @override
  String keysAssociatedHosts(int count) {
    return '$count Host(s)';
  }

  @override
  String get keyDetailTitle => 'Schlüsseldetails';

  @override
  String get keyDetailEditTooltip => 'Bearbeiten';

  @override
  String get keyDetailDeleteTooltip => 'Löschen';

  @override
  String get keyDetailSectionPublicKey => 'Öffentlicher Schlüssel';

  @override
  String get keyDetailCopyPublicKey => 'Öffentlichen Schlüssel kopieren';

  @override
  String get keyDetailSectionFingerprint => 'Fingerabdruck';

  @override
  String get keyDetailSectionAssociatedHosts => 'Zugeordnete Hosts';

  @override
  String get keyDetailSectionDetails => 'Details';

  @override
  String get keyDetailLabelType => 'Typ';

  @override
  String get keyDetailLabelBits => 'Bits';

  @override
  String get keyDetailLabelCreated => 'Erstellt';

  @override
  String get keyDetailNotFound => 'Schlüssel nicht gefunden';

  @override
  String get keyDetailLoading => 'Schlüssel wird geladen...';

  @override
  String get keyDetailPublicKeyCopied =>
      'Öffentlicher Schlüssel kopiert (wird in 30s automatisch gelöscht)';

  @override
  String get keyDetailFingerprintCopied =>
      'Fingerabdruck kopiert (wird in 30s automatisch gelöscht)';

  @override
  String get keyDetailNoAssociatedHosts =>
      'Kein Host verwendet diesen Schlüssel';

  @override
  String get keyImportTitle => 'SSH-Schlüssel importieren';

  @override
  String get keyImportButton => 'Importieren';

  @override
  String get keyImportButtonImporting => 'Wird importiert...';

  @override
  String get keyImportButtonImportKey => 'Schlüssel importieren';

  @override
  String get keyImportLabelField => 'Bezeichnung';

  @override
  String get keyImportLabelHint => 'z.B. Mein Server-Schlüssel';

  @override
  String get keyImportPassphraseField => 'Passphrase (optional)';

  @override
  String get keyImportPassphraseHint =>
      'Leer lassen, wenn der Schlüssel nicht verschlüsselt ist';

  @override
  String get keyImportPrivateKeyField => 'Privater Schlüssel';

  @override
  String get keyImportFromFile => 'Aus Datei';

  @override
  String get keyImportPaste => 'Einfügen';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\noder PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      'Unterstützte Formate: OpenSSH, PEM, PuTTY PPK (RSA, Ed25519, ECDSA). Dein privater Schlüssel wird sicher im Plattform-Schlüsselbund gespeichert und verlässt dieses Gerät nie.';

  @override
  String keyImportFailedToReadFile(String error) {
    return 'Datei konnte nicht gelesen werden: $error';
  }

  @override
  String get keyImportClipboardEmpty => 'Zwischenablage ist leer';

  @override
  String get keyImportPasteOrSelectKey =>
      'Bitte füge einen privaten Schlüssel ein oder wähle einen aus';

  @override
  String keyImportSuccess(String fingerprint) {
    return 'Schlüssel importiert: $fingerprint';
  }

  @override
  String get terminalNoActiveSessions => 'Keine aktiven Sitzungen';

  @override
  String get terminalQuickConnect => 'Schnellverbindung';

  @override
  String get terminalRecentHostsHeader => 'ZULETZT VERWENDETE HOSTS';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  Neuer Host  ·  ⌘⇧N  Schnellverbindung  ·  ⌘K  Suchen';

  @override
  String get terminalMobileShortcutHint =>
      'Tippe auf + um dich mit einem Host zu verbinden';

  @override
  String terminalConnectingToHost(String label) {
    return 'Verbinde mit $label...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return 'Verbindung wird wiederhergestellt... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => 'Abbrechen';

  @override
  String get terminalConnectionLost => 'Verbindung verloren';

  @override
  String get terminalSearchHint => 'Terminal durchsuchen...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => 'Schließen (Esc)';

  @override
  String get terminalConnectionInfoTitle => 'Verbindungsinfo';

  @override
  String get terminalStatusReconnecting =>
      'Verbindung wird wiederhergestellt...';

  @override
  String get terminalStatusConnected => 'Verbunden';

  @override
  String get terminalStatusDisconnected => 'Getrennt';

  @override
  String get terminalInfoLabelHost => 'Host';

  @override
  String get terminalInfoLabelAddress => 'Adresse';

  @override
  String get terminalInfoLabelUsername => 'Benutzername';

  @override
  String get terminalInfoLabelProxyJump => 'Proxy Jump';

  @override
  String get terminalInfoValueProxyJump => 'Über Bastion-Host';

  @override
  String get terminalInfoLabelUptime => 'Betriebszeit';

  @override
  String get terminalInfoLabelConnectedAt => 'Verbunden seit';

  @override
  String get terminalInfoLabelSessionId => 'Sitzungs-ID';

  @override
  String get terminalInfoLabelSplit => 'Teilung';

  @override
  String get terminalInfoValueSplitHorizontal => 'Horizontal (2 Bereiche)';

  @override
  String get terminalInfoValueSplitVertical => 'Vertikal (2 Bereiche)';

  @override
  String get terminalInfoLabelLogging => 'Protokollierung';

  @override
  String get terminalInfoValueLoggingActive => 'Aktiv';

  @override
  String get terminalStatusBarDefaultDuration => '0:00';

  @override
  String get terminalStatusBarLogActive => 'LOG';

  @override
  String get terminalStatusBarLogInactive => 'Log';

  @override
  String get terminalBroadcastOnTooltip =>
      'Broadcast EIN — tippen zum Umschalten, lange drücken für Optionen';

  @override
  String get terminalBroadcastOffTooltip =>
      'Broadcast AUS — tippen zum Umschalten, lange drücken für Optionen';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return 'CAST ($count)';
  }

  @override
  String get terminalBroadcastCastActive => 'CAST';

  @override
  String get terminalBroadcastCastInactive => 'Cast';

  @override
  String get terminalHeaderBackTooltip => 'Zurück';

  @override
  String get terminalHeaderNewConnectionTooltip => 'Neue Verbindung';

  @override
  String get terminalHeaderSnippetsTooltip => 'Snippets';

  @override
  String get terminalHeaderCopyTooltip => 'Auswahl kopieren';

  @override
  String get terminalHeaderPasteTooltip => 'Einfügen';

  @override
  String get terminalHeaderNewTabTooltip => 'Neuer Tab';

  @override
  String get extraKeyEsc => 'ESC';

  @override
  String get extraKeyTab => 'TAB';

  @override
  String get extraKeyCtl => 'CTL';

  @override
  String get extraKeyAlt => 'ALT';

  @override
  String get broadcastPanelTitle => 'Eingabe-Broadcast';

  @override
  String get broadcastPanelDisable => 'Deaktivieren';

  @override
  String get broadcastPanelDescription =>
      'Wähle, welche Terminals deine Tastatureingaben empfangen.';

  @override
  String get broadcastPanelBroadcastToAll => 'An alle senden';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count verbundene Sitzungen';
  }

  @override
  String get broadcastPanelActiveLabel => 'AKTIV';

  @override
  String get broadcastPanelTabConnected => 'Verbunden';

  @override
  String get broadcastPanelTabDisconnected => 'Getrennt';

  @override
  String get snippetsTitle => 'Snippets';

  @override
  String get snippetsAddTooltip => 'Snippet hinzufügen';

  @override
  String get snippetsEmptyTitle => 'Keine Snippets';

  @override
  String get snippetsEmptySubtitle =>
      'Speichere häufig verwendete Befehle für schnellen Zugriff.';

  @override
  String get snippetsEmptyAction => 'Snippet hinzufügen';

  @override
  String get snippetsSearchHint => 'Snippets suchen...';

  @override
  String snippetsNoMatchQuery(String query) {
    return 'Keine Snippets stimmen mit \"$query\" überein';
  }

  @override
  String get snippetsLoadingMessage => 'Snippets werden geladen...';

  @override
  String get snippetsUncategorized => 'Unkategorisiert';

  @override
  String get snippetsHasVariables => 'Hat Variablen';

  @override
  String get snippetsCopyCommandTooltip => 'Befehl kopieren';

  @override
  String get snippetsMenuEdit => 'Bearbeiten';

  @override
  String get snippetsMenuDelete => 'Löschen';

  @override
  String get snippetsCopiedMessage =>
      'Befehl kopiert (wird in 30s automatisch gelöscht)';

  @override
  String get snippetsDeleteDialogTitle => 'Snippet löschen';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return 'Bist du sicher, dass du \"$name\" löschen möchtest?';
  }

  @override
  String get snippetDetailNotFound => 'Snippet nicht gefunden';

  @override
  String get snippetDetailLoading => 'Snippet wird geladen...';

  @override
  String get snippetDetailEditTooltip => 'Bearbeiten';

  @override
  String get snippetDetailDeleteTooltip => 'Löschen';

  @override
  String get snippetDetailSectionCommand => 'Befehl';

  @override
  String get snippetDetailCopyCommandTooltip => 'Befehl kopieren';

  @override
  String get snippetDetailSectionVariables => 'Variablen';

  @override
  String get snippetDetailSectionDescription => 'Beschreibung';

  @override
  String get snippetDetailSectionDetails => 'Details';

  @override
  String get snippetDetailLabelCreated => 'Erstellt';

  @override
  String get snippetDetailLabelUpdated => 'Aktualisiert';

  @override
  String get snippetDetailCopiedMessage =>
      'Befehl kopiert (wird in 30s automatisch gelöscht)';

  @override
  String get snippetFormTitleEdit => 'Snippet bearbeiten';

  @override
  String get snippetFormTitleNew => 'Neues Snippet';

  @override
  String get snippetFormNameLabel => 'Snippet-Name';

  @override
  String get snippetFormNameHint => 'z.B. Speicherplatz prüfen';

  @override
  String get snippetFormNameRequired => 'Name ist erforderlich';

  @override
  String get snippetFormCommandLabel => 'Befehl';

  @override
  String get snippetFormCommandHint =>
      'z.B. df -h\nVerwende Variablen in doppelten geschweiften Klammern als Platzhalter';

  @override
  String get snippetFormCommandRequired => 'Befehl ist erforderlich';

  @override
  String get snippetFormVariablesLabel => 'Variablen:';

  @override
  String get snippetFormCategoryLabel => 'Kategorie (optional)';

  @override
  String get snippetFormCategoryHint => 'z.B. System, Docker, Netzwerk';

  @override
  String get snippetFormDescriptionLabel => 'Beschreibung (optional)';

  @override
  String get snippetFormDescriptionHint => 'Was macht dieser Befehl?';

  @override
  String get snippetFormSaveButtonEdit => 'Snippet aktualisieren';

  @override
  String get snippetFormSaveButtonNew => 'Snippet erstellen';

  @override
  String snippetFormSaveError(String error) {
    return 'Snippet konnte nicht gespeichert werden: $error';
  }

  @override
  String get snippetPickerSearchHint => 'Snippets suchen...';

  @override
  String get snippetPickerEmptyMessage =>
      'Keine Snippets. Erstelle eines in der Snippets-Ansicht.';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return 'Keine Snippets stimmen mit \"$query\" überein';
  }

  @override
  String get snippetPickerLoadingError =>
      'Snippets konnten nicht geladen werden';

  @override
  String get snippetPickerVariableDialogTitle => 'Variablen ausfüllen';

  @override
  String snippetPickerVariableHint(String variable) {
    return 'Wert für $variable eingeben';
  }

  @override
  String get snippetPickerVariableInsert => 'Einfügen';

  @override
  String get sftpSelectHostHint => 'Host auswählen...';

  @override
  String get sftpConnecting => 'Verbindung wird hergestellt...';

  @override
  String get sftpUploadLabel => 'Hochladen';

  @override
  String get sftpDownloadLabel => 'Herunterladen';

  @override
  String get sftpNoSavedHostsTitle => 'Keine gespeicherten Hosts';

  @override
  String get sftpNoSavedHostsSubtitle =>
      'Füge zuerst einen Host hinzu und komme dann zurück, um Dateien zu übertragen.';

  @override
  String get sftpFailedToLoadHosts => 'Hosts konnten nicht geladen werden';

  @override
  String sftpFailedToConnect(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get sftpConnectToHostFirst => 'Verbinde zuerst mit einem Host';

  @override
  String get sftpDropFilesToUpload => 'Dateien zum Hochladen ablegen';

  @override
  String get sftpTabLocal => 'Lokal';

  @override
  String get sftpTabRemote => 'Remote';

  @override
  String get sftpPaneHeaderLocal => 'LOKAL';

  @override
  String get sftpPaneHeaderRemote => 'REMOTE';

  @override
  String get sftpLocalPermissionDenied => 'Zugriff verweigert';

  @override
  String get sftpLocalEmptyFolder => 'Leerer Ordner';

  @override
  String get sftpLocalCannotOpenFolder => 'Ordner kann nicht geöffnet werden';

  @override
  String get sftpRemoteSelectHost => 'Wähle einen Host zum Durchsuchen';

  @override
  String get sftpRemoteSelectHostSubtitle =>
      'Verwende das Dropdown oben, um einen verbundenen Server auszuwählen';

  @override
  String get sftpRemoteEmptyDirectory => 'Leeres Verzeichnis';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return 'Ordner kann nicht geöffnet werden: $message';
  }

  @override
  String get sftpRemoteReadOnly => 'Schreibgeschützt';

  @override
  String get sftpRemoteNewFolderTooltip => 'Neuer Ordner';

  @override
  String get sftpHideHiddenFiles => 'Versteckte Dateien ausblenden';

  @override
  String get sftpShowHiddenFiles => 'Versteckte Dateien anzeigen';

  @override
  String get sftpGoUp => 'Nach oben';

  @override
  String get sftpNewFolderDialogTitle => 'Neuer Ordner';

  @override
  String get sftpNewFolderDialogLabel => 'Ordnername';

  @override
  String get sftpNewFolderDialogHint => 'z.B. neuer-ordner';

  @override
  String get sftpNewFolderDialogCreate => 'Erstellen';

  @override
  String get sftpFileMenuEdit => 'Bearbeiten';

  @override
  String get sftpFileMenuPermissions => 'Berechtigungen';

  @override
  String get sftpFileMenuDelete => 'Löschen';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return 'Berechtigungen — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => 'Oktal: ';

  @override
  String get sftpPermissionsLabelUser => 'Benutzer';

  @override
  String get sftpPermissionsLabelGroup => 'Gruppe';

  @override
  String get sftpPermissionsLabelOther => 'Andere';

  @override
  String get sftpPermissionsBitRead => 'Lesen';

  @override
  String get sftpPermissionsBitWrite => 'Schreiben';

  @override
  String get sftpPermissionsBitExec => 'Ausführen';

  @override
  String get sftpPermissionsApply => 'Anwenden';

  @override
  String get sftpTransfersHeader => 'Übertragungen';

  @override
  String get sftpTransfersClearDone => 'Abgeschlossene löschen';

  @override
  String get sftpTransferStatusDone => 'Fertig';

  @override
  String get sftpTransferStatusFailed => 'Fehlgeschlagen';

  @override
  String get remoteEditorSaveTooltip => 'Speichern';

  @override
  String get remoteEditorFileSaved => 'Datei gespeichert';

  @override
  String remoteEditorFailedToSave(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle => 'Ungespeicherte Änderungen';

  @override
  String get remoteEditorUnsavedChangesMessage =>
      'Du hast ungespeicherte Änderungen. Verwerfen?';

  @override
  String get remoteEditorDiscard => 'Verwerfen';

  @override
  String get remoteEditorFailedToLoadFile =>
      'Datei konnte nicht geladen werden';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get sectionAppearance => 'Darstellung';

  @override
  String get sectionConnection => 'Verbindung';

  @override
  String get sectionNotifications => 'Benachrichtigungen';

  @override
  String get sectionSecurity => 'Sicherheit';

  @override
  String get sectionTools => 'Werkzeuge';

  @override
  String get sectionData => 'Daten';

  @override
  String get sectionCloudImport => 'Cloud-Import';

  @override
  String get sectionSync => 'Synchronisation';

  @override
  String get sectionAbout => 'Über';

  @override
  String get settingThemeTitle => 'Design';

  @override
  String get themeModeDark => 'Dunkel';

  @override
  String get themeModeLight => 'Hell';

  @override
  String get themeModeSystem => 'System';

  @override
  String get settingTerminalThemeTitle => 'Terminal-Design';

  @override
  String get settingFontFamilyTitle => 'Schriftfamilie';

  @override
  String get settingFontSizeTitle => 'Schriftgröße';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => 'Cursorstil';

  @override
  String get cursorStyleBlock => 'Block';

  @override
  String get cursorStyleUnderline => 'Unterstrich';

  @override
  String get cursorStyleVerticalBar => 'Senkrechter Strich';

  @override
  String get settingFontLigaturesTitle => 'Schriftligaturen';

  @override
  String get settingFontLigaturesEnabled => 'Aktiviert (z.B. => wird zu ⇒)';

  @override
  String get settingFontLigaturesDisabled => 'Deaktiviert';

  @override
  String get settingLanguageTitle => 'Sprache';

  @override
  String get settingDefaultSshPortTitle => 'Standard-SSH-Port';

  @override
  String get settingConnectionTimeoutTitle => 'Verbindungs-Timeout';

  @override
  String get settingKeepAliveTitle => 'Keep-Alive-Intervall';

  @override
  String get dialogDefaultSshPort => 'Standard-SSH-Port';

  @override
  String get dialogConnectionTimeout => 'Verbindungs-Timeout (Sekunden)';

  @override
  String get dialogKeepAliveInterval => 'Keep-Alive-Intervall (Sekunden)';

  @override
  String settingTimeoutSuffix(String value) {
    return '${value}s';
  }

  @override
  String get settingCommandCompletionSoundTitle => 'Befehlsabschluss-Ton';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return 'Benachrichtigung bei Befehlen > ${threshold}s';
  }

  @override
  String get settingNotificationThresholdTitle => 'Benachrichtigungsschwelle';

  @override
  String get dialogNotificationThreshold =>
      'Benachrichtigungsschwelle (Sekunden)';

  @override
  String get settingKnownHostsTitle => 'Bekannte Hosts';

  @override
  String get settingKnownHostsSubtitle =>
      'Vertrauenswürdige SSH-Host-Schlüssel verwalten';

  @override
  String get settingWorkspacesTitle => 'Arbeitsbereiche';

  @override
  String get settingWorkspacesSubtitle =>
      'Tab-Layouts speichern und wiederherstellen';

  @override
  String get settingPasswordGeneratorTitle => 'Passwortgenerator';

  @override
  String get settingPasswordGeneratorSubtitle =>
      'Sichere Passwörter generieren';

  @override
  String get settingSessionLogsTitle => 'Sitzungsprotokolle';

  @override
  String get settingSessionLogsSubtitle =>
      'Terminal-Sitzungsaufzeichnungen ansehen';

  @override
  String get settingImportSshConfigTitle => 'SSH-Konfiguration importieren';

  @override
  String get settingImportSshConfigSubtitle =>
      'Hosts aus ~/.ssh/config importieren';

  @override
  String get settingExportDataTitle => 'Daten exportieren';

  @override
  String get settingExportDataSubtitle =>
      'Hosts, Snippets und Einstellungen sichern';

  @override
  String get settingImportDataTitle => 'Daten importieren';

  @override
  String get settingImportDataSubtitle =>
      'Aus einer Sicherungsdatei wiederherstellen';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle =>
      'Instanzen von Amazon Web Services importieren';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle =>
      'Droplets von DigitalOcean importieren';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return 'Version $version';
  }

  @override
  String get settingPrivacyPolicyTitle => 'Datenschutzrichtlinie';

  @override
  String get settingPrivacyPolicySubtitle => 'Wie deine Daten behandelt werden';

  @override
  String get settingTermsOfServiceTitle => 'Nutzungsbedingungen';

  @override
  String get settingTermsOfServiceSubtitle =>
      'Nutzungsbedingungen und Konditionen';

  @override
  String get themePickerTitle => 'Design';

  @override
  String get terminalThemePickerTitle => 'Terminal-Design';

  @override
  String get terminalThemeCustomThemesHeader => 'BENUTZERDEFINIERTE DESIGNS';

  @override
  String get terminalThemeBuiltInThemesHeader => 'INTEGRIERTE DESIGNS';

  @override
  String get terminalThemeNewTheme => 'Neues Design';

  @override
  String get terminalThemeEditTooltip => 'Bearbeiten';

  @override
  String get terminalThemeDeleteTooltip => 'Löschen';

  @override
  String get fontSizePickerTitle => 'Terminal-Schriftgröße';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => 'Zurücksetzen';

  @override
  String get fontFamilyPickerTitle => 'Schriftfamilie';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => 'Cursorstil';

  @override
  String get numberInputInvalidNumber => 'Gültige Zahl eingeben';

  @override
  String numberInputRangeError(String min, String max) {
    return 'Muss zwischen $min und $max liegen';
  }

  @override
  String get exportDataTitle => 'Daten exportieren';

  @override
  String get exportDataMessage =>
      'Wähle den Exporttyp:\n\nKlartext exportiert Hosts, Snippets und Einstellungen. Private Schlüssel werden NICHT eingeschlossen.\n\nVerschlüsselte Tresor-Sicherung enthält alles — Hosts, Schlüssel, Passwörter und Einstellungen — geschützt mit einem Passwort deiner Wahl.';

  @override
  String get exportDataPlaintext => 'Klartext';

  @override
  String get exportDataEncryptedVault => 'Verschlüsselter Tresor';

  @override
  String get exportDataExporting => 'Daten werden exportiert...';

  @override
  String get exportDataEncrypting => 'Verschlüsseln und exportieren...';

  @override
  String exportedToFile(String filename) {
    return 'Exportiert nach: $filename';
  }

  @override
  String exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return 'Tresor exportiert nach: $filename';
  }

  @override
  String get importDataFileDialogTitle => 'CloudShell-Sicherung auswählen';

  @override
  String get importDataPlaintextTitle => 'Klartext-Sicherung importieren';

  @override
  String get importDataPlaintextMessage =>
      'Der Import führt Daten aus der Sicherungsdatei zusammen.\n\nVorhandene Einträge werden aktualisiert, neue Einträge werden hinzugefügt.\n\nHinweis: Klartext-Sicherungen enthalten keine privaten SSH-Schlüssel.';

  @override
  String get importDataPlaintextImport => 'Importieren';

  @override
  String get importDataDecryptTitle => 'Tresor-Sicherung entschlüsseln';

  @override
  String get importDataDecryptMessage =>
      'Gib das Passwort ein, das beim Erstellen dieser Sicherung verwendet wurde.';

  @override
  String get importDataDecryptConfirmLabel => 'Entschlüsseln & Importieren';

  @override
  String get importDataDecrypting => 'Entschlüsseln und importieren...';

  @override
  String importFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get encryptedExportTitle => 'Verschlüsselter Export';

  @override
  String get encryptedExportMessage =>
      'Wähle ein sicheres Passwort, um deine Tresor-Sicherung zu verschlüsseln. Du benötigst dieses Passwort, um die Sicherung wiederherzustellen.';

  @override
  String get encryptedExportConfirmLabel => 'Exportieren';

  @override
  String get passwordDialogLabelPassword => 'Passwort';

  @override
  String get passwordDialogLabelConfirmPassword => 'Passwort bestätigen';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch =>
      'Passwörter stimmen nicht überein';

  @override
  String passwordMinLength(String minLength) {
    return 'Mindestens $minLength Zeichen';
  }

  @override
  String get biometricUnlockTitle => 'Biometrische Entsperrung';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => 'Biometrie';

  @override
  String get biometricNotAvailable =>
      'Biometrische Authentifizierung ist auf diesem Gerät nicht verfügbar.';

  @override
  String get vaultEncryptionTitle => 'Verschlüsselung';

  @override
  String get vaultNotConfiguredSubtitle =>
      'Nicht konfiguriert — anmelden zum Aktivieren';

  @override
  String get vaultEncryptedUnlockedSubtitle => 'Verschlüsselt und entsperrt';

  @override
  String get vaultLockedSubtitle => 'Tresor ist gesperrt';

  @override
  String get vaultMasterPasswordTitle => 'Master-Passwort';

  @override
  String get vaultLoadingSubtitle => 'Laden...';

  @override
  String get vaultErrorSubtitle => 'Fehler beim Laden des Tresorstatus';

  @override
  String get vaultEncryptionEnabled => 'Tresor-Verschlüsselung aktiviert';

  @override
  String get vaultDialogTitle => 'Tresor';

  @override
  String get vaultLockNow => 'Tresor jetzt sperren';

  @override
  String get vaultLocked => 'Tresor gesperrt';

  @override
  String get vaultChangePassword => 'Passwort ändern';

  @override
  String get changePasswordTitle => 'Passwort ändern';

  @override
  String get changePasswordCurrentLabel => 'Aktuelles Passwort';

  @override
  String get changePasswordNewLabel => 'Neues Passwort';

  @override
  String get changePasswordConfirmLabel => 'Neues Passwort bestätigen';

  @override
  String get changePasswordSubmit => 'Ändern';

  @override
  String get changePasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get changePasswordMinLength => 'Mindestens 10 Zeichen erforderlich';

  @override
  String get changePasswordSuccess => 'Master-Passwort erfolgreich geändert';

  @override
  String get autoLockTitle => 'Automatische Sperre';

  @override
  String get autoLockSetUpVaultFirst => 'Tresor zuerst einrichten';

  @override
  String get autoLockDialogTitle => 'Automatische Sperr-Zeitspanne';

  @override
  String get autoLockTimeoutNever => 'Nie';

  @override
  String get autoLockTimeout1Min => '1 Minute';

  @override
  String get autoLockTimeout5Min => '5 Minuten';

  @override
  String get autoLockTimeout15Min => '15 Minuten';

  @override
  String get autoLockTimeout30Min => '30 Minuten';

  @override
  String get autoLockTimeout1Hour => '1 Stunde';

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
  String get syncAccountTitle => 'Konto';

  @override
  String get syncSignedInDefault => 'Angemeldet';

  @override
  String get syncLocalOnlyTitle => 'Nur Lokal';

  @override
  String get syncLocalOnlySubtitle =>
      'Upgrade, um geräteübergreifend zu synchronisieren';

  @override
  String get syncCloudSyncTitle => 'Cloud-Synchronisation';

  @override
  String get syncCloudSyncSubtitle =>
      'Anmelden, um geräteübergreifend zu synchronisieren';

  @override
  String get accountDialogTitle => 'Konto';

  @override
  String get accountSignOut => 'Abmelden';

  @override
  String get accountSignedOut => 'Abgemeldet';

  @override
  String get accountDeleteAccount => 'Konto löschen';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountWillDelete => 'Dies wird dauerhaft gelöscht:';

  @override
  String get deleteAccountItemAccount => '  • Dein Konto und Login';

  @override
  String get deleteAccountItemSyncedData =>
      '  • Alle synchronisierten Daten auf dem Server';

  @override
  String get deleteAccountItemVault =>
      '  • Verschlüsselungs-Tresor-Konfiguration';

  @override
  String get deleteAccountLocalDataNote =>
      'Lokale Daten (Hosts, Schlüssel, Einstellungen) bleiben auf diesem Gerät erhalten.';

  @override
  String get deleteAccountConfirmPrompt => 'Gib DELETE ein, um zu bestätigen:';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => 'Konto löschen';

  @override
  String get deleteAccountDeleting => 'Konto wird gelöscht...';

  @override
  String get deleteAccountFailedDefault => 'Konto konnte nicht gelöscht werden';

  @override
  String get deleteAccountSuccess =>
      'Konto gelöscht. Lokale Daten bleiben erhalten.';

  @override
  String get syncAutoSyncTitle => 'Automatische Synchronisation';

  @override
  String get syncUnlockVault =>
      'Tresor entsperren, um Synchronisation zu aktivieren';

  @override
  String get syncEvery5Minutes => 'Alle 5 Minuten synchronisieren';

  @override
  String get syncDisabled => 'Synchronisation deaktiviert';

  @override
  String get syncNeverSynced => 'Nie synchronisiert';

  @override
  String get syncJustNow => 'Gerade eben';

  @override
  String get syncNowTitle => 'Jetzt synchronisieren';

  @override
  String get syncSyncing => 'Synchronisiere...';

  @override
  String syncResult(int pulled, int pushed) {
    return 'Synchronisiert: $pulled empfangen, $pushed gesendet';
  }

  @override
  String syncFailed(String error) {
    return 'Synchronisation fehlgeschlagen: $error';
  }

  @override
  String get totp2faTitle => '2FA-Authentifizierung';

  @override
  String get totpSignInToEnable => 'Anmelden zum Aktivieren';

  @override
  String get totpEnabled => 'Aktiviert';

  @override
  String get totpNotConfigured => 'Nicht konfiguriert';

  @override
  String get totpDisable2faTitle => '2FA deaktivieren?';

  @override
  String get totpDisable2faMessage =>
      'Dies entfernt die Zwei-Faktor-Authentifizierung von deinem Konto. Du kannst sie jederzeit wieder aktivieren.';

  @override
  String get totpDisable2faSubmit => 'Deaktivieren';

  @override
  String get totpDisabled => '2FA deaktiviert';

  @override
  String get knownHostsTitle => 'Bekannte Hosts';

  @override
  String get knownHostsEmptyTitle => 'Keine bekannten Hosts';

  @override
  String get knownHostsEmptySubtitle =>
      'Host-Schlüssel-Fingerabdrücke werden hier gespeichert, wenn du dich zum ersten Mal mit einem Server verbindest.';

  @override
  String get knownHostsSearchHint => 'Bekannte Hosts suchen...';

  @override
  String get knownHostsLoadingMessage => 'Bekannte Hosts werden geladen...';

  @override
  String get knownHostsRemoveTitle => 'Bekannten Host entfernen';

  @override
  String get knownHostsRemoveConfirmLabel => 'Entfernen';

  @override
  String get knownHostsMenuRemove => 'Entfernen';

  @override
  String get knownHostsFirstSeen => 'Erstmals gesehen';

  @override
  String get knownHostsLastSeen => 'Zuletzt gesehen';

  @override
  String knownHostsNoMatchQuery(String query) {
    return 'Keine Hosts stimmen mit \"$query\" überein';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return 'Vertrauen für $hostname:$port entfernen?\n\nDu wirst bei der nächsten Verbindung erneut aufgefordert, den Host-Schlüssel zu überprüfen.';
  }

  @override
  String get sessionLogsTitle => 'Sitzungsprotokolle';

  @override
  String get sessionLogsDeleteAllTooltip => 'Alle Protokolle löschen';

  @override
  String get sessionLogsEmpty => 'Keine Sitzungsprotokolle';

  @override
  String get sessionLogsEnableHint =>
      'Aktiviere die Protokollierung über das Terminal-Menü';

  @override
  String get sessionLogsView => 'Anzeigen';

  @override
  String get sessionLogsShare => 'Teilen';

  @override
  String get sessionLogsDelete => 'Löschen';

  @override
  String get sessionLogsShareSubject => 'CloudShell-Sitzungsprotokoll';

  @override
  String get sessionLogsDeleteAllTitle => 'Alle Protokolle löschen?';

  @override
  String get sessionLogsDeleteAllMessage =>
      'Dies wird alle Sitzungsprotokolldateien dauerhaft löschen.';

  @override
  String get sessionLogsDeleteAllConfirm => 'Alle löschen';

  @override
  String get sessionLogsShareTooltip => 'Teilen';

  @override
  String sessionLogsReadError(String error) {
    return 'Fehler beim Lesen der Datei: $error';
  }

  @override
  String get customThemeEditTitle => 'Design bearbeiten';

  @override
  String get customThemeNewTitle => 'Neues benutzerdefiniertes Design';

  @override
  String get customThemeSave => 'Speichern';

  @override
  String get customThemeNameLabel => 'Designname';

  @override
  String get customThemeNameHint => 'z.B. Mein benutzerdefiniertes Design';

  @override
  String get customThemeSectionTerminalChrome => 'Terminal-Rahmen';

  @override
  String get customThemeSectionNormalColors => 'Normale Farben';

  @override
  String get customThemeSectionBrightColors => 'Helle Farben';

  @override
  String get colorBackground => 'Hintergrund';

  @override
  String get colorForeground => 'Vordergrund';

  @override
  String get colorCursor => 'Cursor';

  @override
  String get colorSelection => 'Auswahl';

  @override
  String get colorBlack => 'Schwarz';

  @override
  String get colorRed => 'Rot';

  @override
  String get colorGreen => 'Grün';

  @override
  String get colorYellow => 'Gelb';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorMagenta => 'Magenta';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorWhite => 'Weiß';

  @override
  String get colorBrightBlack => 'Helles Schwarz';

  @override
  String get colorBrightRed => 'Helles Rot';

  @override
  String get colorBrightGreen => 'Helles Grün';

  @override
  String get colorBrightYellow => 'Helles Gelb';

  @override
  String get colorBrightBlue => 'Helles Blau';

  @override
  String get colorBrightMagenta => 'Helles Magenta';

  @override
  String get colorBrightCyan => 'Helles Cyan';

  @override
  String get colorBrightWhite => 'Helles Weiß';

  @override
  String get customThemePreviewTitle => 'Terminal-Vorschau';

  @override
  String get customThemePreviewSelectedText =>
      'Vorschau des ausgewählten Texts';

  @override
  String get hexColorLabel => 'Hex-Farbe';

  @override
  String get hexColorPasteTooltip => 'Einfügen';

  @override
  String get hexColorInvalid => 'Ungültiger Hex-Wert';

  @override
  String get hexColorApply => 'Anwenden';

  @override
  String get customThemeNameRequired => 'Designname ist erforderlich';

  @override
  String get sliderHue => 'F';

  @override
  String get sliderSaturation => 'S';

  @override
  String get sliderBrightness => 'H';

  @override
  String get sshConfigImportTitle => 'SSH-Konfiguration importieren';

  @override
  String get sshConfigImportFailed =>
      'SSH-Konfiguration konnte nicht gelesen werden';

  @override
  String get sshConfigNoHostsFound => 'Keine Hosts gefunden';

  @override
  String get sshConfigNoHostsFoundDetail =>
      'Keine gültigen Host-Einträge in ~/.ssh/config gefunden';

  @override
  String get sshConfigDeselectAll => 'Alle abwählen';

  @override
  String get sshConfigSelectAll => 'Alle auswählen';

  @override
  String get sshConfigImportKeys => 'Schlüssel importieren';

  @override
  String sshConfigFoundHosts(int count) {
    return '$count Host(s) in ~/.ssh/config gefunden';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return '$count Host(s) und $keys Schlüssel importiert';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return 'Importieren ($count)';
  }

  @override
  String get legalScreenLoadError => 'Dokument konnte nicht geladen werden';

  @override
  String get workspacesTitle => 'Arbeitsbereiche';

  @override
  String get workspacesSaveCurrent => 'Aktuellen speichern';

  @override
  String get workspacesEmptyTitle => 'Keine gespeicherten Arbeitsbereiche';

  @override
  String get workspacesEmptySubtitle =>
      'Dein aktuelles Tab-Layout wird automatisch gespeichert.\nVerwende \"Aktuellen speichern\", um einen benannten Arbeitsbereich zu erstellen.';

  @override
  String workspacesLoadError(String error) {
    return 'Arbeitsbereiche konnten nicht geladen werden: $error';
  }

  @override
  String get workspacesActiveBadge => 'AKTIV';

  @override
  String get workspacesNoTerminals => 'Keine Terminals';

  @override
  String get workspacesJustNow => 'Gerade eben';

  @override
  String get workspacesMenuSwitchTo => 'Wechseln zu';

  @override
  String get workspacesMenuRename => 'Umbenennen';

  @override
  String get workspacesMenuDelete => 'Löschen';

  @override
  String get workspacesSaveTitle => 'Arbeitsbereich speichern';

  @override
  String get workspacesSaveHint => 'Name des Arbeitsbereichs';

  @override
  String get workspacesSaveSave => 'Speichern';

  @override
  String get workspacesRenameTitle => 'Arbeitsbereich umbenennen';

  @override
  String get workspacesRenameHint => 'Neuer Name';

  @override
  String get workspacesRenameSubmit => 'Umbenennen';

  @override
  String get workspacesDeleteTitle => 'Arbeitsbereich löschen?';

  @override
  String get workspacesDeleteSubmit => 'Löschen';

  @override
  String workspaceTerminalCount(int count) {
    return '$count Terminal(s)';
  }

  @override
  String workspaceSaved(String name) {
    return 'Arbeitsbereich \"$name\" gespeichert';
  }

  @override
  String workspaceSwitching(String name) {
    return 'Wechsle zu \"$name\"...';
  }

  @override
  String workspaceLoaded(String name) {
    return 'Arbeitsbereich \"$name\" geladen';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return '\"$name\" löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get awsImportTitle => 'Von AWS EC2 importieren';

  @override
  String get awsConnectTitle => 'Mit AWS verbinden';

  @override
  String get awsConnectSubtitle =>
      'Gib deine AWS-Anmeldedaten ein, um EC2-Instanzen zu importieren.';

  @override
  String get awsAccessKeyIdLabel => 'Zugangsschlüssel-ID';

  @override
  String get awsAccessKeyIdHelper => 'z.B. AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => 'Geheimer Zugangsschlüssel';

  @override
  String get awsRegionLabel => 'Region';

  @override
  String get awsCredentialsInfo =>
      'Anmeldedaten werden nur für diesen Import verwendet und nicht gespeichert. Verwende einen IAM-Benutzer mit ausschließlich der Berechtigung ec2:DescribeInstances.';

  @override
  String get awsFetchInstances => 'Instanzen abrufen';

  @override
  String get awsFetchingInstances => 'Instanzen werden abgerufen...';

  @override
  String get awsErrorAccessKeyRequired =>
      'Gib deine AWS-Zugangsschlüssel-ID ein';

  @override
  String get awsErrorSecretKeyRequired =>
      'Gib deinen geheimen AWS-Zugangsschlüssel ein';

  @override
  String get awsSelectInstances => 'Instanzen auswählen';

  @override
  String get awsRunningOnlyFilter => 'Nur laufende';

  @override
  String get awsNoRunningInstances => 'Keine laufenden Instanzen gefunden';

  @override
  String get awsNoInstances => 'Keine Instanzen gefunden';

  @override
  String get awsConfigureImport => 'Import konfigurieren';

  @override
  String get awsDefaultUsernameLabel => 'Standard-Benutzername';

  @override
  String get awsDefaultUsernameHelper =>
      'Amazon Linux: ec2-user, Ubuntu: ubuntu';

  @override
  String get awsInstancesToImport => 'Zu importierende Instanzen:';

  @override
  String get awsImporting => 'Wird importiert...';

  @override
  String awsImportResult(int count) {
    return '$count Host(s) von AWS EC2 importiert';
  }

  @override
  String awsImportHostsButton(int count) {
    return '$count Host(s) importieren';
  }

  @override
  String awsNextButton(int count) {
    return 'Weiter ($count)';
  }

  @override
  String get doImportTitle => 'Von DigitalOcean importieren';

  @override
  String get doConnectTitle => 'Mit DigitalOcean verbinden';

  @override
  String get doConnectSubtitle =>
      'Gib deinen persönlichen DigitalOcean-Zugriffstoken ein, um Droplets zu importieren.';

  @override
  String get doApiTokenLabel => 'API-Token';

  @override
  String get doApiTokenHelper =>
      'Erstelle einen unter cloud.digitalocean.com/account/api/tokens';

  @override
  String get doTokenInfo =>
      'Dein Token wird nur für diesen Import verwendet und nicht gespeichert.';

  @override
  String get doFetchDroplets => 'Droplets abrufen';

  @override
  String get doFetchingDroplets => 'Droplets werden abgerufen...';

  @override
  String get doErrorTokenRequired => 'Gib deinen API-Token ein';

  @override
  String get doSelectDroplets => 'Droplets auswählen';

  @override
  String get doActiveOnlyFilter => 'Nur aktive';

  @override
  String get doNoActiveDroplets => 'Keine aktiven Droplets gefunden';

  @override
  String get doNoDroplets => 'Keine Droplets gefunden';

  @override
  String get doConfigureImport => 'Import konfigurieren';

  @override
  String get doDefaultUsernameLabel => 'Standard-Benutzername';

  @override
  String get doDefaultUsernameHelper =>
      'Wird für alle importierten Hosts verwendet (Standard: root)';

  @override
  String get doHostsToImport => 'Zu importierende Hosts:';

  @override
  String get doImporting => 'Wird importiert...';

  @override
  String doImportResult(int count) {
    return '$count Host(s) von DigitalOcean importiert';
  }

  @override
  String doImportHostsButton(int count) {
    return '$count Host(s) importieren';
  }

  @override
  String doNextButton(int count) {
    return 'Weiter ($count)';
  }

  @override
  String get loginSubtitle =>
      'Anmelden, um geräteübergreifend zu synchronisieren';

  @override
  String get loginEmailLabel => 'E-Mail';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginErrorEmailRequired => 'Gib deine E-Mail-Adresse ein';

  @override
  String get loginErrorPasswordRequired => 'Gib dein Passwort ein';

  @override
  String get loginSigningIn => 'Anmeldung läuft...';

  @override
  String get loginSignIn => 'Anmelden';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get loginCreateAccount => 'Konto erstellen';

  @override
  String get loginUseLocally => 'Lokal ohne Konto verwenden';

  @override
  String get signUpSubtitle => 'Erstelle dein Konto';

  @override
  String get signUpEmailLabel => 'E-Mail';

  @override
  String get signUpPasswordLabel => 'Passwort (mind. 10 Zeichen)';

  @override
  String get signUpConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get passwordStrengthWeak => 'Schwach';

  @override
  String get passwordStrengthFair => 'Ausreichend';

  @override
  String get passwordStrengthGood => 'Gut';

  @override
  String get passwordStrengthStrong => 'Stark';

  @override
  String get passwordStrengthExcellent => 'Ausgezeichnet';

  @override
  String get signUpErrorEmailRequired => 'Gib deine E-Mail-Adresse ein';

  @override
  String get signUpErrorPasswordRequired => 'Gib ein Passwort ein';

  @override
  String get signUpErrorPasswordTooShort =>
      'Das Passwort muss mindestens 10 Zeichen lang sein';

  @override
  String get signUpErrorPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get signUpErrorTermsRequired =>
      'Bitte akzeptiere die Nutzungsbedingungen';

  @override
  String get signUpEncryptionWarning =>
      'Deine Daten sind Ende-zu-Ende-verschlüsselt. Wir können dein Konto nicht wiederherstellen, wenn du dein Passwort verlierst.';

  @override
  String get signUpTermsPrefix => 'Ich akzeptiere die ';

  @override
  String get signUpTermsOfService => 'Nutzungsbedingungen';

  @override
  String get signUpTermsAnd => ' und die ';

  @override
  String get signUpPrivacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get signUpCreatingAccount => 'Konto wird erstellt...';

  @override
  String get signUpCreateAccount => 'Konto erstellen';

  @override
  String get signUpAlreadyHaveAccount => 'Bereits ein Konto? ';

  @override
  String get signUpSignIn => 'Anmelden';

  @override
  String get signUpEncryptionNote => 'Verschlüsselung: Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get forgotPasswordInstructions =>
      'Gib die E-Mail-Adresse deines Kontos ein und wir senden dir einen Link zum Zurücksetzen des Passworts.';

  @override
  String get forgotPasswordEmailLabel => 'E-Mail';

  @override
  String get forgotPasswordSending => 'Wird gesendet...';

  @override
  String get forgotPasswordSendResetLink => 'Link zum Zurücksetzen senden';

  @override
  String get forgotPasswordBackToSignIn => 'Zurück zur Anmeldung';

  @override
  String get forgotPasswordErrorEmailRequired => 'Gib deine E-Mail-Adresse ein';

  @override
  String get forgotPasswordCheckEmail => 'Prüfe deine E-Mails';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return 'Wenn ein Konto für $email existiert, erhältst du in Kürze einen Link zum Zurücksetzen des Passworts.';
  }

  @override
  String get forgotPasswordVaultWarning =>
      'Hinweis: Wir verwenden Zero-Knowledge-Verschlüsselung. Wenn du dein Kontopasswort zurücksetzt, bleibt dein Tresor-Master-Passwort unverändert.';

  @override
  String get forgotPasswordTryAgain => 'Nicht erhalten? Erneut versuchen';

  @override
  String get totpSetupTitle => '2FA einrichten';

  @override
  String get totpSetupFailed => '2FA-Einrichtung fehlgeschlagen';

  @override
  String get totpSetupHeading => 'Zwei-Faktor-Authentifizierung';

  @override
  String get totpSetupInstructions =>
      'Scanne diesen QR-Code mit deiner Authentifizierungs-App (Google Authenticator, Authy, etc.).';

  @override
  String get totpSetupManualEntryKey => 'Manueller Eingabeschlüssel';

  @override
  String get totpSetupSecretCopied => 'Geheimnis kopiert';

  @override
  String get totpSetupEnterCode =>
      'Gib den 6-stelligen Code aus deiner App ein:';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => 'Wird überprüft...';

  @override
  String get totpSetupVerifyAndEnable => 'Überprüfen & Aktivieren';

  @override
  String get totpSetupEnabled => 'Zwei-Faktor-Authentifizierung aktiviert';

  @override
  String get totpSetupErrorCodeLength => 'Gib einen 6-stelligen Code ein';

  @override
  String get totpSetupErrorInvalidCode =>
      'Ungültiger Code. Überprüfe deine Authentifizierungs-App und versuche es erneut.';

  @override
  String get totpVerifyHeading => 'Zwei-Faktor-Authentifizierung';

  @override
  String get totpVerifyInstructions =>
      'Gib den 6-stelligen Code aus deiner Authentifizierungs-App ein';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => 'Wird überprüft...';

  @override
  String get totpVerifySubmit => 'Überprüfen';

  @override
  String get totpVerifyHelpText =>
      'Öffne deine Authentifizierungs-App (Google Authenticator, Authy, etc.), um deinen Bestätigungscode zu finden.';

  @override
  String get totpVerifyErrorDefaultFailed => 'Überprüfung fehlgeschlagen';

  @override
  String get totpVerifyErrorInvalidCode => 'Ungültiger Code. Erneut versuchen.';

  @override
  String get adaptiveScaffoldHosts => 'Hosts';

  @override
  String get adaptiveScaffoldKeys => 'Schlüssel';

  @override
  String get adaptiveScaffoldSnippets => 'Snippets';

  @override
  String get adaptiveScaffoldTerminal => 'Terminal';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => 'Portweiterleitung';

  @override
  String get adaptiveScaffoldSettings => 'Einstellungen';

  @override
  String get commandPaletteHint =>
      'Hosts, Snippets suchen oder einen Befehl eingeben...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return 'Keine Ergebnisse für \"$query\"';
  }

  @override
  String get commandPaletteHostsHeader => 'Hosts';

  @override
  String get commandPaletteSnippetsHeader => 'Snippets';

  @override
  String get commandPaletteActionsHeader => 'Aktionen';

  @override
  String get commandPaletteActionNewHost => 'Neuer Host';

  @override
  String get commandPaletteActionQuickConnect => 'Schnellverbindung';

  @override
  String get commandPaletteActionSettings => 'Einstellungen';

  @override
  String get commandPaletteActionToggleTheme => 'Design umschalten';

  @override
  String get shortcutReferenceTitle => 'Tastaturkürzel';

  @override
  String get shortcutCategoryGeneral => 'Allgemein';

  @override
  String get shortcutCategoryTerminal => 'Terminal';

  @override
  String get shortcutCategoryNavigation => 'Navigation';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => 'Zum Fortfahren entsperren';

  @override
  String get appLockUnlockButton => 'Entsperren';

  @override
  String get appLockUnlockWithBiometrics => 'Mit Biometrie entsperren';

  @override
  String get appLockBiometricReason =>
      'Authentifiziere dich, um CloudShell zu entsperren';

  @override
  String get appLockFailed => 'Authentifizierung fehlgeschlagen';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusWarning => 'Warnung';

  @override
  String get statusIdle => 'Inaktiv';

  @override
  String get vaultUnlockTitle => 'Tresor entsperren';

  @override
  String get vaultUnlockSubtitle =>
      'Gib dein Master-Passwort ein, um den Tresor zu entsperren.';

  @override
  String get vaultUnlockPasswordLabel => 'Master-Passwort';

  @override
  String get vaultUnlockPasswordHint => 'Master-Passwort eingeben';

  @override
  String get vaultUnlockButton => 'Entsperren';

  @override
  String get vaultUnlockUnlocking => 'Wird entsperrt...';

  @override
  String get vaultUnlockBiometricButton => 'Mit Biometrie entsperren';

  @override
  String get vaultUnlockForgotPassword => 'Passwort vergessen?';

  @override
  String get vaultUnlockResetTitle => 'Tresor zurücksetzen?';

  @override
  String get vaultUnlockResetMessage =>
      'Das Zurücksetzen löscht alle verschlüsselten Daten (gespeicherte Passwörter, private Schlüssel). Lokale Hosts und Einstellungen bleiben erhalten.\n\nDiese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get vaultUnlockResetConfirm => 'Tresor zurücksetzen';

  @override
  String get vaultUnlockIncorrectPassword => 'Falsches Passwort';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return 'Zu viele Versuche. Erneut versuchen in ${seconds}s.';
  }

  @override
  String get masterPasswordSetupTitle => 'Tresor einrichten';

  @override
  String get masterPasswordSetupSubtitle =>
      'Erstelle ein Master-Passwort, um deine sensiblen Daten zu verschlüsseln.';

  @override
  String get masterPasswordSetupPasswordLabel => 'Master-Passwort';

  @override
  String get masterPasswordSetupPasswordHint => 'Mindestens 10 Zeichen';

  @override
  String get masterPasswordSetupConfirmLabel => 'Passwort bestätigen';

  @override
  String get masterPasswordSetupConfirmHint =>
      'Master-Passwort erneut eingeben';

  @override
  String get masterPasswordSetupButton => 'Tresor erstellen';

  @override
  String get masterPasswordSetupCreating => 'Tresor wird erstellt...';

  @override
  String get masterPasswordSetupMinLength =>
      'Mindestens 10 Zeichen erforderlich';

  @override
  String get masterPasswordSetupMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get masterPasswordSetupStrengthWeak => 'Schwach';

  @override
  String get masterPasswordSetupStrengthFair => 'Ausreichend';

  @override
  String get masterPasswordSetupStrengthGood => 'Gut';

  @override
  String get masterPasswordSetupStrengthStrong => 'Stark';

  @override
  String get masterPasswordSetupWarning =>
      'Dein Master-Passwort kann nicht wiederhergestellt werden. Schreibe es auf und bewahre es sicher auf.';

  @override
  String get passwordGeneratorTitle => 'Passwortgenerator';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return 'Länge: $length';
  }

  @override
  String get passwordGeneratorUppercase => 'Großbuchstaben (A-Z)';

  @override
  String get passwordGeneratorLowercase => 'Kleinbuchstaben (a-z)';

  @override
  String get passwordGeneratorNumbers => 'Zahlen (0-9)';

  @override
  String get passwordGeneratorSymbols => 'Symbole (!@#...)';

  @override
  String get passwordGeneratorGenerate => 'Generieren';

  @override
  String get passwordGeneratorCopy => 'Kopieren';

  @override
  String get passwordGeneratorCopied =>
      'Passwort kopiert (wird in 30s automatisch gelöscht)';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bits Bits Entropie';
  }

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei CloudShell';

  @override
  String get onboardingWelcomeSubtitle =>
      'Ein moderner, plattformübergreifender SSH-Client';

  @override
  String get onboardingSecureTitle => 'Sicher durch Design';

  @override
  String get onboardingSecureSubtitle =>
      'Ende-zu-Ende-verschlüsselter Tresor mit Argon2id + AES-256-GCM';

  @override
  String get onboardingTerminalTitle => 'Leistungsstarkes Terminal';

  @override
  String get onboardingTerminalSubtitle =>
      'Geteilte Bereiche, Tabs, Designs, Snippets und mehr';

  @override
  String get onboardingSyncTitle => 'Überall synchronisieren';

  @override
  String get onboardingSyncSubtitle =>
      'Deine Hosts, Schlüssel und Snippets — auf all deinen Geräten';

  @override
  String get onboardingGetStarted => 'Loslegen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get portForwardingTitle => 'Portweiterleitung';

  @override
  String get portForwardingAddTooltip => 'Regel hinzufügen';

  @override
  String get portForwardingEmptyTitle => 'Keine Portweiterleitungsregeln';

  @override
  String get portForwardingEmptySubtitle =>
      'Erstelle Regeln, um Datenverkehr durch SSH-Verbindungen zu tunneln.';

  @override
  String get portForwardingEmptyAction => 'Regel hinzufügen';

  @override
  String get portForwardingActiveHeader => 'AKTIV';

  @override
  String get portForwardingSavedHeader => 'GESPEICHERTE REGELN';

  @override
  String get portForwardingTypeLocal => 'Lokal';

  @override
  String get portForwardingTypeRemote => 'Remote';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => 'Stopp';

  @override
  String get portForwardingStart => 'Start';

  @override
  String get portForwardingMenuEdit => 'Bearbeiten';

  @override
  String get portForwardingMenuDelete => 'Löschen';

  @override
  String get portForwardingDeleteDialogTitle => 'Regel löschen';

  @override
  String get portForwardingDeleteDialogMessage =>
      'Diese Portweiterleitungsregel löschen?';

  @override
  String get portForwardingLoading =>
      'Portweiterleitungsregeln werden geladen...';

  @override
  String get portForwardFormTitleNew => 'Neue Portweiterleitung';

  @override
  String get portForwardFormTitleEdit => 'Portweiterleitung bearbeiten';

  @override
  String get portForwardFormLabelField => 'Bezeichnung';

  @override
  String get portForwardFormLabelHint => 'z.B. Datenbank-Tunnel';

  @override
  String get portForwardFormTypeField => 'Typ';

  @override
  String get portForwardFormTypeLocal => 'Lokal';

  @override
  String get portForwardFormTypeRemote => 'Remote';

  @override
  String get portForwardFormTypeDynamic => 'Dynamisch (SOCKS)';

  @override
  String get portForwardFormHostField => 'Host';

  @override
  String get portForwardFormSelectHost => 'Einen Host auswählen';

  @override
  String get portForwardFormNoHostsAvailable =>
      'Keine Hosts verfügbar. Erstelle zuerst einen Host.';

  @override
  String get portForwardFormCouldNotLoadHosts =>
      'Hosts konnten nicht geladen werden.';

  @override
  String get portForwardFormLocalPortField => 'Lokaler Port';

  @override
  String get portForwardFormRemotePortField => 'Remote-Port';

  @override
  String get portForwardFormDestHostField => 'Ziel-Host';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => 'Ziel-Port';

  @override
  String get portForwardFormDestPortHint => 'z.B. 5432';

  @override
  String get portForwardFormPortHint => 'z.B. 8080';

  @override
  String get portForwardFormAutoStart => 'Automatisch bei Verbindung starten';

  @override
  String get portForwardFormAutoStartSubtitle =>
      'Diesen Tunnel automatisch starten, wenn eine Verbindung zum Host hergestellt wird.';

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
  String get languageSystem => 'Systemstandard';
}
