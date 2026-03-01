import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CloudShell'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @togglePasswordVisibility.
  ///
  /// In en, this message translates to:
  /// **'Toggle password visibility'**
  String get togglePasswordVisibility;

  /// No description provided for @togglePassphraseVisibility.
  ///
  /// In en, this message translates to:
  /// **'Toggle passphrase visibility'**
  String get togglePassphraseVisibility;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @hostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hosts'**
  String get hostsTitle;

  /// No description provided for @hostsAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add host'**
  String get hostsAddTooltip;

  /// No description provided for @hostsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search hosts...'**
  String get hostsSearchHint;

  /// No description provided for @hostsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No hosts yet'**
  String get hostsEmptyTitle;

  /// No description provided for @hostsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first SSH server to get started.'**
  String get hostsEmptySubtitle;

  /// No description provided for @hostsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add Host'**
  String get hostsEmptyAction;

  /// No description provided for @hostsNoMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No hosts match \"{query}\"'**
  String hostsNoMatchQuery(String query);

  /// No description provided for @hostsLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading hosts...'**
  String get hostsLoadingMessage;

  /// No description provided for @hostsRecentHeader.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get hostsRecentHeader;

  /// No description provided for @hostsGroupsHeader.
  ///
  /// In en, this message translates to:
  /// **'GROUPS'**
  String get hostsGroupsHeader;

  /// No description provided for @hostsFavoritesHeader.
  ///
  /// In en, this message translates to:
  /// **'FAVORITES'**
  String get hostsFavoritesHeader;

  /// No description provided for @hostsAllHostsHeader.
  ///
  /// In en, this message translates to:
  /// **'ALL HOSTS'**
  String get hostsAllHostsHeader;

  /// No description provided for @hostsUngroupedHeader.
  ///
  /// In en, this message translates to:
  /// **'UNGROUPED'**
  String get hostsUngroupedHeader;

  /// No description provided for @hostsDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Host'**
  String get hostsDeleteDialogTitle;

  /// No description provided for @hostsDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String hostsDeleteDialogMessage(String name);

  /// No description provided for @hostsMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get hostsMenuEdit;

  /// No description provided for @hostsMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get hostsMenuDelete;

  /// No description provided for @hostsMenuConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get hostsMenuConnect;

  /// No description provided for @hostsMenuSftp.
  ///
  /// In en, this message translates to:
  /// **'SFTP'**
  String get hostsMenuSftp;

  /// No description provided for @hostsLastConnected.
  ///
  /// In en, this message translates to:
  /// **'Last connected {time}'**
  String hostsLastConnected(String time);

  /// No description provided for @hostsNeverConnected.
  ///
  /// In en, this message translates to:
  /// **'Never connected'**
  String get hostsNeverConnected;

  /// No description provided for @hostsJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get hostsJustNow;

  /// No description provided for @hostFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Host'**
  String get hostFormTitleNew;

  /// No description provided for @hostFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Host'**
  String get hostFormTitleEdit;

  /// No description provided for @hostFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get hostFormSave;

  /// No description provided for @hostFormLabelField.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get hostFormLabelField;

  /// No description provided for @hostFormLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Production Server'**
  String get hostFormLabelHint;

  /// No description provided for @hostFormLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'Label is required'**
  String get hostFormLabelRequired;

  /// No description provided for @hostFormHostnameField.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostFormHostnameField;

  /// No description provided for @hostFormHostnameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 192.168.1.100 or example.com'**
  String get hostFormHostnameHint;

  /// No description provided for @hostFormHostnameRequired.
  ///
  /// In en, this message translates to:
  /// **'Hostname is required'**
  String get hostFormHostnameRequired;

  /// No description provided for @hostFormPortField.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get hostFormPortField;

  /// No description provided for @hostFormUsernameField.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get hostFormUsernameField;

  /// No description provided for @hostFormUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., root'**
  String get hostFormUsernameHint;

  /// No description provided for @hostFormUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get hostFormUsernameRequired;

  /// No description provided for @hostFormPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get hostFormPasswordField;

  /// No description provided for @hostFormPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get hostFormPasswordHint;

  /// No description provided for @hostFormAuthMethodField.
  ///
  /// In en, this message translates to:
  /// **'Auth Method'**
  String get hostFormAuthMethodField;

  /// No description provided for @hostFormAuthMethodKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get hostFormAuthMethodKey;

  /// No description provided for @hostFormAuthMethodPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get hostFormAuthMethodPassword;

  /// No description provided for @hostFormAuthMethodKeyAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Key + Password'**
  String get hostFormAuthMethodKeyAndPassword;

  /// No description provided for @hostFormKeyField.
  ///
  /// In en, this message translates to:
  /// **'SSH Key'**
  String get hostFormKeyField;

  /// No description provided for @hostFormKeyNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get hostFormKeyNone;

  /// No description provided for @hostFormGroupField.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get hostFormGroupField;

  /// No description provided for @hostFormGroupNone.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get hostFormGroupNone;

  /// No description provided for @hostFormTagsField.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get hostFormTagsField;

  /// No description provided for @hostFormTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Add tags (comma separated)'**
  String get hostFormTagsHint;

  /// No description provided for @hostFormAdvancedSection.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get hostFormAdvancedSection;

  /// No description provided for @hostFormJumpHostField.
  ///
  /// In en, this message translates to:
  /// **'Jump Host (Proxy)'**
  String get hostFormJumpHostField;

  /// No description provided for @hostFormJumpHostNone.
  ///
  /// In en, this message translates to:
  /// **'None (direct connection)'**
  String get hostFormJumpHostNone;

  /// No description provided for @hostFormKeepAliveField.
  ///
  /// In en, this message translates to:
  /// **'Keep Alive (seconds)'**
  String get hostFormKeepAliveField;

  /// No description provided for @hostFormStartupCommandField.
  ///
  /// In en, this message translates to:
  /// **'Startup Command'**
  String get hostFormStartupCommandField;

  /// No description provided for @hostFormStartupCommandHint.
  ///
  /// In en, this message translates to:
  /// **'Run after connecting (optional)'**
  String get hostFormStartupCommandHint;

  /// No description provided for @hostFormNotesField.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get hostFormNotesField;

  /// No description provided for @hostFormNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes about this host'**
  String get hostFormNotesHint;

  /// No description provided for @hostFormProtocolSsh.
  ///
  /// In en, this message translates to:
  /// **'SSH'**
  String get hostFormProtocolSsh;

  /// No description provided for @hostFormProtocolTelnet.
  ///
  /// In en, this message translates to:
  /// **'Telnet'**
  String get hostFormProtocolTelnet;

  /// No description provided for @hostFormProtocolSerial.
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get hostFormProtocolSerial;

  /// No description provided for @hostFormSerialPortField.
  ///
  /// In en, this message translates to:
  /// **'Serial Port'**
  String get hostFormSerialPortField;

  /// No description provided for @hostFormSerialPortNone.
  ///
  /// In en, this message translates to:
  /// **'Select port'**
  String get hostFormSerialPortNone;

  /// No description provided for @hostFormSerialNoPortsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No serial ports available'**
  String get hostFormSerialNoPortsAvailable;

  /// No description provided for @hostFormSerialBaudRateField.
  ///
  /// In en, this message translates to:
  /// **'Baud Rate'**
  String get hostFormSerialBaudRateField;

  /// No description provided for @hostFormSerialDataBitsField.
  ///
  /// In en, this message translates to:
  /// **'Data Bits'**
  String get hostFormSerialDataBitsField;

  /// No description provided for @hostFormSerialStopBitsField.
  ///
  /// In en, this message translates to:
  /// **'Stop Bits'**
  String get hostFormSerialStopBitsField;

  /// No description provided for @hostFormSerialParityField.
  ///
  /// In en, this message translates to:
  /// **'Parity'**
  String get hostFormSerialParityField;

  /// No description provided for @hostFormSerialFlowControlField.
  ///
  /// In en, this message translates to:
  /// **'Flow Control'**
  String get hostFormSerialFlowControlField;

  /// No description provided for @hostFormTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get hostFormTestConnection;

  /// No description provided for @hostFormTestConnectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful!'**
  String get hostFormTestConnectionSuccess;

  /// No description provided for @hostFormTestConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String hostFormTestConnectionFailed(String error);

  /// No description provided for @hostDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Host Details'**
  String get hostDetailTitle;

  /// No description provided for @hostDetailConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get hostDetailConnect;

  /// No description provided for @hostDetailSftp.
  ///
  /// In en, this message translates to:
  /// **'SFTP'**
  String get hostDetailSftp;

  /// No description provided for @hostDetailEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get hostDetailEditTooltip;

  /// No description provided for @hostDetailDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get hostDetailDeleteTooltip;

  /// No description provided for @hostDetailFavoriteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get hostDetailFavoriteTooltip;

  /// No description provided for @hostDetailSectionConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get hostDetailSectionConnection;

  /// No description provided for @hostDetailSectionAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get hostDetailSectionAuthentication;

  /// No description provided for @hostDetailSectionAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get hostDetailSectionAdvanced;

  /// No description provided for @hostDetailSectionTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get hostDetailSectionTags;

  /// No description provided for @hostDetailSectionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get hostDetailSectionNotes;

  /// No description provided for @hostDetailLabelHostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostDetailLabelHostname;

  /// No description provided for @hostDetailLabelPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get hostDetailLabelPort;

  /// No description provided for @hostDetailLabelUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get hostDetailLabelUsername;

  /// No description provided for @hostDetailLabelAuthMethod.
  ///
  /// In en, this message translates to:
  /// **'Auth Method'**
  String get hostDetailLabelAuthMethod;

  /// No description provided for @hostDetailLabelKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get hostDetailLabelKey;

  /// No description provided for @hostDetailLabelGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get hostDetailLabelGroup;

  /// No description provided for @hostDetailLabelJumpHost.
  ///
  /// In en, this message translates to:
  /// **'Jump Host'**
  String get hostDetailLabelJumpHost;

  /// No description provided for @hostDetailLabelKeepAlive.
  ///
  /// In en, this message translates to:
  /// **'Keep Alive'**
  String get hostDetailLabelKeepAlive;

  /// No description provided for @hostDetailLabelStartupCommand.
  ///
  /// In en, this message translates to:
  /// **'Startup Command'**
  String get hostDetailLabelStartupCommand;

  /// No description provided for @hostDetailLabelProtocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get hostDetailLabelProtocol;

  /// No description provided for @hostDetailLabelCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get hostDetailLabelCreated;

  /// No description provided for @hostDetailLabelUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get hostDetailLabelUpdated;

  /// No description provided for @hostDetailLabelLastConnected.
  ///
  /// In en, this message translates to:
  /// **'Last Connected'**
  String get hostDetailLabelLastConnected;

  /// No description provided for @hostDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Host not found'**
  String get hostDetailNotFound;

  /// No description provided for @hostDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading host...'**
  String get hostDetailLoading;

  /// No description provided for @hostDetailDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Host'**
  String get hostDetailDeleteDialogTitle;

  /// No description provided for @hostDetailDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String hostDetailDeleteDialogMessage(String name);

  /// No description provided for @quickConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Connect'**
  String get quickConnectTitle;

  /// No description provided for @quickConnectHint.
  ///
  /// In en, this message translates to:
  /// **'user@host:port'**
  String get quickConnectHint;

  /// No description provided for @quickConnectHelperText.
  ///
  /// In en, this message translates to:
  /// **'e.g., root@192.168.1.100:22'**
  String get quickConnectHelperText;

  /// No description provided for @quickConnectSaveHost.
  ///
  /// In en, this message translates to:
  /// **'Save host'**
  String get quickConnectSaveHost;

  /// No description provided for @quickConnectConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get quickConnectConnect;

  /// No description provided for @quickConnectInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format. Use user@host or user@host:port'**
  String get quickConnectInvalidFormat;

  /// No description provided for @groupFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get groupFormTitleNew;

  /// No description provided for @groupFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get groupFormTitleEdit;

  /// No description provided for @groupFormNameField.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupFormNameField;

  /// No description provided for @groupFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Production'**
  String get groupFormNameHint;

  /// No description provided for @groupFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Group name is required'**
  String get groupFormNameRequired;

  /// No description provided for @groupFormParentField.
  ///
  /// In en, this message translates to:
  /// **'Parent Group'**
  String get groupFormParentField;

  /// No description provided for @groupFormParentNone.
  ///
  /// In en, this message translates to:
  /// **'None (top level)'**
  String get groupFormParentNone;

  /// No description provided for @groupFormDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get groupFormDeleteDialogTitle;

  /// No description provided for @groupFormDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Hosts in this group will become ungrouped.'**
  String groupFormDeleteDialogMessage(String name);

  /// No description provided for @hostKeyVerifyChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Host Key Changed'**
  String get hostKeyVerifyChangedTitle;

  /// No description provided for @hostKeyVerifyUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Host'**
  String get hostKeyVerifyUnknownTitle;

  /// No description provided for @hostKeyVerifyChangedWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: The host key for this server has changed. This could indicate a man-in-the-middle attack.'**
  String get hostKeyVerifyChangedWarning;

  /// No description provided for @hostKeyVerifyUnknownMessage.
  ///
  /// In en, this message translates to:
  /// **'The authenticity of this host cannot be verified. Are you sure you want to continue connecting?'**
  String get hostKeyVerifyUnknownMessage;

  /// No description provided for @hostKeyVerifyLabelHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get hostKeyVerifyLabelHost;

  /// No description provided for @hostKeyVerifyLabelKeyType.
  ///
  /// In en, this message translates to:
  /// **'Key Type'**
  String get hostKeyVerifyLabelKeyType;

  /// No description provided for @hostKeyVerifyLabelFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint:'**
  String get hostKeyVerifyLabelFingerprint;

  /// No description provided for @hostKeyVerifyFingerprintCopied.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint copied (auto-clears in 30s)'**
  String get hostKeyVerifyFingerprintCopied;

  /// No description provided for @hostKeyVerifyTrustAnyway.
  ///
  /// In en, this message translates to:
  /// **'Trust Anyway'**
  String get hostKeyVerifyTrustAnyway;

  /// No description provided for @hostKeyVerifyTrustAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Trust & Connect'**
  String get hostKeyVerifyTrustAndConnect;

  /// No description provided for @keysTitle.
  ///
  /// In en, this message translates to:
  /// **'SSH Keys'**
  String get keysTitle;

  /// No description provided for @keysAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import key'**
  String get keysAddTooltip;

  /// No description provided for @keysImportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import key'**
  String get keysImportTooltip;

  /// No description provided for @keysEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No SSH keys'**
  String get keysEmptyTitle;

  /// No description provided for @keysEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import your SSH keys to authenticate with servers.'**
  String get keysEmptySubtitle;

  /// No description provided for @keysEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Import Key'**
  String get keysEmptyAction;

  /// No description provided for @keysSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search keys...'**
  String get keysSearchHint;

  /// No description provided for @keysNoMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No keys match \"{query}\"'**
  String keysNoMatchQuery(String query);

  /// No description provided for @keysLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading keys...'**
  String get keysLoadingMessage;

  /// No description provided for @keysDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Key'**
  String get keysDeleteDialogTitle;

  /// No description provided for @keysDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String keysDeleteDialogMessage(String name);

  /// No description provided for @keysMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get keysMenuDelete;

  /// No description provided for @keysAssociatedHosts.
  ///
  /// In en, this message translates to:
  /// **'{count} host(s)'**
  String keysAssociatedHosts(int count);

  /// No description provided for @keyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Details'**
  String get keyDetailTitle;

  /// No description provided for @keyDetailEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get keyDetailEditTooltip;

  /// No description provided for @keyDetailDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get keyDetailDeleteTooltip;

  /// No description provided for @keyDetailSectionPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get keyDetailSectionPublicKey;

  /// No description provided for @keyDetailCopyPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Copy public key'**
  String get keyDetailCopyPublicKey;

  /// No description provided for @keyDetailSectionFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get keyDetailSectionFingerprint;

  /// No description provided for @keyDetailSectionAssociatedHosts.
  ///
  /// In en, this message translates to:
  /// **'Associated Hosts'**
  String get keyDetailSectionAssociatedHosts;

  /// No description provided for @keyDetailSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get keyDetailSectionDetails;

  /// No description provided for @keyDetailLabelType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get keyDetailLabelType;

  /// No description provided for @keyDetailLabelBits.
  ///
  /// In en, this message translates to:
  /// **'Bits'**
  String get keyDetailLabelBits;

  /// No description provided for @keyDetailLabelCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get keyDetailLabelCreated;

  /// No description provided for @keyDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Key not found'**
  String get keyDetailNotFound;

  /// No description provided for @keyDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading key...'**
  String get keyDetailLoading;

  /// No description provided for @keyDetailPublicKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Public key copied (auto-clears in 30s)'**
  String get keyDetailPublicKeyCopied;

  /// No description provided for @keyDetailFingerprintCopied.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint copied (auto-clears in 30s)'**
  String get keyDetailFingerprintCopied;

  /// No description provided for @keyDetailNoAssociatedHosts.
  ///
  /// In en, this message translates to:
  /// **'No hosts use this key'**
  String get keyDetailNoAssociatedHosts;

  /// No description provided for @keyImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import SSH Key'**
  String get keyImportTitle;

  /// No description provided for @keyImportButton.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get keyImportButton;

  /// No description provided for @keyImportButtonImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get keyImportButtonImporting;

  /// No description provided for @keyImportButtonImportKey.
  ///
  /// In en, this message translates to:
  /// **'Import Key'**
  String get keyImportButtonImportKey;

  /// No description provided for @keyImportLabelField.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get keyImportLabelField;

  /// No description provided for @keyImportLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Server Key'**
  String get keyImportLabelHint;

  /// No description provided for @keyImportPassphraseField.
  ///
  /// In en, this message translates to:
  /// **'Passphrase (optional)'**
  String get keyImportPassphraseField;

  /// No description provided for @keyImportPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if key is not encrypted'**
  String get keyImportPassphraseHint;

  /// No description provided for @keyImportPrivateKeyField.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get keyImportPrivateKeyField;

  /// No description provided for @keyImportFromFile.
  ///
  /// In en, this message translates to:
  /// **'From File'**
  String get keyImportFromFile;

  /// No description provided for @keyImportPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get keyImportPaste;

  /// No description provided for @keyImportPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbm...\n-----END OPENSSH PRIVATE KEY-----\n\nor PuTTY-User-Key-File-2: ssh-rsa...'**
  String get keyImportPlaceholder;

  /// No description provided for @keyImportSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supported formats: OpenSSH, PEM, PuTTY PPK (RSA, Ed25519, ECDSA). Your private key is stored securely in the platform keychain and never leaves this device.'**
  String get keyImportSupportedFormats;

  /// No description provided for @keyImportFailedToReadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to read file: {error}'**
  String keyImportFailedToReadFile(String error);

  /// No description provided for @keyImportClipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty'**
  String get keyImportClipboardEmpty;

  /// No description provided for @keyImportPasteOrSelectKey.
  ///
  /// In en, this message translates to:
  /// **'Please paste or select a private key'**
  String get keyImportPasteOrSelectKey;

  /// No description provided for @keyImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Key imported: {fingerprint}'**
  String keyImportSuccess(String fingerprint);

  /// No description provided for @terminalNoActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get terminalNoActiveSessions;

  /// No description provided for @terminalQuickConnect.
  ///
  /// In en, this message translates to:
  /// **'Quick Connect'**
  String get terminalQuickConnect;

  /// No description provided for @terminalRecentHostsHeader.
  ///
  /// In en, this message translates to:
  /// **'RECENT HOSTS'**
  String get terminalRecentHostsHeader;

  /// No description provided for @terminalDesktopShortcutHints.
  ///
  /// In en, this message translates to:
  /// **'⌘N  New Host  ·  ⌘⇧N  Quick Connect  ·  ⌘K  Search'**
  String get terminalDesktopShortcutHints;

  /// No description provided for @terminalMobileShortcutHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to connect to a host'**
  String get terminalMobileShortcutHint;

  /// No description provided for @terminalConnectingToHost.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {label}...'**
  String terminalConnectingToHost(String label);

  /// No description provided for @terminalReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting... ({attempt}/{maxAttempts})'**
  String terminalReconnecting(int attempt, int maxAttempts);

  /// No description provided for @terminalReconnectCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get terminalReconnectCancel;

  /// No description provided for @terminalConnectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get terminalConnectionLost;

  /// No description provided for @terminalSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search terminal...'**
  String get terminalSearchHint;

  /// No description provided for @terminalSearchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'0/0'**
  String get terminalSearchNoMatches;

  /// No description provided for @terminalSearchClose.
  ///
  /// In en, this message translates to:
  /// **'Close (Esc)'**
  String get terminalSearchClose;

  /// No description provided for @terminalConnectionInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Info'**
  String get terminalConnectionInfoTitle;

  /// No description provided for @terminalStatusReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get terminalStatusReconnecting;

  /// No description provided for @terminalStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get terminalStatusConnected;

  /// No description provided for @terminalStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get terminalStatusDisconnected;

  /// No description provided for @terminalInfoLabelHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get terminalInfoLabelHost;

  /// No description provided for @terminalInfoLabelAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get terminalInfoLabelAddress;

  /// No description provided for @terminalInfoLabelUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get terminalInfoLabelUsername;

  /// No description provided for @terminalInfoLabelProxyJump.
  ///
  /// In en, this message translates to:
  /// **'Proxy Jump'**
  String get terminalInfoLabelProxyJump;

  /// No description provided for @terminalInfoValueProxyJump.
  ///
  /// In en, this message translates to:
  /// **'Via bastion host'**
  String get terminalInfoValueProxyJump;

  /// No description provided for @terminalInfoLabelUptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get terminalInfoLabelUptime;

  /// No description provided for @terminalInfoLabelConnectedAt.
  ///
  /// In en, this message translates to:
  /// **'Connected At'**
  String get terminalInfoLabelConnectedAt;

  /// No description provided for @terminalInfoLabelSessionId.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get terminalInfoLabelSessionId;

  /// No description provided for @terminalInfoLabelSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get terminalInfoLabelSplit;

  /// No description provided for @terminalInfoValueSplitHorizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal (2 panes)'**
  String get terminalInfoValueSplitHorizontal;

  /// No description provided for @terminalInfoValueSplitVertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical (2 panes)'**
  String get terminalInfoValueSplitVertical;

  /// No description provided for @terminalInfoLabelLogging.
  ///
  /// In en, this message translates to:
  /// **'Logging'**
  String get terminalInfoLabelLogging;

  /// No description provided for @terminalInfoValueLoggingActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get terminalInfoValueLoggingActive;

  /// No description provided for @terminalStatusBarDefaultDuration.
  ///
  /// In en, this message translates to:
  /// **'0:00'**
  String get terminalStatusBarDefaultDuration;

  /// No description provided for @terminalStatusBarLogActive.
  ///
  /// In en, this message translates to:
  /// **'LOG'**
  String get terminalStatusBarLogActive;

  /// No description provided for @terminalStatusBarLogInactive.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get terminalStatusBarLogInactive;

  /// No description provided for @terminalBroadcastOnTooltip.
  ///
  /// In en, this message translates to:
  /// **'Broadcast ON — tap to toggle, long-press for options'**
  String get terminalBroadcastOnTooltip;

  /// No description provided for @terminalBroadcastOffTooltip.
  ///
  /// In en, this message translates to:
  /// **'Broadcast OFF — tap to toggle, long-press for options'**
  String get terminalBroadcastOffTooltip;

  /// No description provided for @terminalBroadcastCastActiveWithCount.
  ///
  /// In en, this message translates to:
  /// **'CAST ({count})'**
  String terminalBroadcastCastActiveWithCount(int count);

  /// No description provided for @terminalBroadcastCastActive.
  ///
  /// In en, this message translates to:
  /// **'CAST'**
  String get terminalBroadcastCastActive;

  /// No description provided for @terminalBroadcastCastInactive.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get terminalBroadcastCastInactive;

  /// No description provided for @terminalHeaderBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get terminalHeaderBackTooltip;

  /// No description provided for @terminalHeaderNewConnectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'New connection'**
  String get terminalHeaderNewConnectionTooltip;

  /// No description provided for @terminalHeaderSnippetsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get terminalHeaderSnippetsTooltip;

  /// No description provided for @terminalHeaderCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy selection'**
  String get terminalHeaderCopyTooltip;

  /// No description provided for @terminalHeaderPasteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get terminalHeaderPasteTooltip;

  /// No description provided for @terminalHeaderNewTabTooltip.
  ///
  /// In en, this message translates to:
  /// **'New tab'**
  String get terminalHeaderNewTabTooltip;

  /// No description provided for @extraKeyEsc.
  ///
  /// In en, this message translates to:
  /// **'ESC'**
  String get extraKeyEsc;

  /// No description provided for @extraKeyTab.
  ///
  /// In en, this message translates to:
  /// **'TAB'**
  String get extraKeyTab;

  /// No description provided for @extraKeyCtl.
  ///
  /// In en, this message translates to:
  /// **'CTL'**
  String get extraKeyCtl;

  /// No description provided for @extraKeyAlt.
  ///
  /// In en, this message translates to:
  /// **'ALT'**
  String get extraKeyAlt;

  /// No description provided for @extraKeyBksp.
  ///
  /// In en, this message translates to:
  /// **'BKSP'**
  String get extraKeyBksp;

  /// No description provided for @broadcastPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Broadcast Input'**
  String get broadcastPanelTitle;

  /// No description provided for @broadcastPanelDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get broadcastPanelDisable;

  /// No description provided for @broadcastPanelDescription.
  ///
  /// In en, this message translates to:
  /// **'Select which terminals receive your keyboard input.'**
  String get broadcastPanelDescription;

  /// No description provided for @broadcastPanelBroadcastToAll.
  ///
  /// In en, this message translates to:
  /// **'Broadcast to All'**
  String get broadcastPanelBroadcastToAll;

  /// No description provided for @broadcastPanelConnectedSessions.
  ///
  /// In en, this message translates to:
  /// **'{count} connected sessions'**
  String broadcastPanelConnectedSessions(int count);

  /// No description provided for @broadcastPanelActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get broadcastPanelActiveLabel;

  /// No description provided for @broadcastPanelTabConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get broadcastPanelTabConnected;

  /// No description provided for @broadcastPanelTabDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get broadcastPanelTabDisconnected;

  /// No description provided for @snippetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get snippetsTitle;

  /// No description provided for @snippetsAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add snippet'**
  String get snippetsAddTooltip;

  /// No description provided for @snippetsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No snippets'**
  String get snippetsEmptyTitle;

  /// No description provided for @snippetsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save frequently used commands for quick access.'**
  String get snippetsEmptySubtitle;

  /// No description provided for @snippetsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add Snippet'**
  String get snippetsEmptyAction;

  /// No description provided for @snippetsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search snippets...'**
  String get snippetsSearchHint;

  /// No description provided for @snippetsNoMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No snippets match \"{query}\"'**
  String snippetsNoMatchQuery(String query);

  /// No description provided for @snippetsLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading snippets...'**
  String get snippetsLoadingMessage;

  /// No description provided for @snippetsUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get snippetsUncategorized;

  /// No description provided for @snippetsHasVariables.
  ///
  /// In en, this message translates to:
  /// **'Has variables'**
  String get snippetsHasVariables;

  /// No description provided for @snippetsCopyCommandTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy command'**
  String get snippetsCopyCommandTooltip;

  /// No description provided for @snippetsMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get snippetsMenuEdit;

  /// No description provided for @snippetsMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get snippetsMenuDelete;

  /// No description provided for @snippetsCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Command copied (auto-clears in 30s)'**
  String get snippetsCopiedMessage;

  /// No description provided for @snippetsDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Snippet'**
  String get snippetsDeleteDialogTitle;

  /// No description provided for @snippetsDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String snippetsDeleteDialogMessage(String name);

  /// No description provided for @snippetDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Snippet not found'**
  String get snippetDetailNotFound;

  /// No description provided for @snippetDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading snippet...'**
  String get snippetDetailLoading;

  /// No description provided for @snippetDetailEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get snippetDetailEditTooltip;

  /// No description provided for @snippetDetailDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get snippetDetailDeleteTooltip;

  /// No description provided for @snippetDetailSectionCommand.
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get snippetDetailSectionCommand;

  /// No description provided for @snippetDetailCopyCommandTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy command'**
  String get snippetDetailCopyCommandTooltip;

  /// No description provided for @snippetDetailSectionVariables.
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get snippetDetailSectionVariables;

  /// No description provided for @snippetDetailSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get snippetDetailSectionDescription;

  /// No description provided for @snippetDetailSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get snippetDetailSectionDetails;

  /// No description provided for @snippetDetailLabelCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get snippetDetailLabelCreated;

  /// No description provided for @snippetDetailLabelUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get snippetDetailLabelUpdated;

  /// No description provided for @snippetDetailCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Command copied (auto-clears in 30s)'**
  String get snippetDetailCopiedMessage;

  /// No description provided for @snippetFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Snippet'**
  String get snippetFormTitleEdit;

  /// No description provided for @snippetFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Snippet'**
  String get snippetFormTitleNew;

  /// No description provided for @snippetFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Snippet Name'**
  String get snippetFormNameLabel;

  /// No description provided for @snippetFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Check disk space'**
  String get snippetFormNameHint;

  /// No description provided for @snippetFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get snippetFormNameRequired;

  /// No description provided for @snippetFormCommandLabel.
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get snippetFormCommandLabel;

  /// No description provided for @snippetFormCommandHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., df -h\nUse double-brace variables as placeholders'**
  String get snippetFormCommandHint;

  /// No description provided for @snippetFormCommandRequired.
  ///
  /// In en, this message translates to:
  /// **'Command is required'**
  String get snippetFormCommandRequired;

  /// No description provided for @snippetFormVariablesLabel.
  ///
  /// In en, this message translates to:
  /// **'Variables:'**
  String get snippetFormVariablesLabel;

  /// No description provided for @snippetFormCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get snippetFormCategoryLabel;

  /// No description provided for @snippetFormCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., System, Docker, Network'**
  String get snippetFormCategoryHint;

  /// No description provided for @snippetFormDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get snippetFormDescriptionLabel;

  /// No description provided for @snippetFormDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What does this command do?'**
  String get snippetFormDescriptionHint;

  /// No description provided for @snippetFormSaveButtonEdit.
  ///
  /// In en, this message translates to:
  /// **'Update Snippet'**
  String get snippetFormSaveButtonEdit;

  /// No description provided for @snippetFormSaveButtonNew.
  ///
  /// In en, this message translates to:
  /// **'Create Snippet'**
  String get snippetFormSaveButtonNew;

  /// No description provided for @snippetFormSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save snippet: {error}'**
  String snippetFormSaveError(String error);

  /// No description provided for @snippetPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search snippets...'**
  String get snippetPickerSearchHint;

  /// No description provided for @snippetPickerEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No snippets. Create one from the Snippets screen.'**
  String get snippetPickerEmptyMessage;

  /// No description provided for @snippetPickerNoMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No snippets match \"{query}\"'**
  String snippetPickerNoMatchQuery(String query);

  /// No description provided for @snippetPickerLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load snippets'**
  String get snippetPickerLoadingError;

  /// No description provided for @snippetPickerVariableDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill Variables'**
  String get snippetPickerVariableDialogTitle;

  /// No description provided for @snippetPickerVariableHint.
  ///
  /// In en, this message translates to:
  /// **'Enter value for {variable}'**
  String snippetPickerVariableHint(String variable);

  /// No description provided for @snippetPickerVariableInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get snippetPickerVariableInsert;

  /// No description provided for @sftpSelectHostHint.
  ///
  /// In en, this message translates to:
  /// **'Select host...'**
  String get sftpSelectHostHint;

  /// No description provided for @sftpConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get sftpConnecting;

  /// No description provided for @sftpUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get sftpUploadLabel;

  /// No description provided for @sftpDownloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get sftpDownloadLabel;

  /// No description provided for @sftpNoSavedHostsTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved hosts'**
  String get sftpNoSavedHostsTitle;

  /// No description provided for @sftpNoSavedHostsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a host first, then come back to transfer files.'**
  String get sftpNoSavedHostsSubtitle;

  /// No description provided for @sftpFailedToLoadHosts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load hosts'**
  String get sftpFailedToLoadHosts;

  /// No description provided for @sftpFailedToConnect.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect: {error}'**
  String sftpFailedToConnect(String error);

  /// No description provided for @sftpConnectToHostFirst.
  ///
  /// In en, this message translates to:
  /// **'Connect to a host first'**
  String get sftpConnectToHostFirst;

  /// No description provided for @sftpDropFilesToUpload.
  ///
  /// In en, this message translates to:
  /// **'Drop files to upload'**
  String get sftpDropFilesToUpload;

  /// No description provided for @sftpTabLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get sftpTabLocal;

  /// No description provided for @sftpTabRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get sftpTabRemote;

  /// No description provided for @sftpPaneHeaderLocal.
  ///
  /// In en, this message translates to:
  /// **'LOCAL'**
  String get sftpPaneHeaderLocal;

  /// No description provided for @sftpPaneHeaderRemote.
  ///
  /// In en, this message translates to:
  /// **'REMOTE'**
  String get sftpPaneHeaderRemote;

  /// No description provided for @sftpLocalPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get sftpLocalPermissionDenied;

  /// No description provided for @sftpLocalEmptyFolder.
  ///
  /// In en, this message translates to:
  /// **'Empty folder'**
  String get sftpLocalEmptyFolder;

  /// No description provided for @sftpLocalCannotOpenFolder.
  ///
  /// In en, this message translates to:
  /// **'Cannot open folder'**
  String get sftpLocalCannotOpenFolder;

  /// No description provided for @sftpRemoteSelectHost.
  ///
  /// In en, this message translates to:
  /// **'Select a host to browse'**
  String get sftpRemoteSelectHost;

  /// No description provided for @sftpRemoteSelectHostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the dropdown above to pick a connected server'**
  String get sftpRemoteSelectHostSubtitle;

  /// No description provided for @sftpRemoteEmptyDirectory.
  ///
  /// In en, this message translates to:
  /// **'Empty directory'**
  String get sftpRemoteEmptyDirectory;

  /// No description provided for @sftpRemoteCannotOpenFolder.
  ///
  /// In en, this message translates to:
  /// **'Cannot open folder: {message}'**
  String sftpRemoteCannotOpenFolder(String message);

  /// No description provided for @sftpRemoteReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Read-only'**
  String get sftpRemoteReadOnly;

  /// No description provided for @sftpRemoteNewFolderTooltip.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get sftpRemoteNewFolderTooltip;

  /// No description provided for @sftpHideHiddenFiles.
  ///
  /// In en, this message translates to:
  /// **'Hide hidden files'**
  String get sftpHideHiddenFiles;

  /// No description provided for @sftpShowHiddenFiles.
  ///
  /// In en, this message translates to:
  /// **'Show hidden files'**
  String get sftpShowHiddenFiles;

  /// No description provided for @sftpGoUp.
  ///
  /// In en, this message translates to:
  /// **'Go up'**
  String get sftpGoUp;

  /// No description provided for @sftpNewFolderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get sftpNewFolderDialogTitle;

  /// No description provided for @sftpNewFolderDialogLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get sftpNewFolderDialogLabel;

  /// No description provided for @sftpNewFolderDialogHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., new-folder'**
  String get sftpNewFolderDialogHint;

  /// No description provided for @sftpNewFolderDialogCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get sftpNewFolderDialogCreate;

  /// No description provided for @sftpFileMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sftpFileMenuEdit;

  /// No description provided for @sftpFileMenuPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get sftpFileMenuPermissions;

  /// No description provided for @sftpFileMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sftpFileMenuDelete;

  /// No description provided for @sftpPermissionsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions — {fileName}'**
  String sftpPermissionsDialogTitle(String fileName);

  /// No description provided for @sftpPermissionsOctalLabel.
  ///
  /// In en, this message translates to:
  /// **'Octal: '**
  String get sftpPermissionsOctalLabel;

  /// No description provided for @sftpPermissionsLabelUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get sftpPermissionsLabelUser;

  /// No description provided for @sftpPermissionsLabelGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get sftpPermissionsLabelGroup;

  /// No description provided for @sftpPermissionsLabelOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sftpPermissionsLabelOther;

  /// No description provided for @sftpPermissionsBitRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get sftpPermissionsBitRead;

  /// No description provided for @sftpPermissionsBitWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get sftpPermissionsBitWrite;

  /// No description provided for @sftpPermissionsBitExec.
  ///
  /// In en, this message translates to:
  /// **'Exec'**
  String get sftpPermissionsBitExec;

  /// No description provided for @sftpPermissionsApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get sftpPermissionsApply;

  /// No description provided for @sftpTransfersHeader.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get sftpTransfersHeader;

  /// No description provided for @sftpTransfersClearDone.
  ///
  /// In en, this message translates to:
  /// **'Clear done'**
  String get sftpTransfersClearDone;

  /// No description provided for @sftpTransferStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sftpTransferStatusDone;

  /// No description provided for @sftpTransferStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get sftpTransferStatusFailed;

  /// No description provided for @remoteEditorSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get remoteEditorSaveTooltip;

  /// No description provided for @remoteEditorFileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get remoteEditorFileSaved;

  /// No description provided for @remoteEditorFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String remoteEditorFailedToSave(String error);

  /// No description provided for @remoteEditorUnsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get remoteEditorUnsavedChangesTitle;

  /// No description provided for @remoteEditorUnsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Discard them?'**
  String get remoteEditorUnsavedChangesMessage;

  /// No description provided for @remoteEditorDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get remoteEditorDiscard;

  /// No description provided for @remoteEditorFailedToLoadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load file'**
  String get remoteEditorFailedToLoadFile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get sectionConnection;

  /// No description provided for @sectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sectionNotifications;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @sectionTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get sectionTools;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @sectionCloudImport.
  ///
  /// In en, this message translates to:
  /// **'Cloud Import'**
  String get sectionCloudImport;

  /// No description provided for @sectionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sectionSync;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @settingThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingThemeTitle;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @settingTerminalThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Theme'**
  String get settingTerminalThemeTitle;

  /// No description provided for @settingFontFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get settingFontFamilyTitle;

  /// No description provided for @settingFontSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingFontSizeTitle;

  /// No description provided for @settingFontSizeSuffix.
  ///
  /// In en, this message translates to:
  /// **'{size}px'**
  String settingFontSizeSuffix(String size);

  /// No description provided for @settingCursorStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Cursor Style'**
  String get settingCursorStyleTitle;

  /// No description provided for @cursorStyleBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get cursorStyleBlock;

  /// No description provided for @cursorStyleUnderline.
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get cursorStyleUnderline;

  /// No description provided for @cursorStyleVerticalBar.
  ///
  /// In en, this message translates to:
  /// **'Vertical Bar'**
  String get cursorStyleVerticalBar;

  /// No description provided for @settingFontLigaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Ligatures'**
  String get settingFontLigaturesTitle;

  /// No description provided for @settingFontLigaturesEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled (e.g., => becomes ⇒)'**
  String get settingFontLigaturesEnabled;

  /// No description provided for @settingFontLigaturesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingFontLigaturesDisabled;

  /// No description provided for @settingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguageTitle;

  /// No description provided for @settingDefaultSshPortTitle.
  ///
  /// In en, this message translates to:
  /// **'Default SSH Port'**
  String get settingDefaultSshPortTitle;

  /// No description provided for @settingConnectionTimeoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout'**
  String get settingConnectionTimeoutTitle;

  /// No description provided for @settingKeepAliveTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep Alive Interval'**
  String get settingKeepAliveTitle;

  /// No description provided for @dialogDefaultSshPort.
  ///
  /// In en, this message translates to:
  /// **'Default SSH Port'**
  String get dialogDefaultSshPort;

  /// No description provided for @dialogConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout (seconds)'**
  String get dialogConnectionTimeout;

  /// No description provided for @dialogKeepAliveInterval.
  ///
  /// In en, this message translates to:
  /// **'Keep Alive Interval (seconds)'**
  String get dialogKeepAliveInterval;

  /// No description provided for @settingTimeoutSuffix.
  ///
  /// In en, this message translates to:
  /// **'{value}s'**
  String settingTimeoutSuffix(String value);

  /// No description provided for @settingCommandCompletionSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Command Completion Sound'**
  String get settingCommandCompletionSoundTitle;

  /// No description provided for @settingCommandNotifyEnabled.
  ///
  /// In en, this message translates to:
  /// **'Alert when commands run > {threshold}s'**
  String settingCommandNotifyEnabled(String threshold);

  /// No description provided for @settingNotificationThresholdTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Threshold'**
  String get settingNotificationThresholdTitle;

  /// No description provided for @dialogNotificationThreshold.
  ///
  /// In en, this message translates to:
  /// **'Notification Threshold (seconds)'**
  String get dialogNotificationThreshold;

  /// No description provided for @settingKnownHostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Known Hosts'**
  String get settingKnownHostsTitle;

  /// No description provided for @settingKnownHostsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage trusted SSH host keys'**
  String get settingKnownHostsSubtitle;

  /// No description provided for @settingWorkspacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get settingWorkspacesTitle;

  /// No description provided for @settingWorkspacesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save and restore tab layouts'**
  String get settingWorkspacesSubtitle;

  /// No description provided for @settingPasswordGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get settingPasswordGeneratorTitle;

  /// No description provided for @settingPasswordGeneratorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate secure passwords'**
  String get settingPasswordGeneratorSubtitle;

  /// No description provided for @settingSessionLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Logs'**
  String get settingSessionLogsTitle;

  /// No description provided for @settingSessionLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View terminal session recordings'**
  String get settingSessionLogsSubtitle;

  /// No description provided for @settingImportSshConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Import SSH Config'**
  String get settingImportSshConfigTitle;

  /// No description provided for @settingImportSshConfigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import hosts from ~/.ssh/config'**
  String get settingImportSshConfigSubtitle;

  /// No description provided for @settingExportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingExportDataTitle;

  /// No description provided for @settingExportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backup hosts, snippets, and settings'**
  String get settingExportDataSubtitle;

  /// No description provided for @settingImportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get settingImportDataTitle;

  /// No description provided for @settingImportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup file'**
  String get settingImportDataSubtitle;

  /// No description provided for @settingAwsEc2Title.
  ///
  /// In en, this message translates to:
  /// **'AWS EC2'**
  String get settingAwsEc2Title;

  /// No description provided for @settingAwsEc2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Import instances from Amazon Web Services'**
  String get settingAwsEc2Subtitle;

  /// No description provided for @settingDigitalOceanTitle.
  ///
  /// In en, this message translates to:
  /// **'DigitalOcean'**
  String get settingDigitalOceanTitle;

  /// No description provided for @settingDigitalOceanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import droplets from DigitalOcean'**
  String get settingDigitalOceanSubtitle;

  /// No description provided for @settingVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'CloudShell'**
  String get settingVersionTitle;

  /// No description provided for @settingVersionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingVersionSubtitle(String version);

  /// No description provided for @settingPrivacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingPrivacyPolicyTitle;

  /// No description provided for @settingPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How your data is handled'**
  String get settingPrivacyPolicySubtitle;

  /// No description provided for @settingTermsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingTermsOfServiceTitle;

  /// No description provided for @settingTermsOfServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Usage terms and conditions'**
  String get settingTermsOfServiceSubtitle;

  /// No description provided for @themePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themePickerTitle;

  /// No description provided for @terminalThemePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Theme'**
  String get terminalThemePickerTitle;

  /// No description provided for @terminalThemeCustomThemesHeader.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM THEMES'**
  String get terminalThemeCustomThemesHeader;

  /// No description provided for @terminalThemeBuiltInThemesHeader.
  ///
  /// In en, this message translates to:
  /// **'BUILT-IN THEMES'**
  String get terminalThemeBuiltInThemesHeader;

  /// No description provided for @terminalThemeNewTheme.
  ///
  /// In en, this message translates to:
  /// **'New Theme'**
  String get terminalThemeNewTheme;

  /// No description provided for @terminalThemeEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get terminalThemeEditTooltip;

  /// No description provided for @terminalThemeDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get terminalThemeDeleteTooltip;

  /// No description provided for @fontSizePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Font Size'**
  String get fontSizePickerTitle;

  /// No description provided for @fontSizePreviewText.
  ///
  /// In en, this message translates to:
  /// **'user@server:~ \$ ls -la'**
  String get fontSizePreviewText;

  /// No description provided for @fontSizeReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get fontSizeReset;

  /// No description provided for @fontFamilyPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamilyPickerTitle;

  /// No description provided for @fontFamilyPreviewText.
  ///
  /// In en, this message translates to:
  /// **'ABCDEF abcdef 0123'**
  String get fontFamilyPreviewText;

  /// No description provided for @cursorStylePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Cursor Style'**
  String get cursorStylePickerTitle;

  /// No description provided for @numberInputInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get numberInputInvalidNumber;

  /// No description provided for @numberInputRangeError.
  ///
  /// In en, this message translates to:
  /// **'Must be between {min} and {max}'**
  String numberInputRangeError(String min, String max);

  /// No description provided for @exportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataTitle;

  /// No description provided for @exportDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose export type:\n\nPlaintext exports hosts, snippets, and settings. Private keys are NOT included.\n\nEncrypted vault backup includes everything — hosts, keys, passwords, and settings — protected with a password you choose.'**
  String get exportDataMessage;

  /// No description provided for @exportDataPlaintext.
  ///
  /// In en, this message translates to:
  /// **'Plaintext'**
  String get exportDataPlaintext;

  /// No description provided for @exportDataEncryptedVault.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Vault'**
  String get exportDataEncryptedVault;

  /// No description provided for @exportDataExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting data...'**
  String get exportDataExporting;

  /// No description provided for @exportDataEncrypting.
  ///
  /// In en, this message translates to:
  /// **'Encrypting and exporting...'**
  String get exportDataEncrypting;

  /// No description provided for @exportedToFile.
  ///
  /// In en, this message translates to:
  /// **'Exported to: {filename}'**
  String exportedToFile(String filename);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @vaultExportedToFile.
  ///
  /// In en, this message translates to:
  /// **'Vault exported to: {filename}'**
  String vaultExportedToFile(String filename);

  /// No description provided for @importDataFileDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select CloudShell Backup'**
  String get importDataFileDialogTitle;

  /// No description provided for @importDataPlaintextTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Plaintext Backup'**
  String get importDataPlaintextTitle;

  /// No description provided for @importDataPlaintextMessage.
  ///
  /// In en, this message translates to:
  /// **'Import will merge data from the backup file.\n\nExisting records will be updated, new records will be added.\n\nNote: Plaintext backups do not include private SSH keys.'**
  String get importDataPlaintextMessage;

  /// No description provided for @importDataPlaintextImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importDataPlaintextImport;

  /// No description provided for @importDataDecryptTitle.
  ///
  /// In en, this message translates to:
  /// **'Decrypt Vault Backup'**
  String get importDataDecryptTitle;

  /// No description provided for @importDataDecryptMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the password used when creating this backup.'**
  String get importDataDecryptMessage;

  /// No description provided for @importDataDecryptConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrypt & Import'**
  String get importDataDecryptConfirmLabel;

  /// No description provided for @importDataDecrypting.
  ///
  /// In en, this message translates to:
  /// **'Decrypting and importing...'**
  String get importDataDecrypting;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// No description provided for @encryptedExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Export'**
  String get encryptedExportTitle;

  /// No description provided for @encryptedExportMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password to encrypt your vault backup. You will need this password to restore the backup.'**
  String get encryptedExportMessage;

  /// No description provided for @encryptedExportConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get encryptedExportConfirmLabel;

  /// No description provided for @passwordDialogLabelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordDialogLabelPassword;

  /// No description provided for @passwordDialogLabelConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get passwordDialogLabelConfirmPassword;

  /// No description provided for @passwordDialogErrorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordDialogErrorPasswordsDoNotMatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum {minLength} characters'**
  String passwordMinLength(String minLength);

  /// No description provided for @biometricUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get biometricUnlockTitle;

  /// No description provided for @biometricLabelTouchId.
  ///
  /// In en, this message translates to:
  /// **'Touch ID'**
  String get biometricLabelTouchId;

  /// No description provided for @biometricLabelFaceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get biometricLabelFaceId;

  /// No description provided for @biometricLabelBiometrics.
  ///
  /// In en, this message translates to:
  /// **'biometrics'**
  String get biometricLabelBiometrics;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device.'**
  String get biometricNotAvailable;

  /// No description provided for @vaultEncryptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get vaultEncryptionTitle;

  /// No description provided for @vaultNotConfiguredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Not configured — sign in to enable'**
  String get vaultNotConfiguredSubtitle;

  /// No description provided for @vaultEncryptedUnlockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted and unlocked'**
  String get vaultEncryptedUnlockedSubtitle;

  /// No description provided for @vaultLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vault is locked'**
  String get vaultLockedSubtitle;

  /// No description provided for @vaultMasterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Password'**
  String get vaultMasterPasswordTitle;

  /// No description provided for @vaultLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get vaultLoadingSubtitle;

  /// No description provided for @vaultErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Error loading vault state'**
  String get vaultErrorSubtitle;

  /// No description provided for @vaultEncryptionEnabled.
  ///
  /// In en, this message translates to:
  /// **'Vault encryption enabled'**
  String get vaultEncryptionEnabled;

  /// No description provided for @vaultDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get vaultDialogTitle;

  /// No description provided for @vaultLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock Vault Now'**
  String get vaultLockNow;

  /// No description provided for @vaultLocked.
  ///
  /// In en, this message translates to:
  /// **'Vault locked'**
  String get vaultLocked;

  /// No description provided for @vaultChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get vaultChangePassword;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrentLabel;

  /// No description provided for @changePasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNewLabel;

  /// No description provided for @changePasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirmLabel;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 10 characters required'**
  String get changePasswordMinLength;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Master password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @autoLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock'**
  String get autoLockTitle;

  /// No description provided for @autoLockSetUpVaultFirst.
  ///
  /// In en, this message translates to:
  /// **'Set up vault first'**
  String get autoLockSetUpVaultFirst;

  /// No description provided for @autoLockDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock Timeout'**
  String get autoLockDialogTitle;

  /// No description provided for @autoLockTimeoutNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get autoLockTimeoutNever;

  /// No description provided for @autoLockTimeout1Min.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get autoLockTimeout1Min;

  /// No description provided for @autoLockTimeout5Min.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get autoLockTimeout5Min;

  /// No description provided for @autoLockTimeout15Min.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get autoLockTimeout15Min;

  /// No description provided for @autoLockTimeout30Min.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get autoLockTimeout30Min;

  /// No description provided for @autoLockTimeout1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get autoLockTimeout1Hour;

  /// No description provided for @appLockGracePeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Delay'**
  String get appLockGracePeriodTitle;

  /// No description provided for @appLockGracePeriodEnableBiometricFirst.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric lock first'**
  String get appLockGracePeriodEnableBiometricFirst;

  /// No description provided for @appLockGracePeriodDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Delay After Background'**
  String get appLockGracePeriodDialogTitle;

  /// No description provided for @appLockGracePeriodImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get appLockGracePeriodImmediate;

  /// No description provided for @appLockGracePeriod30Seconds.
  ///
  /// In en, this message translates to:
  /// **'30 seconds'**
  String get appLockGracePeriod30Seconds;

  /// No description provided for @appLockGracePeriod1Minute.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get appLockGracePeriod1Minute;

  /// No description provided for @appLockGracePeriod5Minutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get appLockGracePeriod5Minutes;

  /// No description provided for @appLockGracePeriod15Minutes.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get appLockGracePeriod15Minutes;

  /// No description provided for @syncAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get syncAccountTitle;

  /// No description provided for @syncSignedInDefault.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get syncSignedInDefault;

  /// No description provided for @syncLocalOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get syncLocalOnlyTitle;

  /// No description provided for @syncLocalOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to sync across devices'**
  String get syncLocalOnlySubtitle;

  /// No description provided for @syncCloudSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get syncCloudSyncTitle;

  /// No description provided for @syncCloudSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync across devices'**
  String get syncCloudSyncSubtitle;

  /// No description provided for @accountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountDialogTitle;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get accountSignOut;

  /// No description provided for @accountSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out'**
  String get accountSignedOut;

  /// No description provided for @accountDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountDeleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountWillDelete.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete:'**
  String get deleteAccountWillDelete;

  /// No description provided for @deleteAccountItemAccount.
  ///
  /// In en, this message translates to:
  /// **'  • Your account and login'**
  String get deleteAccountItemAccount;

  /// No description provided for @deleteAccountItemSyncedData.
  ///
  /// In en, this message translates to:
  /// **'  • All synced data on the server'**
  String get deleteAccountItemSyncedData;

  /// No description provided for @deleteAccountItemVault.
  ///
  /// In en, this message translates to:
  /// **'  • Encryption vault configuration'**
  String get deleteAccountItemVault;

  /// No description provided for @deleteAccountLocalDataNote.
  ///
  /// In en, this message translates to:
  /// **'Local data (hosts, keys, settings) will remain on this device.'**
  String get deleteAccountLocalDataNote;

  /// No description provided for @deleteAccountConfirmPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm:'**
  String get deleteAccountConfirmPrompt;

  /// No description provided for @deleteAccountHint.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAccountHint;

  /// No description provided for @deleteAccountSubmit.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountSubmit;

  /// No description provided for @deleteAccountDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deleteAccountDeleting;

  /// No description provided for @deleteAccountFailedDefault.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get deleteAccountFailedDefault;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted. Local data preserved.'**
  String get deleteAccountSuccess;

  /// No description provided for @syncAutoSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get syncAutoSyncTitle;

  /// No description provided for @syncUnlockVault.
  ///
  /// In en, this message translates to:
  /// **'Unlock vault to enable sync'**
  String get syncUnlockVault;

  /// No description provided for @syncEvery5Minutes.
  ///
  /// In en, this message translates to:
  /// **'Sync every 5 minutes'**
  String get syncEvery5Minutes;

  /// No description provided for @syncDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sync is disabled'**
  String get syncDisabled;

  /// No description provided for @syncNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get syncNeverSynced;

  /// No description provided for @syncJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get syncJustNow;

  /// No description provided for @syncNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNowTitle;

  /// No description provided for @syncSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncSyncing;

  /// No description provided for @syncResult.
  ///
  /// In en, this message translates to:
  /// **'Synced: {pulled} pulled, {pushed} pushed'**
  String syncResult(int pulled, int pushed);

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String syncFailed(String error);

  /// No description provided for @totp2faTitle.
  ///
  /// In en, this message translates to:
  /// **'2FA Authentication'**
  String get totp2faTitle;

  /// No description provided for @totpSignInToEnable.
  ///
  /// In en, this message translates to:
  /// **'Sign in to enable'**
  String get totpSignInToEnable;

  /// No description provided for @totpEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get totpEnabled;

  /// No description provided for @totpNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get totpNotConfigured;

  /// No description provided for @totpDisable2faTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA?'**
  String get totpDisable2faTitle;

  /// No description provided for @totpDisable2faMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove two-factor authentication from your account. You can re-enable it at any time.'**
  String get totpDisable2faMessage;

  /// No description provided for @totpDisable2faSubmit.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get totpDisable2faSubmit;

  /// No description provided for @totpDisabled.
  ///
  /// In en, this message translates to:
  /// **'2FA disabled'**
  String get totpDisabled;

  /// No description provided for @knownHostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Known Hosts'**
  String get knownHostsTitle;

  /// No description provided for @knownHostsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No known hosts'**
  String get knownHostsEmptyTitle;

  /// No description provided for @knownHostsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Host key fingerprints are saved here when you connect to a server for the first time.'**
  String get knownHostsEmptySubtitle;

  /// No description provided for @knownHostsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search known hosts...'**
  String get knownHostsSearchHint;

  /// No description provided for @knownHostsLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading known hosts...'**
  String get knownHostsLoadingMessage;

  /// No description provided for @knownHostsRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Known Host'**
  String get knownHostsRemoveTitle;

  /// No description provided for @knownHostsRemoveConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get knownHostsRemoveConfirmLabel;

  /// No description provided for @knownHostsMenuRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get knownHostsMenuRemove;

  /// No description provided for @knownHostsFirstSeen.
  ///
  /// In en, this message translates to:
  /// **'First seen'**
  String get knownHostsFirstSeen;

  /// No description provided for @knownHostsLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get knownHostsLastSeen;

  /// No description provided for @knownHostsNoMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No hosts match \"{query}\"'**
  String knownHostsNoMatchQuery(String query);

  /// No description provided for @knownHostsRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove trust for {hostname}:{port}?\n\nYou will be asked to verify the host key again on next connection.'**
  String knownHostsRemoveMessage(String hostname, String port);

  /// No description provided for @sessionLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Logs'**
  String get sessionLogsTitle;

  /// No description provided for @sessionLogsDeleteAllTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete all logs'**
  String get sessionLogsDeleteAllTooltip;

  /// No description provided for @sessionLogsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No session logs'**
  String get sessionLogsEmpty;

  /// No description provided for @sessionLogsEnableHint.
  ///
  /// In en, this message translates to:
  /// **'Enable logging from the terminal menu'**
  String get sessionLogsEnableHint;

  /// No description provided for @sessionLogsView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get sessionLogsView;

  /// No description provided for @sessionLogsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sessionLogsShare;

  /// No description provided for @sessionLogsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sessionLogsDelete;

  /// No description provided for @sessionLogsShareSubject.
  ///
  /// In en, this message translates to:
  /// **'CloudShell Session Log'**
  String get sessionLogsShareSubject;

  /// No description provided for @sessionLogsDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Logs?'**
  String get sessionLogsDeleteAllTitle;

  /// No description provided for @sessionLogsDeleteAllMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all session log files.'**
  String get sessionLogsDeleteAllMessage;

  /// No description provided for @sessionLogsDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get sessionLogsDeleteAllConfirm;

  /// No description provided for @sessionLogsShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sessionLogsShareTooltip;

  /// No description provided for @sessionLogsReadError.
  ///
  /// In en, this message translates to:
  /// **'Error reading file: {error}'**
  String sessionLogsReadError(String error);

  /// No description provided for @customThemeEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Theme'**
  String get customThemeEditTitle;

  /// No description provided for @customThemeNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Custom Theme'**
  String get customThemeNewTitle;

  /// No description provided for @customThemeSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get customThemeSave;

  /// No description provided for @customThemeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme Name'**
  String get customThemeNameLabel;

  /// No description provided for @customThemeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Custom Theme'**
  String get customThemeNameHint;

  /// No description provided for @customThemeSectionTerminalChrome.
  ///
  /// In en, this message translates to:
  /// **'Terminal Chrome'**
  String get customThemeSectionTerminalChrome;

  /// No description provided for @customThemeSectionNormalColors.
  ///
  /// In en, this message translates to:
  /// **'Normal Colors'**
  String get customThemeSectionNormalColors;

  /// No description provided for @customThemeSectionBrightColors.
  ///
  /// In en, this message translates to:
  /// **'Bright Colors'**
  String get customThemeSectionBrightColors;

  /// No description provided for @colorBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get colorBackground;

  /// No description provided for @colorForeground.
  ///
  /// In en, this message translates to:
  /// **'Foreground'**
  String get colorForeground;

  /// No description provided for @colorCursor.
  ///
  /// In en, this message translates to:
  /// **'Cursor'**
  String get colorCursor;

  /// No description provided for @colorSelection.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get colorSelection;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorMagenta.
  ///
  /// In en, this message translates to:
  /// **'Magenta'**
  String get colorMagenta;

  /// No description provided for @colorCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get colorCyan;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorBrightBlack.
  ///
  /// In en, this message translates to:
  /// **'Bright Black'**
  String get colorBrightBlack;

  /// No description provided for @colorBrightRed.
  ///
  /// In en, this message translates to:
  /// **'Bright Red'**
  String get colorBrightRed;

  /// No description provided for @colorBrightGreen.
  ///
  /// In en, this message translates to:
  /// **'Bright Green'**
  String get colorBrightGreen;

  /// No description provided for @colorBrightYellow.
  ///
  /// In en, this message translates to:
  /// **'Bright Yellow'**
  String get colorBrightYellow;

  /// No description provided for @colorBrightBlue.
  ///
  /// In en, this message translates to:
  /// **'Bright Blue'**
  String get colorBrightBlue;

  /// No description provided for @colorBrightMagenta.
  ///
  /// In en, this message translates to:
  /// **'Bright Magenta'**
  String get colorBrightMagenta;

  /// No description provided for @colorBrightCyan.
  ///
  /// In en, this message translates to:
  /// **'Bright Cyan'**
  String get colorBrightCyan;

  /// No description provided for @colorBrightWhite.
  ///
  /// In en, this message translates to:
  /// **'Bright White'**
  String get colorBrightWhite;

  /// No description provided for @customThemePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Preview'**
  String get customThemePreviewTitle;

  /// No description provided for @customThemePreviewSelectedText.
  ///
  /// In en, this message translates to:
  /// **'Selected text preview'**
  String get customThemePreviewSelectedText;

  /// No description provided for @hexColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Hex Color'**
  String get hexColorLabel;

  /// No description provided for @hexColorPasteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get hexColorPasteTooltip;

  /// No description provided for @hexColorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid hex'**
  String get hexColorInvalid;

  /// No description provided for @hexColorApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get hexColorApply;

  /// No description provided for @customThemeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Theme name is required'**
  String get customThemeNameRequired;

  /// No description provided for @sliderHue.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get sliderHue;

  /// No description provided for @sliderSaturation.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get sliderSaturation;

  /// No description provided for @sliderBrightness.
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get sliderBrightness;

  /// No description provided for @sshConfigImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import SSH Config'**
  String get sshConfigImportTitle;

  /// No description provided for @sshConfigImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to read SSH config'**
  String get sshConfigImportFailed;

  /// No description provided for @sshConfigNoHostsFound.
  ///
  /// In en, this message translates to:
  /// **'No hosts found'**
  String get sshConfigNoHostsFound;

  /// No description provided for @sshConfigNoHostsFoundDetail.
  ///
  /// In en, this message translates to:
  /// **'No valid host entries were found in ~/.ssh/config'**
  String get sshConfigNoHostsFoundDetail;

  /// No description provided for @sshConfigDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get sshConfigDeselectAll;

  /// No description provided for @sshConfigSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get sshConfigSelectAll;

  /// No description provided for @sshConfigImportKeys.
  ///
  /// In en, this message translates to:
  /// **'Import keys'**
  String get sshConfigImportKeys;

  /// No description provided for @sshConfigFoundHosts.
  ///
  /// In en, this message translates to:
  /// **'Found {count} host(s) in ~/.ssh/config'**
  String sshConfigFoundHosts(int count);

  /// No description provided for @sshConfigImportedResult.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} host(s) and {keys} key(s)'**
  String sshConfigImportedResult(int count, int keys);

  /// No description provided for @sshConfigImportFailed2.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String sshConfigImportFailed2(String error);

  /// No description provided for @sshConfigImportButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Import ({count})'**
  String sshConfigImportButtonLabel(int count);

  /// No description provided for @legalScreenLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load document'**
  String get legalScreenLoadError;

  /// No description provided for @workspacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get workspacesTitle;

  /// No description provided for @workspacesSaveCurrent.
  ///
  /// In en, this message translates to:
  /// **'Save Current'**
  String get workspacesSaveCurrent;

  /// No description provided for @workspacesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved workspaces'**
  String get workspacesEmptyTitle;

  /// No description provided for @workspacesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your current tab layout is auto-saved.\nUse \"Save Current\" to create a named workspace.'**
  String get workspacesEmptySubtitle;

  /// No description provided for @workspacesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load workspaces: {error}'**
  String workspacesLoadError(String error);

  /// No description provided for @workspacesActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get workspacesActiveBadge;

  /// No description provided for @workspacesNoTerminals.
  ///
  /// In en, this message translates to:
  /// **'No terminals'**
  String get workspacesNoTerminals;

  /// No description provided for @workspacesJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get workspacesJustNow;

  /// No description provided for @workspacesMenuSwitchTo.
  ///
  /// In en, this message translates to:
  /// **'Switch to'**
  String get workspacesMenuSwitchTo;

  /// No description provided for @workspacesMenuRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get workspacesMenuRename;

  /// No description provided for @workspacesMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get workspacesMenuDelete;

  /// No description provided for @workspacesSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Workspace'**
  String get workspacesSaveTitle;

  /// No description provided for @workspacesSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Workspace name'**
  String get workspacesSaveHint;

  /// No description provided for @workspacesSaveSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get workspacesSaveSave;

  /// No description provided for @workspacesRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Workspace'**
  String get workspacesRenameTitle;

  /// No description provided for @workspacesRenameHint.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get workspacesRenameHint;

  /// No description provided for @workspacesRenameSubmit.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get workspacesRenameSubmit;

  /// No description provided for @workspacesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Workspace?'**
  String get workspacesDeleteTitle;

  /// No description provided for @workspacesDeleteSubmit.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get workspacesDeleteSubmit;

  /// No description provided for @workspaceTerminalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} terminal(s)'**
  String workspaceTerminalCount(int count);

  /// No description provided for @workspaceSaved.
  ///
  /// In en, this message translates to:
  /// **'Workspace \"{name}\" saved'**
  String workspaceSaved(String name);

  /// No description provided for @workspaceSwitching.
  ///
  /// In en, this message translates to:
  /// **'Switching to \"{name}\"...'**
  String workspaceSwitching(String name);

  /// No description provided for @workspaceLoaded.
  ///
  /// In en, this message translates to:
  /// **'Workspace \"{name}\" loaded'**
  String workspaceLoaded(String name);

  /// No description provided for @workspaceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String workspaceDeleteConfirm(String name);

  /// No description provided for @awsImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from AWS EC2'**
  String get awsImportTitle;

  /// No description provided for @awsConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to AWS'**
  String get awsConnectTitle;

  /// No description provided for @awsConnectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your AWS credentials to import EC2 instances.'**
  String get awsConnectSubtitle;

  /// No description provided for @awsAccessKeyIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Access Key ID'**
  String get awsAccessKeyIdLabel;

  /// No description provided for @awsAccessKeyIdHelper.
  ///
  /// In en, this message translates to:
  /// **'e.g. AKIAIOSFODNN7EXAMPLE'**
  String get awsAccessKeyIdHelper;

  /// No description provided for @awsSecretAccessKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Secret Access Key'**
  String get awsSecretAccessKeyLabel;

  /// No description provided for @awsRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get awsRegionLabel;

  /// No description provided for @awsCredentialsInfo.
  ///
  /// In en, this message translates to:
  /// **'Credentials are only used for this import and are not stored. Use an IAM user with ec2:DescribeInstances permission only.'**
  String get awsCredentialsInfo;

  /// No description provided for @awsFetchInstances.
  ///
  /// In en, this message translates to:
  /// **'Fetch Instances'**
  String get awsFetchInstances;

  /// No description provided for @awsFetchingInstances.
  ///
  /// In en, this message translates to:
  /// **'Fetching instances...'**
  String get awsFetchingInstances;

  /// No description provided for @awsErrorAccessKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your AWS Access Key ID'**
  String get awsErrorAccessKeyRequired;

  /// No description provided for @awsErrorSecretKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your AWS Secret Access Key'**
  String get awsErrorSecretKeyRequired;

  /// No description provided for @awsSelectInstances.
  ///
  /// In en, this message translates to:
  /// **'Select Instances'**
  String get awsSelectInstances;

  /// No description provided for @awsRunningOnlyFilter.
  ///
  /// In en, this message translates to:
  /// **'Running only'**
  String get awsRunningOnlyFilter;

  /// No description provided for @awsNoRunningInstances.
  ///
  /// In en, this message translates to:
  /// **'No running instances found'**
  String get awsNoRunningInstances;

  /// No description provided for @awsNoInstances.
  ///
  /// In en, this message translates to:
  /// **'No instances found'**
  String get awsNoInstances;

  /// No description provided for @awsConfigureImport.
  ///
  /// In en, this message translates to:
  /// **'Configure Import'**
  String get awsConfigureImport;

  /// No description provided for @awsDefaultUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Default Username'**
  String get awsDefaultUsernameLabel;

  /// No description provided for @awsDefaultUsernameHelper.
  ///
  /// In en, this message translates to:
  /// **'Amazon Linux: ec2-user, Ubuntu: ubuntu'**
  String get awsDefaultUsernameHelper;

  /// No description provided for @awsInstancesToImport.
  ///
  /// In en, this message translates to:
  /// **'Instances to import:'**
  String get awsInstancesToImport;

  /// No description provided for @awsImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get awsImporting;

  /// No description provided for @awsImportResult.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} host(s) from AWS EC2'**
  String awsImportResult(int count);

  /// No description provided for @awsImportHostsButton.
  ///
  /// In en, this message translates to:
  /// **'Import {count} Host(s)'**
  String awsImportHostsButton(int count);

  /// No description provided for @awsNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next ({count})'**
  String awsNextButton(int count);

  /// No description provided for @doImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from DigitalOcean'**
  String get doImportTitle;

  /// No description provided for @doConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to DigitalOcean'**
  String get doConnectTitle;

  /// No description provided for @doConnectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your DigitalOcean personal access token to import droplets.'**
  String get doConnectSubtitle;

  /// No description provided for @doApiTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'API Token'**
  String get doApiTokenLabel;

  /// No description provided for @doApiTokenHelper.
  ///
  /// In en, this message translates to:
  /// **'Generate at cloud.digitalocean.com/account/api/tokens'**
  String get doApiTokenHelper;

  /// No description provided for @doTokenInfo.
  ///
  /// In en, this message translates to:
  /// **'Your token is only used for this import and is not stored.'**
  String get doTokenInfo;

  /// No description provided for @doFetchDroplets.
  ///
  /// In en, this message translates to:
  /// **'Fetch Droplets'**
  String get doFetchDroplets;

  /// No description provided for @doFetchingDroplets.
  ///
  /// In en, this message translates to:
  /// **'Fetching droplets...'**
  String get doFetchingDroplets;

  /// No description provided for @doErrorTokenRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your API token'**
  String get doErrorTokenRequired;

  /// No description provided for @doSelectDroplets.
  ///
  /// In en, this message translates to:
  /// **'Select Droplets'**
  String get doSelectDroplets;

  /// No description provided for @doActiveOnlyFilter.
  ///
  /// In en, this message translates to:
  /// **'Active only'**
  String get doActiveOnlyFilter;

  /// No description provided for @doNoActiveDroplets.
  ///
  /// In en, this message translates to:
  /// **'No active droplets found'**
  String get doNoActiveDroplets;

  /// No description provided for @doNoDroplets.
  ///
  /// In en, this message translates to:
  /// **'No droplets found'**
  String get doNoDroplets;

  /// No description provided for @doConfigureImport.
  ///
  /// In en, this message translates to:
  /// **'Configure Import'**
  String get doConfigureImport;

  /// No description provided for @doDefaultUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Default Username'**
  String get doDefaultUsernameLabel;

  /// No description provided for @doDefaultUsernameHelper.
  ///
  /// In en, this message translates to:
  /// **'Used for all imported hosts (default: root)'**
  String get doDefaultUsernameHelper;

  /// No description provided for @doHostsToImport.
  ///
  /// In en, this message translates to:
  /// **'Hosts to import:'**
  String get doHostsToImport;

  /// No description provided for @doImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get doImporting;

  /// No description provided for @doImportResult.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} host(s) from DigitalOcean'**
  String doImportResult(int count);

  /// No description provided for @doImportHostsButton.
  ///
  /// In en, this message translates to:
  /// **'Import {count} Host(s)'**
  String doImportHostsButton(int count);

  /// No description provided for @doNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next ({count})'**
  String doNextButton(int count);

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync across devices'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginErrorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get loginErrorEmailRequired;

  /// No description provided for @loginErrorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginErrorPasswordRequired;

  /// No description provided for @loginSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginSigningIn;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginCreateAccount;

  /// No description provided for @loginUseLocally.
  ///
  /// In en, this message translates to:
  /// **'Use locally without an account'**
  String get loginUseLocally;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpSubtitle;

  /// No description provided for @signUpEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signUpEmailLabel;

  /// No description provided for @signUpPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password (min 10 characters)'**
  String get signUpPasswordLabel;

  /// No description provided for @signUpConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPasswordLabel;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get passwordStrengthExcellent;

  /// No description provided for @signUpErrorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get signUpErrorEmailRequired;

  /// No description provided for @signUpErrorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get signUpErrorPasswordRequired;

  /// No description provided for @signUpErrorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 10 characters'**
  String get signUpErrorPasswordTooShort;

  /// No description provided for @signUpErrorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signUpErrorPasswordMismatch;

  /// No description provided for @signUpErrorTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms of service'**
  String get signUpErrorTermsRequired;

  /// No description provided for @signUpEncryptionWarning.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted end-to-end. We cannot recover your account if you lose your password.'**
  String get signUpEncryptionWarning;

  /// No description provided for @signUpTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get signUpTermsPrefix;

  /// No description provided for @signUpTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get signUpTermsOfService;

  /// No description provided for @signUpTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get signUpTermsAnd;

  /// No description provided for @signUpPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get signUpPrivacyPolicy;

  /// No description provided for @signUpCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get signUpCreatingAccount;

  /// No description provided for @signUpCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpCreateAccount;

  /// No description provided for @signUpAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signUpAlreadyHaveAccount;

  /// No description provided for @signUpSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signUpSignIn;

  /// No description provided for @signUpEncryptionNote.
  ///
  /// In en, this message translates to:
  /// **'Encryption: Argon2id + AES-256-GCM'**
  String get signUpEncryptionNote;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account and we\'ll send a password reset link.'**
  String get forgotPasswordInstructions;

  /// No description provided for @forgotPasswordEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgotPasswordEmailLabel;

  /// No description provided for @forgotPasswordSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get forgotPasswordSending;

  /// No description provided for @forgotPasswordSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotPasswordSendResetLink;

  /// No description provided for @forgotPasswordBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get forgotPasswordBackToSignIn;

  /// No description provided for @forgotPasswordErrorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get forgotPasswordErrorEmailRequired;

  /// No description provided for @forgotPasswordCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get forgotPasswordCheckEmail;

  /// No description provided for @forgotPasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, you\'ll receive a password reset link shortly.'**
  String forgotPasswordSuccessMessage(String email);

  /// No description provided for @forgotPasswordVaultWarning.
  ///
  /// In en, this message translates to:
  /// **'Remember: Resetting your password will also reset your encryption vault. Data encrypted with your old password cannot be recovered.'**
  String get forgotPasswordVaultWarning;

  /// No description provided for @forgotPasswordTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it? Try again'**
  String get forgotPasswordTryAgain;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below. This will also reset your encryption vault.'**
  String get resetPasswordInstructions;

  /// No description provided for @resetPasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetPasswordNewLabel;

  /// No description provided for @resetPasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get resetPasswordConfirmLabel;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get resetPasswordUpdating;

  /// No description provided for @resetPasswordVaultWarning.
  ///
  /// In en, this message translates to:
  /// **'Setting a new password will reset your encryption vault. Data encrypted with your old password cannot be recovered.'**
  String get resetPasswordVaultWarning;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get resetPasswordMismatch;

  /// No description provided for @resetPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 10 characters'**
  String get resetPasswordTooShort;

  /// No description provided for @totpSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Up 2FA'**
  String get totpSetupTitle;

  /// No description provided for @totpSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to set up 2FA'**
  String get totpSetupFailed;

  /// No description provided for @totpSetupHeading.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get totpSetupHeading;

  /// No description provided for @totpSetupInstructions.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code with your authenticator app (Google Authenticator, Authy, etc.).'**
  String get totpSetupInstructions;

  /// No description provided for @totpSetupManualEntryKey.
  ///
  /// In en, this message translates to:
  /// **'Manual entry key'**
  String get totpSetupManualEntryKey;

  /// No description provided for @totpSetupSecretCopied.
  ///
  /// In en, this message translates to:
  /// **'Secret copied'**
  String get totpSetupSecretCopied;

  /// No description provided for @totpSetupEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your app:'**
  String get totpSetupEnterCode;

  /// No description provided for @totpSetupCodeHint.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get totpSetupCodeHint;

  /// No description provided for @totpSetupVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get totpSetupVerifying;

  /// No description provided for @totpSetupVerifyAndEnable.
  ///
  /// In en, this message translates to:
  /// **'Verify & Enable'**
  String get totpSetupVerifyAndEnable;

  /// No description provided for @totpSetupEnabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication enabled'**
  String get totpSetupEnabled;

  /// No description provided for @totpSetupErrorCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit code'**
  String get totpSetupErrorCodeLength;

  /// No description provided for @totpSetupErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Check your authenticator app and try again.'**
  String get totpSetupErrorInvalidCode;

  /// No description provided for @totpVerifyHeading.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get totpVerifyHeading;

  /// No description provided for @totpVerifyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app'**
  String get totpVerifyInstructions;

  /// No description provided for @totpVerifyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get totpVerifyCodeHint;

  /// No description provided for @totpVerifyVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get totpVerifyVerifying;

  /// No description provided for @totpVerifySubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get totpVerifySubmit;

  /// No description provided for @totpVerifyHelpText.
  ///
  /// In en, this message translates to:
  /// **'Open your authenticator app (Google Authenticator, Authy, etc.) to find your verification code.'**
  String get totpVerifyHelpText;

  /// No description provided for @totpVerifyErrorDefaultFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get totpVerifyErrorDefaultFailed;

  /// No description provided for @totpVerifyErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Try again.'**
  String get totpVerifyErrorInvalidCode;

  /// No description provided for @adaptiveScaffoldHosts.
  ///
  /// In en, this message translates to:
  /// **'Hosts'**
  String get adaptiveScaffoldHosts;

  /// No description provided for @adaptiveScaffoldKeys.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get adaptiveScaffoldKeys;

  /// No description provided for @adaptiveScaffoldSnippets.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get adaptiveScaffoldSnippets;

  /// No description provided for @adaptiveScaffoldTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get adaptiveScaffoldTerminal;

  /// No description provided for @adaptiveScaffoldSftp.
  ///
  /// In en, this message translates to:
  /// **'SFTP'**
  String get adaptiveScaffoldSftp;

  /// No description provided for @adaptiveScaffoldPortForwarding.
  ///
  /// In en, this message translates to:
  /// **'Port Forwarding'**
  String get adaptiveScaffoldPortForwarding;

  /// No description provided for @adaptiveScaffoldSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adaptiveScaffoldSettings;

  /// No description provided for @commandPaletteHint.
  ///
  /// In en, this message translates to:
  /// **'Search hosts, snippets, or type a command...'**
  String get commandPaletteHint;

  /// No description provided for @commandPaletteNoMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String commandPaletteNoMatchQuery(String query);

  /// No description provided for @commandPaletteHostsHeader.
  ///
  /// In en, this message translates to:
  /// **'Hosts'**
  String get commandPaletteHostsHeader;

  /// No description provided for @commandPaletteSnippetsHeader.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get commandPaletteSnippetsHeader;

  /// No description provided for @commandPaletteActionsHeader.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commandPaletteActionsHeader;

  /// No description provided for @commandPaletteActionNewHost.
  ///
  /// In en, this message translates to:
  /// **'New Host'**
  String get commandPaletteActionNewHost;

  /// No description provided for @commandPaletteActionQuickConnect.
  ///
  /// In en, this message translates to:
  /// **'Quick Connect'**
  String get commandPaletteActionQuickConnect;

  /// No description provided for @commandPaletteActionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commandPaletteActionSettings;

  /// No description provided for @commandPaletteActionToggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get commandPaletteActionToggleTheme;

  /// No description provided for @shortcutReferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts'**
  String get shortcutReferenceTitle;

  /// No description provided for @shortcutCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get shortcutCategoryGeneral;

  /// No description provided for @shortcutCategoryTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get shortcutCategoryTerminal;

  /// No description provided for @shortcutCategoryNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get shortcutCategoryNavigation;

  /// No description provided for @appLockTitle.
  ///
  /// In en, this message translates to:
  /// **'CloudShell'**
  String get appLockTitle;

  /// No description provided for @appLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock to continue'**
  String get appLockSubtitle;

  /// No description provided for @appLockUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get appLockUnlockButton;

  /// No description provided for @appLockUnlockWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get appLockUnlockWithBiometrics;

  /// No description provided for @appLockBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock CloudShell'**
  String get appLockBiometricReason;

  /// No description provided for @appLockFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get appLockFailed;

  /// No description provided for @statusOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get statusOnline;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// No description provided for @statusWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get statusWarning;

  /// No description provided for @statusIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get statusIdle;

  /// No description provided for @vaultUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Vault'**
  String get vaultUnlockTitle;

  /// No description provided for @vaultUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your master password to unlock the vault.'**
  String get vaultUnlockSubtitle;

  /// No description provided for @vaultUnlockPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Master Password'**
  String get vaultUnlockPasswordLabel;

  /// No description provided for @vaultUnlockPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter master password'**
  String get vaultUnlockPasswordHint;

  /// No description provided for @vaultUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get vaultUnlockButton;

  /// No description provided for @vaultUnlockUnlocking.
  ///
  /// In en, this message translates to:
  /// **'Unlocking...'**
  String get vaultUnlockUnlocking;

  /// No description provided for @vaultUnlockBiometricButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get vaultUnlockBiometricButton;

  /// No description provided for @vaultUnlockForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get vaultUnlockForgotPassword;

  /// No description provided for @vaultUnlockResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Vault?'**
  String get vaultUnlockResetTitle;

  /// No description provided for @vaultUnlockResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Resetting will delete all encrypted data (saved passwords, private keys). Local hosts and settings will be preserved.\n\nThis action cannot be undone.'**
  String get vaultUnlockResetMessage;

  /// No description provided for @vaultUnlockResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset Vault'**
  String get vaultUnlockResetConfirm;

  /// No description provided for @vaultUnlockIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get vaultUnlockIncorrectPassword;

  /// No description provided for @vaultUnlockLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds}s.'**
  String vaultUnlockLockedOut(int seconds);

  /// No description provided for @masterPasswordSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Up Vault'**
  String get masterPasswordSetupTitle;

  /// No description provided for @masterPasswordSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a master password to encrypt your sensitive data.'**
  String get masterPasswordSetupSubtitle;

  /// No description provided for @masterPasswordSetupPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Master Password'**
  String get masterPasswordSetupPasswordLabel;

  /// No description provided for @masterPasswordSetupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 10 characters'**
  String get masterPasswordSetupPasswordHint;

  /// No description provided for @masterPasswordSetupConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get masterPasswordSetupConfirmLabel;

  /// No description provided for @masterPasswordSetupConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter master password'**
  String get masterPasswordSetupConfirmHint;

  /// No description provided for @masterPasswordSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Create Vault'**
  String get masterPasswordSetupButton;

  /// No description provided for @masterPasswordSetupCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating vault...'**
  String get masterPasswordSetupCreating;

  /// No description provided for @masterPasswordSetupMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 10 characters required'**
  String get masterPasswordSetupMinLength;

  /// No description provided for @masterPasswordSetupMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get masterPasswordSetupMismatch;

  /// No description provided for @masterPasswordSetupStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get masterPasswordSetupStrengthWeak;

  /// No description provided for @masterPasswordSetupStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get masterPasswordSetupStrengthFair;

  /// No description provided for @masterPasswordSetupStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get masterPasswordSetupStrengthGood;

  /// No description provided for @masterPasswordSetupStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get masterPasswordSetupStrengthStrong;

  /// No description provided for @masterPasswordSetupWarning.
  ///
  /// In en, this message translates to:
  /// **'Your master password cannot be recovered. Write it down and store it safely.'**
  String get masterPasswordSetupWarning;

  /// No description provided for @passwordGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGeneratorTitle;

  /// No description provided for @passwordGeneratorLengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Length: {length}'**
  String passwordGeneratorLengthLabel(int length);

  /// No description provided for @passwordGeneratorUppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase (A-Z)'**
  String get passwordGeneratorUppercase;

  /// No description provided for @passwordGeneratorLowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase (a-z)'**
  String get passwordGeneratorLowercase;

  /// No description provided for @passwordGeneratorNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers (0-9)'**
  String get passwordGeneratorNumbers;

  /// No description provided for @passwordGeneratorSymbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols (!@#...)'**
  String get passwordGeneratorSymbols;

  /// No description provided for @passwordGeneratorGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get passwordGeneratorGenerate;

  /// No description provided for @passwordGeneratorCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get passwordGeneratorCopy;

  /// No description provided for @passwordGeneratorCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied (auto-clears in 30s)'**
  String get passwordGeneratorCopied;

  /// No description provided for @passwordGeneratorStrengthBits.
  ///
  /// In en, this message translates to:
  /// **'{bits} bits of entropy'**
  String passwordGeneratorStrengthBits(String bits);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CloudShell'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A modern, cross-platform SSH client'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure by Design'**
  String get onboardingSecureTitle;

  /// No description provided for @onboardingSecureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted vault with Argon2id + AES-256-GCM'**
  String get onboardingSecureSubtitle;

  /// No description provided for @onboardingTerminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Powerful Terminal'**
  String get onboardingTerminalTitle;

  /// No description provided for @onboardingTerminalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Split panes, tabs, themes, snippets, and more'**
  String get onboardingTerminalSubtitle;

  /// No description provided for @onboardingSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Everywhere'**
  String get onboardingSyncTitle;

  /// No description provided for @onboardingSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your hosts, keys, and snippets — on all your devices'**
  String get onboardingSyncSubtitle;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @portForwardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Port Forwarding'**
  String get portForwardingTitle;

  /// No description provided for @portForwardingAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get portForwardingAddTooltip;

  /// No description provided for @portForwardingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No port forwarding rules'**
  String get portForwardingEmptyTitle;

  /// No description provided for @portForwardingEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create rules to tunnel traffic through SSH connections.'**
  String get portForwardingEmptySubtitle;

  /// No description provided for @portForwardingEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add Rule'**
  String get portForwardingEmptyAction;

  /// No description provided for @portForwardingActiveHeader.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get portForwardingActiveHeader;

  /// No description provided for @portForwardingSavedHeader.
  ///
  /// In en, this message translates to:
  /// **'SAVED RULES'**
  String get portForwardingSavedHeader;

  /// No description provided for @portForwardingTypeLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get portForwardingTypeLocal;

  /// No description provided for @portForwardingTypeRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get portForwardingTypeRemote;

  /// No description provided for @portForwardingTypeDynamic.
  ///
  /// In en, this message translates to:
  /// **'SOCKS'**
  String get portForwardingTypeDynamic;

  /// No description provided for @portForwardingStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get portForwardingStop;

  /// No description provided for @portForwardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get portForwardingStart;

  /// No description provided for @portForwardingMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get portForwardingMenuEdit;

  /// No description provided for @portForwardingMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get portForwardingMenuDelete;

  /// No description provided for @portForwardingDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Rule'**
  String get portForwardingDeleteDialogTitle;

  /// No description provided for @portForwardingDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this port forwarding rule?'**
  String get portForwardingDeleteDialogMessage;

  /// No description provided for @portForwardingLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading port forwarding rules...'**
  String get portForwardingLoading;

  /// No description provided for @portForwardFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Port Forward'**
  String get portForwardFormTitleNew;

  /// No description provided for @portForwardFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Port Forward'**
  String get portForwardFormTitleEdit;

  /// No description provided for @portForwardFormLabelField.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get portForwardFormLabelField;

  /// No description provided for @portForwardFormLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Database Tunnel'**
  String get portForwardFormLabelHint;

  /// No description provided for @portForwardFormTypeField.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get portForwardFormTypeField;

  /// No description provided for @portForwardFormTypeLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get portForwardFormTypeLocal;

  /// No description provided for @portForwardFormTypeRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get portForwardFormTypeRemote;

  /// No description provided for @portForwardFormTypeDynamic.
  ///
  /// In en, this message translates to:
  /// **'Dynamic (SOCKS)'**
  String get portForwardFormTypeDynamic;

  /// No description provided for @portForwardFormHostField.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get portForwardFormHostField;

  /// No description provided for @portForwardFormSelectHost.
  ///
  /// In en, this message translates to:
  /// **'Select a host'**
  String get portForwardFormSelectHost;

  /// No description provided for @portForwardFormNoHostsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No hosts available. Create a host first.'**
  String get portForwardFormNoHostsAvailable;

  /// No description provided for @portForwardFormCouldNotLoadHosts.
  ///
  /// In en, this message translates to:
  /// **'Could not load hosts.'**
  String get portForwardFormCouldNotLoadHosts;

  /// No description provided for @portForwardFormLocalPortField.
  ///
  /// In en, this message translates to:
  /// **'Local Port'**
  String get portForwardFormLocalPortField;

  /// No description provided for @portForwardFormRemotePortField.
  ///
  /// In en, this message translates to:
  /// **'Remote Port'**
  String get portForwardFormRemotePortField;

  /// No description provided for @portForwardFormDestHostField.
  ///
  /// In en, this message translates to:
  /// **'Destination Host'**
  String get portForwardFormDestHostField;

  /// No description provided for @portForwardFormDestHostHint.
  ///
  /// In en, this message translates to:
  /// **'localhost'**
  String get portForwardFormDestHostHint;

  /// No description provided for @portForwardFormDestPortField.
  ///
  /// In en, this message translates to:
  /// **'Dest Port'**
  String get portForwardFormDestPortField;

  /// No description provided for @portForwardFormDestPortHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 5432'**
  String get portForwardFormDestPortHint;

  /// No description provided for @portForwardFormPortHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 8080'**
  String get portForwardFormPortHint;

  /// No description provided for @portForwardFormAutoStart.
  ///
  /// In en, this message translates to:
  /// **'Auto-start on connect'**
  String get portForwardFormAutoStart;

  /// No description provided for @portForwardFormAutoStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start this tunnel automatically when connecting to the host.'**
  String get portForwardFormAutoStartSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
