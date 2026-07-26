// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appInfoTitle => 'App Information';

  @override
  String get appName => 'CARMELITE ORDER APPLICATION';

  @override
  String get headquarters => 'Headquarters';

  @override
  String get headquartersAddress =>
      'Curia Generalitia\nVia di San Martino ai Monti, 8\n00184 Rome, Italy';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactDetails => 'Email: info@ocarm.org\nPhone: +39 06 4620181';

  @override
  String get continueToLogin => 'Continue to Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameEmailLabel => 'Username / Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginAsMember => 'Login as Member';

  @override
  String get loginAsAdmin => 'Login as Admin';

  @override
  String get userProfileTitle => 'User Profile';

  @override
  String get studentRole => 'Student';

  @override
  String get welcomeMessage => 'Welcome, Abraham';

  @override
  String get universityStudent => 'University Student';

  @override
  String get drawerInstruction =>
      'Tap the three lines in the top left corner to view the Carmelite Order directory.';

  @override
  String openingMenu(String title) {
    return 'Opening: $title';
  }

  @override
  String get logout => 'Logout';

  @override
  String get adminDashboardTitle => 'Admin Dashboard';

  @override
  String get directoryManagementMenu => 'Directory Management Menu';

  @override
  String get manageMasterData => 'Manage Master Data';

  @override
  String get masterDataSubtitle => 'Addresses, Entities, and Monasteries';

  @override
  String get manageMemberData => 'Manage Member Data';

  @override
  String get memberDataSubtitle => 'Add, Edit, and Delete Personnel';

  @override
  String get manageCentralOfficials => 'Manage Central Officials & Curia';

  @override
  String get centralOfficialsSubtitle =>
      'Appoint officials of the Curia Generalis & Sub Immediata';

  @override
  String get manageBishopData => 'Manage Bishop Data';

  @override
  String get bishopDataSubtitle =>
      'Manage the list of Episcopi Ex Ordines Assumpti';

  @override
  String get manageCitocNews => 'Manage CITOC News';

  @override
  String get citocNewsSubtitle => 'Add latest news links';

  @override
  String get manageGeneralCommissions => 'Manage General Commissions';

  @override
  String get generalCommissionsSubtitle =>
      'Organize commission divisions and their members';
}
