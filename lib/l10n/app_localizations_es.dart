// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'CloudShell';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Cerrar';

  @override
  String get retry => 'Reintentar';

  @override
  String get back => 'Atrás';

  @override
  String get edit => 'Editar';

  @override
  String get done => 'Hecho';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get search => 'Buscar';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String get togglePasswordVisibility => 'Alternar visibilidad de contraseña';

  @override
  String get togglePassphraseVisibility =>
      'Alternar visibilidad de frase de contraseña';

  @override
  String get ok => 'Aceptar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get none => 'Ninguno';

  @override
  String get unknown => 'Desconocido';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get hostsTitle => 'Hosts';

  @override
  String get hostsAddTooltip => 'Añadir host';

  @override
  String get hostsSearchHint => 'Buscar hosts...';

  @override
  String get hostsEmptyTitle => 'No hay hosts aún';

  @override
  String get hostsEmptySubtitle =>
      'Añade tu primer servidor SSH para comenzar.';

  @override
  String get hostsEmptyAction => 'Añadir Host';

  @override
  String hostsNoMatchQuery(String query) {
    return 'Ningún host coincide con \"$query\"';
  }

  @override
  String get hostsLoadingMessage => 'Cargando hosts...';

  @override
  String get hostsRecentHeader => 'RECIENTES';

  @override
  String get hostsGroupsHeader => 'GRUPOS';

  @override
  String get hostsFavoritesHeader => 'FAVORITOS';

  @override
  String get hostsAllHostsHeader => 'TODOS LOS HOSTS';

  @override
  String get hostsUngroupedHeader => 'SIN GRUPO';

  @override
  String get hostsDeleteDialogTitle => 'Eliminar Host';

  @override
  String hostsDeleteDialogMessage(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"?';
  }

  @override
  String get hostsMenuEdit => 'Editar';

  @override
  String get hostsMenuDelete => 'Eliminar';

  @override
  String get hostsMenuConnect => 'Conectar';

  @override
  String get hostsMenuSftp => 'SFTP';

  @override
  String hostsLastConnected(String time) {
    return 'Última conexión $time';
  }

  @override
  String get hostsNeverConnected => 'Nunca conectado';

  @override
  String get hostsJustNow => 'Justo ahora';

  @override
  String get hostFormTitleNew => 'Nuevo Host';

  @override
  String get hostFormTitleEdit => 'Editar Host';

  @override
  String get hostFormSave => 'Guardar';

  @override
  String get hostFormLabelField => 'Etiqueta';

  @override
  String get hostFormLabelHint => 'ej., Servidor de Producción';

  @override
  String get hostFormLabelRequired => 'La etiqueta es obligatoria';

  @override
  String get hostFormHostnameField => 'Nombre de host';

  @override
  String get hostFormHostnameHint => 'ej., 192.168.1.100 o ejemplo.com';

  @override
  String get hostFormHostnameRequired => 'El nombre de host es obligatorio';

  @override
  String get hostFormPortField => 'Puerto';

  @override
  String get hostFormUsernameField => 'Usuario';

  @override
  String get hostFormUsernameHint => 'ej., root';

  @override
  String get hostFormUsernameRequired => 'El usuario es obligatorio';

  @override
  String get hostFormPasswordField => 'Contraseña';

  @override
  String get hostFormPasswordHint => 'Introduce la contraseña';

  @override
  String get hostFormAuthMethodField => 'Método de autenticación';

  @override
  String get hostFormAuthMethodKey => 'Clave';

  @override
  String get hostFormAuthMethodPassword => 'Contraseña';

  @override
  String get hostFormAuthMethodKeyAndPassword => 'Clave + Contraseña';

  @override
  String get hostFormKeyField => 'Clave SSH';

  @override
  String get hostFormKeyNone => 'Ninguna';

  @override
  String get hostFormGroupField => 'Grupo';

  @override
  String get hostFormGroupNone => 'Sin grupo';

  @override
  String get hostFormTagsField => 'Etiquetas';

  @override
  String get hostFormTagsHint => 'Añadir etiquetas (separadas por comas)';

  @override
  String get hostFormAdvancedSection => 'Avanzado';

  @override
  String get hostFormJumpHostField => 'Host de salto (Proxy)';

  @override
  String get hostFormJumpHostNone => 'Ninguno (conexión directa)';

  @override
  String get hostFormKeepAliveField => 'Mantener vivo (segundos)';

  @override
  String get hostFormStartupCommandField => 'Comando de inicio';

  @override
  String get hostFormStartupCommandHint =>
      'Ejecutar después de conectar (opcional)';

  @override
  String get hostFormNotesField => 'Notas';

  @override
  String get hostFormNotesHint => 'Notas opcionales sobre este host';

  @override
  String get hostFormProtocolSsh => 'SSH';

  @override
  String get hostFormProtocolTelnet => 'Telnet';

  @override
  String get hostFormProtocolSerial => 'Serial';

  @override
  String get hostFormSerialPortField => 'Puerto serial';

  @override
  String get hostFormSerialPortNone => 'Seleccionar puerto';

  @override
  String get hostFormSerialNoPortsAvailable =>
      'No hay puertos seriales disponibles';

  @override
  String get hostFormSerialBaudRateField => 'Velocidad en baudios';

  @override
  String get hostFormSerialDataBitsField => 'Bits de datos';

  @override
  String get hostFormSerialStopBitsField => 'Bits de parada';

  @override
  String get hostFormSerialParityField => 'Paridad';

  @override
  String get hostFormSerialFlowControlField => 'Control de flujo';

  @override
  String get hostFormTestConnection => 'Probar Conexión';

  @override
  String get hostFormTestConnectionSuccess => '¡Conexión exitosa!';

  @override
  String hostFormTestConnectionFailed(String error) {
    return 'Conexión fallida: $error';
  }

  @override
  String get hostDetailTitle => 'Detalles del Host';

  @override
  String get hostDetailConnect => 'Conectar';

  @override
  String get hostDetailSftp => 'SFTP';

  @override
  String get hostDetailEditTooltip => 'Editar';

  @override
  String get hostDetailDeleteTooltip => 'Eliminar';

  @override
  String get hostDetailFavoriteTooltip => 'Favorito';

  @override
  String get hostDetailSectionConnection => 'Conexión';

  @override
  String get hostDetailSectionAuthentication => 'Autenticación';

  @override
  String get hostDetailSectionAdvanced => 'Avanzado';

  @override
  String get hostDetailSectionTags => 'Etiquetas';

  @override
  String get hostDetailSectionNotes => 'Notas';

  @override
  String get hostDetailLabelHostname => 'Nombre de host';

  @override
  String get hostDetailLabelPort => 'Puerto';

  @override
  String get hostDetailLabelUsername => 'Usuario';

  @override
  String get hostDetailLabelAuthMethod => 'Método de autenticación';

  @override
  String get hostDetailLabelKey => 'Clave';

  @override
  String get hostDetailLabelGroup => 'Grupo';

  @override
  String get hostDetailLabelJumpHost => 'Host de salto';

  @override
  String get hostDetailLabelKeepAlive => 'Mantener vivo';

  @override
  String get hostDetailLabelStartupCommand => 'Comando de inicio';

  @override
  String get hostDetailLabelProtocol => 'Protocolo';

  @override
  String get hostDetailLabelCreated => 'Creado';

  @override
  String get hostDetailLabelUpdated => 'Actualizado';

  @override
  String get hostDetailLabelLastConnected => 'Última conexión';

  @override
  String get hostDetailNotFound => 'Host no encontrado';

  @override
  String get hostDetailLoading => 'Cargando host...';

  @override
  String get hostDetailDeleteDialogTitle => 'Eliminar Host';

  @override
  String hostDetailDeleteDialogMessage(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get quickConnectTitle => 'Conexión Rápida';

  @override
  String get quickConnectHint => 'usuario@host:puerto';

  @override
  String get quickConnectHelperText => 'ej., root@192.168.1.100:22';

  @override
  String get quickConnectSaveHost => 'Guardar host';

  @override
  String get quickConnectConnect => 'Conectar';

  @override
  String get quickConnectInvalidFormat =>
      'Formato inválido. Usa usuario@host o usuario@host:puerto';

  @override
  String get groupFormTitleNew => 'Nuevo Grupo';

  @override
  String get groupFormTitleEdit => 'Editar Grupo';

  @override
  String get groupFormNameField => 'Nombre del Grupo';

  @override
  String get groupFormNameHint => 'ej., Producción';

  @override
  String get groupFormNameRequired => 'El nombre del grupo es obligatorio';

  @override
  String get groupFormParentField => 'Grupo padre';

  @override
  String get groupFormParentNone => 'Ninguno (nivel superior)';

  @override
  String get groupFormDeleteDialogTitle => 'Eliminar Grupo';

  @override
  String groupFormDeleteDialogMessage(String name) {
    return '¿Eliminar \"$name\"? Los hosts en este grupo quedarán sin grupo.';
  }

  @override
  String get hostKeyVerifyChangedTitle => 'La clave del host ha cambiado';

  @override
  String get hostKeyVerifyUnknownTitle => 'Host desconocido';

  @override
  String get hostKeyVerifyChangedWarning =>
      'ADVERTENCIA: La clave del host de este servidor ha cambiado. Esto podría indicar un ataque de intermediario.';

  @override
  String get hostKeyVerifyUnknownMessage =>
      'No se puede verificar la autenticidad de este host. ¿Estás seguro de que quieres continuar conectando?';

  @override
  String get hostKeyVerifyLabelHost => 'Host';

  @override
  String get hostKeyVerifyLabelKeyType => 'Tipo de clave';

  @override
  String get hostKeyVerifyLabelFingerprint => 'Huella digital:';

  @override
  String get hostKeyVerifyFingerprintCopied =>
      'Huella digital copiada (se borra automáticamente en 30s)';

  @override
  String get hostKeyVerifyTrustAnyway => 'Confiar de todos modos';

  @override
  String get hostKeyVerifyTrustAndConnect => 'Confiar y Conectar';

  @override
  String get keysTitle => 'Claves SSH';

  @override
  String get keysAddTooltip => 'Importar clave';

  @override
  String get keysImportTooltip => 'Importar clave';

  @override
  String get keysEmptyTitle => 'No hay claves SSH';

  @override
  String get keysEmptySubtitle =>
      'Importa tus claves SSH para autenticarte con los servidores.';

  @override
  String get keysEmptyAction => 'Importar Clave';

  @override
  String get keysSearchHint => 'Buscar claves...';

  @override
  String keysNoMatchQuery(String query) {
    return 'Ninguna clave coincide con \"$query\"';
  }

  @override
  String get keysLoadingMessage => 'Cargando claves...';

  @override
  String get keysDeleteDialogTitle => 'Eliminar Clave';

  @override
  String keysDeleteDialogMessage(String name) {
    return '¿Eliminar \"$name\"? Esto no se puede deshacer.';
  }

  @override
  String get keysMenuDelete => 'Eliminar';

  @override
  String keysAssociatedHosts(int count) {
    return '$count host(s)';
  }

  @override
  String get keyDetailTitle => 'Detalles de la Clave';

  @override
  String get keyDetailEditTooltip => 'Editar';

  @override
  String get keyDetailDeleteTooltip => 'Eliminar';

  @override
  String get keyDetailSectionPublicKey => 'Clave Pública';

  @override
  String get keyDetailCopyPublicKey => 'Copiar clave pública';

  @override
  String get keyDetailSectionFingerprint => 'Huella digital';

  @override
  String get keyDetailSectionAssociatedHosts => 'Hosts Asociados';

  @override
  String get keyDetailSectionDetails => 'Detalles';

  @override
  String get keyDetailLabelType => 'Tipo';

  @override
  String get keyDetailLabelBits => 'Bits';

  @override
  String get keyDetailLabelCreated => 'Creado';

  @override
  String get keyDetailNotFound => 'Clave no encontrada';

  @override
  String get keyDetailLoading => 'Cargando clave...';

  @override
  String get keyDetailPublicKeyCopied =>
      'Clave pública copiada (se borra automáticamente en 30s)';

  @override
  String get keyDetailFingerprintCopied =>
      'Huella digital copiada (se borra automáticamente en 30s)';

  @override
  String get keyDetailNoAssociatedHosts => 'Ningún host usa esta clave';

  @override
  String get keyImportTitle => 'Importar Clave SSH';

  @override
  String get keyImportButton => 'Importar';

  @override
  String get keyImportButtonImporting => 'Importando...';

  @override
  String get keyImportButtonImportKey => 'Importar Clave';

  @override
  String get keyImportLabelField => 'Etiqueta';

  @override
  String get keyImportLabelHint => 'ej., Mi Clave del Servidor';

  @override
  String get keyImportPassphraseField => 'Frase de contraseña (opcional)';

  @override
  String get keyImportPassphraseHint =>
      'Dejar vacío si la clave no está cifrada';

  @override
  String get keyImportPrivateKeyField => 'Clave Privada';

  @override
  String get keyImportFromFile => 'Desde Archivo';

  @override
  String get keyImportPaste => 'Pegar';

  @override
  String get keyImportPlaceholder =>
      '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\no PuTTY-User-Key-File-2: ssh-rsa...';

  @override
  String get keyImportSupportedFormats =>
      'Formatos soportados: OpenSSH, PEM, PuTTY PPK (RSA, Ed25519, ECDSA). Tu clave privada se almacena de forma segura en el llavero de la plataforma y nunca sale de este dispositivo.';

  @override
  String keyImportFailedToReadFile(String error) {
    return 'Error al leer el archivo: $error';
  }

  @override
  String get keyImportClipboardEmpty => 'El portapapeles está vacío';

  @override
  String get keyImportPasteOrSelectKey =>
      'Por favor, pega o selecciona una clave privada';

  @override
  String keyImportSuccess(String fingerprint) {
    return 'Clave importada: $fingerprint';
  }

  @override
  String get terminalNoActiveSessions => 'No hay sesiones activas';

  @override
  String get terminalQuickConnect => 'Conexión Rápida';

  @override
  String get terminalRecentHostsHeader => 'HOSTS RECIENTES';

  @override
  String get terminalDesktopShortcutHints =>
      '⌘N  Nuevo Host  ·  ⌘⇧N  Conexión Rápida  ·  ⌘K  Buscar';

  @override
  String get terminalMobileShortcutHint => 'Toca + para conectar a un host';

  @override
  String terminalConnectingToHost(String label) {
    return 'Conectando a $label...';
  }

  @override
  String terminalReconnecting(int attempt, int maxAttempts) {
    return 'Reconectando... ($attempt/$maxAttempts)';
  }

  @override
  String get terminalReconnectCancel => 'Cancelar';

  @override
  String get terminalConnectionLost => 'Conexión perdida';

  @override
  String get terminalSearchHint => 'Buscar en terminal...';

  @override
  String get terminalSearchNoMatches => '0/0';

  @override
  String get terminalSearchClose => 'Cerrar (Esc)';

  @override
  String get terminalConnectionInfoTitle => 'Info de Conexión';

  @override
  String get terminalStatusReconnecting => 'Reconectando...';

  @override
  String get terminalStatusConnected => 'Conectado';

  @override
  String get terminalStatusDisconnected => 'Desconectado';

  @override
  String get terminalInfoLabelHost => 'Host';

  @override
  String get terminalInfoLabelAddress => 'Dirección';

  @override
  String get terminalInfoLabelUsername => 'Usuario';

  @override
  String get terminalInfoLabelProxyJump => 'Proxy Jump';

  @override
  String get terminalInfoValueProxyJump => 'A través de host bastión';

  @override
  String get terminalInfoLabelUptime => 'Tiempo activo';

  @override
  String get terminalInfoLabelConnectedAt => 'Conectado a las';

  @override
  String get terminalInfoLabelSessionId => 'ID de Sesión';

  @override
  String get terminalInfoLabelSplit => 'División';

  @override
  String get terminalInfoValueSplitHorizontal => 'Horizontal (2 paneles)';

  @override
  String get terminalInfoValueSplitVertical => 'Vertical (2 paneles)';

  @override
  String get terminalInfoLabelLogging => 'Registro';

  @override
  String get terminalInfoValueLoggingActive => 'Activo';

  @override
  String get terminalStatusBarDefaultDuration => '0:00';

  @override
  String get terminalStatusBarLogActive => 'LOG';

  @override
  String get terminalStatusBarLogInactive => 'Log';

  @override
  String get terminalBroadcastOnTooltip =>
      'Difusión ACTIVADA — toca para alternar, mantén pulsado para opciones';

  @override
  String get terminalBroadcastOffTooltip =>
      'Difusión DESACTIVADA — toca para alternar, mantén pulsado para opciones';

  @override
  String terminalBroadcastCastActiveWithCount(int count) {
    return 'CAST ($count)';
  }

  @override
  String get terminalBroadcastCastActive => 'CAST';

  @override
  String get terminalBroadcastCastInactive => 'Cast';

  @override
  String get terminalHeaderBackTooltip => 'Atrás';

  @override
  String get terminalHeaderNewConnectionTooltip => 'Nueva conexión';

  @override
  String get terminalHeaderSnippetsTooltip => 'Snippets';

  @override
  String get terminalHeaderCopyTooltip => 'Copiar selección';

  @override
  String get terminalHeaderPasteTooltip => 'Pegar';

  @override
  String get terminalHeaderNewTabTooltip => 'Nueva pestaña';

  @override
  String get extraKeyEsc => 'ESC';

  @override
  String get extraKeyTab => 'TAB';

  @override
  String get extraKeyCtl => 'CTL';

  @override
  String get extraKeyAlt => 'ALT';

  @override
  String get broadcastPanelTitle => 'Difusión de Entrada';

  @override
  String get broadcastPanelDisable => 'Desactivar';

  @override
  String get broadcastPanelDescription =>
      'Selecciona qué terminales reciben tu entrada de teclado.';

  @override
  String get broadcastPanelBroadcastToAll => 'Difundir a Todos';

  @override
  String broadcastPanelConnectedSessions(int count) {
    return '$count sesiones conectadas';
  }

  @override
  String get broadcastPanelActiveLabel => 'ACTIVO';

  @override
  String get broadcastPanelTabConnected => 'Conectado';

  @override
  String get broadcastPanelTabDisconnected => 'Desconectado';

  @override
  String get snippetsTitle => 'Snippets';

  @override
  String get snippetsAddTooltip => 'Añadir snippet';

  @override
  String get snippetsEmptyTitle => 'No hay snippets';

  @override
  String get snippetsEmptySubtitle =>
      'Guarda comandos frecuentes para acceso rápido.';

  @override
  String get snippetsEmptyAction => 'Añadir Snippet';

  @override
  String get snippetsSearchHint => 'Buscar snippets...';

  @override
  String snippetsNoMatchQuery(String query) {
    return 'Ningún snippet coincide con \"$query\"';
  }

  @override
  String get snippetsLoadingMessage => 'Cargando snippets...';

  @override
  String get snippetsUncategorized => 'Sin categoría';

  @override
  String get snippetsHasVariables => 'Tiene variables';

  @override
  String get snippetsCopyCommandTooltip => 'Copiar comando';

  @override
  String get snippetsMenuEdit => 'Editar';

  @override
  String get snippetsMenuDelete => 'Eliminar';

  @override
  String get snippetsCopiedMessage =>
      'Comando copiado (se borra automáticamente en 30s)';

  @override
  String get snippetsDeleteDialogTitle => 'Eliminar Snippet';

  @override
  String snippetsDeleteDialogMessage(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"?';
  }

  @override
  String get snippetDetailNotFound => 'Snippet no encontrado';

  @override
  String get snippetDetailLoading => 'Cargando snippet...';

  @override
  String get snippetDetailEditTooltip => 'Editar';

  @override
  String get snippetDetailDeleteTooltip => 'Eliminar';

  @override
  String get snippetDetailSectionCommand => 'Comando';

  @override
  String get snippetDetailCopyCommandTooltip => 'Copiar comando';

  @override
  String get snippetDetailSectionVariables => 'Variables';

  @override
  String get snippetDetailSectionDescription => 'Descripción';

  @override
  String get snippetDetailSectionDetails => 'Detalles';

  @override
  String get snippetDetailLabelCreated => 'Creado';

  @override
  String get snippetDetailLabelUpdated => 'Actualizado';

  @override
  String get snippetDetailCopiedMessage =>
      'Comando copiado (se borra automáticamente en 30s)';

  @override
  String get snippetFormTitleEdit => 'Editar Snippet';

  @override
  String get snippetFormTitleNew => 'Nuevo Snippet';

  @override
  String get snippetFormNameLabel => 'Nombre del Snippet';

  @override
  String get snippetFormNameHint => 'ej., Verificar espacio en disco';

  @override
  String get snippetFormNameRequired => 'El nombre es obligatorio';

  @override
  String get snippetFormCommandLabel => 'Comando';

  @override
  String get snippetFormCommandHint =>
      'ej., df -h\nUsa variables con doble llave como marcadores';

  @override
  String get snippetFormCommandRequired => 'El comando es obligatorio';

  @override
  String get snippetFormVariablesLabel => 'Variables:';

  @override
  String get snippetFormCategoryLabel => 'Categoría (opcional)';

  @override
  String get snippetFormCategoryHint => 'ej., Sistema, Docker, Red';

  @override
  String get snippetFormDescriptionLabel => 'Descripción (opcional)';

  @override
  String get snippetFormDescriptionHint => '¿Qué hace este comando?';

  @override
  String get snippetFormSaveButtonEdit => 'Actualizar Snippet';

  @override
  String get snippetFormSaveButtonNew => 'Crear Snippet';

  @override
  String snippetFormSaveError(String error) {
    return 'Error al guardar snippet: $error';
  }

  @override
  String get snippetPickerSearchHint => 'Buscar snippets...';

  @override
  String get snippetPickerEmptyMessage =>
      'No hay snippets. Crea uno desde la pantalla de Snippets.';

  @override
  String snippetPickerNoMatchQuery(String query) {
    return 'Ningún snippet coincide con \"$query\"';
  }

  @override
  String get snippetPickerLoadingError => 'Error al cargar snippets';

  @override
  String get snippetPickerVariableDialogTitle => 'Completar Variables';

  @override
  String snippetPickerVariableHint(String variable) {
    return 'Introduce valor para $variable';
  }

  @override
  String get snippetPickerVariableInsert => 'Insertar';

  @override
  String get sftpSelectHostHint => 'Seleccionar host...';

  @override
  String get sftpConnecting => 'Conectando...';

  @override
  String get sftpUploadLabel => 'Subir';

  @override
  String get sftpDownloadLabel => 'Descargar';

  @override
  String get sftpNoSavedHostsTitle => 'No hay hosts guardados';

  @override
  String get sftpNoSavedHostsSubtitle =>
      'Añade un host primero y luego vuelve para transferir archivos.';

  @override
  String get sftpFailedToLoadHosts => 'Error al cargar hosts';

  @override
  String sftpFailedToConnect(String error) {
    return 'Error al conectar: $error';
  }

  @override
  String get sftpConnectToHostFirst => 'Conecta a un host primero';

  @override
  String get sftpDropFilesToUpload => 'Arrastra archivos para subir';

  @override
  String get sftpTabLocal => 'Local';

  @override
  String get sftpTabRemote => 'Remoto';

  @override
  String get sftpPaneHeaderLocal => 'LOCAL';

  @override
  String get sftpPaneHeaderRemote => 'REMOTO';

  @override
  String get sftpLocalPermissionDenied => 'Permiso denegado';

  @override
  String get sftpLocalEmptyFolder => 'Carpeta vacía';

  @override
  String get sftpLocalCannotOpenFolder => 'No se puede abrir la carpeta';

  @override
  String get sftpRemoteSelectHost => 'Selecciona un host para explorar';

  @override
  String get sftpRemoteSelectHostSubtitle =>
      'Usa el desplegable de arriba para elegir un servidor conectado';

  @override
  String get sftpRemoteEmptyDirectory => 'Directorio vacío';

  @override
  String sftpRemoteCannotOpenFolder(String message) {
    return 'No se puede abrir la carpeta: $message';
  }

  @override
  String get sftpRemoteReadOnly => 'Solo lectura';

  @override
  String get sftpRemoteNewFolderTooltip => 'Nueva carpeta';

  @override
  String get sftpHideHiddenFiles => 'Ocultar archivos ocultos';

  @override
  String get sftpShowHiddenFiles => 'Mostrar archivos ocultos';

  @override
  String get sftpGoUp => 'Subir';

  @override
  String get sftpNewFolderDialogTitle => 'Nueva Carpeta';

  @override
  String get sftpNewFolderDialogLabel => 'Nombre de la carpeta';

  @override
  String get sftpNewFolderDialogHint => 'ej., nueva-carpeta';

  @override
  String get sftpNewFolderDialogCreate => 'Crear';

  @override
  String get sftpFileMenuEdit => 'Editar';

  @override
  String get sftpFileMenuPermissions => 'Permisos';

  @override
  String get sftpFileMenuDelete => 'Eliminar';

  @override
  String sftpPermissionsDialogTitle(String fileName) {
    return 'Permisos — $fileName';
  }

  @override
  String get sftpPermissionsOctalLabel => 'Octal: ';

  @override
  String get sftpPermissionsLabelUser => 'Usuario';

  @override
  String get sftpPermissionsLabelGroup => 'Grupo';

  @override
  String get sftpPermissionsLabelOther => 'Otros';

  @override
  String get sftpPermissionsBitRead => 'Lectura';

  @override
  String get sftpPermissionsBitWrite => 'Escritura';

  @override
  String get sftpPermissionsBitExec => 'Ejecución';

  @override
  String get sftpPermissionsApply => 'Aplicar';

  @override
  String get sftpTransfersHeader => 'Transferencias';

  @override
  String get sftpTransfersClearDone => 'Limpiar completados';

  @override
  String get sftpTransferStatusDone => 'Hecho';

  @override
  String get sftpTransferStatusFailed => 'Fallido';

  @override
  String get remoteEditorSaveTooltip => 'Guardar';

  @override
  String get remoteEditorFileSaved => 'Archivo guardado';

  @override
  String remoteEditorFailedToSave(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get remoteEditorUnsavedChangesTitle => 'Cambios sin guardar';

  @override
  String get remoteEditorUnsavedChangesMessage =>
      'Tienes cambios sin guardar. ¿Descartarlos?';

  @override
  String get remoteEditorDiscard => 'Descartar';

  @override
  String get remoteEditorFailedToLoadFile => 'Error al cargar el archivo';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionConnection => 'Conexión';

  @override
  String get sectionNotifications => 'Notificaciones';

  @override
  String get sectionSecurity => 'Seguridad';

  @override
  String get sectionTools => 'Herramientas';

  @override
  String get sectionData => 'Datos';

  @override
  String get sectionCloudImport => 'Importación en la Nube';

  @override
  String get sectionSync => 'Sincronización';

  @override
  String get sectionAbout => 'Acerca de';

  @override
  String get settingThemeTitle => 'Tema';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get settingTerminalThemeTitle => 'Tema del Terminal';

  @override
  String get settingFontFamilyTitle => 'Familia de Fuente';

  @override
  String get settingFontSizeTitle => 'Tamaño de Fuente';

  @override
  String settingFontSizeSuffix(String size) {
    return '${size}px';
  }

  @override
  String get settingCursorStyleTitle => 'Estilo del Cursor';

  @override
  String get cursorStyleBlock => 'Bloque';

  @override
  String get cursorStyleUnderline => 'Subrayado';

  @override
  String get cursorStyleVerticalBar => 'Barra Vertical';

  @override
  String get settingFontLigaturesTitle => 'Ligaduras de Fuente';

  @override
  String get settingFontLigaturesEnabled =>
      'Activadas (ej., => se convierte en ⇒)';

  @override
  String get settingFontLigaturesDisabled => 'Desactivadas';

  @override
  String get settingLanguageTitle => 'Idioma';

  @override
  String get settingDefaultSshPortTitle => 'Puerto SSH Predeterminado';

  @override
  String get settingConnectionTimeoutTitle => 'Tiempo de Espera de Conexión';

  @override
  String get settingKeepAliveTitle => 'Intervalo de Mantener Vivo';

  @override
  String get dialogDefaultSshPort => 'Puerto SSH Predeterminado';

  @override
  String get dialogConnectionTimeout =>
      'Tiempo de Espera de Conexión (segundos)';

  @override
  String get dialogKeepAliveInterval => 'Intervalo de Mantener Vivo (segundos)';

  @override
  String settingTimeoutSuffix(String value) {
    return '${value}s';
  }

  @override
  String get settingCommandCompletionSoundTitle =>
      'Sonido de Finalización de Comando';

  @override
  String settingCommandNotifyEnabled(String threshold) {
    return 'Alertar cuando los comandos tardan > ${threshold}s';
  }

  @override
  String get settingNotificationThresholdTitle => 'Umbral de Notificación';

  @override
  String get dialogNotificationThreshold => 'Umbral de Notificación (segundos)';

  @override
  String get settingKnownHostsTitle => 'Hosts Conocidos';

  @override
  String get settingKnownHostsSubtitle =>
      'Gestionar claves de host SSH de confianza';

  @override
  String get settingWorkspacesTitle => 'Espacios de Trabajo';

  @override
  String get settingWorkspacesSubtitle =>
      'Guardar y restaurar disposiciones de pestañas';

  @override
  String get settingPasswordGeneratorTitle => 'Generador de Contraseñas';

  @override
  String get settingPasswordGeneratorSubtitle => 'Genera contraseñas seguras';

  @override
  String get settingSessionLogsTitle => 'Registros de Sesión';

  @override
  String get settingSessionLogsSubtitle =>
      'Ver grabaciones de sesiones de terminal';

  @override
  String get settingImportSshConfigTitle => 'Importar Configuración SSH';

  @override
  String get settingImportSshConfigSubtitle =>
      'Importar hosts desde ~/.ssh/config';

  @override
  String get settingExportDataTitle => 'Exportar Datos';

  @override
  String get settingExportDataSubtitle => 'Respaldar hosts, snippets y ajustes';

  @override
  String get settingImportDataTitle => 'Importar Datos';

  @override
  String get settingImportDataSubtitle =>
      'Restaurar desde un archivo de respaldo';

  @override
  String get settingAwsEc2Title => 'AWS EC2';

  @override
  String get settingAwsEc2Subtitle =>
      'Importar instancias de Amazon Web Services';

  @override
  String get settingDigitalOceanTitle => 'DigitalOcean';

  @override
  String get settingDigitalOceanSubtitle => 'Importar droplets de DigitalOcean';

  @override
  String get settingVersionTitle => 'CloudShell';

  @override
  String settingVersionSubtitle(String version) {
    return 'Versión $version';
  }

  @override
  String get settingPrivacyPolicyTitle => 'Política de Privacidad';

  @override
  String get settingPrivacyPolicySubtitle => 'Cómo se manejan tus datos';

  @override
  String get settingTermsOfServiceTitle => 'Términos de Servicio';

  @override
  String get settingTermsOfServiceSubtitle => 'Términos y condiciones de uso';

  @override
  String get themePickerTitle => 'Tema';

  @override
  String get terminalThemePickerTitle => 'Tema del Terminal';

  @override
  String get terminalThemeCustomThemesHeader => 'TEMAS PERSONALIZADOS';

  @override
  String get terminalThemeBuiltInThemesHeader => 'TEMAS INTEGRADOS';

  @override
  String get terminalThemeNewTheme => 'Nuevo Tema';

  @override
  String get terminalThemeEditTooltip => 'Editar';

  @override
  String get terminalThemeDeleteTooltip => 'Eliminar';

  @override
  String get fontSizePickerTitle => 'Tamaño de Fuente del Terminal';

  @override
  String get fontSizePreviewText => 'user@server:~ \$ ls -la';

  @override
  String get fontSizeReset => 'Restablecer';

  @override
  String get fontFamilyPickerTitle => 'Familia de Fuente';

  @override
  String get fontFamilyPreviewText => 'ABCDEF abcdef 0123';

  @override
  String get cursorStylePickerTitle => 'Estilo del Cursor';

  @override
  String get numberInputInvalidNumber => 'Introduce un número válido';

  @override
  String numberInputRangeError(String min, String max) {
    return 'Debe estar entre $min y $max';
  }

  @override
  String get exportDataTitle => 'Exportar Datos';

  @override
  String get exportDataMessage =>
      'Elige el tipo de exportación:\n\nTexto plano exporta hosts, snippets y ajustes. Las claves privadas NO se incluyen.\n\nLa copia de seguridad cifrada del baúl incluye todo — hosts, claves, contraseñas y ajustes — protegida con una contraseña que elijas.';

  @override
  String get exportDataPlaintext => 'Texto Plano';

  @override
  String get exportDataEncryptedVault => 'Baúl Cifrado';

  @override
  String get exportDataExporting => 'Exportando datos...';

  @override
  String get exportDataEncrypting => 'Cifrando y exportando...';

  @override
  String exportedToFile(String filename) {
    return 'Exportado a: $filename';
  }

  @override
  String exportFailed(String error) {
    return 'Exportación fallida: $error';
  }

  @override
  String vaultExportedToFile(String filename) {
    return 'Baúl exportado a: $filename';
  }

  @override
  String get importDataFileDialogTitle => 'Seleccionar Respaldo de CloudShell';

  @override
  String get importDataPlaintextTitle => 'Importar Respaldo de Texto Plano';

  @override
  String get importDataPlaintextMessage =>
      'La importación fusionará los datos del archivo de respaldo.\n\nLos registros existentes se actualizarán, los nuevos se añadirán.\n\nNota: Los respaldos de texto plano no incluyen claves SSH privadas.';

  @override
  String get importDataPlaintextImport => 'Importar';

  @override
  String get importDataDecryptTitle => 'Descifrar Respaldo del Baúl';

  @override
  String get importDataDecryptMessage =>
      'Introduce la contraseña usada al crear este respaldo.';

  @override
  String get importDataDecryptConfirmLabel => 'Descifrar e Importar';

  @override
  String get importDataDecrypting => 'Descifrando e importando...';

  @override
  String importFailed(String error) {
    return 'Importación fallida: $error';
  }

  @override
  String get encryptedExportTitle => 'Exportación Cifrada';

  @override
  String get encryptedExportMessage =>
      'Elige una contraseña segura para cifrar tu respaldo del baúl. Necesitarás esta contraseña para restaurar el respaldo.';

  @override
  String get encryptedExportConfirmLabel => 'Exportar';

  @override
  String get passwordDialogLabelPassword => 'Contraseña';

  @override
  String get passwordDialogLabelConfirmPassword => 'Confirmar contraseña';

  @override
  String get passwordDialogErrorPasswordsDoNotMatch =>
      'Las contraseñas no coinciden';

  @override
  String passwordMinLength(String minLength) {
    return 'Mínimo $minLength caracteres';
  }

  @override
  String get biometricUnlockTitle => 'Desbloqueo Biométrico';

  @override
  String get biometricLabelTouchId => 'Touch ID';

  @override
  String get biometricLabelFaceId => 'Face ID';

  @override
  String get biometricLabelBiometrics => 'biometría';

  @override
  String get biometricNotAvailable =>
      'La autenticación biométrica no está disponible en este dispositivo.';

  @override
  String get vaultEncryptionTitle => 'Cifrado';

  @override
  String get vaultNotConfiguredSubtitle =>
      'No configurado — inicia sesión para activar';

  @override
  String get vaultEncryptedUnlockedSubtitle => 'Cifrado y desbloqueado';

  @override
  String get vaultLockedSubtitle => 'El baúl está bloqueado';

  @override
  String get vaultMasterPasswordTitle => 'Contraseña Maestra';

  @override
  String get vaultLoadingSubtitle => 'Cargando...';

  @override
  String get vaultErrorSubtitle => 'Error al cargar el estado del baúl';

  @override
  String get vaultEncryptionEnabled => 'Cifrado del baúl activado';

  @override
  String get vaultDialogTitle => 'Baúl';

  @override
  String get vaultLockNow => 'Bloquear Baúl Ahora';

  @override
  String get vaultLocked => 'Baúl bloqueado';

  @override
  String get vaultChangePassword => 'Cambiar Contraseña';

  @override
  String get changePasswordTitle => 'Cambiar Contraseña';

  @override
  String get changePasswordCurrentLabel => 'Contraseña Actual';

  @override
  String get changePasswordNewLabel => 'Nueva Contraseña';

  @override
  String get changePasswordConfirmLabel => 'Confirmar Nueva Contraseña';

  @override
  String get changePasswordSubmit => 'Cambiar';

  @override
  String get changePasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get changePasswordMinLength => 'Se requieren mínimo 10 caracteres';

  @override
  String get changePasswordSuccess =>
      'Contraseña maestra cambiada exitosamente';

  @override
  String get autoLockTitle => 'Bloqueo Automático';

  @override
  String get autoLockSetUpVaultFirst => 'Configura el baúl primero';

  @override
  String get autoLockDialogTitle => 'Tiempo de Bloqueo Automático';

  @override
  String get autoLockTimeoutNever => 'Nunca';

  @override
  String get autoLockTimeout1Min => '1 minuto';

  @override
  String get autoLockTimeout5Min => '5 minutos';

  @override
  String get autoLockTimeout15Min => '15 minutos';

  @override
  String get autoLockTimeout30Min => '30 minutos';

  @override
  String get autoLockTimeout1Hour => '1 hora';

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
  String get syncAccountTitle => 'Cuenta';

  @override
  String get syncSignedInDefault => 'Sesión iniciada';

  @override
  String get syncLocalOnlyTitle => 'Solo Local';

  @override
  String get syncLocalOnlySubtitle =>
      'Actualiza para sincronizar entre dispositivos';

  @override
  String get syncCloudSyncTitle => 'Sincronización en la Nube';

  @override
  String get syncCloudSyncSubtitle =>
      'Inicia sesión para sincronizar entre dispositivos';

  @override
  String get accountDialogTitle => 'Cuenta';

  @override
  String get accountSignOut => 'Cerrar Sesión';

  @override
  String get accountSignedOut => 'Sesión cerrada';

  @override
  String get accountDeleteAccount => 'Eliminar Cuenta';

  @override
  String get deleteAccountTitle => 'Eliminar Cuenta';

  @override
  String get deleteAccountWarning => 'Esta acción no se puede deshacer.';

  @override
  String get deleteAccountWillDelete => 'Esto eliminará permanentemente:';

  @override
  String get deleteAccountItemAccount => '  • Tu cuenta e inicio de sesión';

  @override
  String get deleteAccountItemSyncedData =>
      '  • Todos los datos sincronizados en el servidor';

  @override
  String get deleteAccountItemVault => '  • Configuración del baúl de cifrado';

  @override
  String get deleteAccountLocalDataNote =>
      'Los datos locales (hosts, claves, ajustes) permanecerán en este dispositivo.';

  @override
  String get deleteAccountConfirmPrompt => 'Escribe DELETE para confirmar:';

  @override
  String get deleteAccountHint => 'DELETE';

  @override
  String get deleteAccountSubmit => 'Eliminar Cuenta';

  @override
  String get deleteAccountDeleting => 'Eliminando cuenta...';

  @override
  String get deleteAccountFailedDefault => 'Error al eliminar la cuenta';

  @override
  String get deleteAccountSuccess =>
      'Cuenta eliminada. Datos locales preservados.';

  @override
  String get syncAutoSyncTitle => 'Sincronización Automática';

  @override
  String get syncUnlockVault =>
      'Desbloquea el baúl para activar la sincronización';

  @override
  String get syncEvery5Minutes => 'Sincronizar cada 5 minutos';

  @override
  String get syncDisabled => 'Sincronización desactivada';

  @override
  String get syncNeverSynced => 'Nunca sincronizado';

  @override
  String get syncJustNow => 'Justo ahora';

  @override
  String get syncNowTitle => 'Sincronizar Ahora';

  @override
  String get syncSyncing => 'Sincronizando...';

  @override
  String syncResult(int pulled, int pushed) {
    return 'Sincronizado: $pulled recibidos, $pushed enviados';
  }

  @override
  String syncFailed(String error) {
    return 'Sincronización fallida: $error';
  }

  @override
  String get totp2faTitle => 'Autenticación 2FA';

  @override
  String get totpSignInToEnable => 'Inicia sesión para activar';

  @override
  String get totpEnabled => 'Activado';

  @override
  String get totpNotConfigured => 'No configurado';

  @override
  String get totpDisable2faTitle => '¿Desactivar 2FA?';

  @override
  String get totpDisable2faMessage =>
      'Esto eliminará la autenticación de dos factores de tu cuenta. Puedes reactivarla en cualquier momento.';

  @override
  String get totpDisable2faSubmit => 'Desactivar';

  @override
  String get totpDisabled => '2FA desactivado';

  @override
  String get knownHostsTitle => 'Hosts Conocidos';

  @override
  String get knownHostsEmptyTitle => 'No hay hosts conocidos';

  @override
  String get knownHostsEmptySubtitle =>
      'Las huellas digitales de las claves de host se guardan aquí cuando te conectas a un servidor por primera vez.';

  @override
  String get knownHostsSearchHint => 'Buscar hosts conocidos...';

  @override
  String get knownHostsLoadingMessage => 'Cargando hosts conocidos...';

  @override
  String get knownHostsRemoveTitle => 'Eliminar Host Conocido';

  @override
  String get knownHostsRemoveConfirmLabel => 'Eliminar';

  @override
  String get knownHostsMenuRemove => 'Eliminar';

  @override
  String get knownHostsFirstSeen => 'Visto por primera vez';

  @override
  String get knownHostsLastSeen => 'Visto por última vez';

  @override
  String knownHostsNoMatchQuery(String query) {
    return 'Ningún host coincide con \"$query\"';
  }

  @override
  String knownHostsRemoveMessage(String hostname, String port) {
    return '¿Eliminar la confianza de $hostname:$port?\n\nSe te pedirá verificar la clave del host de nuevo en la próxima conexión.';
  }

  @override
  String get sessionLogsTitle => 'Registros de Sesión';

  @override
  String get sessionLogsDeleteAllTooltip => 'Eliminar todos los registros';

  @override
  String get sessionLogsEmpty => 'No hay registros de sesión';

  @override
  String get sessionLogsEnableHint =>
      'Activa el registro desde el menú del terminal';

  @override
  String get sessionLogsView => 'Ver';

  @override
  String get sessionLogsShare => 'Compartir';

  @override
  String get sessionLogsDelete => 'Eliminar';

  @override
  String get sessionLogsShareSubject => 'Registro de Sesión de CloudShell';

  @override
  String get sessionLogsDeleteAllTitle => '¿Eliminar Todos los Registros?';

  @override
  String get sessionLogsDeleteAllMessage =>
      'Esto eliminará permanentemente todos los archivos de registro de sesión.';

  @override
  String get sessionLogsDeleteAllConfirm => 'Eliminar Todos';

  @override
  String get sessionLogsShareTooltip => 'Compartir';

  @override
  String sessionLogsReadError(String error) {
    return 'Error al leer el archivo: $error';
  }

  @override
  String get customThemeEditTitle => 'Editar Tema';

  @override
  String get customThemeNewTitle => 'Nuevo Tema Personalizado';

  @override
  String get customThemeSave => 'Guardar';

  @override
  String get customThemeNameLabel => 'Nombre del Tema';

  @override
  String get customThemeNameHint => 'ej., Mi Tema Personalizado';

  @override
  String get customThemeSectionTerminalChrome => 'Cromo del Terminal';

  @override
  String get customThemeSectionNormalColors => 'Colores Normales';

  @override
  String get customThemeSectionBrightColors => 'Colores Brillantes';

  @override
  String get colorBackground => 'Fondo';

  @override
  String get colorForeground => 'Primer plano';

  @override
  String get colorCursor => 'Cursor';

  @override
  String get colorSelection => 'Selección';

  @override
  String get colorBlack => 'Negro';

  @override
  String get colorRed => 'Rojo';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorMagenta => 'Magenta';

  @override
  String get colorCyan => 'Cian';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorBrightBlack => 'Negro Brillante';

  @override
  String get colorBrightRed => 'Rojo Brillante';

  @override
  String get colorBrightGreen => 'Verde Brillante';

  @override
  String get colorBrightYellow => 'Amarillo Brillante';

  @override
  String get colorBrightBlue => 'Azul Brillante';

  @override
  String get colorBrightMagenta => 'Magenta Brillante';

  @override
  String get colorBrightCyan => 'Cian Brillante';

  @override
  String get colorBrightWhite => 'Blanco Brillante';

  @override
  String get customThemePreviewTitle => 'Vista Previa del Terminal';

  @override
  String get customThemePreviewSelectedText =>
      'Vista previa de texto seleccionado';

  @override
  String get hexColorLabel => 'Color Hexadecimal';

  @override
  String get hexColorPasteTooltip => 'Pegar';

  @override
  String get hexColorInvalid => 'Hex inválido';

  @override
  String get hexColorApply => 'Aplicar';

  @override
  String get customThemeNameRequired => 'El nombre del tema es obligatorio';

  @override
  String get sliderHue => 'T';

  @override
  String get sliderSaturation => 'S';

  @override
  String get sliderBrightness => 'V';

  @override
  String get sshConfigImportTitle => 'Importar Configuración SSH';

  @override
  String get sshConfigImportFailed => 'Error al leer la configuración SSH';

  @override
  String get sshConfigNoHostsFound => 'No se encontraron hosts';

  @override
  String get sshConfigNoHostsFoundDetail =>
      'No se encontraron entradas de host válidas en ~/.ssh/config';

  @override
  String get sshConfigDeselectAll => 'Deseleccionar Todo';

  @override
  String get sshConfigSelectAll => 'Seleccionar Todo';

  @override
  String get sshConfigImportKeys => 'Importar claves';

  @override
  String sshConfigFoundHosts(int count) {
    return 'Se encontraron $count host(s) en ~/.ssh/config';
  }

  @override
  String sshConfigImportedResult(int count, int keys) {
    return 'Se importaron $count host(s) y $keys clave(s)';
  }

  @override
  String sshConfigImportFailed2(String error) {
    return 'Importación fallida: $error';
  }

  @override
  String sshConfigImportButtonLabel(int count) {
    return 'Importar ($count)';
  }

  @override
  String get legalScreenLoadError => 'Error al cargar el documento';

  @override
  String get workspacesTitle => 'Espacios de Trabajo';

  @override
  String get workspacesSaveCurrent => 'Guardar Actual';

  @override
  String get workspacesEmptyTitle => 'No hay espacios de trabajo guardados';

  @override
  String get workspacesEmptySubtitle =>
      'Tu disposición actual de pestañas se guarda automáticamente.\nUsa \"Guardar Actual\" para crear un espacio de trabajo con nombre.';

  @override
  String workspacesLoadError(String error) {
    return 'Error al cargar espacios de trabajo: $error';
  }

  @override
  String get workspacesActiveBadge => 'ACTIVO';

  @override
  String get workspacesNoTerminals => 'Sin terminales';

  @override
  String get workspacesJustNow => 'Justo ahora';

  @override
  String get workspacesMenuSwitchTo => 'Cambiar a';

  @override
  String get workspacesMenuRename => 'Renombrar';

  @override
  String get workspacesMenuDelete => 'Eliminar';

  @override
  String get workspacesSaveTitle => 'Guardar Espacio de Trabajo';

  @override
  String get workspacesSaveHint => 'Nombre del espacio de trabajo';

  @override
  String get workspacesSaveSave => 'Guardar';

  @override
  String get workspacesRenameTitle => 'Renombrar Espacio de Trabajo';

  @override
  String get workspacesRenameHint => 'Nuevo nombre';

  @override
  String get workspacesRenameSubmit => 'Renombrar';

  @override
  String get workspacesDeleteTitle => '¿Eliminar Espacio de Trabajo?';

  @override
  String get workspacesDeleteSubmit => 'Eliminar';

  @override
  String workspaceTerminalCount(int count) {
    return '$count terminal(es)';
  }

  @override
  String workspaceSaved(String name) {
    return 'Espacio de trabajo \"$name\" guardado';
  }

  @override
  String workspaceSwitching(String name) {
    return 'Cambiando a \"$name\"...';
  }

  @override
  String workspaceLoaded(String name) {
    return 'Espacio de trabajo \"$name\" cargado';
  }

  @override
  String workspaceDeleteConfirm(String name) {
    return '¿Eliminar \"$name\"? Esto no se puede deshacer.';
  }

  @override
  String get awsImportTitle => 'Importar desde AWS EC2';

  @override
  String get awsConnectTitle => 'Conectar a AWS';

  @override
  String get awsConnectSubtitle =>
      'Introduce tus credenciales de AWS para importar instancias EC2.';

  @override
  String get awsAccessKeyIdLabel => 'ID de Clave de Acceso';

  @override
  String get awsAccessKeyIdHelper => 'ej. AKIAIOSFODNN7EXAMPLE';

  @override
  String get awsSecretAccessKeyLabel => 'Clave de Acceso Secreta';

  @override
  String get awsRegionLabel => 'Región';

  @override
  String get awsCredentialsInfo =>
      'Las credenciales solo se usan para esta importación y no se almacenan. Usa un usuario IAM con solo el permiso ec2:DescribeInstances.';

  @override
  String get awsFetchInstances => 'Obtener Instancias';

  @override
  String get awsFetchingInstances => 'Obteniendo instancias...';

  @override
  String get awsErrorAccessKeyRequired =>
      'Introduce tu ID de Clave de Acceso de AWS';

  @override
  String get awsErrorSecretKeyRequired =>
      'Introduce tu Clave de Acceso Secreta de AWS';

  @override
  String get awsSelectInstances => 'Seleccionar Instancias';

  @override
  String get awsRunningOnlyFilter => 'Solo en ejecución';

  @override
  String get awsNoRunningInstances =>
      'No se encontraron instancias en ejecución';

  @override
  String get awsNoInstances => 'No se encontraron instancias';

  @override
  String get awsConfigureImport => 'Configurar Importación';

  @override
  String get awsDefaultUsernameLabel => 'Usuario Predeterminado';

  @override
  String get awsDefaultUsernameHelper =>
      'Amazon Linux: ec2-user, Ubuntu: ubuntu';

  @override
  String get awsInstancesToImport => 'Instancias a importar:';

  @override
  String get awsImporting => 'Importando...';

  @override
  String awsImportResult(int count) {
    return 'Se importaron $count host(s) desde AWS EC2';
  }

  @override
  String awsImportHostsButton(int count) {
    return 'Importar $count Host(s)';
  }

  @override
  String awsNextButton(int count) {
    return 'Siguiente ($count)';
  }

  @override
  String get doImportTitle => 'Importar desde DigitalOcean';

  @override
  String get doConnectTitle => 'Conectar a DigitalOcean';

  @override
  String get doConnectSubtitle =>
      'Introduce tu token de acceso personal de DigitalOcean para importar droplets.';

  @override
  String get doApiTokenLabel => 'Token de API';

  @override
  String get doApiTokenHelper =>
      'Genera uno en cloud.digitalocean.com/account/api/tokens';

  @override
  String get doTokenInfo =>
      'Tu token solo se usa para esta importación y no se almacena.';

  @override
  String get doFetchDroplets => 'Obtener Droplets';

  @override
  String get doFetchingDroplets => 'Obteniendo droplets...';

  @override
  String get doErrorTokenRequired => 'Introduce tu token de API';

  @override
  String get doSelectDroplets => 'Seleccionar Droplets';

  @override
  String get doActiveOnlyFilter => 'Solo activos';

  @override
  String get doNoActiveDroplets => 'No se encontraron droplets activos';

  @override
  String get doNoDroplets => 'No se encontraron droplets';

  @override
  String get doConfigureImport => 'Configurar Importación';

  @override
  String get doDefaultUsernameLabel => 'Usuario Predeterminado';

  @override
  String get doDefaultUsernameHelper =>
      'Usado para todos los hosts importados (predeterminado: root)';

  @override
  String get doHostsToImport => 'Hosts a importar:';

  @override
  String get doImporting => 'Importando...';

  @override
  String doImportResult(int count) {
    return 'Se importaron $count host(s) desde DigitalOcean';
  }

  @override
  String doImportHostsButton(int count) {
    return 'Importar $count Host(s)';
  }

  @override
  String doNextButton(int count) {
    return 'Siguiente ($count)';
  }

  @override
  String get loginSubtitle =>
      'Inicia sesión para sincronizar entre dispositivos';

  @override
  String get loginEmailLabel => 'Correo electrónico';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginErrorEmailRequired => 'Introduce tu correo electrónico';

  @override
  String get loginErrorPasswordRequired => 'Introduce tu contraseña';

  @override
  String get loginSigningIn => 'Iniciando sesión...';

  @override
  String get loginSignIn => 'Iniciar Sesión';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginCreateAccount => 'Crear Cuenta';

  @override
  String get loginUseLocally => 'Usar localmente sin cuenta';

  @override
  String get signUpSubtitle => 'Crea tu cuenta';

  @override
  String get signUpEmailLabel => 'Correo electrónico';

  @override
  String get signUpPasswordLabel => 'Contraseña (mín. 10 caracteres)';

  @override
  String get signUpConfirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get passwordStrengthWeak => 'Débil';

  @override
  String get passwordStrengthFair => 'Aceptable';

  @override
  String get passwordStrengthGood => 'Buena';

  @override
  String get passwordStrengthStrong => 'Fuerte';

  @override
  String get passwordStrengthExcellent => 'Excelente';

  @override
  String get signUpErrorEmailRequired => 'Introduce tu correo electrónico';

  @override
  String get signUpErrorPasswordRequired => 'Introduce una contraseña';

  @override
  String get signUpErrorPasswordTooShort =>
      'La contraseña debe tener al menos 10 caracteres';

  @override
  String get signUpErrorPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get signUpErrorTermsRequired =>
      'Por favor, acepta los términos de servicio';

  @override
  String get signUpEncryptionWarning =>
      'Tus datos están cifrados de extremo a extremo. No podemos recuperar tu cuenta si pierdes tu contraseña.';

  @override
  String get signUpTermsPrefix => 'Acepto los ';

  @override
  String get signUpTermsOfService => 'Términos de Servicio';

  @override
  String get signUpTermsAnd => ' y la ';

  @override
  String get signUpPrivacyPolicy => 'Política de Privacidad';

  @override
  String get signUpCreatingAccount => 'Creando cuenta...';

  @override
  String get signUpCreateAccount => 'Crear Cuenta';

  @override
  String get signUpAlreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get signUpSignIn => 'Iniciar Sesión';

  @override
  String get signUpEncryptionNote => 'Cifrado: Argon2id + AES-256-GCM';

  @override
  String get forgotPasswordTitle => 'Restablecer tu contraseña';

  @override
  String get forgotPasswordInstructions =>
      'Introduce el correo electrónico asociado a tu cuenta y te enviaremos un enlace para restablecer la contraseña.';

  @override
  String get forgotPasswordEmailLabel => 'Correo electrónico';

  @override
  String get forgotPasswordSending => 'Enviando...';

  @override
  String get forgotPasswordSendResetLink => 'Enviar Enlace de Restablecimiento';

  @override
  String get forgotPasswordBackToSignIn => 'Volver a Iniciar Sesión';

  @override
  String get forgotPasswordErrorEmailRequired =>
      'Introduce tu correo electrónico';

  @override
  String get forgotPasswordCheckEmail => 'Revisa Tu Correo';

  @override
  String forgotPasswordSuccessMessage(String email) {
    return 'Si existe una cuenta para $email, recibirás un enlace para restablecer la contraseña en breve.';
  }

  @override
  String get forgotPasswordVaultWarning =>
      'Recuerda: Usamos cifrado de conocimiento cero. Si restableces la contraseña de tu cuenta, la contraseña maestra de tu baúl no se ve afectada.';

  @override
  String get forgotPasswordTryAgain => '¿No lo recibiste? Inténtalo de nuevo';

  @override
  String get totpSetupTitle => 'Configurar 2FA';

  @override
  String get totpSetupFailed => 'Error al configurar 2FA';

  @override
  String get totpSetupHeading => 'Autenticación de Dos Factores';

  @override
  String get totpSetupInstructions =>
      'Escanea este código QR con tu aplicación de autenticación (Google Authenticator, Authy, etc.).';

  @override
  String get totpSetupManualEntryKey => 'Clave de entrada manual';

  @override
  String get totpSetupSecretCopied => 'Secreto copiado';

  @override
  String get totpSetupEnterCode =>
      'Introduce el código de 6 dígitos de tu aplicación:';

  @override
  String get totpSetupCodeHint => '000000';

  @override
  String get totpSetupVerifying => 'Verificando...';

  @override
  String get totpSetupVerifyAndEnable => 'Verificar y Activar';

  @override
  String get totpSetupEnabled => 'Autenticación de dos factores activada';

  @override
  String get totpSetupErrorCodeLength => 'Introduce un código de 6 dígitos';

  @override
  String get totpSetupErrorInvalidCode =>
      'Código inválido. Comprueba tu aplicación de autenticación e inténtalo de nuevo.';

  @override
  String get totpVerifyHeading => 'Autenticación de Dos Factores';

  @override
  String get totpVerifyInstructions =>
      'Introduce el código de 6 dígitos de tu aplicación de autenticación';

  @override
  String get totpVerifyCodeHint => '000000';

  @override
  String get totpVerifyVerifying => 'Verificando...';

  @override
  String get totpVerifySubmit => 'Verificar';

  @override
  String get totpVerifyHelpText =>
      'Abre tu aplicación de autenticación (Google Authenticator, Authy, etc.) para encontrar tu código de verificación.';

  @override
  String get totpVerifyErrorDefaultFailed => 'Verificación fallida';

  @override
  String get totpVerifyErrorInvalidCode =>
      'Código inválido. Inténtalo de nuevo.';

  @override
  String get adaptiveScaffoldHosts => 'Hosts';

  @override
  String get adaptiveScaffoldKeys => 'Claves';

  @override
  String get adaptiveScaffoldSnippets => 'Snippets';

  @override
  String get adaptiveScaffoldTerminal => 'Terminal';

  @override
  String get adaptiveScaffoldSftp => 'SFTP';

  @override
  String get adaptiveScaffoldPortForwarding => 'Reenvío de Puertos';

  @override
  String get adaptiveScaffoldSettings => 'Ajustes';

  @override
  String get commandPaletteHint =>
      'Buscar hosts, snippets o escribir un comando...';

  @override
  String commandPaletteNoMatchQuery(String query) {
    return 'Sin resultados para \"$query\"';
  }

  @override
  String get commandPaletteHostsHeader => 'Hosts';

  @override
  String get commandPaletteSnippetsHeader => 'Snippets';

  @override
  String get commandPaletteActionsHeader => 'Acciones';

  @override
  String get commandPaletteActionNewHost => 'Nuevo Host';

  @override
  String get commandPaletteActionQuickConnect => 'Conexión Rápida';

  @override
  String get commandPaletteActionSettings => 'Ajustes';

  @override
  String get commandPaletteActionToggleTheme => 'Alternar Tema';

  @override
  String get shortcutReferenceTitle => 'Atajos de Teclado';

  @override
  String get shortcutCategoryGeneral => 'General';

  @override
  String get shortcutCategoryTerminal => 'Terminal';

  @override
  String get shortcutCategoryNavigation => 'Navegación';

  @override
  String get appLockTitle => 'CloudShell';

  @override
  String get appLockSubtitle => 'Desbloquea para continuar';

  @override
  String get appLockUnlockButton => 'Desbloquear';

  @override
  String get appLockUnlockWithBiometrics => 'Desbloquear con biometría';

  @override
  String get appLockBiometricReason =>
      'Autentícate para desbloquear CloudShell';

  @override
  String get appLockFailed => 'Autenticación fallida';

  @override
  String get statusOnline => 'En línea';

  @override
  String get statusOffline => 'Sin conexión';

  @override
  String get statusWarning => 'Advertencia';

  @override
  String get statusIdle => 'Inactivo';

  @override
  String get vaultUnlockTitle => 'Desbloquear Baúl';

  @override
  String get vaultUnlockSubtitle =>
      'Introduce tu contraseña maestra para desbloquear el baúl.';

  @override
  String get vaultUnlockPasswordLabel => 'Contraseña Maestra';

  @override
  String get vaultUnlockPasswordHint => 'Introduce la contraseña maestra';

  @override
  String get vaultUnlockButton => 'Desbloquear';

  @override
  String get vaultUnlockUnlocking => 'Desbloqueando...';

  @override
  String get vaultUnlockBiometricButton => 'Desbloquear con biometría';

  @override
  String get vaultUnlockForgotPassword => '¿Olvidaste la contraseña?';

  @override
  String get vaultUnlockResetTitle => '¿Restablecer Baúl?';

  @override
  String get vaultUnlockResetMessage =>
      'Restablecer eliminará todos los datos cifrados (contraseñas guardadas, claves privadas). Los hosts y ajustes locales se conservarán.\n\nEsta acción no se puede deshacer.';

  @override
  String get vaultUnlockResetConfirm => 'Restablecer Baúl';

  @override
  String get vaultUnlockIncorrectPassword => 'Contraseña incorrecta';

  @override
  String vaultUnlockLockedOut(int seconds) {
    return 'Demasiados intentos. Inténtalo de nuevo en ${seconds}s.';
  }

  @override
  String get masterPasswordSetupTitle => 'Configurar Baúl';

  @override
  String get masterPasswordSetupSubtitle =>
      'Crea una contraseña maestra para cifrar tus datos sensibles.';

  @override
  String get masterPasswordSetupPasswordLabel => 'Contraseña Maestra';

  @override
  String get masterPasswordSetupPasswordHint => 'Mínimo 10 caracteres';

  @override
  String get masterPasswordSetupConfirmLabel => 'Confirmar Contraseña';

  @override
  String get masterPasswordSetupConfirmHint => 'Repite la contraseña maestra';

  @override
  String get masterPasswordSetupButton => 'Crear Baúl';

  @override
  String get masterPasswordSetupCreating => 'Creando baúl...';

  @override
  String get masterPasswordSetupMinLength =>
      'Se requieren mínimo 10 caracteres';

  @override
  String get masterPasswordSetupMismatch => 'Las contraseñas no coinciden';

  @override
  String get masterPasswordSetupStrengthWeak => 'Débil';

  @override
  String get masterPasswordSetupStrengthFair => 'Aceptable';

  @override
  String get masterPasswordSetupStrengthGood => 'Buena';

  @override
  String get masterPasswordSetupStrengthStrong => 'Fuerte';

  @override
  String get masterPasswordSetupWarning =>
      'Tu contraseña maestra no se puede recuperar. Anótala y guárdala en un lugar seguro.';

  @override
  String get passwordGeneratorTitle => 'Generador de Contraseñas';

  @override
  String passwordGeneratorLengthLabel(int length) {
    return 'Longitud: $length';
  }

  @override
  String get passwordGeneratorUppercase => 'Mayúsculas (A-Z)';

  @override
  String get passwordGeneratorLowercase => 'Minúsculas (a-z)';

  @override
  String get passwordGeneratorNumbers => 'Números (0-9)';

  @override
  String get passwordGeneratorSymbols => 'Símbolos (!@#...)';

  @override
  String get passwordGeneratorGenerate => 'Generar';

  @override
  String get passwordGeneratorCopy => 'Copiar';

  @override
  String get passwordGeneratorCopied =>
      'Contraseña copiada (se borra automáticamente en 30s)';

  @override
  String passwordGeneratorStrengthBits(String bits) {
    return '$bits bits de entropía';
  }

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a CloudShell';

  @override
  String get onboardingWelcomeSubtitle =>
      'Un cliente SSH moderno y multiplataforma';

  @override
  String get onboardingSecureTitle => 'Seguro por Diseño';

  @override
  String get onboardingSecureSubtitle =>
      'Baúl cifrado de extremo a extremo con Argon2id + AES-256-GCM';

  @override
  String get onboardingTerminalTitle => 'Terminal Potente';

  @override
  String get onboardingTerminalSubtitle =>
      'Paneles divididos, pestañas, temas, snippets y más';

  @override
  String get onboardingSyncTitle => 'Sincroniza en Todas Partes';

  @override
  String get onboardingSyncSubtitle =>
      'Tus hosts, claves y snippets — en todos tus dispositivos';

  @override
  String get onboardingGetStarted => 'Comenzar';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get portForwardingTitle => 'Reenvío de Puertos';

  @override
  String get portForwardingAddTooltip => 'Añadir regla';

  @override
  String get portForwardingEmptyTitle => 'No hay reglas de reenvío de puertos';

  @override
  String get portForwardingEmptySubtitle =>
      'Crea reglas para tunelizar tráfico a través de conexiones SSH.';

  @override
  String get portForwardingEmptyAction => 'Añadir Regla';

  @override
  String get portForwardingActiveHeader => 'ACTIVO';

  @override
  String get portForwardingSavedHeader => 'REGLAS GUARDADAS';

  @override
  String get portForwardingTypeLocal => 'Local';

  @override
  String get portForwardingTypeRemote => 'Remoto';

  @override
  String get portForwardingTypeDynamic => 'SOCKS';

  @override
  String get portForwardingStop => 'Detener';

  @override
  String get portForwardingStart => 'Iniciar';

  @override
  String get portForwardingMenuEdit => 'Editar';

  @override
  String get portForwardingMenuDelete => 'Eliminar';

  @override
  String get portForwardingDeleteDialogTitle => 'Eliminar Regla';

  @override
  String get portForwardingDeleteDialogMessage =>
      '¿Eliminar esta regla de reenvío de puertos?';

  @override
  String get portForwardingLoading =>
      'Cargando reglas de reenvío de puertos...';

  @override
  String get portForwardFormTitleNew => 'Nuevo Reenvío de Puerto';

  @override
  String get portForwardFormTitleEdit => 'Editar Reenvío de Puerto';

  @override
  String get portForwardFormLabelField => 'Etiqueta';

  @override
  String get portForwardFormLabelHint => 'ej., Túnel de Base de Datos';

  @override
  String get portForwardFormTypeField => 'Tipo';

  @override
  String get portForwardFormTypeLocal => 'Local';

  @override
  String get portForwardFormTypeRemote => 'Remoto';

  @override
  String get portForwardFormTypeDynamic => 'Dinámico (SOCKS)';

  @override
  String get portForwardFormHostField => 'Host';

  @override
  String get portForwardFormSelectHost => 'Selecciona un host';

  @override
  String get portForwardFormNoHostsAvailable =>
      'No hay hosts disponibles. Crea un host primero.';

  @override
  String get portForwardFormCouldNotLoadHosts =>
      'No se pudieron cargar los hosts.';

  @override
  String get portForwardFormLocalPortField => 'Puerto Local';

  @override
  String get portForwardFormRemotePortField => 'Puerto Remoto';

  @override
  String get portForwardFormDestHostField => 'Host Destino';

  @override
  String get portForwardFormDestHostHint => 'localhost';

  @override
  String get portForwardFormDestPortField => 'Puerto Destino';

  @override
  String get portForwardFormDestPortHint => 'ej., 5432';

  @override
  String get portForwardFormPortHint => 'ej., 8080';

  @override
  String get portForwardFormAutoStart => 'Iniciar automáticamente al conectar';

  @override
  String get portForwardFormAutoStartSubtitle =>
      'Iniciar este túnel automáticamente al conectarse al host.';

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
  String get languageSystem => 'Predeterminado del Sistema';
}
