// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latin (`la`).
class AppLocalizationsLa extends AppLocalizations {
  AppLocalizationsLa([String locale = 'la']) : super(locale);

  @override
  String get appInfoTitle => 'Informatio Applicationis';

  @override
  String get appName => 'APPLICATIO ORDINIS CARMELITARUM';

  @override
  String get headquarters => 'Sedes Principalis';

  @override
  String get headquartersAddress =>
      'Curia Generalitia\nVia di San Martino ai Monti, 8\n00184 Roma, Italia';

  @override
  String get contactUs => 'Contactus';

  @override
  String get contactDetails => 'Email: info@ocarm.org\nTel: +39 06 4620181';

  @override
  String get continueToLogin => 'Perge ad Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameEmailLabel => 'Nomen Usoris / Email';

  @override
  String get passwordLabel => 'Tessera';

  @override
  String get loginAsMember => 'Login ut Sodalis';

  @override
  String get loginAsAdmin => 'Login ut Administrator';

  @override
  String get userProfileTitle => 'Profilum Usoris';

  @override
  String get studentRole => 'Discipulus';

  @override
  String get welcomeMessage => 'Salve, Abraham';

  @override
  String get universityStudent => 'Discipulus Universitatis';

  @override
  String get drawerInstruction =>
      'Preme tres lineas in angulo superiore sinistro ad videndum directorium Ordinis Carmelitarum.';

  @override
  String openingMenu(String title) {
    return 'Aperiens: $title';
  }

  @override
  String get logout => 'Exire';

  @override
  String get adminDashboardTitle => 'Tabula Administratoris';

  @override
  String get directoryManagementMenu => 'Menu Administrationis Directorii';

  @override
  String get manageMasterData => 'Administrare Data Principalia';

  @override
  String get masterDataSubtitle => 'Inscriptiones, Entitates et Monasteria';

  @override
  String get manageMemberData => 'Administrare Data Sodalium';

  @override
  String get memberDataSubtitle => 'Adde, Recense, et Dele Personalia';

  @override
  String get manageCentralOfficials =>
      'Administrare Officiales Centrales & Curiam';

  @override
  String get centralOfficialsSubtitle =>
      'Designa officiales Curiae Generalis & Sub Immediata';

  @override
  String get manageBishopData => 'Administrare Data Episcoporum';

  @override
  String get bishopDataSubtitle =>
      'Administrare indicem Episcoporum Ex Ordine Assumptorum';

  @override
  String get manageCitocNews => 'Administrare Nuntios CITOC';

  @override
  String get citocNewsSubtitle => 'Adde vincula nuntiorum recentium';

  @override
  String get manageGeneralCommissions => 'Administrare Commissiones Generales';

  @override
  String get generalCommissionsSubtitle =>
      'Guberna divisiones commissionum et sodales earum';
}
