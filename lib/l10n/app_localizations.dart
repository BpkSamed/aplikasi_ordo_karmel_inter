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

  /// No description provided for @appInfoTitle.
  ///
  /// In la, this message translates to:
  /// **'Informatio Applicationis'**
  String get appInfoTitle;

  /// No description provided for @appName.
  ///
  /// In la, this message translates to:
  /// **'APPLICATIO ORDINIS CARMELITARUM'**
  String get appName;

  /// No description provided for @headquarters.
  ///
  /// In la, this message translates to:
  /// **'Sedes Principalis'**
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

  /// No description provided for @continueToLogin.
  ///
  /// In la, this message translates to:
  /// **'Perge ad Login'**
  String get continueToLogin;

  /// No description provided for @loginTitle.
  ///
  /// In la, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @usernameEmailLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Usoris / Email'**
  String get usernameEmailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In la, this message translates to:
  /// **'Tessera'**
  String get passwordLabel;

  /// No description provided for @loginAsMember.
  ///
  /// In la, this message translates to:
  /// **'Login ut Sodalis'**
  String get loginAsMember;

  /// No description provided for @loginAsAdmin.
  ///
  /// In la, this message translates to:
  /// **'Login ut Administrator'**
  String get loginAsAdmin;

  /// No description provided for @userProfileTitle.
  ///
  /// In la, this message translates to:
  /// **'Profilum Usoris'**
  String get userProfileTitle;

  /// No description provided for @studentRole.
  ///
  /// In la, this message translates to:
  /// **'Discipulus'**
  String get studentRole;

  /// No description provided for @welcomeMessage.
  ///
  /// In la, this message translates to:
  /// **'Salve, Abraham'**
  String get welcomeMessage;

  /// No description provided for @universityStudent.
  ///
  /// In la, this message translates to:
  /// **'Discipulus Universitatis'**
  String get universityStudent;

  /// No description provided for @drawerInstruction.
  ///
  /// In la, this message translates to:
  /// **'Preme tres lineas in angulo superiore sinistro ad videndum directorium Ordinis Carmelitarum.'**
  String get drawerInstruction;

  /// No description provided for @openingMenu.
  ///
  /// In la, this message translates to:
  /// **'Aperiens: {title}'**
  String openingMenu(String title);

  /// No description provided for @logout.
  ///
  /// In la, this message translates to:
  /// **'Exire'**
  String get logout;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In la, this message translates to:
  /// **'Tabula Administratoris'**
  String get adminDashboardTitle;

  /// No description provided for @directoryManagementMenu.
  ///
  /// In la, this message translates to:
  /// **'Menu Administrationis Directorii'**
  String get directoryManagementMenu;

  /// No description provided for @manageMasterData.
  ///
  /// In la, this message translates to:
  /// **'Administrare Data Principalia'**
  String get manageMasterData;

  /// No description provided for @masterDataSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Inscriptiones, Entitates et Monasteria'**
  String get masterDataSubtitle;

  /// No description provided for @manageMemberData.
  ///
  /// In la, this message translates to:
  /// **'Administrare Data Sodalium'**
  String get manageMemberData;

  /// No description provided for @memberDataSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Adde, Recense, et Dele Personalia'**
  String get memberDataSubtitle;

  /// No description provided for @manageCentralOfficials.
  ///
  /// In la, this message translates to:
  /// **'Administrare Officiales Centrales & Curiam'**
  String get manageCentralOfficials;

  /// No description provided for @centralOfficialsSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Designa officiales Curiae Generalis & Sub Immediata'**
  String get centralOfficialsSubtitle;

  /// No description provided for @manageBishopData.
  ///
  /// In la, this message translates to:
  /// **'Administrare Data Episcoporum'**
  String get manageBishopData;

  /// No description provided for @bishopDataSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Administrare indicem Episcoporum Ex Ordine Assumptorum'**
  String get bishopDataSubtitle;

  /// No description provided for @manageCitocNews.
  ///
  /// In la, this message translates to:
  /// **'Administrare Nuntios CITOC'**
  String get manageCitocNews;

  /// No description provided for @citocNewsSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Adde vincula nuntiorum recentium'**
  String get citocNewsSubtitle;

  /// No description provided for @manageGeneralCommissions.
  ///
  /// In la, this message translates to:
  /// **'Administrare Commissiones Generales'**
  String get manageGeneralCommissions;

  /// No description provided for @generalCommissionsSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Guberna divisiones commissionum et sodales earum'**
  String get generalCommissionsSubtitle;

  /// No description provided for @curiaGeneralisTitle.
  ///
  /// In la, this message translates to:
  /// **'Curia Generalis'**
  String get curiaGeneralisTitle;

  /// No description provided for @consiliumGenerale.
  ///
  /// In la, this message translates to:
  /// **'Consilium Generale'**
  String get consiliumGenerale;

  /// No description provided for @officiaGeneralia.
  ///
  /// In la, this message translates to:
  /// **'Officia Generalia et Sectores Laborum'**
  String get officiaGeneralia;

  /// No description provided for @commissionesGenerales.
  ///
  /// In la, this message translates to:
  /// **'Commissiones Generales'**
  String get commissionesGenerales;

  /// No description provided for @priorGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Prior Generalis'**
  String get priorGeneralis;

  /// No description provided for @vicePriorGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Vice Prior Generalis'**
  String get vicePriorGeneralis;

  /// No description provided for @procuratorGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Procurator Generalis'**
  String get procuratorGeneralis;

  /// No description provided for @oeconomusGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Oeconomus Generalis'**
  String get oeconomusGeneralis;

  /// No description provided for @consiliariusAmericarum.
  ///
  /// In la, this message translates to:
  /// **'Consiliarius pro Ambitu Americarum'**
  String get consiliariusAmericarum;

  /// No description provided for @consiliariusAfricae.
  ///
  /// In la, this message translates to:
  /// **'Consiliarius pro Ambitu Africae'**
  String get consiliariusAfricae;

  /// No description provided for @consiliariusAsiae.
  ///
  /// In la, this message translates to:
  /// **'Consiliarius pro Ambitu Asiae, Australiae et Oceaniae'**
  String get consiliariusAsiae;

  /// No description provided for @consiliariusEuropae.
  ///
  /// In la, this message translates to:
  /// **'Consiliarius pro Ambitu Europae'**
  String get consiliariusEuropae;

  /// No description provided for @oeconomatusGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Oeconomatus Generalis'**
  String get oeconomatusGeneralis;

  /// No description provided for @secretariatusGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Secretariatus Generalis'**
  String get secretariatusGeneralis;

  /// No description provided for @delegatusMonacorum.
  ///
  /// In la, this message translates to:
  /// **'Delegatus Monacorum, Heremiti et Instituta'**
  String get delegatusMonacorum;

  /// No description provided for @delegatusFormationis.
  ///
  /// In la, this message translates to:
  /// **'Delegatus Formationis'**
  String get delegatusFormationis;

  /// No description provided for @delegatusIuvenibus.
  ///
  /// In la, this message translates to:
  /// **'Delegatus Iuvenibus'**
  String get delegatusIuvenibus;

  /// No description provided for @delegatusToc.
  ///
  /// In la, this message translates to:
  /// **'Delegatus TOC'**
  String get delegatusToc;

  /// No description provided for @delegatusLaicorum.
  ///
  /// In la, this message translates to:
  /// **'Delegatus Laicorum'**
  String get delegatusLaicorum;

  /// No description provided for @postulaturaGeneralis.
  ///
  /// In la, this message translates to:
  /// **'Postulatura Generalis'**
  String get postulaturaGeneralis;

  /// No description provided for @legaleRappresentante.
  ///
  /// In la, this message translates to:
  /// **'Legale Rappresentante'**
  String get legaleRappresentante;

  /// No description provided for @cDeFormatione.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Formatione'**
  String get cDeFormatione;

  /// No description provided for @cDeIuvenibus.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Iuvenibus Carmelitis'**
  String get cDeIuvenibus;

  /// No description provided for @cDeRebusOeconomicis.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Rebus Oeconomicis'**
  String get cDeRebusOeconomicis;

  /// No description provided for @cDeLiturgia.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Liturgia et Oratione'**
  String get cDeLiturgia;

  /// No description provided for @cDeCommunicatione.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Communicatione'**
  String get cDeCommunicatione;

  /// No description provided for @cDeEvangelizatio.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Evangelizatio, Iustitia, Pace et Creationis Integritate'**
  String get cDeEvangelizatio;

  /// No description provided for @cDeMinisterium.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis de Ministerium'**
  String get cDeMinisterium;

  /// No description provided for @cProTutelaMinorium.
  ///
  /// In la, this message translates to:
  /// **'Commissio Generalis pro Tutela Minorium'**
  String get cProTutelaMinorium;

  /// No description provided for @tocNegotiumForce.
  ///
  /// In la, this message translates to:
  /// **'TOC Negotium Force'**
  String get tocNegotiumForce;

  /// No description provided for @praeses.
  ///
  /// In la, this message translates to:
  /// **'Praeses'**
  String get praeses;

  /// No description provided for @sodales.
  ///
  /// In la, this message translates to:
  /// **'Sodales'**
  String get sodales;

  /// No description provided for @missio.
  ///
  /// In la, this message translates to:
  /// **'Missio'**
  String get missio;
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
