// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appInfoTitle => 'Informazioni sull\'App';

  @override
  String get appName => 'APPLICAZIONE ORDINE CARMELITANO';

  @override
  String get headquarters => 'Sede Centrale';

  @override
  String get headquartersAddress =>
      'Curia Generalizia\nVia di San Martino ai Monti, 8\n00184 Roma, Italia';

  @override
  String get contactUs => 'Contattaci';

  @override
  String get contactDetails => 'Email: info@ocarm.org\nTel: +39 06 4620181';

  @override
  String get continueToLogin => 'Continua al Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameEmailLabel => 'Nome utente / Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginAsMember => 'Accedi come Membro';

  @override
  String get loginAsAdmin => 'Accedi come Amministratore';

  @override
  String get userProfileTitle => 'Profilo Utente';

  @override
  String get studentRole => 'Studente';

  @override
  String get welcomeMessage => 'Benvenuto, Abraham';

  @override
  String get universityStudent => 'Studente Universitario';

  @override
  String get drawerInstruction =>
      'Tocca le tre linee in alto a sinistra per visualizzare la directory dell\'Ordine Carmelitano.';

  @override
  String openingMenu(String title) {
    return 'Apertura: $title';
  }

  @override
  String get logout => 'Esci';

  @override
  String get adminDashboardTitle => 'Dashboard Amministratore';

  @override
  String get directoryManagementMenu => 'Menu Gestione Directory';

  @override
  String get manageMasterData => 'Gestisci Dati Anagrafici';

  @override
  String get masterDataSubtitle => 'Indirizzi, Entità e Monasteri';

  @override
  String get manageMemberData => 'Gestisci Dati Membri';

  @override
  String get memberDataSubtitle => 'Aggiungi, Modifica ed Elimina Personale';

  @override
  String get manageCentralOfficials => 'Gestisci Funzionari Centrali e Curia';

  @override
  String get centralOfficialsSubtitle =>
      'Nomina funzionari della Curia Generalis e Sub Immediata';

  @override
  String get manageBishopData => 'Gestisci Dati Vescovi';

  @override
  String get bishopDataSubtitle =>
      'Gestisci l\'elenco degli Episcopi Ex Ordines Assumpti';

  @override
  String get manageCitocNews => 'Gestisci Notizie CITOC';

  @override
  String get citocNewsSubtitle => 'Aggiungi i link delle ultime notizie';

  @override
  String get manageGeneralCommissions => 'Gestisci Commissioni Generali';

  @override
  String get generalCommissionsSubtitle =>
      'Organizza le divisioni delle commissioni e i loro membri';
}
