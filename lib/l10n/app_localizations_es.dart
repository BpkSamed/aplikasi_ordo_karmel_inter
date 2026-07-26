// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appInfoTitle => 'Información de la App';

  @override
  String get appName => 'APLICACIÓN ORDEN CARMELITA';

  @override
  String get headquarters => 'Sede Central';

  @override
  String get headquartersAddress =>
      'Curia Generalizia\nVia di San Martino ai Monti, 8\n00184 Roma, Italia';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get contactDetails => 'Email: info@ocarm.org\nTel: +39 06 4620181';

  @override
  String get continueToLogin => 'Continuar al Login';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get usernameEmailLabel => 'Usuario / Correo';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginAsMember => 'Ingresar como Miembro';

  @override
  String get loginAsAdmin => 'Ingresar como Administrador';

  @override
  String get userProfileTitle => 'Perfil de Usuario';

  @override
  String get studentRole => 'Estudiante';

  @override
  String get welcomeMessage => 'Bienvenido, Abraham';

  @override
  String get universityStudent => 'Estudiante Universitario';

  @override
  String get drawerInstruction =>
      'Toca las tres líneas en la esquina superior izquierda para ver el directorio de la Orden Carmelita.';

  @override
  String openingMenu(String title) {
    return 'Abriendo: $title';
  }

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get adminDashboardTitle => 'Panel de Administrador';

  @override
  String get directoryManagementMenu => 'Menú de Gestión de Directorio';

  @override
  String get manageMasterData => 'Gestionar Datos Maestros';

  @override
  String get masterDataSubtitle => 'Direcciones, Entidades y Monasterios';

  @override
  String get manageMemberData => 'Gestionar Datos de Miembros';

  @override
  String get memberDataSubtitle => 'Añadir, Editar y Eliminar Personal';

  @override
  String get manageCentralOfficials => 'Gestionar Oficiales Centrales y Curia';

  @override
  String get centralOfficialsSubtitle =>
      'Designar oficiales de la Curia Generalis y Sub Immediata';

  @override
  String get manageBishopData => 'Gestionar Datos de Obispos';

  @override
  String get bishopDataSubtitle =>
      'Gestionar la lista de Episcopi Ex Ordines Assumpti';

  @override
  String get manageCitocNews => 'Gestionar Noticias CITOC';

  @override
  String get citocNewsSubtitle => 'Añadir enlaces de noticias recientes';

  @override
  String get manageGeneralCommissions => 'Gestionar Comisiones Generales';

  @override
  String get generalCommissionsSubtitle =>
      'Organizar las divisiones de comisiones y sus miembros';
}
