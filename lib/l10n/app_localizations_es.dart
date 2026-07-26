// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'App Orden Carmelita';

  @override
  String get loginTitle => 'Usuario / Correo electrónico';

  @override
  String get passwordTitle => 'Contraseña';

  @override
  String get loginMemberButton => 'Iniciar sesión como Miembro';

  @override
  String get loginAdminButton => 'Iniciar sesión como Administrador';

  @override
  String get selectLanguage => 'Seleccionar Idioma';
}
