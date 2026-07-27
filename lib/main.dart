import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import file Lokalisasi
import 'l10n/app_localizations.dart';

// Import Semua Halaman Menu Anggota / Publik
import 'curia_generalis.dart';
import 'episcopi_ex_ordines_assumpti.dart';
import 'jurisdictione_prioris_generalis.dart';
import 'citoc.dart';
import 'fratres.dart';
import 'heremiti.dart';
import 'moniales.dart';
import 'monasteria_ordinis.dart';
import 'heremitae.dart';
import 'instituta.dart';
import 'ministries.dart';
import 'statistica.dart';

// Import Semua Halaman Manajemen Admin
import 'daftar_admin.dart';
import 'kelola_pejabat_pusat.dart';
import 'kelola_komisi.dart';
import 'kelola_citoc.dart';
import 'daftar_anggota.dart';
import 'daftar_data_non_anggota.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase (Sesuaikan URL & AnonKey dengan project Supabase Anda)
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direktori Ordo Karmel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primary抓Scheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        scaffoldBackgroundColor: Colors.grey.shade100,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('la'), // Latin
        Locale('en'), // English
        Locale('it'), // Italiano
        Locale('es'), // Español
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HalamanUtama(),
    );
  }
}

/// =================================================================
/// HALAMAN UTAMA (DASHBOARD Utama)
/// =================================================================
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  bool _isAdmin = false; // Status apakah user login sebagai admin
  String? _adminName;

  // Fungsi Popup Login Admin
  Future<void> _showLoginDialog(AppLocalizations t, double baseWidth) async {
    final nameCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    bool isLoggingIn = false;
    String? errorMessage;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.admin_panel_settings, color: Colors.brown),
                  SizedBox(width: baseWidth * 0.02),
                  Text(
                    t.manageAdminTitle ?? "Login Admin",
                    style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: baseWidth * 0.02),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: baseWidth * 0.032),
                      ),
                    ),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: t.adminNameLabel ?? "Nama Admin / Username",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: baseWidth * 0.03),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: t.passwordLabel ?? "Password",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.cancelButton ?? "Batal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  onPressed: isLoggingIn
                      ? null
                      : () async {
                          setDialogState(() {
                            isLoggingIn = true;
                            errorMessage = null;
                          });

                          try {
                            // Cek kredensial ke Supabase tabel 'admins'
                            final response = await Supabase.instance.client
                                .from('admins')
                                .select()
                                .eq('name', nameCtrl.text.trim())
                                .eq('password', passCtrl.text.trim())
                                .maybeSingle();

                            if (response != null) {
                              setState(() {
                                _isAdmin = true;
                                _adminName = response['name'];
                              });
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Selamat datang Admin, ${_adminName ?? ''}!")),
                                );
                              }
                            } else {
                              setDialogState(() {
                                isLoggingIn = false;
                                errorMessage = "Username atau Password salah!";
                              });
                            }
                          } catch (e) {
                            setDialogState(() {
                              isLoggingIn = false;
                              errorMessage = "Gagal login: $e";
                            });
                          }
                        },
                  child: isLoggingIn
                      ? SizedBox(
                          width: baseWidth * 0.04,
                          height: baseWidth * 0.04,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("LOGIN"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _logoutAdmin() {
    setState(() {
      _isAdmin = false;
      _adminName = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Anda telah keluar dari mode Admin.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle ?? "Direktori Ordo Karmel"),
        actions: [
          // Pemilih Bahasa (Locale Selector)
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: "Pilih Bahasa / Select Language",
            onSelected: (Locale locale) {
              MyApp.setLocale(context, locale);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: Locale('la'), child: Text("Latin (LA)")),
              const PopupMenuItem(value: Locale('en'), child: Text("English (EN)")),
              const PopupMenuItem(value: Locale('it'), child: Text("Italiano (IT)")),
              const PopupMenuItem(value: Locale('es'), child: Text("Español (ES)")),
            ],
          ),

          // Tombol Login / Logout Admin
          IconButton(
            icon: Icon(_isAdmin ? Icons.logout : Icons.lock_outline),
            tooltip: _isAdmin ? "Logout Admin" : "Login Admin",
            onPressed: () {
              if (_isAdmin) {
                _logoutAdmin();
              } else {
                final double baseWidth = MediaQuery.of(context).size.width;
                _showLoginDialog(t, baseWidth);
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.04),
            children: [
              // BISA DITAMPILKAN KARTU STATUS LOGIN JIKA SEBAGAI ADMIN
              if (_isAdmin) ...[
                Container(
                  padding: EdgeInsets.all(baseWidth * 0.035),
                  margin: EdgeInsets.only(bottom: baseWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.amber, size: baseWidth * 0.07),
                      SizedBox(width: baseWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mode Administrator Aktif",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: baseWidth * 0.038,
                              ),
                            ),
                            Text(
                              "Admin: ${_adminName ?? 'Administrator'}",
                              style: TextStyle(color: Colors.white70, fontSize: baseWidth * 0.032),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // SECTION: MENU KHUSUS ADMIN (HANYA MUNCUL SETELAH LOGIN)
                // ==========================================
                Text(
                  t.manageAdminTitle ?? "Panel Pengelolaan Admin",
                  style: TextStyle(
                    fontSize: baseWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900,
                  ),
                ),
                SizedBox(height: baseWidth * 0.02),

                // 1. MENU KELOLA ADMIN (Daftar Admin & Tambah Admin)
                _buildMenuCard(
                  context,
                  title: t.manageAdminTitle ?? "Kelola Admin",
                  subtitle: t.adminListTitle ?? "Daftar & Hak Akses Administrator",
                  icon: Icons.admin_panel_settings,
                  color: Colors.brown.shade700,
                  page: const HalamanDaftarAdmin(),
                  baseWidth: baseWidth,
                ),

                // 2. MENU KELOLA PEJABAT PUSAT
                _buildMenuCard(
                  context,
                  title: t.manageCuriaTitle ?? "Kelola Curia & Pejabat Pusat",
                  subtitle: "Penunjukan Pejabat Curia Generalis",
                  icon: Icons.manage_accounts,
                  color: Colors.brown.shade700,
                  page: const HalamanKelolaPejabatPusat(),
                  baseWidth: baseWidth,
                ),

                // 3. MENU KELOLA KOMISI
                _buildMenuCard(
                  context,
                  title: t.manageCommissionTitle ?? "Kelola Komisi Jenderal",
                  subtitle: "Atur Komisi & Anggota Komisi",
                  icon: Icons.assignment_ind,
                  color: Colors.brown.shade700,
                  page: const HalamanKelolaKomisi(),
                  baseWidth: baseWidth,
                ),

                // 4. MENU KELOLA BERITA CITOC
                _buildMenuCard(
                  context,
                  title: t.manageCitocNewsTitle ?? "Kelola Berita CITOC",
                  subtitle: "Tambah/Edit Link Berita Publik",
                  icon: Icons.edit_document,
                  color: Colors.brown.shade700,
                  page: const HalamanKelolaCitoc(),
                  baseWidth: baseWidth,
                ),

                // 5. MENU KELOLA ANGGOTA
                _buildMenuCard(
                  context,
                  title: t.memberListTitle ?? "Kelola Data Anggota",
                  subtitle: "Tambah, Edit, & Hapus Biodata Sodales",
                  icon: Icons.person_add_alt_1,
                  color: Colors.brown.shade700,
                  page: const HalamanDaftarAnggota(),
                  baseWidth: baseWidth,
                ),

                // 6. MENU KELOLA DATA NON ANGGOTA
                _buildMenuCard(
                  context,
                  title: t.nonMemberDataListTitle ?? "Kelola Alamat, Entitas & Biara",
                  subtitle: "Master Data Domicilia & Conventus",
                  icon: Icons.dataset,
                  color: Colors.brown.shade700,
                  page: const HalamanDaftarDataNonAnggota(),
                  baseWidth: baseWidth,
                ),

                SizedBox(height: baseWidth * 0.04),
                const Divider(),
                SizedBox(height: baseWidth * 0.02),
              ],

              // ==========================================
              // SECTION: MENU ANGGOTA / PUBLIK (BISA DITRANSLATE)
              // ==========================================
              Text(
                t.mainDirectoryTitle ?? "Direktori Utama Ordo Karmel",
                style: TextStyle(
                  fontSize: baseWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade900,
                ),
              ),
              SizedBox(height: baseWidth * 0.025),

              _buildMenuCard(
                context,
                title: t.curiaGeneralisTitle ?? "Curia Generalis",
                subtitle: t.curiaGeneralisSubtitle ?? "Consilium, Officia, & Commissiones",
                icon: Icons.account_balance,
                color: Colors.brown,
                page: const HalamanCuriaGeneralis(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.episcopiExOrdinesTitle ?? "Episcopi Ex Ordine Assumpti",
                subtitle: t.episcopiSubtitle ?? "Daftar Uskup dari Ordo Karmel",
                icon: Icons.person_search,
                color: Colors.brown,
                page: const HalamanEpiscopi(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.subJurisdictioneTitle ?? "Sub Immediata Jurisdictione",
                subtitle: t.subJurisdictioneSubtitle ?? "Delegatio, CISA, Domus S. Alberti",
                icon: Icons.gavel,
                color: Colors.brown,
                page: const HalamanSubImmediata(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.citocTitle ?? "CITOC",
                subtitle: t.citocSubtitle ?? "Berita & Informatorum Carmelitanum",
                icon: Icons.newspaper,
                color: Colors.brown,
                page: const HalamanCitoc(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.fratresTitle ?? "FRATRES",
                subtitle: t.fratresSubtitle ?? "Provincia, Commissariatus, & Delegationes",
                icon: Icons.groups,
                color: Colors.brown,
                page: const HalamanFratres(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.heremitiTitle ?? "HEREMITI",
                subtitle: t.heremitiSubtitle ?? "Pertapa Carmelita (Sacerdotalis & Sorores)",
                icon: Icons.self_improvement,
                color: Colors.brown,
                page: const HalamanHeremiti(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.monialesTitle ?? "MONIALES",
                subtitle: t.monialesSubtitle ?? "Suster-Suster Kontemplatif Carmelita",
                icon: Icons.church,
                color: Colors.brown,
                page: const HalamanMoniales(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.monasteriaOrdinisTitle ?? "MONASTERIA ORDINIS",
                subtitle: t.monasteriaOrdinisSubtitle ?? "Monasteria Sui Iuris / Propriis Utuntur",
                icon: Icons.holiday_village,
                color: Colors.brown,
                page: const HalamanMonasteriaOrdiniss(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.heremitaeTitle ?? "HEREMITAE",
                subtitle: t.heremitaeSubtitle ?? "Pertapa Carmelita Terpisah",
                icon: Icons.terrain,
                color: Colors.brown,
                page: const HalamanHeremitae(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.institutaTitle ?? "INSTITUTA",
                subtitle: t.institutaSubtitle ?? "Institut-Institut Secularia Terafiliasi",
                icon: Icons.domain,
                color: Colors.brown,
                page: const HalamanInstituta(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.ministriesTitle ?? "MINISTRIES",
                subtitle: t.ministriesSubtitle ?? "Paroki, Sekolah, Rumah Retret, dll",
                icon: Icons.volunteer_activism,
                color: Colors.brown,
                page: const HalamanMinistries(),
                baseWidth: baseWidth,
              ),

              _buildMenuCard(
                context,
                title: t.statisticaTitle ?? "STATISTICA",
                subtitle: t.statisticaSubtitle ?? "Data Angka Statistik & Persebaran Negara",
                icon: Icons.bar_chart,
                color: Colors.brown,
                page: const HalamanStatistica(),
                baseWidth: baseWidth,
              ),
            ],
          );
        },
      ),
    );
  }

  // WIDGET CARD REUSABLE DAN RESPONSIF SANGAT FLEKSIBEL
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
    required double baseWidth,
  }) {
    return Card(
      elevation: 2.5,
      margin: EdgeInsets.only(bottom: baseWidth * 0.025),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.015),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: baseWidth * 0.055,
          child: Icon(icon, color: Colors.white, size: baseWidth * 0.055),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: baseWidth * 0.038,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade900,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: baseWidth * 0.03, color: Colors.grey.shade700),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04, color: Colors.grey),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}