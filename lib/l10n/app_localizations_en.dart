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
  String get loginTitle => 'Username / Email';

  @override
  String get passwordTitle => 'Password';

  @override
  String get loginMemberButton => 'Login as Member';

  @override
  String get loginAdminButton => 'Login as Admin';

  @override
  String get selectLanguage => 'Select Language';
}
