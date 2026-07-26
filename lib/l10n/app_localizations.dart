import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';
import 'app_localizations_la.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('es'),
    Locale('it'),
    Locale('la'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In la, this message translates to:
  /// **'Ordo Carmelitarum'**
  String get appTitle;

  /// No description provided for @infoAppTitle.
  ///
  /// In la, this message translates to:
  /// **'Informatio Applicationis'**
  String get infoAppTitle;

  /// No description provided for @infoMainTitle.
  ///
  /// In la, this message translates to:
  /// **'APPLICATIO ORDINIS CARMELITARUM'**
  String get infoMainTitle;

  /// No description provided for @headquarters.
  ///
  /// In la, this message translates to:
  /// **'Domus Centralis'**
  String get headquarters;

  /// No description provided for @headquartersAddress.
  ///
  /// In la, this message translates to:
  /// **'Curia Generalitia\nVia di San Martino ai Monti, 8\n00184 Roma, Italia'**
  String get headquartersAddress;

  /// No description provided for @contactUs.
  ///
  /// In la, this message translates to:
  /// **'Contactus'**
  String get contactUs;

  /// No description provided for @contactDetails.
  ///
  /// In la, this message translates to:
  /// **'Email: info@ocarm.org\nTel: +39 06 4620181'**
  String get contactDetails;

  /// No description provided for @btnContinueLogin.
  ///
  /// In la, this message translates to:
  /// **'Perge ad Ingressum'**
  String get btnContinueLogin;

  /// No description provided for @loginTitle.
  ///
  /// In la, this message translates to:
  /// **'Ingressus'**
  String get loginTitle;

  /// No description provided for @welcomeText.
  ///
  /// In la, this message translates to:
  /// **'Salve'**
  String get welcomeText;

  /// No description provided for @labelUsername.
  ///
  /// In la, this message translates to:
  /// **'Nomen Usuarii / Email'**
  String get labelUsername;

  /// No description provided for @labelPassword.
  ///
  /// In la, this message translates to:
  /// **'Tessera'**
  String get labelPassword;

  /// No description provided for @btnLoginMember.
  ///
  /// In la, this message translates to:
  /// **'Ingredere ut Sodalis'**
  String get btnLoginMember;

  /// No description provided for @btnLoginAdmin.
  ///
  /// In la, this message translates to:
  /// **'Ingredere ut Administrator'**
  String get btnLoginAdmin;

  /// No description provided for @profileTitle.
  ///
  /// In la, this message translates to:
  /// **'Profilum Usuarii'**
  String get profileTitle;

  /// No description provided for @welcomeMember.
  ///
  /// In la, this message translates to:
  /// **'Salve, Abraham'**
  String get welcomeMember;

  /// No description provided for @studentSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Studiosus Universitatis'**
  String get studentSubtitle;

  /// No description provided for @drawerInstruction.
  ///
  /// In la, this message translates to:
  /// **'Preme menu ad sinistram superiorem ut directorium videas.'**
  String get drawerInstruction;

  /// No description provided for @logout.
  ///
  /// In la, this message translates to:
  /// **'Exitus'**
  String get logout;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In la, this message translates to:
  /// **'Tabula Administrationis'**
  String get adminDashboardTitle;

  /// No description provided for @adminMenuTitle.
  ///
  /// In la, this message translates to:
  /// **'Index Administrationis Directorii'**
  String get adminMenuTitle;

  /// No description provided for @menuMasterData.
  ///
  /// In la, this message translates to:
  /// **'Gere Data Magistralia'**
  String get menuMasterData;

  /// No description provided for @subMasterData.
  ///
  /// In la, this message translates to:
  /// **'Inscriptiones, Entitates, et Conventus'**
  String get subMasterData;

  /// No description provided for @menuMemberData.
  ///
  /// In la, this message translates to:
  /// **'Gere Data Sodalium'**
  String get menuMemberData;

  /// No description provided for @subMemberData.
  ///
  /// In la, this message translates to:
  /// **'Adde, Muta, et Dele Personas'**
  String get subMemberData;

  /// No description provided for @menuCentralOfficers.
  ///
  /// In la, this message translates to:
  /// **'Gere Praefectos Centrales'**
  String get menuCentralOfficers;

  /// No description provided for @subCentralOfficers.
  ///
  /// In la, this message translates to:
  /// **'Designa Praefectos Curiae Generalitiae & Sub Immediata'**
  String get subCentralOfficers;

  /// No description provided for @menuBishopsData.
  ///
  /// In la, this message translates to:
  /// **'Gere Data Episcoporum'**
  String get menuBishopsData;

  /// No description provided for @subBishopsData.
  ///
  /// In la, this message translates to:
  /// **'Gere Indicem Episcoporum Ex Ordine'**
  String get subBishopsData;

  /// No description provided for @menuCitocNews.
  ///
  /// In la, this message translates to:
  /// **'Gere Nuntios CITOC'**
  String get menuCitocNews;

  /// No description provided for @subCitocNews.
  ///
  /// In la, this message translates to:
  /// **'Adde Vincula Nuntiorum Novissimorum'**
  String get subCitocNews;

  /// No description provided for @menuCommissions.
  ///
  /// In la, this message translates to:
  /// **'Gere Commissiones Generales'**
  String get menuCommissions;

  /// No description provided for @subCommissions.
  ///
  /// In la, this message translates to:
  /// **'Ordina Divisiones Commissionum et Sodales'**
  String get subCommissions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it', 'la'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
    case 'la':
      return AppLocalizationsLa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
