import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';

import 'curia_generalis.dart';
import 'episcopi_ex_ordines_assumpti.dart';
import 'heremitae.dart';
import 'heremiti.dart';
import 'instituta.dart';
import 'jurisdictione_prioris_generalis.dart';
import 'citoc.dart';
import 'fratres.dart';
import 'monasteria_ordinis.dart';
import 'moniales.dart';
import 'statistica.dart';
import 'ministries.dart';
import 'tambah_admin.dart';
import 'tambah_anggota.dart';
import 'daftar_admin.dart';
import 'daftar_anggota.dart';
import 'data_non_anggota.dart';
import 'daftar_data_non_anggota.dart';
import 'kelola_pejabat_pusat.dart';
import 'daftar_episcopi.dart';
import 'kelola_komisi.dart';
import 'kelola_citoc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dcvbectolbungkxutiio.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjdmJlY3RvbGJ1bmdreHV0aWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMyMTA3NTAsImV4cCI6MjA5ODc4Njc1MH0.gXn1syMkQ1WvrZS7qxAwcE9InVBjzsj4Qq5ppZEL9ME',
  );
  runApp(const AplikasiOrdoKarmel());
}

class FallbackMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'la';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'la';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}

class AplikasiOrdoKarmel extends StatefulWidget {
  const AplikasiOrdoKarmel({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _AplikasiOrdoKarmelState? state = context.findAncestorStateOfType<_AplikasiOrdoKarmelState>();
    state?.changeLocale(newLocale);
  }

  @override
  State<AplikasiOrdoKarmel> createState() => _AplikasiOrdoKarmelState();
}

class _AplikasiOrdoKarmelState extends State<AplikasiOrdoKarmel> {
  Locale _locale = const Locale('la'); 

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Ordo Karmel',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown, 
          foregroundColor: Colors.white
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationsDelegate(),
        FallbackCupertinoLocalizationsDelegate(),
      ],
      supportedLocales: const [
        Locale('la'),
        Locale('en'),
        Locale('it'),
        Locale('es'),
      ],
      home: const HalamanInformasi(),
    );
  }
}

/// =================================================================
/// 1. HALAMAN INFORMASI (Gabungan Halaman 1, 2, & 3)
/// =================================================================
class HalamanInformasi extends StatelessWidget {
  const HalamanInformasi({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(t.appInfoTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Menggunakan basis lebar layar untuk kalkulasi ukuran dinamis
          final double baseWidth = constraints.maxWidth;
          
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: baseWidth * 0.05,
              vertical: 20.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.03),
                    // Icon mengikuti persentase ukuran layar
                    Icon(Icons.church, size: baseWidth * 0.25, color: Colors.brown),
                    const SizedBox(height: 15),
                    // Font dinamis
                    Text(
                      t.appName, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseWidth * 0.055, // Proporsional ~22pt
                        fontWeight: FontWeight.bold, 
                        color: Colors.brown
                      ),
                    ),
                    Divider(height: constraints.maxHeight * 0.05),

                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.brown, size: baseWidth * 0.065),
                      title: Text(t.headquarters, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(t.headquartersAddress),
                    ),
                    const Divider(),

