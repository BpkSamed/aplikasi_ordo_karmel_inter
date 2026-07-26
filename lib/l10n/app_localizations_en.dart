// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Carmelite Order App';

  @override
  String get infoAppTitle => 'App Information';

  @override
  String get infoMainTitle => 'CARMELITE ORDER APPLICATION';

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
  String get btnContinueLogin => 'Continue to Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get welcomeText => 'Welcome';

  @override
  String get labelUsername => 'Username / Email';

  @override
  String get labelPassword => 'Password';

  @override
  String get btnLoginMember => 'Login as Member';

  @override
  String get btnLoginAdmin => 'Login as Admin';

  @override
  String get profileTitle => 'User Profile';

  @override
  String get welcomeMember => 'Welcome, Abraham';

  @override
  String get studentSubtitle => 'University Student';

  @override
  String get drawerInstruction =>
      'Click the menu icon at the top left to view the Carmelite directory.';

  @override
  String get logout => 'Logout';

  @override
  String get adminDashboardTitle => 'Admin Dashboard';

  @override
  String get adminMenuTitle => 'Directory Management Menu';

  @override
  String get menuMasterData => 'Manage Master Data';

  @override
  String get subMasterData => 'Addresses, Entities, and Monasteries';

  @override
  String get menuMemberData => 'Manage Member Data';

  @override
  String get subMemberData => 'Add, Edit, and Delete Personnel';

  @override
  String get menuCentralOfficers => 'Manage Central Officials';

  @override
  String get subCentralOfficers =>
      'Assign Officials for Curia Generalis & Sub Immediata';

  @override
  String get menuBishopsData => 'Manage Bishops Data';

  @override
  String get subBishopsData => 'Manage Bishops Ex Ordines Assumpti list';

  @override
  String get menuCitocNews => 'Manage CITOC News';

  @override
  String get subCitocNews => 'Add latest news links';

  @override
  String get menuCommissions => 'Manage General Commissions';

  @override
  String get subCommissions => 'Organize commission divisions and members';
}
