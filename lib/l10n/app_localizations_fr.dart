// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get close => 'Fermer';

  @override
  String get retry => 'Réessayer';

  @override
  String get back => 'Retour';

  @override
  String get edit => 'Modifier';

  @override
  String get done => 'Terminé';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get search => 'Rechercher';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get togglePasswordVisibility => 'Afficher/masquer le mot de passe';

  @override
  String get togglePassphraseVisibility => 'Afficher/masquer la phrase secrète';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get enabled => 'Activé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get none => 'Aucun';

  @override
  String get unknown => 'Inconnu';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get hostsTitle => 'Hôtes';

  @override
  String get hostsAddTooltip => 'Ajouter un hôte';

  @override
  String get hostsSearchHint => 'Rechercher des hôtes...';

  @override
  String get hostsEmptyTitle => 'Aucun hôte pour le moment';

  @override
  String get hostsEmptySubtitle =>
      'Ajoutez votre premier serveur SSH pour commencer.';

  @override
  String get hostsEmptyAction => 'Ajouter un hôte';

  @override
  String hostsNoMatchQuery(String query) {
    return 'Aucun hôte ne correspond à « $query »';
  }

  @override
  String get hostsLoadingMessage => 'Chargement des hôtes...';

  @override
  String get hostsRecentHeader => 'RÉCENTS';

  @override
  String get hostsGroupsHeader => 'GROUPES';

  @override
  String get hostsFavoritesHeader => 'FAVORIS';

  @override
  String get hostsAllHostsHeader => 'TOUS LES HÔTES';

  @override
  String get hostsUngroupedHeader => 'NON GROUPÉS';

  @override
  String get hostsDeleteDialogTitle => 'Supprimer l\'hôte';

  @override
  String hostsDeleteDialogMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ?';
  }

  @override
  String get hostsMenuEdit => 'Modifier';

  @override
  String get hostsMenuDelete => 'Supprimer';

  @override
  String get hostsMenuConnect => 'Se connecter';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return 'Dernière connexion $time';
  }

  @override
  String get hostsNeverConnected => 'Jamais connecté';

  @override
  String get hostsJustNow => 'À l\'instant';

  @override
  String get hostFormTitleNew => 'Nouvel hôte';

  @override
  String get hostFormTitleEdit => 'Modifier l\'hôte';

  @override
  String get hostFormSave => 'Enregistrer';

  @override
  String get hostFormLabelField => 'Libellé';

  @override
  String get hostFormLabelHint => 'ex. : Serveur de production';

  @override
  String get hostFormLabelRequired => 'Le libellé est requis';

  @override
  String get hostFormHostnameField => 'Nom d\'hôte';

  @override
  String get hostFormHostnameHint => 'ex. : 192.168.1.100 ou exemple.com';

  @override
  String get hostFormHostnameRequired => 'Le nom d\'hôte est requis';

  @override
  String get hostFormPortField => 'Port';

  @override
  String get hostFormUsernameField => 'Nom d\'utilisateur';

  @override
  String get hostFormUsernameHint => 'ex. : root';

  @override
  String get hostFormUsernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get hostFormPasswordField => 'Mot de passe';

  @override
  String get hostFormPasswordHint => 'Entrez le mot de passe';

  @override
  String get hostFormAuthMethodField => 'Méthode d\'authentification';

  @override
  String get hostFormAuthMethodKey => 'Clé';

  @override
  String get hostFormAuthMethodPassword => 'Mot de passe';

  @override
  String get hostFormAuthMethodKeyAndPassword => 'Clé + Mot de passe';

  @override
  String get hostFormKeyField => 'Clé SSH';

  @override
  String get hostFormKeyNone => 'Aucune';

  @override
  String get hostFormGroupField => 'Groupe';

  @override
  String get hostFormGroupNone => 'Aucun groupe';

  @override
  String get hostFormTagsField => 'Étiquettes';

  @override
  String get hostFormTagsHint =>
      'Ajouter des étiquettes (séparées par des virgules)';

  @override
  String get hostFormAdvancedSection => 'Avancé';

  @override
  String get hostFormJumpHostField => 'Hôte de rebond (Proxy)';

  @override
  String get hostFormJumpHostNone => 'Aucun (connexion directe)';

  @override
  String get hostFormKeepAliveField => 'Keep Alive (secondes)';

  @override
  String get hostFormStartupCommandField => 'Commande de démarrage';

  @override
  String get hostFormStartupCommandHint =>
      'Exécuter après la connexion (facultatif)';

  @override
  String get hostFormNotesField => 'Notes';

  @override
  String get hostFormNotesHint => 'Notes facultatives sur cet hôte';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => 'Série';

  @override
  String get hostFormSerialPortField => 'Port série';

  @override
  String get hostFormSerialPortNone => 'Sélectionner un port';

  @override
  String get hostFormSerialNoPortsAvailable => 'Aucun port série disponible';

  @override
  String get hostFormSerialBaudRateField => 'Débit en bauds';

  @override
  String get hostFormSerialDataBitsField => 'Bits de données';

  @override
  String get hostFormSerialStopBitsField => 'Bits d\'arrêt';

  @override
  String get hostFormSerialParityField => 'Parité';

  @override
  String get hostFormSerialFlowControlField => 'Contrôle de flux';

  @override
  String get hostFormTestConnection => 'Tester la connexion';

  @override
  String get hostFormTestConnectionSuccess => 'Connexion réussie !';

  @override
  String hostFormTestConnectionFailed(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get hostDetailTitle => 'Détails de l\'hôte';

  @override
  String get hostDetailConnect => 'Se connecter';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => 'Modifier';

  @override
  String get hostDetailDeleteTooltip => 'Supprimer';

  @override
  String get hostDetailFavoriteTooltip => 'Favori';

  @override
  String get hostDetailSectionConnection => 'Connexion';

  @override
  String get hostDetailSectionAuthentication => 'Authentification';

  @override
  String get hostDetailSectionAdvanced => 'Avancé';

  @override
  String get hostDetailSectionTags => 'Étiquettes';

  @override
  String get hostDetailSectionNotes => 'Notes';

  @override
  String get hostDetailLabelHostname => 'Nom d\'hôte';

  @override
  String get hostDetailLabelPort => 'Port';

  @override
  String get hostDetailLabelUsername => 'Nom d\'utilisateur';

  @override
  String get hostDetailLabelAuthMethod => 'Méthode d\'authentification';

  @override
  String get hostDetailLabelKey => 'Clé';

  @override
  String get hostDetailLabelGroup => 'Groupe';

  @override
  String get hostDetailLabelJumpHost => 'Hôte de rebond';

  @override
  String get hostDetailLabelKeepAlive => 'Keep Alive';

  @override
  String get hostDetailLabelStartupCommand => 'Commande de démarrage';

  @override
  String get hostDetailLabelProtocol => 'Protocole';

  @override
  String get hostDetailLabelCreated => 'Créé';

  @override
  String get hostDetailLabelUpdated => 'Mis à jour';

  @override
  String get hostDetailLabelLastConnected => 'Dernière connexion';

  @override
  String get hostDetailNotFound => 'Hôte introuvable';

  @override
  String get hostDetailLoading => 'Chargement de l\'hôte...';

  @override
  String get hostDetailDeleteDialogTitle => 'Supprimer l\'hôte';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String get quickConnectTitle => 'Connexion rapide';

  @override
  String get quickConnectHint => 'utilisateur@hôte:port';

  @override
  String get quickConnectHelperText => 'ex. : root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => 'Enregistrer l\'hôte';

  @override
  String get quickConnectConnect => 'Se connecter';

  @override
  String get quickConnectInvalidFormat =>
      'Format invalide. Utilisez utilisateur@hôte ou utilisateur@hôte:port';

  @override
  String get groupFormTitleNew => 'Nouveau groupe';

  @override
  String get groupFormTitleEdit => 'Modifier le groupe';

  @override
  String get groupFormNameField => 'Nom du groupe';

  @override
  String get groupFormNameHint => 'ex. : Production';

  @override
  String get groupFormNameRequired => 'Le nom du groupe est requis';

  @override
  String get groupFormParentField => 'Groupe parent';

  @override
  String get groupFormParentNone => 'Aucun (niveau supérieur)';

  @override
  String get groupFormDeleteDialogTitle => 'Supprimer le groupe';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return 'Supprimer « $name » ? Les hôtes de ce groupe deviendront non groupés.';
  }

  @override
  String get hostKeyVerifyChangedTitle => 'Clé d\'hôte modifiée';

  @override
  String get hostKeyVerifyUnknownTitle => 'Hôte inconnu';

  @override
  String get hostKeyVerifyChangedWarning =>
      'ATTENTION : La clé de cet hôte a changé. Cela pourrait indiquer une attaque de type « man-in-the-middle ».';

  @override
  String get hostKeyVerifyUnknownMessage =>
      'L\'authenticité de cet hôte ne peut pas être vérifiée. Êtes-vous sûr de vouloir continuer la connexion ?';

  @override
  String get hostKeyVerifyLabelHost => 'Hôte';

  @override
  String get hostKeyVerifyLabelKeyType => 'Type de clé';

  @override
  String get hostKeyVerifyLabelFingerprint => 'Empreinte :';

  @override
  String get hostKeyVerifyFingerprintCopied =>
      'Empreinte copiée (effacement automatique dans 30 s)';

  @override
  String get hostKeyVerifyTrustAnyway => 'Faire confiance quand même';

  @override
  String get hostKeyVerifyTrustAndConnect => 'Faire confiance et se connecter';

  @override
  String get keysTitle => 'Clés SSH';

  @override
  String get keysAddTooltip => 'Importer une clé';

  @override
  String get keysImportTooltip => 'Importer une clé';

  @override
  String get keysEmptyTitle => 'Aucune clé SSH';

  @override
  String get keysEmptySubtitle =>
      'Importez vos clés SSH pour vous authentifier auprès des serveurs.';

  @override
  String get keysEmptyAction => 'Importer une clé';

  @override
  String get keysSearchHint => 'Rechercher des clés...';

  @override
  String keysNoMatchQuery(String query) {
    return 'Aucune clé ne correspond à « $query »';
  }

  @override
  String get keysLoadingMessage => 'Chargement des clés...';

  @override
  String get keysDeleteDialogTitle => 'Supprimer la clé';

  @override
  String keysDeleteDialogMessage(String name) {
    return 'Supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String get keysMenuDelete => 'Supprimer';

  @override
  String keysAssociatedHosts(int count) {
    return '$count hôte(s)';
  }

  @override
  String get keyDetailTitle => 'Détails de la clé';

  @override
  String get keyDetailEditTooltip => 'Modifier';

  @override
  String get keyDetailDeleteTooltip => 'Supprimer';

  @override
  String get keyDetailSectionPublicKey => 'Clé publique';

  @override
  String get keyDetailCopyPublicKey => 'Copier la clé publique';

  @override
  String get keyDetailSectionFingerprint => 'Empreinte';

  @override
  String get keyDetailSectionAssociatedHosts => 'Hôtes associés';

  @override
  String get keyDetailSectionDetails => 'Détails';

  @override
  String get keyDetailLabelType => 'Type';

  @override
  String get keyDetailLabelBits => 'Bits';

  @override
  String get keyDetailLabelCreated => 'Créée';

  @override
  String get keyDetailNotFound => 'Clé introuvable';

  @override
  String get keyDetailLoading => 'Chargement de la clé...';

  @override
  String get keyDetailPublicKeyCopied =>
      'Clé publique copiée (effacement automatique dans 30 s)';

  @override
  String get keyDetailFingerprintCopied =>
      'Empreinte copiée (effacement automatique dans 30 s)';

  @override
  String get keyDetailNoAssociatedHosts => 'Aucun hôte n\'utilise cette clé';

  @override
  String get keyImportTitle => 'Importer une clé SSH';

  @override
  String get keyImportButton => 'Importer';

  @override
  String get keyImportButtonImporting => 'Importation...';

  @override
  String get keyImportButtonImportKey => 'Importer la clé';

  @override
  String get keyImportLabelField => 'Libellé';

  @override
  String get keyImportLabelHint => 'ex. : Ma clé serveur';

  @override
  String get keyImportPassphraseField => 'Phrase secrète (facultatif)';

  @override
  String get keyImportPassphraseHint =>
      'Laissez vide si la clé n\'est pas chiffrée';

  @override
  String get keyImportPrivateKeyField => 'Clé privée';

  @override
  String get keyImportFromFile => 'Depuis un fichier';

  @override
  String get keyImportPaste => 'Coller';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\nou PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      'Formats pris en charge : OpenSSH, PEM, PuTTY PPK (RSA, Ed25519, ECDSA). Votre clé privée est stockée de manière sécurisée dans le trousseau de la plateforme et ne quitte jamais cet appareil.';

  @override
  String keyImportFailedToReadFile(String error) {
    return 'Échec de la lecture du fichier : $error';
  }

  @override
  String get keyImportClipboardEmpty => 'Le presse-papiers est vide';

  @override
  String get keyImportPasteOrSelectKey =>
      'Veuillez coller ou sélectionner une clé privée';

  @override
  String keyImportSuccess(String fingerprint) {
    return 'Clé importée : $fingerprint';
  }

  @override
  String get terminalNoActiveSessions => 'Aucune session active';

  @override
  String get terminalQuickConnect => 'Connexion rapide';

  @override
  String get terminalRecentHostsHeader => 'HÔTES RÉCENTS';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  Nouvel hôte  ·  ⌘⇧N  Connexion rapide  ·  ⌘K  Rechercher';

  @override
  String get terminalMobileShortcutHint =>
      'Appuyez sur + pour se connecter à un hôte';

  @override
  String terminalConnectingToHost(String label) {
    return 'Connexion à $label...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return 'Reconnexion... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => 'Annuler';

  @override
  String get terminalConnectionLost => 'Connexion perdue';

  @override
  String get terminalSearchHint => 'Rechercher dans le terminal...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => 'Fermer (Esc)';

  @override
  String get terminalConnectionInfoTitle => 'Informations de connexion';

  @override
  String get terminalStatusReconnecting => 'Reconnexion...';

  @override
  String get terminalStatusConnected => 'Connecté';

  @override
  String get terminalStatusDisconnected => 'Déconnecté';

  @override
  String get terminalInfoLabelHost => 'Hôte';

  @override
  String get terminalInfoLabelAddress => 'Adresse';

  @override
  String get terminalInfoLabelUsername => 'Nom d\'utilisateur';

  @override
  String get terminalInfoLabelProxyJump => 'Proxy Jump';

  @override
  String get terminalInfoValueProxyJump => 'Via hôte bastion';

  @override
  String get terminalInfoLabelUptime => 'Temps de fonctionnement';

  @override
  String get terminalInfoLabelConnectedAt => 'Connecté à';

  @override
  String get terminalInfoLabelSessionId => 'ID de session';

  @override
  String get terminalInfoLabelSplit => 'Division';

  @override
  String get terminalInfoValueSplitHorizontal => 'Horizontal (2 panneaux)';

  @override
  String get terminalInfoValueSplitVertical => 'Vertical (2 panneaux)';

  @override
  String get terminalInfoLabelLogging => 'Journalisation';

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
      'Diffusion ACTIVÉE — appuyez pour basculer, appui long pour les options';

  @override
  String get terminalBroadcastOffTooltip =>
      'Diffusion DÉSACTIVÉE — appuyez pour basculer, appui long pour les options';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return 'CAST ($count)';
  }

  @override
  String get terminalBroadcastCastActive => 'CAST';

  @override
  String get terminalBroadcastCastInactive => 'Cast';

  @override
  String get terminalHeaderBackTooltip => 'Retour';

  @override
  String get terminalHeaderNewConnectionTooltip => 'Nouvelle connexion';

  @override
  String get terminalHeaderSnippetsTooltip => 'Snippets';

  @override
  String get terminalHeaderCopyTooltip => 'Copier la sélection';

  @override
  String get terminalHeaderPasteTooltip => 'Coller';

  @override
  String get terminalHeaderNewTabTooltip => 'Nouvel onglet';

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
  String get broadcastPanelTitle => 'Diffusion d\'entrée';

  @override
  String get broadcastPanelDisable => 'Désactiver';

  @override
  String get broadcastPanelDescription =>
      'Sélectionnez les terminaux qui reçoivent votre saisie clavier.';

  @override
  String get broadcastPanelBroadcastToAll => 'Diffuser à tous';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count sessions connectées';
  }

  @override
  String get broadcastPanelActiveLabel => 'ACTIF';

  @override
  String get broadcastPanelTabConnected => 'Connecté';

  @override
  String get broadcastPanelTabDisconnected => 'Déconnecté';

  @override
  String get snippetsTitle => 'Snippets';

  @override
  String get snippetsAddTooltip => 'Ajouter un snippet';

  @override
  String get snippetsEmptyTitle => 'Aucun snippet';

  @override
  String get snippetsEmptySubtitle =>
      'Enregistrez les commandes fréquemment utilisées pour un accès rapide.';

  @override
  String get snippetsEmptyAction => 'Ajouter un snippet';

  @override
  String get snippetsSearchHint => 'Rechercher des snippets...';

  @override
  String snippetsNoMatchQuery(String query) {
    return 'Aucun snippet ne correspond à « $query »';
  }

  @override
  String get snippetsLoadingMessage => 'Chargement des snippets...';

  @override
  String get snippetsUncategorized => 'Non catégorisé';

  @override
  String get snippetsHasVariables => 'Contient des variables';

  @override
  String get snippetsCopyCommandTooltip => 'Copier la commande';

  @override
  String get snippetsMenuEdit => 'Modifier';

  @override
  String get snippetsMenuDelete => 'Supprimer';

  @override
  String get snippetsCopiedMessage =>
      'Commande copiée (effacement automatique dans 30 s)';

  @override
  String get snippetsDeleteDialogTitle => 'Supprimer le snippet';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ?';
  }

  @override
  String get snippetDetailNotFound => 'Snippet introuvable';

  @override
  String get snippetDetailLoading => 'Chargement du snippet...';

  @override
  String get snippetDetailEditTooltip => 'Modifier';

  @override
  String get snippetDetailDeleteTooltip => 'Supprimer';

  @override
  String get snippetDetailSectionCommand => 'Commande';

  @override
  String get snippetDetailCopyCommandTooltip => 'Copier la commande';

  @override
  String get snippetDetailSectionVariables => 'Variables';

  @override
  String get snippetDetailSectionDescription => 'Description';

  @override
  String get snippetDetailSectionDetails => 'Détails';

  @override
  String get snippetDetailLabelCreated => 'Créé';

  @override
  String get snippetDetailLabelUpdated => 'Mis à jour';

  @override
  String get snippetDetailCopiedMessage =>
      'Commande copiée (effacement automatique dans 30 s)';

  @override
  String get snippetFormTitleEdit => 'Modifier le snippet';

  @override
  String get snippetFormTitleNew => 'Nouveau snippet';

  @override
  String get snippetFormNameLabel => 'Nom du snippet';

  @override
  String get snippetFormNameHint => 'ex. : Vérifier l\'espace disque';

  @override
  String get snippetFormNameRequired => 'Le nom est requis';

  @override
  String get snippetFormCommandLabel => 'Commande';

  @override
  String get snippetFormCommandHint =>
      'ex. : df -h\nUtilisez des variables entre doubles accolades comme marqueurs';

  @override
  String get snippetFormCommandRequired => 'La commande est requise';

  @override
  String get snippetFormVariablesLabel => 'Variables :';

  @override
  String get snippetFormCategoryLabel => 'Catégorie (facultatif)';

  @override
  String get snippetFormCategoryHint => 'ex. : Système, Docker, Réseau';

  @override
  String get snippetFormDescriptionLabel => 'Description (facultatif)';

  @override
  String get snippetFormDescriptionHint => 'Que fait cette commande ?';

  @override
  String get snippetFormSaveButtonEdit => 'Mettre à jour le snippet';

  @override
  String get snippetFormSaveButtonNew => 'Créer un snippet';

  @override
  String snippetFormSaveError(String error) {
    return 'Échec de l\'enregistrement du snippet : $error';
  }

  @override
  String get snippetPickerSearchHint => 'Rechercher des snippets...';

  @override
  String get snippetPickerEmptyMessage =>
      'Aucun snippet. Créez-en un depuis l\'écran Snippets.';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return 'Aucun snippet ne correspond à « $query »';
  }

  @override
  String get snippetPickerLoadingError => 'Échec du chargement des snippets';

  @override
  String get snippetPickerVariableDialogTitle => 'Remplir les variables';

  @override
  String snippetPickerVariableHint(String variable) {
    return 'Entrez la valeur pour $variable';
  }

  @override
  String get snippetPickerVariableInsert => 'Insérer';

  @override
  String get sftpSelectHostHint => 'Sélectionner un hôte...';

  @override
  String get sftpConnecting => 'Connexion...';

  @override
  String get sftpUploadLabel => 'Téléverser';

  @override
  String get sftpDownloadLabel => 'Télécharger';

  @override
  String get sftpNoSavedHostsTitle => 'Aucun hôte enregistré';

  @override
  String get sftpNoSavedHostsSubtitle =>
      'Ajoutez d\'abord un hôte, puis revenez pour transférer des fichiers.';

  @override
  String get sftpFailedToLoadHosts => 'Échec du chargement des hôtes';

  @override
  String sftpFailedToConnect(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get sftpConnectToHostFirst => 'Connectez-vous d\'abord à un hôte';

  @override
  String get sftpDropFilesToUpload => 'Déposez des fichiers pour téléverser';

  @override
  String get sftpTabLocal => 'Local';

  @override
  String get sftpTabRemote => 'Distant';

  @override
  String get sftpPaneHeaderLocal => 'LOCAL';

  @override
  String get sftpPaneHeaderRemote => 'DISTANT';

  @override
  String get sftpLocalPermissionDenied => 'Permission refusée';

  @override
  String get sftpLocalEmptyFolder => 'Dossier vide';

  @override
  String get sftpLocalCannotOpenFolder => 'Impossible d\'ouvrir le dossier';

  @override
  String get sftpRemoteSelectHost => 'Sélectionnez un hôte à parcourir';

  @override
  String get sftpRemoteSelectHostSubtitle =>
      'Utilisez le menu déroulant ci-dessus pour choisir un serveur connecté';

  @override
  String get sftpRemoteEmptyDirectory => 'Répertoire vide';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return 'Impossible d\'ouvrir le dossier : $message';
  }

  @override
  String get sftpRemoteReadOnly => 'Lecture seule';

  @override
  String get sftpRemoteNewFolderTooltip => 'Nouveau dossier';

  @override
  String get sftpHideHiddenFiles => 'Masquer les fichiers cachés';

  @override
  String get sftpShowHiddenFiles => 'Afficher les fichiers cachés';

  @override
  String get sftpGoUp => 'Remonter';

  @override
  String get sftpNewFolderDialogTitle => 'Nouveau dossier';

  @override
  String get sftpNewFolderDialogLabel => 'Nom du dossier';

  @override
  String get sftpNewFolderDialogHint => 'ex. : nouveau-dossier';

  @override
  String get sftpNewFolderDialogCreate => 'Créer';

  @override
  String get sftpFileMenuEdit => 'Modifier';

  @override
  String get sftpFileMenuPermissions => 'Permissions';

  @override
  String get sftpFileMenuDelete => 'Supprimer';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return 'Permissions — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => 'Octal : ';

  @override
  String get sftpPermissionsLabelUser => 'Utilisateur';

  @override
  String get sftpPermissionsLabelGroup => 'Groupe';

  @override
  String get sftpPermissionsLabelOther => 'Autre';

  @override
  String get sftpPermissionsBitRead => 'Lecture';

  @override
  String get sftpPermissionsBitWrite => 'Écriture';

  @override
  String get sftpPermissionsBitExec => 'Exécution';

  @override
  String get sftpPermissionsApply => 'Appliquer';

  @override
  String get sftpTransfersHeader => 'Transferts';

  @override
  String get sftpTransfersClearDone => 'Effacer terminés';

  @override
  String get sftpTransferStatusDone => 'Terminé';

  @override
  String get sftpTransferStatusFailed => 'Échoué';

  @override
  String get remoteEditorSaveTooltip => 'Enregistrer';

  @override
  String get remoteEditorFileSaved => 'Fichier enregistré';

  @override
  String remoteEditorFailedToSave(String error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle =>
      'Modifications non enregistrées';

  @override
  String get remoteEditorUnsavedChangesMessage =>
      'Vous avez des modifications non enregistrées. Les abandonner ?';

  @override
  String get remoteEditorDiscard => 'Abandonner';

  @override
  String get remoteEditorFailedToLoadFile => 'Échec du chargement du fichier';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get sectionConnection => 'Connexion';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get sectionSecurity => 'Sécurité';

  @override
  String get sectionTools => 'Outils';

  @override
  String get sectionData => 'Données';

  @override
  String get sectionCloudImport => 'Importation cloud';

  @override
  String get sectionSync => 'Synchronisation';

  @override
  String get sectionAbout => 'À propos';

  @override
  String get settingThemeTitle => 'Thème';

  @override
  String get themeModeDark => 'Sombre';

  @override
  String get themeModeLight => 'Clair';

  @override
  String get themeModeSystem => 'Système';

  @override
  String get settingTerminalThemeTitle => 'Thème du terminal';

  @override
  String get settingFontFamilyTitle => 'Police de caractères';

  @override
  String get settingFontSizeTitle => 'Taille de police';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => 'Style du curseur';

  @override
  String get cursorStyleBlock => 'Bloc';

  @override
  String get cursorStyleUnderline => 'Souligné';

  @override
  String get cursorStyleVerticalBar => 'Barre verticale';

  @override
  String get settingFontLigaturesTitle => 'Ligatures de police';

  @override
  String get settingFontLigaturesEnabled => 'Activées (ex. : => devient ⇒)';

  @override
  String get settingFontLigaturesDisabled => 'Désactivées';

  @override
  String get settingLanguageTitle => 'Langue';

  @override
  String get settingDefaultSshPortTitle => 'Port SSH par défaut';

  @override
  String get settingConnectionTimeoutTitle => 'Délai de connexion';

  @override
  String get settingKeepAliveTitle => 'Intervalle Keep Alive';

  @override
  String get dialogDefaultSshPort => 'Port SSH par défaut';

  @override
  String get dialogConnectionTimeout => 'Délai de connexion (secondes)';

  @override
  String get dialogKeepAliveInterval => 'Intervalle Keep Alive (secondes)';

  @override
  String settingTimeoutSuffix(String value) {
    return '${value}s';
  }

  @override
  String get settingCommandCompletionSoundTitle => 'Son de fin de commande';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return 'Alerter quand les commandes durent > ${threshold}s';
  }

  @override
  String get settingNotificationThresholdTitle => 'Seuil de notification';

  @override
  String get dialogNotificationThreshold => 'Seuil de notification (secondes)';

  @override
  String get settingKnownHostsTitle => 'Hôtes connus';

  @override
  String get settingKnownHostsSubtitle =>
      'Gérer les clés d\'hôtes SSH de confiance';

  @override
  String get settingWorkspacesTitle => 'Espaces de travail';

  @override
  String get settingWorkspacesSubtitle =>
      'Enregistrer et restaurer les dispositions d\'onglets';

  @override
  String get settingPasswordGeneratorTitle => 'Générateur de mot de passe';

  @override
  String get settingPasswordGeneratorSubtitle =>
      'Générer des mots de passe sécurisés';

  @override
  String get settingSessionLogsTitle => 'Journaux de session';

  @override
  String get settingSessionLogsSubtitle =>
      'Voir les enregistrements de sessions du terminal';

  @override
  String get settingImportSshConfigTitle => 'Importer la configuration SSH';

  @override
  String get settingImportSshConfigSubtitle =>
      'Importer les hôtes depuis ~/.ssh/config';

  @override
  String get settingExportDataTitle => 'Exporter les données';

  @override
  String get settingExportDataSubtitle =>
      'Sauvegarder les hôtes, snippets et paramètres';

  @override
  String get settingImportDataTitle => 'Importer les données';

  @override
  String get settingImportDataSubtitle =>
      'Restaurer à partir d\'un fichier de sauvegarde';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle =>
      'Importer des instances depuis Amazon Web Services';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle =>
      'Importer des droplets depuis DigitalOcean';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return 'Version $version';
  }

  @override
  String get settingPrivacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get settingPrivacyPolicySubtitle =>
      'Comment vos données sont traitées';

  @override
  String get settingTermsOfServiceTitle => 'Conditions d\'utilisation';

  @override
  String get settingTermsOfServiceSubtitle =>
      'Conditions et modalités d\'utilisation';

  @override
  String get themePickerTitle => 'Thème';

  @override
  String get terminalThemePickerTitle => 'Thème du terminal';

  @override
  String get terminalThemeCustomThemesHeader => 'THÈMES PERSONNALISÉS';

  @override
  String get terminalThemeBuiltInThemesHeader => 'THÈMES INTÉGRÉS';

  @override
  String get terminalThemeNewTheme => 'Nouveau thème';

  @override
  String get terminalThemeEditTooltip => 'Modifier';

  @override
  String get terminalThemeDeleteTooltip => 'Supprimer';

  @override
  String get fontSizePickerTitle => 'Taille de police du terminal';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => 'Réinitialiser';

  @override
  String get fontFamilyPickerTitle => 'Police de caractères';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => 'Style du curseur';

  @override
  String get numberInputInvalidNumber => 'Entrez un nombre valide';

  @override
  String numberInputRangeError(String min, String max) {
    return 'Doit être entre $min et $max';
  }

  @override
  String get exportDataTitle => 'Exporter les données';

  @override
  String get exportDataMessage =>
      'Choisissez le type d\'export :\n\nL\'export en texte brut inclut les hôtes, snippets et paramètres. Les clés privées ne sont PAS incluses.\n\nLa sauvegarde chiffrée du coffre inclut tout — hôtes, clés, mots de passe et paramètres — protégé par un mot de passe de votre choix.';

  @override
  String get exportDataPlaintext => 'Texte brut';

  @override
  String get exportDataEncryptedVault => 'Coffre chiffré';

  @override
  String get exportDataExporting => 'Exportation des données...';

  @override
  String get exportDataEncrypting => 'Chiffrement et exportation...';

  @override
  String exportedToFile(String filename) {
    return 'Exporté vers : $filename';
  }

  @override
  String exportFailed(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return 'Coffre exporté vers : $filename';
  }

  @override
  String get importDataFileDialogTitle =>
      'Sélectionner une sauvegarde CloudShell';

  @override
  String get importDataPlaintextTitle =>
      'Importer une sauvegarde en texte brut';

  @override
  String get importDataPlaintextMessage =>
      'L\'importation fusionnera les données du fichier de sauvegarde.\n\nLes enregistrements existants seront mis à jour, les nouveaux seront ajoutés.\n\nRemarque : Les sauvegardes en texte brut n\'incluent pas les clés SSH privées.';

  @override
  String get importDataPlaintextImport => 'Importer';

  @override
  String get importDataDecryptTitle => 'Déchiffrer la sauvegarde du coffre';

  @override
  String get importDataDecryptMessage =>
      'Entrez le mot de passe utilisé lors de la création de cette sauvegarde.';

  @override
  String get importDataDecryptConfirmLabel => 'Déchiffrer et importer';

  @override
  String get importDataDecrypting => 'Déchiffrement et importation...';

  @override
  String importFailed(String error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String get encryptedExportTitle => 'Exportation chiffrée';

  @override
  String get encryptedExportMessage =>
      'Choisissez un mot de passe fort pour chiffrer la sauvegarde de votre coffre. Vous aurez besoin de ce mot de passe pour restaurer la sauvegarde.';

  @override
  String get encryptedExportConfirmLabel => 'Exporter';

  @override
  String get passwordDialogLabelPassword => 'Mot de passe';

  @override
  String get passwordDialogLabelConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String passwordMinLength(String minLength) {
    return 'Minimum $minLength caractères';
  }

  @override
  String get biometricUnlockTitle => 'Déverrouillage biométrique';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => 'biométrie';

  @override
  String get biometricNotAvailable =>
      'L\'authentification biométrique n\'est pas disponible sur cet appareil.';

  @override
  String get vaultEncryptionTitle => 'Chiffrement';

  @override
  String get vaultNotConfiguredSubtitle =>
      'Non configuré — connectez-vous pour activer';

  @override
  String get vaultEncryptedUnlockedSubtitle => 'Chiffré et déverrouillé';

  @override
  String get vaultLockedSubtitle => 'Le coffre est verrouillé';

  @override
  String get vaultMasterPasswordTitle => 'Mot de passe principal';

  @override
  String get vaultLoadingSubtitle => 'Chargement...';

  @override
  String get vaultErrorSubtitle =>
      'Erreur lors du chargement de l\'état du coffre';

  @override
  String get vaultEncryptionEnabled => 'Chiffrement du coffre activé';

  @override
  String get vaultDialogTitle => 'Coffre';

  @override
  String get vaultLockNow => 'Verrouiller le coffre maintenant';

  @override
  String get vaultLocked => 'Coffre verrouillé';

  @override
  String get vaultChangePassword => 'Changer le mot de passe';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get changePasswordCurrentLabel => 'Mot de passe actuel';

  @override
  String get changePasswordNewLabel => 'Nouveau mot de passe';

  @override
  String get changePasswordConfirmLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get changePasswordSubmit => 'Changer';

  @override
  String get changePasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get changePasswordMinLength => 'Minimum 10 caractères requis';

  @override
  String get changePasswordSuccess =>
      'Mot de passe principal changé avec succès';

  @override
  String get autoLockTitle => 'Verrouillage automatique';

  @override
  String get autoLockSetUpVaultFirst => 'Configurez d\'abord le coffre';

  @override
  String get autoLockDialogTitle => 'Délai de verrouillage automatique';

  @override
  String get autoLockTimeoutNever => 'Jamais';

  @override
  String get autoLockTimeout1Min => '1 minute';

  @override
  String get autoLockTimeout5Min => '5 minutes';

  @override
  String get autoLockTimeout15Min => '15 minutes';

  @override
  String get autoLockTimeout30Min => '30 minutes';

  @override
  String get autoLockTimeout1Hour => '1 heure';

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
  String get syncAccountTitle => 'Compte';

  @override
  String get syncSignedInDefault => 'Connecté';

  @override
  String get syncLocalOnlyTitle => 'Local uniquement';

  @override
  String get syncLocalOnlySubtitle =>
      'Passez à la version supérieure pour synchroniser entre appareils';

  @override
  String get syncCloudSyncTitle => 'Synchronisation cloud';

  @override
  String get syncCloudSyncSubtitle =>
      'Connectez-vous pour synchroniser entre appareils';

  @override
  String get accountDialogTitle => 'Compte';

  @override
  String get accountSignOut => 'Se déconnecter';

  @override
  String get accountSignedOut => 'Déconnecté';

  @override
  String get accountDeleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountWarning => 'Cette action est irréversible.';

  @override
  String get deleteAccountWillDelete => 'Cela supprimera définitivement :';

  @override
  String get deleteAccountItemAccount => '  • Votre compte et identifiant';

  @override
  String get deleteAccountItemSyncedData =>
      '  • Toutes les données synchronisées sur le serveur';

  @override
  String get deleteAccountItemVault =>
      '  • La configuration du coffre de chiffrement';

  @override
  String get deleteAccountLocalDataNote =>
      'Les données locales (hôtes, clés, paramètres) resteront sur cet appareil.';

  @override
  String get deleteAccountConfirmPrompt => 'Tapez DELETE pour confirmer :';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => 'Supprimer le compte';

  @override
  String get deleteAccountDeleting => 'Suppression du compte...';

  @override
  String get deleteAccountFailedDefault => 'Échec de la suppression du compte';

  @override
  String get deleteAccountSuccess =>
      'Compte supprimé. Données locales conservées.';

  @override
  String get syncAutoSyncTitle => 'Synchronisation automatique';

  @override
  String get syncUnlockVault =>
      'Déverrouillez le coffre pour activer la synchronisation';

  @override
  String get syncEvery5Minutes => 'Synchronisation toutes les 5 minutes';

  @override
  String get syncDisabled => 'La synchronisation est désactivée';

  @override
  String get syncNeverSynced => 'Jamais synchronisé';

  @override
  String get syncJustNow => 'À l\'instant';

  @override
  String get syncNowTitle => 'Synchroniser maintenant';

  @override
  String get syncSyncing => 'Synchronisation...';

  @override
  String syncResult(int pulled, int pushed) {
    return 'Synchronisé : $pulled récupérés, $pushed envoyés';
  }

  @override
  String syncFailed(String error) {
    return 'Échec de la synchronisation : $error';
  }

  @override
  String get totp2faTitle => 'Authentification 2FA';

  @override
  String get totpSignInToEnable => 'Connectez-vous pour activer';

  @override
  String get totpEnabled => 'Activé';

  @override
  String get totpNotConfigured => 'Non configuré';

  @override
  String get totpDisable2faTitle => 'Désactiver la 2FA ?';

  @override
  String get totpDisable2faMessage =>
      'Cela supprimera l\'authentification à deux facteurs de votre compte. Vous pourrez la réactiver à tout moment.';

  @override
  String get totpDisable2faSubmit => 'Désactiver';

  @override
  String get totpDisabled => '2FA désactivée';

  @override
  String get knownHostsTitle => 'Hôtes connus';

  @override
  String get knownHostsEmptyTitle => 'Aucun hôte connu';

  @override
  String get knownHostsEmptySubtitle =>
      'Les empreintes de clés d\'hôtes sont enregistrées ici lorsque vous vous connectez à un serveur pour la première fois.';

  @override
  String get knownHostsSearchHint => 'Rechercher des hôtes connus...';

  @override
  String get knownHostsLoadingMessage => 'Chargement des hôtes connus...';

  @override
  String get knownHostsRemoveTitle => 'Supprimer l\'hôte connu';

  @override
  String get knownHostsRemoveConfirmLabel => 'Supprimer';

  @override
  String get knownHostsMenuRemove => 'Supprimer';

  @override
  String get knownHostsFirstSeen => 'Première connexion';

  @override
  String get knownHostsLastSeen => 'Dernière connexion';

  @override
  String knownHostsNoMatchQuery(String query) {
    return 'Aucun hôte ne correspond à « $query »';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return 'Retirer la confiance pour $hostname:$port ?\n\nVous devrez vérifier la clé d\'hôte à nouveau lors de la prochaine connexion.';
  }

  @override
  String get sessionLogsTitle => 'Journaux de session';

  @override
  String get sessionLogsDeleteAllTooltip => 'Supprimer tous les journaux';

  @override
  String get sessionLogsEmpty => 'Aucun journal de session';

  @override
  String get sessionLogsEnableHint =>
      'Activez la journalisation depuis le menu du terminal';

  @override
  String get sessionLogsView => 'Voir';

  @override
  String get sessionLogsShare => 'Partager';

  @override
  String get sessionLogsDelete => 'Supprimer';

  @override
  String get sessionLogsShareSubject => 'Journal de session CloudShell';

  @override
  String get sessionLogsDeleteAllTitle => 'Supprimer tous les journaux ?';

  @override
  String get sessionLogsDeleteAllMessage =>
      'Cela supprimera définitivement tous les fichiers journaux de session.';

  @override
  String get sessionLogsDeleteAllConfirm => 'Tout supprimer';

  @override
  String get sessionLogsShareTooltip => 'Partager';

  @override
  String sessionLogsReadError(String error) {
    return 'Erreur de lecture du fichier : $error';
  }

  @override
  String get customThemeEditTitle => 'Modifier le thème';

  @override
  String get customThemeNewTitle => 'Nouveau thème personnalisé';

  @override
  String get customThemeSave => 'Enregistrer';

  @override
  String get customThemeNameLabel => 'Nom du thème';

  @override
  String get customThemeNameHint => 'ex. : Mon thème personnalisé';

  @override
  String get customThemeSectionTerminalChrome => 'Chrome du terminal';

  @override
  String get customThemeSectionNormalColors => 'Couleurs normales';

  @override
  String get customThemeSectionBrightColors => 'Couleurs vives';

  @override
  String get colorBackground => 'Arrière-plan';

  @override
  String get colorForeground => 'Premier plan';

  @override
  String get colorCursor => 'Curseur';

  @override
  String get colorSelection => 'Sélection';

  @override
  String get colorBlack => 'Noir';

  @override
  String get colorRed => 'Rouge';

  @override
  String get colorGreen => 'Vert';

  @override
  String get colorYellow => 'Jaune';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorMagenta => 'Magenta';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorWhite => 'Blanc';

  @override
  String get colorBrightBlack => 'Noir vif';

  @override
  String get colorBrightRed => 'Rouge vif';

  @override
  String get colorBrightGreen => 'Vert vif';

  @override
  String get colorBrightYellow => 'Jaune vif';

  @override
  String get colorBrightBlue => 'Bleu vif';

  @override
  String get colorBrightMagenta => 'Magenta vif';

  @override
  String get colorBrightCyan => 'Cyan vif';

  @override
  String get colorBrightWhite => 'Blanc vif';

  @override
  String get customThemePreviewTitle => 'Aperçu du terminal';

  @override
  String get customThemePreviewSelectedText => 'Aperçu du texte sélectionné';

  @override
  String get hexColorLabel => 'Couleur hexadécimale';

  @override
  String get hexColorPasteTooltip => 'Coller';

  @override
  String get hexColorInvalid => 'Hexadécimal invalide';

  @override
  String get hexColorApply => 'Appliquer';

  @override
  String get customThemeNameRequired => 'Le nom du thème est requis';

  @override
  String get sliderHue => 'T';

  @override
  String get sliderSaturation => 'S';

  @override
  String get sliderBrightness => 'V';

  @override
  String get sshConfigImportTitle => 'Importer la configuration SSH';

  @override
  String get sshConfigImportFailed =>
      'Échec de la lecture de la configuration SSH';

  @override
  String get sshConfigNoHostsFound => 'Aucun hôte trouvé';

  @override
  String get sshConfigNoHostsFoundDetail =>
      'Aucune entrée d\'hôte valide n\'a été trouvée dans ~/.ssh/config';

  @override
  String get sshConfigDeselectAll => 'Tout désélectionner';

  @override
  String get sshConfigSelectAll => 'Tout sélectionner';

  @override
  String get sshConfigImportKeys => 'Importer les clés';

  @override
  String sshConfigFoundHosts(int count) {
    return '$count hôte(s) trouvé(s) dans ~/.ssh/config';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return '$count hôte(s) et $keys clé(s) importé(s)';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return 'Importer ($count)';
  }

  @override
  String get legalScreenLoadError => 'Échec du chargement du document';

  @override
  String get workspacesTitle => 'Espaces de travail';

  @override
  String get workspacesSaveCurrent => 'Enregistrer l\'actuel';

  @override
  String get workspacesEmptyTitle => 'Aucun espace de travail enregistré';

  @override
  String get workspacesEmptySubtitle =>
      'La disposition actuelle de vos onglets est enregistrée automatiquement.\nUtilisez « Enregistrer l\'actuel » pour créer un espace de travail nommé.';

  @override
  String workspacesLoadError(String error) {
    return 'Échec du chargement des espaces de travail : $error';
  }

  @override
  String get workspacesActiveBadge => 'ACTIF';

  @override
  String get workspacesNoTerminals => 'Aucun terminal';

  @override
  String get workspacesJustNow => 'À l\'instant';

  @override
  String get workspacesMenuSwitchTo => 'Basculer vers';

  @override
  String get workspacesMenuRename => 'Renommer';

  @override
  String get workspacesMenuDelete => 'Supprimer';

  @override
  String get workspacesSaveTitle => 'Enregistrer l\'espace de travail';

  @override
  String get workspacesSaveHint => 'Nom de l\'espace de travail';

  @override
  String get workspacesSaveSave => 'Enregistrer';

  @override
  String get workspacesRenameTitle => 'Renommer l\'espace de travail';

  @override
  String get workspacesRenameHint => 'Nouveau nom';

  @override
  String get workspacesRenameSubmit => 'Renommer';

  @override
  String get workspacesDeleteTitle => 'Supprimer l\'espace de travail ?';

  @override
  String get workspacesDeleteSubmit => 'Supprimer';

  @override
  String workspaceTerminalCount(int count) {
    return '$count terminal(aux)';
  }

  @override
  String workspaceSaved(String name) {
    return 'Espace de travail « $name » enregistré';
  }

  @override
  String workspaceSwitching(String name) {
    return 'Basculement vers « $name »...';
  }

  @override
  String workspaceLoaded(String name) {
    return 'Espace de travail « $name » chargé';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return 'Supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String get awsImportTitle => 'Importer depuis AWS EC2';

  @override
  String get awsConnectTitle => 'Se connecter à AWS';

  @override
  String get awsConnectSubtitle =>
      'Entrez vos identifiants AWS pour importer les instances EC2.';

  @override
  String get awsAccessKeyIdLabel => 'ID de clé d\'accès';

  @override
  String get awsAccessKeyIdHelper => 'ex. : AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => 'Clé d\'accès secrète';

  @override
  String get awsRegionLabel => 'Région';

  @override
  String get awsCredentialsInfo =>
      'Les identifiants ne sont utilisés que pour cette importation et ne sont pas stockés. Utilisez un utilisateur IAM avec uniquement la permission ec2:DescribeInstances.';

  @override
  String get awsFetchInstances => 'Récupérer les instances';

  @override
  String get awsFetchingInstances => 'Récupération des instances...';

  @override
  String get awsErrorAccessKeyRequired => 'Entrez votre ID de clé d\'accès AWS';

  @override
  String get awsErrorSecretKeyRequired =>
      'Entrez votre clé d\'accès secrète AWS';

  @override
  String get awsSelectInstances => 'Sélectionner les instances';

  @override
  String get awsRunningOnlyFilter => 'En cours d\'exécution uniquement';

  @override
  String get awsNoRunningInstances =>
      'Aucune instance en cours d\'exécution trouvée';

  @override
  String get awsNoInstances => 'Aucune instance trouvée';

  @override
  String get awsConfigureImport => 'Configurer l\'importation';

  @override
  String get awsDefaultUsernameLabel => 'Nom d\'utilisateur par défaut';

  @override
  String get awsDefaultUsernameHelper =>
      'Amazon Linux : ec2-user, Ubuntu : ubuntu';

  @override
  String get awsInstancesToImport => 'Instances à importer :';

  @override
  String get awsImporting => 'Importation...';

  @override
  String awsImportResult(int count) {
    return '$count hôte(s) importé(s) depuis AWS EC2';
  }

  @override
  String awsImportHostsButton(int count) {
    return 'Importer $count hôte(s)';
  }

  @override
  String awsNextButton(int count) {
    return 'Suivant ($count)';
  }

  @override
  String get doImportTitle => 'Importer depuis DigitalOcean';

  @override
  String get doConnectTitle => 'Se connecter à DigitalOcean';

  @override
  String get doConnectSubtitle =>
      'Entrez votre jeton d\'accès personnel DigitalOcean pour importer les droplets.';

  @override
  String get doApiTokenLabel => 'Jeton API';

  @override
  String get doApiTokenHelper =>
      'Générez-le sur cloud.digitalocean.com/account/api/tokens';

  @override
  String get doTokenInfo =>
      'Votre jeton n\'est utilisé que pour cette importation et n\'est pas stocké.';

  @override
  String get doFetchDroplets => 'Récupérer les droplets';

  @override
  String get doFetchingDroplets => 'Récupération des droplets...';

  @override
  String get doErrorTokenRequired => 'Entrez votre jeton API';

  @override
  String get doSelectDroplets => 'Sélectionner les droplets';

  @override
  String get doActiveOnlyFilter => 'Actifs uniquement';

  @override
  String get doNoActiveDroplets => 'Aucun droplet actif trouvé';

  @override
  String get doNoDroplets => 'Aucun droplet trouvé';

  @override
  String get doConfigureImport => 'Configurer l\'importation';

  @override
  String get doDefaultUsernameLabel => 'Nom d\'utilisateur par défaut';

  @override
  String get doDefaultUsernameHelper =>
      'Utilisé pour tous les hôtes importés (par défaut : root)';

  @override
  String get doHostsToImport => 'Hôtes à importer :';

  @override
  String get doImporting => 'Importation...';

  @override
  String doImportResult(int count) {
    return '$count hôte(s) importé(s) depuis DigitalOcean';
  }

  @override
  String doImportHostsButton(int count) {
    return 'Importer $count hôte(s)';
  }

  @override
  String doNextButton(int count) {
    return 'Suivant ($count)';
  }

  @override
  String get loginSubtitle =>
      'Connectez-vous pour synchroniser entre appareils';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginErrorEmailRequired => 'Entrez votre adresse e-mail';

  @override
  String get loginErrorPasswordRequired => 'Entrez votre mot de passe';

  @override
  String get loginSigningIn => 'Connexion en cours...';

  @override
  String get loginSignIn => 'Se connecter';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String get loginUseLocally => 'Utiliser localement sans compte';

  @override
  String get signUpSubtitle => 'Créez votre compte';

  @override
  String get signUpEmailLabel => 'E-mail';

  @override
  String get signUpPasswordLabel => 'Mot de passe (min. 10 caractères)';

  @override
  String get signUpConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get passwordStrengthWeak => 'Faible';

  @override
  String get passwordStrengthFair => 'Moyen';

  @override
  String get passwordStrengthGood => 'Bon';

  @override
  String get passwordStrengthStrong => 'Fort';

  @override
  String get passwordStrengthExcellent => 'Excellent';

  @override
  String get signUpErrorEmailRequired => 'Entrez votre adresse e-mail';

  @override
  String get signUpErrorPasswordRequired => 'Entrez un mot de passe';

  @override
  String get signUpErrorPasswordTooShort =>
      'Le mot de passe doit contenir au moins 10 caractères';

  @override
  String get signUpErrorPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get signUpErrorTermsRequired =>
      'Veuillez accepter les conditions d\'utilisation';

  @override
  String get signUpEncryptionWarning =>
      'Vos données sont chiffrées de bout en bout. Nous ne pouvons pas récupérer votre compte si vous perdez votre mot de passe.';

  @override
  String get signUpTermsPrefix => 'J\'accepte les ';

  @override
  String get signUpTermsOfService => 'Conditions d\'utilisation';

  @override
  String get signUpTermsAnd => ' et la ';

  @override
  String get signUpPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get signUpCreatingAccount => 'Création du compte...';

  @override
  String get signUpCreateAccount => 'Créer un compte';

  @override
  String get signUpAlreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get signUpSignIn => 'Se connecter';

  @override
  String get signUpEncryptionNote => 'Chiffrement : Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => 'Réinitialiser votre mot de passe';

  @override
  String get forgotPasswordInstructions =>
      'Entrez l\'adresse e-mail associée à votre compte et nous vous enverrons un lien de réinitialisation.';

  @override
  String get forgotPasswordEmailLabel => 'E-mail';

  @override
  String get forgotPasswordSending => 'Envoi...';

  @override
  String get forgotPasswordSendResetLink =>
      'Envoyer le lien de réinitialisation';

  @override
  String get forgotPasswordBackToSignIn => 'Retour à la connexion';

  @override
  String get forgotPasswordErrorEmailRequired => 'Entrez votre adresse e-mail';

  @override
  String get forgotPasswordCheckEmail => 'Vérifiez votre e-mail';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return 'Si un compte existe pour $email, vous recevrez un lien de réinitialisation sous peu.';
  }

  @override
  String get forgotPasswordVaultWarning =>
      'Rappel : Nous utilisons le chiffrement à connaissance nulle. Si vous réinitialisez le mot de passe de votre compte, le mot de passe principal de votre coffre reste inchangé.';

  @override
  String get forgotPasswordTryAgain => 'Vous ne l\'avez pas reçu ? Réessayez';

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
  String get totpSetupTitle => 'Configurer la 2FA';

  @override
  String get totpSetupFailed => 'Échec de la configuration de la 2FA';

  @override
  String get totpSetupHeading => 'Authentification à deux facteurs';

  @override
  String get totpSetupInstructions =>
      'Scannez ce code QR avec votre application d\'authentification (Google Authenticator, Authy, etc.).';

  @override
  String get totpSetupManualEntryKey => 'Clé de saisie manuelle';

  @override
  String get totpSetupSecretCopied => 'Secret copié';

  @override
  String get totpSetupEnterCode =>
      'Entrez le code à 6 chiffres de votre application :';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => 'Vérification...';

  @override
  String get totpSetupVerifyAndEnable => 'Vérifier et activer';

  @override
  String get totpSetupEnabled => 'Authentification à deux facteurs activée';

  @override
  String get totpSetupErrorCodeLength => 'Entrez un code à 6 chiffres';

  @override
  String get totpSetupErrorInvalidCode =>
      'Code invalide. Vérifiez votre application d\'authentification et réessayez.';

  @override
  String get totpVerifyHeading => 'Authentification à deux facteurs';

  @override
  String get totpVerifyInstructions =>
      'Entrez le code à 6 chiffres de votre application d\'authentification';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => 'Vérification...';

  @override
  String get totpVerifySubmit => 'Vérifier';

  @override
  String get totpVerifyHelpText =>
      'Ouvrez votre application d\'authentification (Google Authenticator, Authy, etc.) pour trouver votre code de vérification.';

  @override
  String get totpVerifyErrorDefaultFailed => 'La vérification a échoué';

  @override
  String get totpVerifyErrorInvalidCode => 'Code invalide. Réessayez.';

  @override
  String get adaptiveScaffoldHosts => 'Hôtes';

  @override
  String get adaptiveScaffoldKeys => 'Clés';

  @override
  String get adaptiveScaffoldSnippets => 'Snippets';

  @override
  String get adaptiveScaffoldTerminal => 'Terminal';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => 'Redirection de ports';

  @override
  String get adaptiveScaffoldSettings => 'Paramètres';

  @override
  String get commandPaletteHint =>
      'Rechercher des hôtes, snippets, ou tapez une commande...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get commandPaletteHostsHeader => 'Hôtes';

  @override
  String get commandPaletteSnippetsHeader => 'Snippets';

  @override
  String get commandPaletteActionsHeader => 'Actions';

  @override
  String get commandPaletteActionNewHost => 'Nouvel hôte';

  @override
  String get commandPaletteActionQuickConnect => 'Connexion rapide';

  @override
  String get commandPaletteActionSettings => 'Paramètres';

  @override
  String get commandPaletteActionToggleTheme => 'Basculer le thème';

  @override
  String get shortcutReferenceTitle => 'Raccourcis clavier';

  @override
  String get shortcutCategoryGeneral => 'Général';

  @override
  String get shortcutCategoryTerminal => 'Terminal';

  @override
  String get shortcutCategoryNavigation => 'Navigation';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => 'Déverrouillez pour continuer';

  @override
  String get appLockUnlockButton => 'Déverrouiller';

  @override
  String get appLockUnlockWithBiometrics => 'Déverrouiller avec la biométrie';

  @override
  String get appLockBiometricReason =>
      'Authentifiez-vous pour déverrouiller CloudShell';

  @override
  String get appLockFailed => 'Échec de l\'authentification';

  @override
  String get statusOnline => 'En ligne';

  @override
  String get statusOffline => 'Hors ligne';

  @override
  String get statusWarning => 'Avertissement';

  @override
  String get statusIdle => 'Inactif';

  @override
  String get vaultUnlockTitle => 'Déverrouiller le coffre';

  @override
  String get vaultUnlockSubtitle =>
      'Entrez votre mot de passe principal pour déverrouiller le coffre.';

  @override
  String get vaultUnlockPasswordLabel => 'Mot de passe principal';

  @override
  String get vaultUnlockPasswordHint => 'Entrez le mot de passe principal';

  @override
  String get vaultUnlockButton => 'Déverrouiller';

  @override
  String get vaultUnlockUnlocking => 'Déverrouillage...';

  @override
  String get vaultUnlockBiometricButton => 'Déverrouiller avec la biométrie';

  @override
  String get vaultUnlockForgotPassword => 'Mot de passe oublié ?';

  @override
  String get vaultUnlockResetTitle => 'Réinitialiser le coffre ?';

  @override
  String get vaultUnlockResetMessage =>
      'La réinitialisation supprimera toutes les données chiffrées (mots de passe enregistrés, clés privées). Les hôtes et paramètres locaux seront conservés.\n\nCette action est irréversible.';

  @override
  String get vaultUnlockResetConfirm => 'Réinitialiser le coffre';

  @override
  String get vaultUnlockIncorrectPassword => 'Mot de passe incorrect';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return 'Trop de tentatives. Réessayez dans $seconds s.';
  }

  @override
  String get masterPasswordSetupTitle => 'Configurer le coffre';

  @override
  String get masterPasswordSetupSubtitle =>
      'Créez un mot de passe principal pour chiffrer vos données sensibles.';

  @override
  String get masterPasswordSetupPasswordLabel => 'Mot de passe principal';

  @override
  String get masterPasswordSetupPasswordHint => 'Minimum 10 caractères';

  @override
  String get masterPasswordSetupConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get masterPasswordSetupConfirmHint =>
      'Resaisissez le mot de passe principal';

  @override
  String get masterPasswordSetupButton => 'Créer le coffre';

  @override
  String get masterPasswordSetupCreating => 'Création du coffre...';

  @override
  String get masterPasswordSetupMinLength => 'Minimum 10 caractères requis';

  @override
  String get masterPasswordSetupMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get masterPasswordSetupStrengthWeak => 'Faible';

  @override
  String get masterPasswordSetupStrengthFair => 'Moyen';

  @override
  String get masterPasswordSetupStrengthGood => 'Bon';

  @override
  String get masterPasswordSetupStrengthStrong => 'Fort';

  @override
  String get masterPasswordSetupWarning =>
      'Votre mot de passe principal ne peut pas être récupéré. Notez-le et conservez-le en lieu sûr.';

  @override
  String get passwordGeneratorTitle => 'Générateur de mot de passe';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return 'Longueur : $length';
  }

  @override
  String get passwordGeneratorUppercase => 'Majuscules (A-Z)';

  @override
  String get passwordGeneratorLowercase => 'Minuscules (a-z)';

  @override
  String get passwordGeneratorNumbers => 'Chiffres (0-9)';

  @override
  String get passwordGeneratorSymbols => 'Symboles (!@#...)';

  @override
  String get passwordGeneratorGenerate => 'Générer';

  @override
  String get passwordGeneratorCopy => 'Copier';

  @override
  String get passwordGeneratorCopied =>
      'Mot de passe copié (effacement automatique dans 30 s)';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bits bits d\'entropie';
  }

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur CloudShell';

  @override
  String get onboardingWelcomeSubtitle =>
      'Un client SSH moderne et multiplateforme';

  @override
  String get onboardingSecureTitle => 'Sécurisé par conception';

  @override
  String get onboardingSecureSubtitle =>
      'Coffre chiffré de bout en bout avec Argon2id + AES-256-GCM';

  @override
  String get onboardingTerminalTitle => 'Terminal puissant';

  @override
  String get onboardingTerminalSubtitle =>
      'Panneaux divisés, onglets, thèmes, snippets et plus encore';

  @override
  String get onboardingSyncTitle => 'Synchronisez partout';

  @override
  String get onboardingSyncSubtitle =>
      'Vos hôtes, clés et snippets — sur tous vos appareils';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get portForwardingTitle => 'Redirection de ports';

  @override
  String get portForwardingAddTooltip => 'Ajouter une règle';

  @override
  String get portForwardingEmptyTitle => 'Aucune règle de redirection de ports';

  @override
  String get portForwardingEmptySubtitle =>
      'Créez des règles pour tunneliser le trafic via des connexions SSH.';

  @override
  String get portForwardingEmptyAction => 'Ajouter une règle';

  @override
  String get portForwardingActiveHeader => 'ACTIVES';

  @override
  String get portForwardingSavedHeader => 'RÈGLES ENREGISTRÉES';

  @override
  String get portForwardingTypeLocal => 'Local';

  @override
  String get portForwardingTypeRemote => 'Distant';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => 'Arrêter';

  @override
  String get portForwardingStart => 'Démarrer';

  @override
  String get portForwardingMenuEdit => 'Modifier';

  @override
  String get portForwardingMenuDelete => 'Supprimer';

  @override
  String get portForwardingDeleteDialogTitle => 'Supprimer la règle';

  @override
  String get portForwardingDeleteDialogMessage =>
      'Supprimer cette règle de redirection de ports ?';

  @override
  String get portForwardingLoading =>
      'Chargement des règles de redirection de ports...';

  @override
  String get portForwardFormTitleNew => 'Nouvelle redirection de port';

  @override
  String get portForwardFormTitleEdit => 'Modifier la redirection de port';

  @override
  String get portForwardFormLabelField => 'Libellé';

  @override
  String get portForwardFormLabelHint => 'ex. : Tunnel base de données';

  @override
  String get portForwardFormTypeField => 'Type';

  @override
  String get portForwardFormTypeLocal => 'Local';

  @override
  String get portForwardFormTypeRemote => 'Distant';

  @override
  String get portForwardFormTypeDynamic => 'Dynamique (SOCKS)';

  @override
  String get portForwardFormHostField => 'Hôte';

  @override
  String get portForwardFormSelectHost => 'Sélectionner un hôte';

  @override
  String get portForwardFormNoHostsAvailable =>
      'Aucun hôte disponible. Créez d\'abord un hôte.';

  @override
  String get portForwardFormCouldNotLoadHosts =>
      'Impossible de charger les hôtes.';

  @override
  String get portForwardFormLocalPortField => 'Port local';

  @override
  String get portForwardFormRemotePortField => 'Port distant';

  @override
  String get portForwardFormDestHostField => 'Hôte de destination';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => 'Port de destination';

  @override
  String get portForwardFormDestPortHint => 'ex. : 5432';

  @override
  String get portForwardFormPortHint => 'ex. : 8080';

  @override
  String get portForwardFormAutoStart => 'Démarrage automatique à la connexion';

  @override
  String get portForwardFormAutoStartSubtitle =>
      'Démarrer ce tunnel automatiquement lors de la connexion à l\'hôte.';

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
  String get languageSystem => 'Par défaut du système';
}