                    ListTile(
                      leading: Icon(Icons.contact_mail, color: Colors.brown, size: baseWidth * 0.065),
                      title: Text(t.contactUs, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(t.contactDetails),
                    ),
                    
                    const Spacer(),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, constraints.maxHeight * 0.07), // Tinggi responsif
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
                      },
                      child: Text(t.continueToLogin, style: TextStyle(fontSize: baseWidth * 0.04)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN LOGIN DENGAN PILIHAN BAHASA & TEKS SELAMAT DATANG
/// =================================================================
class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    Locale currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.loginTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: baseWidth * 0.06,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: constraints.maxHeight * 0.03),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.language, color: Colors.brown, size: baseWidth * 0.05),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: currentLocale.languageCode,
                      underline: Container(height: 2, color: Colors.brown),
                      onChanged: (String? newLangCode) {
                        if (newLangCode != null) {
                          AplikasiOrdoKarmel.setLocale(context, Locale(newLangCode));
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'la', child: Text('Latin (Default)')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'it', child: Text('Italiano')),
                        DropdownMenuItem(value: 'es', child: Text('Español')),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: constraints.maxHeight * 0.03),

                Text(
                  t.welcomeMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: baseWidth * 0.06, // Ukuran font responsif
                    fontWeight: FontWeight.bold, 
                    color: Colors.brown
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.04),

                TextField(
                  decoration: InputDecoration(
                    labelText: t.usernameEmailLabel, 
                    border: const OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t.passwordLabel, 
                    border: const OutlineInputBorder()
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.04),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, constraints.maxHeight * 0.07),
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanUtama()));
                  },
                  child: Text(t.loginAsMember, style: TextStyle(fontSize: baseWidth * 0.04)),
                ),
                
                const SizedBox(height: 15),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, constraints.maxHeight * 0.07),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.brown,
                    side: const BorderSide(color: Colors.brown, width: 2),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanAdmin()));
                  },
                  child: Text(
                    t.loginAsAdmin, 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 3. HALAMAN UTAMA (PROFIL) DENGAN DRAWER (MENU GARIS 3)
/// =================================================================
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.userProfileTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.brown),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.brown)),
                  const SizedBox(height: 10),
                  const Text("Abraham", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(t.studentRole, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            _buildMenuItem(context, "Curia Generalis"),
            _buildMenuItem(context, "Episcopi Ex Ordines Assumpti"),
            _buildMenuItem(context, "Sub Immediata Jurisdictione Prioris Generalis"),
            _buildMenuItem(context, "CITOC"),
            _buildMenuItem(context, "FRATRES"),
            _buildMenuItem(context, "HEREMITI"),
            _buildMenuItem(context, "MONIALES"),
            _buildMenuItem(context, "MONASTERIA ORDINIS..."),
            _buildMenuItem(context, "HEREMITAE"),
            _buildMenuItem(context, "INSTITUTA"),
            _buildMenuItem(context, "STATISTICA"),
            _buildMenuItem(context, "Ministries"),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(t.logout),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin())),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: baseWidth * 0.12, child: Icon(Icons.person, size: baseWidth * 0.12)),
                    const SizedBox(height: 20),
                    Text(
                      t.welcomeMessage, 
                      style: TextStyle(fontSize: baseWidth * 0.05, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 10),
                    Text(t.universityStudent, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        t.drawerInstruction, 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: baseWidth * 0.038),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    final t = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.openingMenu(title))));

        if (title == "Curia Generalis") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanCuriaGeneralis()));
        } 
        else if (title == "Episcopi Ex Ordines Assumpti") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanEpiscopi()));
        }
        else if (title == "Sub Immediata Jurisdictione Prioris Generalis") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanSubImmediata()));
        }
        else if (title == "CITOC") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanCitoc()));
        }
        else if (title == "FRATRES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanFratres()));
        }
        else if (title == "HEREMITI") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanHeremiti()));
        }
        else if (title == "MONIALES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMoniales()));
        }
        else if (title.contains("MONASTERIA ORDINIS")) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMonasteriaOrdiniss()));
        }
        else if (title == "HEREMITAE") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanHeremitae()));
        }
        else if (title == "INSTITUTA") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanInstituta()));
        }
        else if (title == "STATISTICA") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanStatistica()));
        }
        else if (title == "Ministries") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMinistries()));
        }
      },
    );
  }
}

/// =================================================================
/// 4. HALAMAN DASBOR ADMIN
/// =================================================================
class HalamanAdmin extends StatelessWidget {
  const HalamanAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.adminDashboardTitle),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: baseWidth * 0.04,
              vertical: 16.0,
            ),
            children: [
              Text(
                t.directoryManagementMenu,
                style: TextStyle(
                  fontSize: baseWidth * 0.045, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.brown
                ),
              ),
              const SizedBox(height: 15),

              _buildAdminMenuCard(
                context: context,
                title: t.manageMasterData,
                subtitle: t.masterDataSubtitle,
                icon: Icons.domain,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanDaftarDataNonAnggota()));
                },
              ),

              _buildAdminMenuCard(
                context: context,
                title: t.manageMemberData,
                subtitle: t.memberDataSubtitle,
                icon: Icons.people,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanDaftarAnggota()));
                },
              ),

              _buildAdminMenuCard(
                context: context,
                title: t.manageCentralOfficials,
                subtitle: t.centralOfficialsSubtitle,
                icon: Icons.assignment_ind,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanKelolaPejabatPusat()));
                },
              ),

              _buildAdminMenuCard(
                context: context,
                title: t.manageBishopData,
                subtitle: t.bishopDataSubtitle,
                icon: Icons.shield,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanDaftarEpiscopi()));
                },
              ),

              _buildAdminMenuCard(
                context: context,
                title: t.manageCitocNews,
                subtitle: t.citocNewsSubtitle,
                icon: Icons.newspaper,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanKelolaCitoc()));
                },
              ),

              _buildAdminMenuCard(
                context: context,
                title: t.manageGeneralCommissions,
                subtitle: t.generalCommissionsSubtitle,
                icon: Icons.assignment,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanKelolaKomisi()));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAdminMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required double baseWidth,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.brown,
          child: Icon(icon, color: Colors.white, size: baseWidth * 0.055),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04),
        onTap: onTap,
      ),
    );
  }
}