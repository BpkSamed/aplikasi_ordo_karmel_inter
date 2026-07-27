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
  /// **'Salve'**
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
  String openingMenu(Object title);

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

  /// No description provided for @unassignedMonastery.
  ///
  /// In la, this message translates to:
  /// **'Monasterium non assignatum'**
  String get unassignedMonastery;

  /// No description provided for @unassignedOfficial.
  ///
  /// In la, this message translates to:
  /// **'Officialis non assignatus'**
  String get unassignedOfficial;

  /// No description provided for @communityOrigin.
  ///
  /// In la, this message translates to:
  /// **'Communitas Originis'**
  String get communityOrigin;

  /// No description provided for @birthPlace.
  ///
  /// In la, this message translates to:
  /// **'Locus Nativitatis'**
  String get birthPlace;

  /// No description provided for @birthCountry.
  ///
  /// In la, this message translates to:
  /// **'Patria Nativitatis'**
  String get birthCountry;

  /// No description provided for @birthDate.
  ///
  /// In la, this message translates to:
  /// **'Dies Nativitatis'**
  String get birthDate;

  /// No description provided for @firstProfession.
  ///
  /// In la, this message translates to:
  /// **'Professio Prima'**
  String get firstProfession;

  /// No description provided for @solemnProfession.
  ///
  /// In la, this message translates to:
  /// **'Professio Sollemnis'**
  String get solemnProfession;

  /// No description provided for @ordinationDate.
  ///
  /// In la, this message translates to:
  /// **'Dies Ordinationis'**
  String get ordinationDate;

  /// No description provided for @noCommissionData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Commissionis adhuc inscripta.'**
  String get noCommissionData;

  /// No description provided for @unassignedPresident.
  ///
  /// In la, this message translates to:
  /// **'Nondum definitus'**
  String get unassignedPresident;

  /// No description provided for @missionTask.
  ///
  /// In la, this message translates to:
  /// **'Missio / Munus Apostolicum:'**
  String get missionTask;

  /// No description provided for @noMissionDesc.
  ///
  /// In la, this message translates to:
  /// **'Nulla descriptio missionis adhuc exstat.'**
  String get noMissionDesc;

  /// No description provided for @commissionMembersLabel.
  ///
  /// In la, this message translates to:
  /// **'Sodales (Membri Commissionis):'**
  String get commissionMembersLabel;

  /// No description provided for @noCommissionMembers.
  ///
  /// In la, this message translates to:
  /// **'Nulli sodales commissioni adhuc additi.'**
  String get noCommissionMembers;

  /// No description provided for @unknown.
  ///
  /// In la, this message translates to:
  /// **'Incognitus'**
  String get unknown;

  /// No description provided for @positionLabel.
  ///
  /// In la, this message translates to:
  /// **'Officium'**
  String get positionLabel;

  /// No description provided for @memberRole.
  ///
  /// In la, this message translates to:
  /// **'Sodalis'**
  String get memberRole;

  /// No description provided for @episcopiTitle.
  ///
  /// In la, this message translates to:
  /// **'Episcopi Ex Ordine Assumpti'**
  String get episcopiTitle;

  /// No description provided for @titularSee.
  ///
  /// In la, this message translates to:
  /// **'Sedes Titularis / Dioecesis'**
  String get titularSee;

  /// No description provided for @episcopalConsecration.
  ///
  /// In la, this message translates to:
  /// **'Consecratio Episcopalis'**
  String get episcopalConsecration;

  /// No description provided for @bishopStatus.
  ///
  /// In la, this message translates to:
  /// **'Status Episcopi'**
  String get bishopStatus;

  /// No description provided for @activeBishop.
  ///
  /// In la, this message translates to:
  /// **'In Officio'**
  String get activeBishop;

  /// No description provided for @emeritusBishop.
  ///
  /// In la, this message translates to:
  /// **'Emeritus'**
  String get emeritusBishop;

  /// No description provided for @noBishopData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Episcoporum inventa.'**
  String get noBishopData;

  /// No description provided for @searchBishop.
  ///
  /// In la, this message translates to:
  /// **'Quaere Episcopum...'**
  String get searchBishop;

  /// No description provided for @errorOccurred.
  ///
  /// In la, this message translates to:
  /// **'Error accidit'**
  String get errorOccurred;

  /// No description provided for @emptyDataDetailWarning.
  ///
  /// In la, this message translates to:
  /// **'Data vacua sunt, singula aperiri non possunt.'**
  String get emptyDataDetailWarning;

  /// No description provided for @episcopiDetailTitle.
  ///
  /// In la, this message translates to:
  /// **'Facies Episcopi'**
  String get episcopiDetailTitle;

  /// No description provided for @mainInfo.
  ///
  /// In la, this message translates to:
  /// **'Notitia Principalis'**
  String get mainInfo;

  /// No description provided for @exCarmeliteEntity.
  ///
  /// In la, this message translates to:
  /// **'Ex Carmelita Entity'**
  String get exCarmeliteEntity;

  /// No description provided for @status.
  ///
  /// In la, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @addressLabel.
  ///
  /// In la, this message translates to:
  /// **'Domicilium'**
  String get addressLabel;

  /// No description provided for @houseName.
  ///
  /// In la, this message translates to:
  /// **'Nomen Domus'**
  String get houseName;

  /// No description provided for @street.
  ///
  /// In la, this message translates to:
  /// **'Via'**
  String get street;

  /// No description provided for @city.
  ///
  /// In la, this message translates to:
  /// **'Civitas'**
  String get city;

  /// No description provided for @country.
  ///
  /// In la, this message translates to:
  /// **'Civitas/Regio'**
  String get country;

  /// No description provided for @postalCode.
  ///
  /// In la, this message translates to:
  /// **'Cursualis Codex'**
  String get postalCode;

  /// No description provided for @contactLabel.
  ///
  /// In la, this message translates to:
  /// **'Contactus'**
  String get contactLabel;

  /// No description provided for @telephone.
  ///
  /// In la, this message translates to:
  /// **'Telephonum'**
  String get telephone;

  /// No description provided for @faxcimile.
  ///
  /// In la, this message translates to:
  /// **'Facsimile'**
  String get faxcimile;

  /// No description provided for @email.
  ///
  /// In la, this message translates to:
  /// **'Litterae Electronicae'**
  String get email;

  /// No description provided for @subImmediataTitle.
  ///
  /// In la, this message translates to:
  /// **'Sub Immediata Jurisdictione'**
  String get subImmediataTitle;

  /// No description provided for @noSubImmediataData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data adhuc relata sunt.'**
  String get noSubImmediataData;

  /// No description provided for @citocNewsTitle.
  ///
  /// In la, this message translates to:
  /// **'Nuntii CITOC'**
  String get citocNewsTitle;

  /// No description provided for @linkOpenError.
  ///
  /// In la, this message translates to:
  /// **'Vinculum aperiri non potuit. Fac formam rectam esse.'**
  String get linkOpenError;

  /// No description provided for @noCitocNews.
  ///
  /// In la, this message translates to:
  /// **'Nulli nuntii hoc tempore editi sunt.'**
  String get noCitocNews;

  /// No description provided for @latestNews.
  ///
  /// In la, this message translates to:
  /// **'Nuntii Recentissimi'**
  String get latestNews;

  /// No description provided for @tapToReadMore.
  ///
  /// In la, this message translates to:
  /// **'Tange ut plura legas...'**
  String get tapToReadMore;

  /// No description provided for @fratresDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Fratrum'**
  String get fratresDirectoryTitle;

  /// No description provided for @selectFratresCategory.
  ///
  /// In la, this message translates to:
  /// **'Elige Categoriam Fratrum'**
  String get selectFratresCategory;

  /// No description provided for @provincia.
  ///
  /// In la, this message translates to:
  /// **'PROVINCIA'**
  String get provincia;

  /// No description provided for @commissariatusGeneralis.
  ///
  /// In la, this message translates to:
  /// **'COMMISSARIATUS GENERALIS'**
  String get commissariatusGeneralis;

  /// No description provided for @delegatioGeneralis.
  ///
  /// In la, this message translates to:
  /// **'DELEGATIO GENERALIS'**
  String get delegatioGeneralis;

  /// No description provided for @listCategoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Index {category}'**
  String listCategoryTitle(Object category);

  /// No description provided for @searchCategoryName.
  ///
  /// In la, this message translates to:
  /// **'Quaere Nomen {category}...'**
  String searchCategoryName(Object category);

  /// No description provided for @noCategoryData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data {category} inventa sunt.'**
  String noCategoryData(Object category);

  /// No description provided for @locationNotSet.
  ///
  /// In la, this message translates to:
  /// **'Locus non constitutus'**
  String get locationNotSet;

  /// No description provided for @detail.
  ///
  /// In la, this message translates to:
  /// **'Singula'**
  String get detail;

  /// No description provided for @historia.
  ///
  /// In la, this message translates to:
  /// **'Historia'**
  String get historia;

  /// No description provided for @noHistory.
  ///
  /// In la, this message translates to:
  /// **'Nulla historia adhuc relata est.'**
  String get noHistory;

  /// No description provided for @website.
  ///
  /// In la, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @officialWebsite.
  ///
  /// In la, this message translates to:
  /// **'Website Publicum'**
  String get officialWebsite;

  /// No description provided for @webLink.
  ///
  /// In la, this message translates to:
  /// **'Vinculum Web'**
  String get webLink;

  /// No description provided for @noWebsite.
  ///
  /// In la, this message translates to:
  /// **'Nullum website'**
  String get noWebsite;

  /// No description provided for @consiliumCouncil.
  ///
  /// In la, this message translates to:
  /// **'Consilium'**
  String get consiliumCouncil;

  /// No description provided for @leadershipConsilium.
  ///
  /// In la, this message translates to:
  /// **'Consilium Gubernii'**
  String get leadershipConsilium;

  /// No description provided for @domusAddress.
  ///
  /// In la, this message translates to:
  /// **'Domus'**
  String get domusAddress;

  /// No description provided for @addressNotAvailable.
  ///
  /// In la, this message translates to:
  /// **'Domicilium non praesto est.'**
  String get addressNotAvailable;

  /// No description provided for @monasteryBuilding.
  ///
  /// In la, this message translates to:
  /// **'Monasterium / Aedificium'**
  String get monasteryBuilding;

  /// No description provided for @officialDomus.
  ///
  /// In la, this message translates to:
  /// **'Domus Publica'**
  String get officialDomus;

  /// No description provided for @conventusList.
  ///
  /// In la, this message translates to:
  /// **'Conventus (Index Monasteriorum)'**
  String get conventusList;

  /// No description provided for @sodalesList.
  ///
  /// In la, this message translates to:
  /// **'Sodales (Index Sodalarum)'**
  String get sodalesList;

  /// No description provided for @memberListSodales.
  ///
  /// In la, this message translates to:
  /// **'Index Sodalarum'**
  String get memberListSodales;

  /// No description provided for @noMemberData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data sodalarum.'**
  String get noMemberData;

  /// No description provided for @positionRole.
  ///
  /// In la, this message translates to:
  /// **'Munus / Partes'**
  String get positionRole;

  /// No description provided for @conventusMonasteriesTitle.
  ///
  /// In la, this message translates to:
  /// **'Index Domorum Monasteriorum (Conventus)'**
  String get conventusMonasteriesTitle;

  /// No description provided for @noRegisteredMonastery.
  ///
  /// In la, this message translates to:
  /// **'Nulla data monasterii adhuc relata sunt.'**
  String get noRegisteredMonastery;

  /// No description provided for @completeMonasteryAddress.
  ///
  /// In la, this message translates to:
  /// **'Domicilium Monasterii Integrum:'**
  String get completeMonasteryAddress;

  /// No description provided for @addressNotFilled.
  ///
  /// In la, this message translates to:
  /// **'Singula domicilii nondum expleta sunt.'**
  String get addressNotFilled;

  /// No description provided for @heremitiDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Heremitarum'**
  String get heremitiDirectoryTitle;

  /// No description provided for @heremitiTitle.
  ///
  /// In la, this message translates to:
  /// **'Heremiti'**
  String get heremitiTitle;

  /// No description provided for @searchHeremiti.
  ///
  /// In la, this message translates to:
  /// **'Quaere Heremitas...'**
  String get searchHeremiti;

  /// No description provided for @noHeremitiData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data heremitarum inventa sunt.'**
  String get noHeremitiData;

  /// No description provided for @heremitiDetailTitle.
  ///
  /// In la, this message translates to:
  /// **'Singula Heremitarum'**
  String get heremitiDetailTitle;

  /// No description provided for @hermitageName.
  ///
  /// In la, this message translates to:
  /// **'Nomen Eremiterii'**
  String get hermitageName;

  /// No description provided for @heremitiPrior.
  ///
  /// In la, this message translates to:
  /// **'Prior / Moderator Heremi'**
  String get heremitiPrior;

  /// No description provided for @monialesDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Monialium'**
  String get monialesDirectoryTitle;

  /// No description provided for @federatioEntitiesTitle.
  ///
  /// In la, this message translates to:
  /// **'Federatio / Entitates'**
  String get federatioEntitiesTitle;

  /// No description provided for @federatioEntitiesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Federationum Monialium, Historia, et Website Publicum'**
  String get federatioEntitiesSubtitle;

  /// No description provided for @monialesConventusTitle.
  ///
  /// In la, this message translates to:
  /// **'Monasteria / Conventus'**
  String get monialesConventusTitle;

  /// No description provided for @monialesConventusSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Monasteriorum Monialium et Domicilia Contactus'**
  String get monialesConventusSubtitle;

  /// No description provided for @sororesTitle.
  ///
  /// In la, this message translates to:
  /// **'Sorores'**
  String get sororesTitle;

  /// No description provided for @sororesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Sororum, Locus Nativitatis, et Dies Professionis'**
  String get sororesSubtitle;

  /// No description provided for @federatioAndEntities.
  ///
  /// In la, this message translates to:
  /// **'Federatio et Entitates'**
  String get federatioAndEntities;

  /// No description provided for @searchFederation.
  ///
  /// In la, this message translates to:
  /// **'Quaere Federationem / Entitatem...'**
  String get searchFederation;

  /// No description provided for @noMonialesEntitiesData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Entitatum Monialium inventa sunt.'**
  String get noMonialesEntitiesData;

  /// No description provided for @monasteriaTitle.
  ///
  /// In la, this message translates to:
  /// **'Monasteria'**
  String get monasteriaTitle;

  /// No description provided for @searchMonasteryCity.
  ///
  /// In la, this message translates to:
  /// **'Quaere Nomen Monasterii / Civitatis...'**
  String get searchMonasteryCity;

  /// No description provided for @noMonialesMonasteryData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Monasteriorum Monialium inventa sunt.'**
  String get noMonialesMonasteryData;

  /// No description provided for @federationLabel.
  ///
  /// In la, this message translates to:
  /// **'Federatio'**
  String get federationLabel;

  /// No description provided for @monasteryLocationDetail.
  ///
  /// In la, this message translates to:
  /// **'Singula Loci Monasterii:'**
  String get monasteryLocationDetail;

  /// No description provided for @searchSisterName.
  ///
  /// In la, this message translates to:
  /// **'Quaere Nomen Sororis...'**
  String get searchSisterName;

  /// No description provided for @noSororesData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Sororum inventa sunt.'**
  String get noSororesData;

  /// No description provided for @sisterMonastery.
  ///
  /// In la, this message translates to:
  /// **'Monasterium'**
  String get sisterMonastery;

  /// No description provided for @monasteriaOrdinisTitle.
  ///
  /// In la, this message translates to:
  /// **'Monasteria Ordinis'**
  String get monasteriaOrdinisTitle;

  /// No description provided for @entitiesCongregatioTitle.
  ///
  /// In la, this message translates to:
  /// **'Entitates / Congregatio'**
  String get entitiesCongregatioTitle;

  /// No description provided for @entitiesCongregatioSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Entitatum Principalium, Historia, et Website Publicum'**
  String get entitiesCongregatioSubtitle;

  /// No description provided for @monasteriaConventusSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Monasteriorum Sui Iuris et Domicilia Contactus'**
  String get monasteriaConventusSubtitle;

  /// No description provided for @sororesMonialTitle.
  ///
  /// In la, this message translates to:
  /// **'Sorores (Moniales)'**
  String get sororesMonialTitle;

  /// No description provided for @sororesMonialSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Sororum, Locus Nativitatis, et Dies Professionis'**
  String get sororesMonialSubtitle;

  /// No description provided for @searchParentEntity.
  ///
  /// In la, this message translates to:
  /// **'Quaere Entitatem Principalem...'**
  String get searchParentEntity;

  /// No description provided for @noMonasteriaEntitiesData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Entitatum Monasteriorum Ordinis inventa sunt.'**
  String get noMonasteriaEntitiesData;

  /// No description provided for @historiaConstitution.
  ///
  /// In la, this message translates to:
  /// **'Historia / Constitutiones Propriae:'**
  String get historiaConstitution;

  /// No description provided for @noHistoriaConstitution.
  ///
  /// In la, this message translates to:
  /// **'Nulla data historiae vel constitutionum adhuc relata sunt.'**
  String get noHistoriaConstitution;

  /// No description provided for @noMonasteriaConventusData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Monasteriorum inventa sunt.'**
  String get noMonasteriaConventusData;

  /// No description provided for @affiliation.
  ///
  /// In la, this message translates to:
  /// **'Affiliatio:'**
  String get affiliation;

  /// No description provided for @contactAndMonasteryDetail.
  ///
  /// In la, this message translates to:
  /// **'Singula Contactus et Domus Monasterii:'**
  String get contactAndMonasteryDetail;

  /// No description provided for @addressNotCompleteInDb.
  ///
  /// In la, this message translates to:
  /// **'Data domicilii in database nondum expleta sunt.'**
  String get addressNotCompleteInDb;

  /// No description provided for @sororesMembersTitle.
  ///
  /// In la, this message translates to:
  /// **'Sorores (Sodales)'**
  String get sororesMembersTitle;

  /// No description provided for @noSisterDataFound.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Sororum inventa sunt.'**
  String get noSisterDataFound;

  /// No description provided for @notDetermined.
  ///
  /// In la, this message translates to:
  /// **'Nondum constitutum'**
  String get notDetermined;

  /// No description provided for @databaseError.
  ///
  /// In la, this message translates to:
  /// **'Error database accidit'**
  String get databaseError;

  /// No description provided for @domusHeadquarters.
  ///
  /// In la, this message translates to:
  /// **'Domus / Sedes Principalis'**
  String get domusHeadquarters;

  /// No description provided for @monasteriaConventusTitle.
  ///
  /// In la, this message translates to:
  /// **'Monasteria / Conventus'**
  String get monasteriaConventusTitle;

  /// No description provided for @heremitaeDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Heremitarum'**
  String get heremitaeDirectoryTitle;

  /// No description provided for @heremitaeTitle.
  ///
  /// In la, this message translates to:
  /// **'HEREMITAE'**
  String get heremitaeTitle;

  /// No description provided for @eremitoriaTitle.
  ///
  /// In la, this message translates to:
  /// **'Eremitoria / Conventus'**
  String get eremitoriaTitle;

  /// No description provided for @eremitoriaSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Eremitoriorum et Domicilia Contactus'**
  String get eremitoriaSubtitle;

  /// No description provided for @heremitaeEntitiesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Entitatum Heremitarum, Historia, et Website Publicum'**
  String get heremitaeEntitiesSubtitle;

  /// No description provided for @heremitaeMembersSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Sodalarum, Locus Nativitatis, et Dies Professionis'**
  String get heremitaeMembersSubtitle;

  /// No description provided for @searchHeremitae.
  ///
  /// In la, this message translates to:
  /// **'Quaere Heremitas / Eremitoria...'**
  String get searchHeremitae;

  /// No description provided for @searchHeremitaeEntity.
  ///
  /// In la, this message translates to:
  /// **'Quaere Entitatem Heremitarum...'**
  String get searchHeremitaeEntity;

  /// No description provided for @noHeremitaeData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Heremitarum inventa sunt.'**
  String get noHeremitaeData;

  /// No description provided for @eremitoriumDetailTitle.
  ///
  /// In la, this message translates to:
  /// **'Singula Eremitorii'**
  String get eremitoriumDetailTitle;

  /// No description provided for @institutaDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Institutorum'**
  String get institutaDirectoryTitle;

  /// No description provided for @institutaTitle.
  ///
  /// In la, this message translates to:
  /// **'INSTITUTA'**
  String get institutaTitle;

  /// No description provided for @institutaEntitiesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Institutorum, Historia, et Website Publicum'**
  String get institutaEntitiesSubtitle;

  /// No description provided for @institutaConventusSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Domorum Institutorum et Domicilia Contactus'**
  String get institutaConventusSubtitle;

  /// No description provided for @institutaMembersSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index Sodalarum Institutorum, Locus Nativitatis, et Dies Professionis'**
  String get institutaMembersSubtitle;

  /// No description provided for @searchInstituta.
  ///
  /// In la, this message translates to:
  /// **'Quaere Instituta...'**
  String get searchInstituta;

  /// No description provided for @searchInstitutaEntity.
  ///
  /// In la, this message translates to:
  /// **'Quaere Entitatem Instituti...'**
  String get searchInstitutaEntity;

  /// No description provided for @noInstitutaData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Institutorum inventa sunt.'**
  String get noInstitutaData;

  /// No description provided for @institutaDetailTitle.
  ///
  /// In la, this message translates to:
  /// **'Singula Instituti'**
  String get institutaDetailTitle;

  /// No description provided for @statisticaTitle.
  ///
  /// In la, this message translates to:
  /// **'Statistica'**
  String get statisticaTitle;

  /// No description provided for @selectStatisticCategory.
  ///
  /// In la, this message translates to:
  /// **'Elige Categoriam Statisticae:'**
  String get selectStatisticCategory;

  /// No description provided for @statisticaFratres.
  ///
  /// In la, this message translates to:
  /// **'Statistica Fratrum'**
  String get statisticaFratres;

  /// No description provided for @statisticaFratresSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Per Provinciam / Commissariatum / Delegationem Generalem'**
  String get statisticaFratresSubtitle;

  /// No description provided for @statisticaMoniales.
  ///
  /// In la, this message translates to:
  /// **'Statistica Monialium'**
  String get statisticaMoniales;

  /// No description provided for @statisticaMonialesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Moniales in Genere'**
  String get statisticaMonialesSubtitle;

  /// No description provided for @statisticaHeremiti.
  ///
  /// In la, this message translates to:
  /// **'Statistica Heremitarum'**
  String get statisticaHeremiti;

  /// No description provided for @statisticaHeremitiSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Heremitae in Genere'**
  String get statisticaHeremitiSubtitle;

  /// No description provided for @statisticaMonasteria.
  ///
  /// In la, this message translates to:
  /// **'Statistica Monasteriorum Ordinis'**
  String get statisticaMonasteria;

  /// No description provided for @statisticaMonasteriaSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Monasteria in Genere (Sui Iuris)'**
  String get statisticaMonasteriaSubtitle;

  /// No description provided for @dataRecapitulation.
  ///
  /// In la, this message translates to:
  /// **'Recapitulatio Datorum'**
  String get dataRecapitulation;

  /// No description provided for @domusHouse.
  ///
  /// In la, this message translates to:
  /// **'Domus'**
  String get domusHouse;

  /// No description provided for @noviatus.
  ///
  /// In la, this message translates to:
  /// **'Noviatus'**
  String get noviatus;

  /// No description provided for @profTemporaneae.
  ///
  /// In la, this message translates to:
  /// **'Prof. Temporaneae'**
  String get profTemporaneae;

  /// No description provided for @solemnProfessus.
  ///
  /// In la, this message translates to:
  /// **'Solemn. Professus'**
  String get solemnProfessus;

  /// No description provided for @sacerdotalisPriest.
  ///
  /// In la, this message translates to:
  /// **'Sacerdotalis'**
  String get sacerdotalisPriest;

  /// No description provided for @listCountriesWork.
  ///
  /// In la, this message translates to:
  /// **'Index Nationum ubi Laborant:'**
  String get listCountriesWork;

  /// No description provided for @noCountriesData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data nationum in domiciliis descripta sunt.'**
  String get noCountriesData;

  /// No description provided for @ministriesDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Ministeriorum'**
  String get ministriesDirectoryTitle;

  /// No description provided for @apostolicMinistryCategories.
  ///
  /// In la, this message translates to:
  /// **'Categoriae Ministeriorum Apostolicorum'**
  String get apostolicMinistryCategories;

  /// No description provided for @parishes.
  ///
  /// In la, this message translates to:
  /// **'Paroeciae'**
  String get parishes;

  /// No description provided for @schools.
  ///
  /// In la, this message translates to:
  /// **'Scholae'**
  String get schools;

  /// No description provided for @elementarySchool.
  ///
  /// In la, this message translates to:
  /// **'Schola Elementaris'**
  String get elementarySchool;

  /// No description provided for @secondarySchool.
  ///
  /// In la, this message translates to:
  /// **'Schola Secundaria'**
  String get secondarySchool;

  /// No description provided for @academy.
  ///
  /// In la, this message translates to:
  /// **'Academia'**
  String get academy;

  /// No description provided for @universityInstitute.
  ///
  /// In la, this message translates to:
  /// **'Universitas / Institutum'**
  String get universityInstitute;

  /// No description provided for @retreatCenters.
  ///
  /// In la, this message translates to:
  /// **'Centra Exercitiorum Spiritualium'**
  String get retreatCenters;

  /// No description provided for @spiritualityInstitute.
  ///
  /// In la, this message translates to:
  /// **'Institutum Spiritualitatis'**
  String get spiritualityInstitute;

  /// No description provided for @socialMinistries.
  ///
  /// In la, this message translates to:
  /// **'Ministeria Socialia'**
  String get socialMinistries;

  /// No description provided for @libraries.
  ///
  /// In la, this message translates to:
  /// **'Bibliothecae'**
  String get libraries;

  /// No description provided for @hospitalsClinics.
  ///
  /// In la, this message translates to:
  /// **'Valetudinaria / Clinicae'**
  String get hospitalsClinics;

  /// No description provided for @allMinistriesPersonnel.
  ///
  /// In la, this message translates to:
  /// **'Omnes Personales Ministeriorum'**
  String get allMinistriesPersonnel;

  /// No description provided for @allPersonnelSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index sodalarum in omnibus institutis laborantium'**
  String get allPersonnelSubtitle;

  /// No description provided for @ministriesListTitle.
  ///
  /// In la, this message translates to:
  /// **'Index {category}'**
  String ministriesListTitle(String category);

  /// No description provided for @noDataForCategory.
  ///
  /// In la, this message translates to:
  /// **'Nulla data pro {category} praesto sunt.'**
  String noDataForCategory(String category);

  /// No description provided for @searchMinistryCategory.
  ///
  /// In la, this message translates to:
  /// **'Quaere Nomen {category}...'**
  String searchMinistryCategory(String category);

  /// No description provided for @descriptionHistoria.
  ///
  /// In la, this message translates to:
  /// **'Descriptio / Historia:'**
  String get descriptionHistoria;

  /// No description provided for @noDescriptionData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data descriptionis praesto sunt.'**
  String get noDescriptionData;

  /// No description provided for @officialMinistryAddress.
  ///
  /// In la, this message translates to:
  /// **'Domicilium Officiale Ministerii:'**
  String get officialMinistryAddress;

  /// No description provided for @personnelWorkingMembers.
  ///
  /// In la, this message translates to:
  /// **'Personales (Sodales Laborantes)'**
  String get personnelWorkingMembers;

  /// No description provided for @searchPersonnelName.
  ///
  /// In la, this message translates to:
  /// **'Quaere Nomen Personalis...'**
  String get searchPersonnelName;

  /// No description provided for @noMinistriesPersonnelData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data Personalium Ministeriorum inventa sunt.'**
  String get noMinistriesPersonnelData;

  /// No description provided for @ministryWork.
  ///
  /// In la, this message translates to:
  /// **'Ministerium:'**
  String get ministryWork;

  /// No description provided for @nonMemberDataListTitle.
  ///
  /// In la, this message translates to:
  /// **'Index Datorum Non-Sodalarum'**
  String get nonMemberDataListTitle;

  /// No description provided for @tabAddress.
  ///
  /// In la, this message translates to:
  /// **'Domicilia'**
  String get tabAddress;

  /// No description provided for @tabEntity.
  ///
  /// In la, this message translates to:
  /// **'Entitates'**
  String get tabEntity;

  /// No description provided for @tabMonastery.
  ///
  /// In la, this message translates to:
  /// **'Monasteria'**
  String get tabMonastery;

  /// No description provided for @addDataButton.
  ///
  /// In la, this message translates to:
  /// **'Adde Data'**
  String get addDataButton;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In la, this message translates to:
  /// **'Confirmatio Deletionis'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In la, this message translates to:
  /// **'Certe vis delere data \'{itemName}\'?\n\nMonitio: Data connexa etiam deleri aut relationes amittere possunt.'**
  String deleteConfirmMessage(String itemName);

  /// No description provided for @cancelButton.
  ///
  /// In la, this message translates to:
  /// **'Cancellare'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In la, this message translates to:
  /// **'Delere'**
  String get deleteButton;

  /// No description provided for @deleteSuccessMessage.
  ///
  /// In la, this message translates to:
  /// **'Data \'{itemName}\' feliciter deleta sunt.'**
  String deleteSuccessMessage(String itemName);

  /// No description provided for @deleteErrorMessage.
  ///
  /// In la, this message translates to:
  /// **'Deletio datorum defecit: {error}'**
  String deleteErrorMessage(String error);

  /// No description provided for @noAddressData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data domiciliorum adhuc relata sunt.'**
  String get noAddressData;

  /// No description provided for @noCity.
  ///
  /// In la, this message translates to:
  /// **'Sine Civitate'**
  String get noCity;

  /// No description provided for @noEntityData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data entitatum adhuc relata sunt.'**
  String get noEntityData;

  /// No description provided for @noName.
  ///
  /// In la, this message translates to:
  /// **'Sine Nomine'**
  String get noName;

  /// No description provided for @centerHeadquarters.
  ///
  /// In la, this message translates to:
  /// **'Sedes'**
  String get centerHeadquarters;

  /// No description provided for @noMonasteryData.
  ///
  /// In la, this message translates to:
  /// **'Nulla data monasteriorum adhuc relata sunt.'**
  String get noMonasteryData;

  /// No description provided for @parentInduk.
  ///
  /// In la, this message translates to:
  /// **'Mater'**
  String get parentInduk;

  /// No description provided for @location.
  ///
  /// In la, this message translates to:
  /// **'Locus'**
  String get location;

  /// No description provided for @editTooltip.
  ///
  /// In la, this message translates to:
  /// **'Recensere'**
  String get editTooltip;

  /// No description provided for @selectItemTitle.
  ///
  /// In la, this message translates to:
  /// **'Elige {judul}'**
  String selectItemTitle(String judul);

  /// No description provided for @searchItemHint.
  ///
  /// In la, this message translates to:
  /// **'Quaere {judul}...'**
  String searchItemHint(String judul);

  /// No description provided for @dataNotFound.
  ///
  /// In la, this message translates to:
  /// **'Data non inventa sunt'**
  String get dataNotFound;

  /// No description provided for @closeButton.
  ///
  /// In la, this message translates to:
  /// **'Claudere'**
  String get closeButton;

  /// No description provided for @cityCountryRequired.
  ///
  /// In la, this message translates to:
  /// **'Civitas et Patria requiruntur!'**
  String get cityCountryRequired;

  /// No description provided for @addressUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Domicilii feliciter renovata sunt!'**
  String get addressUpdateSuccess;

  /// No description provided for @addressSaveSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Domicilii feliciter servata sunt!'**
  String get addressSaveSuccess;

  /// No description provided for @categoryEntityNameRequired.
  ///
  /// In la, this message translates to:
  /// **'Categoria et Nomen Entitatis requiruntur!'**
  String get categoryEntityNameRequired;

  /// No description provided for @ministryTypeRequiredAlert.
  ///
  /// In la, this message translates to:
  /// **'Elige Typum Ministerii!'**
  String get ministryTypeRequiredAlert;

  /// No description provided for @entityUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Entitatis feliciter renovata sunt!'**
  String get entityUpdateSuccess;

  /// No description provided for @entitySaveSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Entitatis feliciter servata sunt!'**
  String get entitySaveSuccess;

  /// No description provided for @parentEntityConventusNameRequired.
  ///
  /// In la, this message translates to:
  /// **'Elige Entitatem Matrem et exple Nomen Monasterii!'**
  String get parentEntityConventusNameRequired;

  /// No description provided for @conventusUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Monasterii feliciter renovata sunt!'**
  String get conventusUpdateSuccess;

  /// No description provided for @conventusSaveSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Monasterii feliciter servata sunt!'**
  String get conventusSaveSuccess;

  /// No description provided for @editMasterData.
  ///
  /// In la, this message translates to:
  /// **'Recensere Data Principalia'**
  String get editMasterData;

  /// No description provided for @editAddressTitle.
  ///
  /// In la, this message translates to:
  /// **'Recensere Domicilium'**
  String get editAddressTitle;

  /// No description provided for @addNewAddressTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Novum Domicilium'**
  String get addNewAddressTitle;

  /// No description provided for @houseNameOptional.
  ///
  /// In la, this message translates to:
  /// **'Nomen Domus (Ad libitum)'**
  String get houseNameOptional;

  /// No description provided for @streetDetailLocation.
  ///
  /// In la, this message translates to:
  /// **'Via / Singula Loci'**
  String get streetDetailLocation;

  /// No description provided for @cityRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Civitas (Requisitum)'**
  String get cityRequiredLabel;

  /// No description provided for @countryRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Patria (Requisitum)'**
  String get countryRequiredLabel;

  /// No description provided for @officialEmail.
  ///
  /// In la, this message translates to:
  /// **'Litterae Electronicae Publicae'**
  String get officialEmail;

  /// No description provided for @updateAddressBtn.
  ///
  /// In la, this message translates to:
  /// **'RENOVARE DOMICILIUM'**
  String get updateAddressBtn;

  /// No description provided for @saveAddressBtn.
  ///
  /// In la, this message translates to:
  /// **'SERVARE DOMICILIUM'**
  String get saveAddressBtn;

  /// No description provided for @editEntityTitle.
  ///
  /// In la, this message translates to:
  /// **'Recensere Entitatem'**
  String get editEntityTitle;

  /// No description provided for @addEntityTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Entitatem'**
  String get addEntityTitle;

  /// No description provided for @entityCategoryRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Categoria Entitatis (Requisitum)'**
  String get entityCategoryRequiredLabel;

  /// No description provided for @ministryTypeRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Typus Ministerii (Requisitum)'**
  String get ministryTypeRequiredLabel;

  /// No description provided for @entityNameRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Entitatis (Requisitum)'**
  String get entityNameRequiredLabel;

  /// No description provided for @historyDescription.
  ///
  /// In la, this message translates to:
  /// **'Historia / Descriptio'**
  String get historyDescription;

  /// No description provided for @websiteLink.
  ///
  /// In la, this message translates to:
  /// **'Vinculum Website'**
  String get websiteLink;

  /// No description provided for @selectHeadquartersAddress.
  ///
  /// In la, this message translates to:
  /// **'Elige Domicilium Sedis (Ad libitum)'**
  String get selectHeadquartersAddress;

  /// No description provided for @updateEntityBtn.
  ///
  /// In la, this message translates to:
  /// **'RENOVARE ENTITATEM'**
  String get updateEntityBtn;

  /// No description provided for @saveEntityBtn.
  ///
  /// In la, this message translates to:
  /// **'SERVARE ENTITATEM'**
  String get saveEntityBtn;

  /// No description provided for @editConventusTitle.
  ///
  /// In la, this message translates to:
  /// **'Recensere Monasterium / Communitatem'**
  String get editConventusTitle;

  /// No description provided for @addConventusTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Monasterium / Communitatem'**
  String get addConventusTitle;

  /// No description provided for @parentEntityRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Entitas Mater / Provincia (Requisitum)'**
  String get parentEntityRequiredLabel;

  /// No description provided for @conventusNameRequiredLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Monasterii (Requisitum)'**
  String get conventusNameRequiredLabel;

  /// No description provided for @selectConventusAddress.
  ///
  /// In la, this message translates to:
  /// **'Elige Domicilium Monasterii (Ad libitum)'**
  String get selectConventusAddress;

  /// No description provided for @updateConventusBtn.
  ///
  /// In la, this message translates to:
  /// **'RENOVARE MONASTERIUM'**
  String get updateConventusBtn;

  /// No description provided for @saveConventusBtn.
  ///
  /// In la, this message translates to:
  /// **'SERVARE MONASTERIUM'**
  String get saveConventusBtn;

  /// No description provided for @memberListTitle.
  ///
  /// In la, this message translates to:
  /// **'Index Sodalium'**
  String get memberListTitle;

  /// No description provided for @deleteMemberConfirmTitle.
  ///
  /// In la, this message translates to:
  /// **'Confirmatio Deletionis Sodalis'**
  String get deleteMemberConfirmTitle;

  /// No description provided for @deleteMemberConfirmMsg.
  ///
  /// In la, this message translates to:
  /// **'Certe vis delere data sodalis \'{nama}\'?'**
  String deleteMemberConfirmMsg(String nama);

  /// No description provided for @deleteMemberSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data \'{nama}\' feliciter deleta sunt.'**
  String deleteMemberSuccess(String nama);

  /// No description provided for @deleteMemberError.
  ///
  /// In la, this message translates to:
  /// **'Deletio defecit: {error}'**
  String deleteMemberError(String error);

  /// No description provided for @noMemberDataAdded.
  ///
  /// In la, this message translates to:
  /// **'Nulla data sodalarum adhuc relata sunt.'**
  String get noMemberDataAdded;

  /// No description provided for @originPrefix.
  ///
  /// In la, this message translates to:
  /// **'Origo'**
  String get originPrefix;

  /// No description provided for @bornPrefix.
  ///
  /// In la, this message translates to:
  /// **'Natus/a'**
  String get bornPrefix;

  /// No description provided for @editDataTooltip.
  ///
  /// In la, this message translates to:
  /// **'Recensere Data'**
  String get editDataTooltip;

  /// No description provided for @deleteDataTooltip.
  ///
  /// In la, this message translates to:
  /// **'Delere Data'**
  String get deleteDataTooltip;

  /// No description provided for @addMemberBtn.
  ///
  /// In la, this message translates to:
  /// **'Adde Sodalem'**
  String get addMemberBtn;

  /// No description provided for @goToEditPageMsg.
  ///
  /// In la, this message translates to:
  /// **'I ad paginam recensionis'**
  String get goToEditPageMsg;

  /// No description provided for @addMemberPageTitle.
  ///
  /// In la, this message translates to:
  /// **'Registratio Novi Sodalis'**
  String get addMemberPageTitle;

  /// No description provided for @editMemberPageTitle.
  ///
  /// In la, this message translates to:
  /// **'Recensere Data Sodalis'**
  String get editMemberPageTitle;

  /// No description provided for @fetchEntityFailed.
  ///
  /// In la, this message translates to:
  /// **'Adfectio datorum entitatis defecit: {error}'**
  String fetchEntityFailed(String error);

  /// No description provided for @fetchConventusFailed.
  ///
  /// In la, this message translates to:
  /// **'Adfectio datorum monasterii defecit: {error}'**
  String fetchConventusFailed(String error);

  /// No description provided for @pickImageFailed.
  ///
  /// In la, this message translates to:
  /// **'Electio imaginis defecit: {error}'**
  String pickImageFailed(String error);

  /// No description provided for @selectDatePrompt.
  ///
  /// In la, this message translates to:
  /// **'Elige Diem'**
  String get selectDatePrompt;

  /// No description provided for @mandatoryFieldsEmpty.
  ///
  /// In la, this message translates to:
  /// **'Nomen, Status, et Entitas expleri debent!'**
  String get mandatoryFieldsEmpty;

  /// No description provided for @memberUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Sodalis feliciter renovata sunt!'**
  String get memberUpdateSuccess;

  /// No description provided for @memberAddSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Sodalis feliciter addita sunt!'**
  String get memberAddSuccess;

  /// No description provided for @processingData.
  ///
  /// In la, this message translates to:
  /// **'Data procedunt...'**
  String get processingData;

  /// No description provided for @loadingMemberData.
  ///
  /// In la, this message translates to:
  /// **'Data sodalis onerantur...'**
  String get loadingMemberData;

  /// No description provided for @saveChangesBtn.
  ///
  /// In la, this message translates to:
  /// **'Servare Mutationes'**
  String get saveChangesBtn;

  /// No description provided for @saveDataBtn.
  ///
  /// In la, this message translates to:
  /// **'Servare Data'**
  String get saveDataBtn;

  /// No description provided for @nextBtn.
  ///
  /// In la, this message translates to:
  /// **'Continuare'**
  String get nextBtn;

  /// No description provided for @backBtn.
  ///
  /// In la, this message translates to:
  /// **'Regredi'**
  String get backBtn;

  /// No description provided for @step1Title.
  ///
  /// In la, this message translates to:
  /// **'Biographia Personalis'**
  String get step1Title;

  /// No description provided for @changePhotoPrompt.
  ///
  /// In la, this message translates to:
  /// **'Tange iconem ut imaginem mutes'**
  String get changePhotoPrompt;

  /// No description provided for @fullNameLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Integrum'**
  String get fullNameLabel;

  /// No description provided for @birthCityLabel.
  ///
  /// In la, this message translates to:
  /// **'Urbs Nativitatis'**
  String get birthCityLabel;

  /// No description provided for @birthCountryLabel.
  ///
  /// In la, this message translates to:
  /// **'Patria'**
  String get birthCountryLabel;

  /// No description provided for @birthDateLabel.
  ///
  /// In la, this message translates to:
  /// **'Dies Nativitatis'**
  String get birthDateLabel;

  /// No description provided for @step2Title.
  ///
  /// In la, this message translates to:
  /// **'Status et Dies Vocationis'**
  String get step2Title;

  /// No description provided for @vocationStatusLabel.
  ///
  /// In la, this message translates to:
  /// **'Status Vocationis (Requisitum)'**
  String get vocationStatusLabel;

  /// No description provided for @firstProfessionDateLabel.
  ///
  /// In la, this message translates to:
  /// **'Dies Professionis Primae'**
  String get firstProfessionDateLabel;

  /// No description provided for @solemnProfessionDateLabel.
  ///
  /// In la, this message translates to:
  /// **'Dies Professionis Sollemnis'**
  String get solemnProfessionDateLabel;

  /// No description provided for @ordinationDateLabel.
  ///
  /// In la, this message translates to:
  /// **'Dies Ordinationis'**
  String get ordinationDateLabel;

  /// No description provided for @step3Title.
  ///
  /// In la, this message translates to:
  /// **'Assignatio Loci'**
  String get step3Title;

  /// No description provided for @entityProvinceLabel.
  ///
  /// In la, this message translates to:
  /// **'Entitas / Provincia (Requisitum)'**
  String get entityProvinceLabel;

  /// No description provided for @conventusCommunityLabel.
  ///
  /// In la, this message translates to:
  /// **'Monasterium / Communitas (Ad libitum)'**
  String get conventusCommunityLabel;

  /// No description provided for @personalRoleLabel.
  ///
  /// In la, this message translates to:
  /// **'Partes Personales'**
  String get personalRoleLabel;

  /// No description provided for @roleHint.
  ///
  /// In la, this message translates to:
  /// **'Exemplum: Sodales, Prior, etc.'**
  String get roleHint;

  /// No description provided for @manageCuriaTitle.
  ///
  /// In la, this message translates to:
  /// **'Administrare Curiam et Sub Immediata'**
  String get manageCuriaTitle;

  /// No description provided for @jabatanUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Officium \'{title}\' feliciter renovatum est!'**
  String jabatanUpdateSuccess(String title);

  /// No description provided for @jabatanEmptySuccess.
  ///
  /// In la, this message translates to:
  /// **'Officium \'{title}\' feliciter vacuatum est.'**
  String jabatanEmptySuccess(String title);

  /// No description provided for @failedToUpdate.
  ///
  /// In la, this message translates to:
  /// **'Defecit: {error}'**
  String failedToUpdate(String error);

  /// No description provided for @failedToEmpty.
  ///
  /// In la, this message translates to:
  /// **'Vacuatio defecit: {error}'**
  String failedToEmpty(String error);

  /// No description provided for @selectOrChangeBtn.
  ///
  /// In la, this message translates to:
  /// **'Elige / Muta'**
  String get selectOrChangeBtn;

  /// No description provided for @searchAndSelectMemberTitle.
  ///
  /// In la, this message translates to:
  /// **'Quaere et Elige Sodalem'**
  String get searchAndSelectMemberTitle;

  /// No description provided for @typeMemberNameHint.
  ///
  /// In la, this message translates to:
  /// **'Scribe Nomen Sodalis...'**
  String get typeMemberNameHint;

  /// No description provided for @episcopiListTitle.
  ///
  /// In la, this message translates to:
  /// **'Index Episcoporum'**
  String get episcopiListTitle;

  /// No description provided for @deleteEpiscopusConfirmTitle.
  ///
  /// In la, this message translates to:
  /// **'Confirmatio Deletionis Episcopi'**
  String get deleteEpiscopusConfirmTitle;

  /// No description provided for @deleteEpiscopusConfirmMsg.
  ///
  /// In la, this message translates to:
  /// **'Certe vis delere data episcopi \'{nama}\'?'**
  String deleteEpiscopusConfirmMsg(String nama);

  /// No description provided for @deleteEpiscopusSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data \'{nama}\' feliciter deleta sunt.'**
  String deleteEpiscopusSuccess(String nama);

  /// No description provided for @noEpiscopusDataAdded.
  ///
  /// In la, this message translates to:
  /// **'Nulla data episcoporum adhuc relata sunt.'**
  String get noEpiscopusDataAdded;

  /// No description provided for @addEpiscopusBtn.
  ///
  /// In la, this message translates to:
  /// **'Adde Episcopum'**
  String get addEpiscopusBtn;

  /// No description provided for @episcopusTitle.
  ///
  /// In la, this message translates to:
  /// **'Episcopus'**
  String get episcopusTitle;

  /// No description provided for @addEpiscopusPageTitle.
  ///
  /// In la, this message translates to:
  /// **'Registratio Novi Episcopi'**
  String get addEpiscopusPageTitle;

  /// No description provided for @editEpiscopusPageTitle.
  ///
  /// In la, this message translates to:
  /// **'Recensere Data Episcopi'**
  String get editEpiscopusPageTitle;

  /// No description provided for @episcopusNameLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Episcopi'**
  String get episcopusNameLabel;

  /// No description provided for @dioceseLabel.
  ///
  /// In la, this message translates to:
  /// **'Dioecesis'**
  String get dioceseLabel;

  /// No description provided for @episcopusUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Episcopi feliciter renovata sunt!'**
  String get episcopusUpdateSuccess;

  /// No description provided for @episcopusAddSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data Episcopi feliciter addita sunt!'**
  String get episcopusAddSuccess;

  /// No description provided for @saveEpiscopusBtn.
  ///
  /// In la, this message translates to:
  /// **'Servare Episcopum'**
  String get saveEpiscopusBtn;

  /// No description provided for @updateEpiscopusBtn.
  ///
  /// In la, this message translates to:
  /// **'Renovare Episcopum'**
  String get updateEpiscopusBtn;

  /// No description provided for @errorSavingEpiscopus.
  ///
  /// In la, this message translates to:
  /// **'Error servando data episcopi: {error}'**
  String errorSavingEpiscopus(String error);

  /// No description provided for @manageCitocNewsTitle.
  ///
  /// In la, this message translates to:
  /// **'Administrare Nuntios CITOC'**
  String get manageCitocNewsTitle;

  /// No description provided for @deleteNewsTitle.
  ///
  /// In la, this message translates to:
  /// **'Delere Nuntium'**
  String get deleteNewsTitle;

  /// No description provided for @deleteNewsConfirmMsg.
  ///
  /// In la, this message translates to:
  /// **'Certe vis delere hoc vinculum nuntii?'**
  String get deleteNewsConfirmMsg;

  /// No description provided for @newsDeletedSuccess.
  ///
  /// In la, this message translates to:
  /// **'Nuntius deletus est.'**
  String get newsDeletedSuccess;

  /// No description provided for @noCitocNewsYet.
  ///
  /// In la, this message translates to:
  /// **'Nulli nuntii CITOC adhuc sunt.'**
  String get noCitocNewsYet;

  /// No description provided for @noTitle.
  ///
  /// In la, this message translates to:
  /// **'Sine Titulo'**
  String get noTitle;

  /// No description provided for @addNewsBtn.
  ///
  /// In la, this message translates to:
  /// **'Adde Nuntium'**
  String get addNewsBtn;

  /// No description provided for @titleAndUrlRequired.
  ///
  /// In la, this message translates to:
  /// **'Titulus et Vinculum Web (URL) requiruntur!'**
  String get titleAndUrlRequired;

  /// No description provided for @newsUpdateSuccess.
  ///
  /// In la, this message translates to:
  /// **'Nuntius feliciter renovatus est!'**
  String get newsUpdateSuccess;

  /// No description provided for @newsAddSuccess.
  ///
  /// In la, this message translates to:
  /// **'Nuntius feliciter additus est!'**
  String get newsAddSuccess;

  /// No description provided for @editCitocNewsTitle.
  ///
  /// In la, this message translates to:
  /// **'Recensere Nuntium CITOC'**
  String get editCitocNewsTitle;

  /// No description provided for @addNewNewsTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Novum Nuntium'**
  String get addNewNewsTitle;

  /// No description provided for @newsTitleLabel.
  ///
  /// In la, this message translates to:
  /// **'Titulus Nuntii'**
  String get newsTitleLabel;

  /// No description provided for @webLinkLabel.
  ///
  /// In la, this message translates to:
  /// **'Vinculum Web (URL)'**
  String get webLinkLabel;

  /// No description provided for @webLinkHint.
  ///
  /// In la, this message translates to:
  /// **'Exemplum: https://ocarm.org/news'**
  String get webLinkHint;

  /// No description provided for @saveNewsBtn.
  ///
  /// In la, this message translates to:
  /// **'SERVARE NUNTIUM'**
  String get saveNewsBtn;

  /// No description provided for @operationFailed.
  ///
  /// In la, this message translates to:
  /// **'Operatio defecit: {error}'**
  String operationFailed(String error);

  /// No description provided for @manageCommissionTitle.
  ///
  /// In la, this message translates to:
  /// **'Administrare Commissiones Generales'**
  String get manageCommissionTitle;

  /// No description provided for @noCommissionsRegistered.
  ///
  /// In la, this message translates to:
  /// **'Nullae commissiones descriptae sunt.'**
  String get noCommissionsRegistered;

  /// No description provided for @deleteCommissionConfirmMsg.
  ///
  /// In la, this message translates to:
  /// **'Certe vis delere \'{name}\'? Omnia data sodalarum in hac commissione etiam delebuntur.'**
  String deleteCommissionConfirmMsg(String name);

  /// No description provided for @commissionDeletedSuccess.
  ///
  /// In la, this message translates to:
  /// **'Commissio feliciter deleta est.'**
  String get commissionDeletedSuccess;

  /// No description provided for @failedToDeleteCommission.
  ///
  /// In la, this message translates to:
  /// **'Deletio defecit: {error}'**
  String failedToDeleteCommission(String error);

  /// No description provided for @manageMembersTooltip.
  ///
  /// In la, this message translates to:
  /// **'Administrare Sodales'**
  String get manageMembersTooltip;

  /// No description provided for @deleteCommissionTooltip.
  ///
  /// In la, this message translates to:
  /// **'Delere Commissionem'**
  String get deleteCommissionTooltip;

  /// No description provided for @addCommissionBtn.
  ///
  /// In la, this message translates to:
  /// **'Adde Commissionem'**
  String get addCommissionBtn;

  /// No description provided for @addNewCommissionTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Novam Commissionem'**
  String get addNewCommissionTitle;

  /// No description provided for @fillDataAndSelectPraesesWarning.
  ///
  /// In la, this message translates to:
  /// **'Quaeso, exple data et elige Praesidem!'**
  String get fillDataAndSelectPraesesWarning;

  /// No description provided for @commissionNameLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Commissionis (Requisitum)'**
  String get commissionNameLabel;

  /// No description provided for @commissionNameRequired.
  ///
  /// In la, this message translates to:
  /// **'Nomen commissionis expleri debet'**
  String get commissionNameRequired;

  /// No description provided for @missionApostolateTaskLabel.
  ///
  /// In la, this message translates to:
  /// **'Missio / Munus Apostolicum'**
  String get missionApostolateTaskLabel;

  /// No description provided for @selectPraesesPresidentLabel.
  ///
  /// In la, this message translates to:
  /// **'Elige Praesidem'**
  String get selectPraesesPresidentLabel;

  /// No description provided for @saveCommissionBtn.
  ///
  /// In la, this message translates to:
  /// **'SERVARE COMMISSIONEM'**
  String get saveCommissionBtn;

  /// No description provided for @commissionMembersTitle.
  ///
  /// In la, this message translates to:
  /// **'Sodales: {name}'**
  String commissionMembersTitle(String name);

  /// No description provided for @addCommissionMemberPanelTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Sodalem Commissionis'**
  String get addCommissionMemberPanelTitle;

  /// No description provided for @selectMemberNameLabel.
  ///
  /// In la, this message translates to:
  /// **'Elige Nomen Sodalis'**
  String get selectMemberNameLabel;

  /// No description provided for @positionInCommissionLabel.
  ///
  /// In la, this message translates to:
  /// **'Officium in Commissione'**
  String get positionInCommissionLabel;

  /// No description provided for @addToCommissionBtn.
  ///
  /// In la, this message translates to:
  /// **'Adde ad Commissionem'**
  String get addToCommissionBtn;

  /// No description provided for @memberAddedToCommissionSuccess.
  ///
  /// In la, this message translates to:
  /// **'Sodalis feliciter commissioni additus est'**
  String get memberAddedToCommissionSuccess;

  /// No description provided for @memberAlreadyRegisteredOrError.
  ///
  /// In la, this message translates to:
  /// **'Iam descriptus / Error: {error}'**
  String memberAlreadyRegisteredOrError(String error);

  /// No description provided for @noAdditionalMembersInCommission.
  ///
  /// In la, this message translates to:
  /// **'Haec commissio sodales addititios nondum habet.'**
  String get noAdditionalMembersInCommission;

  /// No description provided for @unknownName.
  ///
  /// In la, this message translates to:
  /// **'Ignotum'**
  String get unknownName;

  /// No description provided for @positionPrefix.
  ///
  /// In la, this message translates to:
  /// **'Officium'**
  String get positionPrefix;

  /// No description provided for @manageAdminTitle.
  ///
  /// In la, this message translates to:
  /// **'Administrare Aditus'**
  String get manageAdminTitle;

  /// No description provided for @adminListTitle.
  ///
  /// In la, this message translates to:
  /// **'Index Administratorum'**
  String get adminListTitle;

  /// No description provided for @addAdminPageTitle.
  ///
  /// In la, this message translates to:
  /// **'Adde Novum Administratorem'**
  String get addAdminPageTitle;

  /// No description provided for @adminNameLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen Administratoris'**
  String get adminNameLabel;

  /// No description provided for @saveAdminBtn.
  ///
  /// In la, this message translates to:
  /// **'SERVARE ADMINISTRATOREM'**
  String get saveAdminBtn;

  /// No description provided for @adminAddSuccess.
  ///
  /// In la, this message translates to:
  /// **'Administrator feliciter additus est!'**
  String get adminAddSuccess;

  /// No description provided for @deleteAdminConfirm.
  ///
  /// In la, this message translates to:
  /// **'Certe vis delere hunc administratorem?'**
  String get deleteAdminConfirm;

  /// No description provided for @adminDeleted.
  ///
  /// In la, this message translates to:
  /// **'Administrator deletus est.'**
  String get adminDeleted;

  /// No description provided for @appTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Ordinis Carmelitarum'**
  String get appTitle;

  /// No description provided for @mainDirectoryTitle.
  ///
  /// In la, this message translates to:
  /// **'Directorium Principale Ordinis Carmelitarum'**
  String get mainDirectoryTitle;

  /// No description provided for @curiaGeneralisSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Consilium, officia, et commissiones'**
  String get curiaGeneralisSubtitle;

  /// No description provided for @episcopiExOrdinesTitle.
  ///
  /// In la, this message translates to:
  /// **'Episcopi Ex Ordine Assumpti'**
  String get episcopiExOrdinesTitle;

  /// No description provided for @episcopiSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index episcoporum ex Ordine Carmelitarum'**
  String get episcopiSubtitle;

  /// No description provided for @subJurisdictioneTitle.
  ///
  /// In la, this message translates to:
  /// **'Sub Immediata Jurisdictione'**
  String get subJurisdictioneTitle;

  /// No description provided for @subJurisdictioneSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Delegatio, CISA, Domus S. Alberti'**
  String get subJurisdictioneSubtitle;

  /// No description provided for @citocTitle.
  ///
  /// In la, this message translates to:
  /// **'CITOC'**
  String get citocTitle;

  /// No description provided for @citocSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Nuntii et informatorum Carmelitanum'**
  String get citocSubtitle;

  /// No description provided for @fratresTitle.
  ///
  /// In la, this message translates to:
  /// **'Fratres'**
  String get fratresTitle;

  /// No description provided for @fratresSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Provinciae, commissariatus, et delegationes'**
  String get fratresSubtitle;

  /// No description provided for @heremitiSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Heremitae Carmelitae (sacerdotes et sorores)'**
  String get heremitiSubtitle;

  /// No description provided for @monialesTitle.
  ///
  /// In la, this message translates to:
  /// **'Moniales'**
  String get monialesTitle;

  /// No description provided for @monialesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Moniales contemplativae Carmelitae'**
  String get monialesSubtitle;

  /// No description provided for @monasteriaOrdinisSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Monasteria sui iuris / propriis utuntur'**
  String get monasteriaOrdinisSubtitle;

  /// No description provided for @heremitaeSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Heremitae Carmelitae separati'**
  String get heremitaeSubtitle;

  /// No description provided for @institutaSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Instituta saecularia affiliata'**
  String get institutaSubtitle;

  /// No description provided for @ministriesTitle.
  ///
  /// In la, this message translates to:
  /// **'Ministeria'**
  String get ministriesTitle;

  /// No description provided for @ministriesSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Paroeciae, scholae, domus exercitiorum, etc.'**
  String get ministriesSubtitle;

  /// No description provided for @statisticaSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Data statistica et distributio nationum'**
  String get statisticaSubtitle;

  /// No description provided for @adminSubtitle.
  ///
  /// In la, this message translates to:
  /// **'Index et iura accessus administratorum'**
  String get adminSubtitle;

  /// No description provided for @faxNumber.
  ///
  /// In la, this message translates to:
  /// **'Numerus Fax'**
  String get faxNumber;

  /// No description provided for @usernameLabel.
  ///
  /// In la, this message translates to:
  /// **'Nomen utentis'**
  String get usernameLabel;

  /// No description provided for @selectEntityFirstPrompt.
  ///
  /// In la, this message translates to:
  /// **'Elige Entitatem/Provinciam prius!'**
  String get selectEntityFirstPrompt;

  /// No description provided for @searchMemberHint.
  ///
  /// In la, this message translates to:
  /// **'Quaere nomen, munus, vel statum...'**
  String get searchMemberHint;

  /// No description provided for @editBtn.
  ///
  /// In la, this message translates to:
  /// **'Recensere'**
  String get editBtn;

  /// No description provided for @deleteBtn.
  ///
  /// In la, this message translates to:
  /// **'Delere'**
  String get deleteBtn;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In la, this message translates to:
  /// **'Confirmatio Deletionis'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMemberMsg.
  ///
  /// In la, this message translates to:
  /// **'Esne certus te velle hanc datam sodalis delere?'**
  String get confirmDeleteMemberMsg;

  /// No description provided for @cancelBtn.
  ///
  /// In la, this message translates to:
  /// **'Rescindere'**
  String get cancelBtn;

  /// No description provided for @memberDeleteSuccess.
  ///
  /// In la, this message translates to:
  /// **'Data sodalis feliciter deleta est!'**
  String get memberDeleteSuccess;
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
