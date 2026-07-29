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
/// 1. HALAMAN INFORMASI (Tampilan Awal Aplikasi)
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
                    Icon(Icons.church, size: baseWidth * 0.25, color: Colors.brown),
                    const SizedBox(height: 15),
                    Text(
                      t.appName, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseWidth * 0.055,
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
                        minimumSize: Size(double.infinity, constraints.maxHeight * 0.07),
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
/// 2. HALAMAN LOGIN DENGAN AUTENTIKASI SUPABASE
/// =================================================================
class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  // Login khusus Admin
  Future<void> _loginAdmin(AppLocalizations t) async {
    if (_usernameCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('admins')
          .select()
          .eq('name', _usernameCtrl.text)
          .eq('password', _passwordCtrl.text)
          .maybeSingle();

      if (response != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanAdmin(currentAdminId: response['id']),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Admin gagal: Username atau Password salah!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Login khusus Anggota biasa
  Future<void> _loginMember(AppLocalizations t) async {
    if (_usernameCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      // Mengecek berdasarkan email atau full_name/name di tabel members
      final response = await Supabase.instance.client
          .from('members')
          .select()
          .or('username.eq.${_usernameCtrl.text},full_name.eq.${_usernameCtrl.text}')
          .eq('password', _passwordCtrl.text)
          .maybeSingle();

      if (response != null) {
        if (mounted) {
          // Bawa data anggota ke HalamanUtama
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanUtama(memberData: response),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Anggota gagal: Username/Email atau Password salah!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                    fontSize: baseWidth * 0.06,
                    fontWeight: FontWeight.bold, 
                    color: Colors.brown
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.04),

                TextField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                    labelText: t.usernameEmailLabel, 
                    border: const OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t.passwordLabel, 
                    border: const OutlineInputBorder()
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.04),
                
                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.brown))
                else ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, constraints.maxHeight * 0.07),
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _loginMember(t),
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
                    onPressed: () => _loginAdmin(t),
                    child: Text(
                      t.loginAsAdmin, 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)
                    ),
                  ),
                ],
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
/// 3. HALAMAN UTAMA (PROFIL ANGGOTA & NAVIGASI DRAWER)
/// =================================================================
class HalamanUtama extends StatelessWidget {
  final Map<String, dynamic>? memberData;

