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
  /// **'HEREMITI'**
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