  const HalamanUtama({super.key, this.memberData});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Ambil data anggota jika ada
    final String namaLengkap = memberData?['full_name'] ?? memberData?['name'] ?? 'Anggota Karmel';
    final String photoUrl = memberData?['photo_url'] ?? '';
    final String email = memberData?['email'] ?? '-';
    final String phone = memberData?['phone'] ?? '-';
    final String status = memberData?['status'] ?? 'Anggota';
    final String address = memberData?['address'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(t.userProfileTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.brown),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.isEmpty ? const Icon(Icons.person, size: 40, color: Colors.brown) : null,
              ),
              accountName: Text(
                namaLengkap,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              accountEmail: Text(
                email.isNotEmpty ? email : status,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            _buildMenuItem(context, "Curia Generalis", t.curiaGeneralisTitle ?? "Curia Generalis"),
            _buildMenuItem(context, "Episcopi Ex Ordines Assumpti", t.episcopiExOrdinesTitle ?? "Episcopi Ex Ordine Assumpti"),
            _buildMenuItem(context, "Sub Immediata Jurisdictione Prioris Generalis", t.subJurisdictioneTitle ?? "Sub Immediata Jurisdictione"),
            _buildMenuItem(context, "CITOC", t.citocTitle ?? "CITOC"),
            _buildMenuItem(context, "FRATRES", t.fratresTitle ?? "Fratres"),
            _buildMenuItem(context, "HEREMITI", t.heremitiTitle ?? "Heremiti"),
            _buildMenuItem(context, "MONIALES", t.monialesTitle ?? "Moniales"),
            _buildMenuItem(context, "MONASTERIA ORDINIS", t.monasteriaOrdinisTitle ?? "Monasteria Ordinis"),
            _buildMenuItem(context, "HEREMITAE", t.heremitaeTitle ?? "Heremitae"),
            _buildMenuItem(context, "INSTITUTA", t.institutaTitle ?? "Instituta"),
            _buildMenuItem(context, "STATISTICA", t.statisticaTitle ?? "Statistica"),
            _buildMenuItem(context, "Ministries", t.ministriesTitle ?? "Ministries"),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(t.logout, style: const TextStyle(color: Colors.red)),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin())),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Foto Profil
                  CircleAvatar(
                    radius: baseWidth * 0.15,
                    backgroundColor: Colors.brown[100],
                    backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child: photoUrl.isEmpty ? Icon(Icons.person, size: baseWidth * 0.15, color: Colors.brown) : null,
                  ),
                  const SizedBox(height: 15),
                  // Nama Pengguna
                  Text(
                    namaLengkap,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: baseWidth * 0.055, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const SizedBox(height: 5),
                  // Status
                  Chip(
                    label: Text(status, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.brown,
                  ),
                  const SizedBox(height: 20),
                  const Divider(),

                  // Kartu Detail Data Pengguna
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email, color: Colors.brown),
                            title: const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(email),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.brown),
                            title: const Text("Nomor Telepon", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(phone),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.home, color: Colors.brown),
                            title: const Text("Alamat", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(address),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.drawerInstruction, 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String routeKey, String displayTitle) {
    final t = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(displayTitle),
      onTap: () {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.openingMenu(displayTitle))));

        if (routeKey == "Curia Generalis") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanCuriaGeneralis()));
        } 
        else if (routeKey == "Episcopi Ex Ordines Assumpti") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanEpiscopi()));
        }
        else if (routeKey == "Sub Immediata Jurisdictione Prioris Generalis") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanSubImmediata()));
        }
        else if (routeKey == "CITOC") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanCitoc()));
        }
        else if (routeKey == "FRATRES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanFratres()));
        }
        else if (routeKey == "HEREMITI") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanHeremiti()));
        }
        else if (routeKey == "MONIALES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMoniales()));
        }
        else if (routeKey.contains("MONASTERIA ORDINIS")) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMonasteriaOrdinis()));
        }
        else if (routeKey == "HEREMITAE") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanHeremitae()));
        }
        else if (routeKey == "INSTITUTA") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanInstituta()));
        }
        else if (routeKey == "STATISTICA") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanStatistica()));
        }
        else if (routeKey == "Ministries") {
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
  final int currentAdminId;

  const HalamanAdmin({super.key, required this.currentAdminId});

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

              // MENU EDIT PROFIL APLIKASI (INFORMASI AWAL)
              _buildAdminMenuCard(
                context: context,
                title: "Edit Profil Aplikasi",
                subtitle: "Kelola Alamat Kantor Pusat & Kontak Informasi",
                icon: Icons.edit_attributes,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanEditProfilAplikasi()));
                },
              ),

              _buildAdminMenuCard(
                context: context,
                title: t.manageAdminTitle ?? "Kelola Admin",
                subtitle: t.adminSubtitle ?? "Daftar Administrator",
                icon: Icons.admin_panel_settings,
                baseWidth: baseWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanDaftarAdmin(currentAdminId: currentAdminId)));
                },
              ),

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

/// =================================================================
/// 5. HALAMAN EDIT PROFIL APLIKASI (INFORMASI AWAL KANTOR PUSAT & KONTAK)
/// =================================================================
class HalamanEditProfilAplikasi extends StatefulWidget {
  const HalamanEditProfilAplikasi({super.key});

  @override
  State<HalamanEditProfilAplikasi> createState() => _HalamanEditProfilAplikasiState();
}

class _HalamanEditProfilAplikasiState extends State<HalamanEditProfilAplikasi> {
  final _addressCtrl = TextEditingController(text: "Via Giovanni Lanza 138, 00184 Roma, Italia");
  final _contactCtrl = TextEditingController(text: "Email: curia@ocarm.org\nPhone: +39 06 4620181");
  bool _isLoading = false;

  Future<void> _simpanPerubahan() async {
    setState(() => _isLoading = true);
    // Contoh simpan ke database atau state lokal
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil aplikasi berhasil diperbarui!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil Aplikasi")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Kelola Informasi Awal Aplikasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Alamat Kantor Pusat",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contactCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Kontak Informasi / Person",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _simpanPerubahan,
                    child: const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
          ],
        ),
      ),
    );
  }
}