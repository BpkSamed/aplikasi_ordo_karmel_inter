import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'l10n/app_localizations.dart'; // UNCOMMENT ini nanti saat file .arb sudah selesai

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

// Menggunakan StatefulWidget agar bahasa bisa berubah tanpa harus merestart aplikasi
class AplikasiOrdoKarmel extends StatefulWidget {
  const AplikasiOrdoKarmel({super.key});

  static _AplikasiOrdoKarmelState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AplikasiOrdoKarmelState>();

  @override
  State<AplikasiOrdoKarmel> createState() => _AplikasiOrdoKarmelState();
}

class _AplikasiOrdoKarmelState extends State<AplikasiOrdoKarmel> {
  // Default aplikasi dibuka menggunakan bahasa Latin
  Locale _locale = const Locale('la'); 

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit untuk memastikan ukuran elemen menyesuaikan HP pengguna
    return ScreenUtilInit(
      designSize: const Size(360, 800), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aplikasi Ordo Karmel',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
          ),
          
          locale: _locale,
          localizationsDelegates: const [
            // Delegasi kustom agar flutter tidak error saat memproses bahasa Latin
            _LaMaterialLocalizations.delegate,
            _LaCupertinoLocalizations.delegate,
            
            // AppLocalizations.delegate, // UNCOMMENT baris ini nanti jika .arb sudah di-setup
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('la', ''), // Latin (Default)
            Locale('en', ''), // English
            Locale('it', ''), // Italia
            Locale('es', ''), // Spanyol
          ],
          home: const HalamanInformasi(),
        );
      },
    );
  }
}

/// =================================================================
/// 1. HALAMAN INFORMASI 
/// =================================================================
class HalamanInformasi extends StatelessWidget {
  const HalamanInformasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Informasi Aplikasi")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w), 
        child: Column(
          children: [
            Icon(Icons.church, size: 100.w, color: Colors.brown),
            Text("APLIKASI ORDO KARMEL", 
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.brown)),
            Divider(height: 40.h),

            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.brown),
              title: const Text("Kantor Pusat", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Curia Generalitia\nVia di San Martino ai Monti, 8\n00184 Rome, Italy"),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.brown),
              title: const Text("Hubungi Kami", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Email: info@ocarm.org\nTelp: +39 06 4620181"),
            ),
            
            SizedBox(height: 50.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
              },
              child: Text("Lanjut ke Login", style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        ),
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN LOGIN 
/// =================================================================
class HalamanLogin extends StatelessWidget {
  const HalamanLogin({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    String welcomeText = "Salve"; // Default Latin
    if (languageCode == 'en') welcomeText = "Welcome";
    if (languageCode == 'it') welcomeText = "Benvenuto";
    if (languageCode == 'es') welcomeText = "Bienvenido";

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            
            // TOMBOL PILIHAN BAHASA (DROPDOWN)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.brown),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 20.sp, color: Colors.brown),
                    SizedBox(width: 8.w),
                    DropdownButton<Locale>(
                      value: currentLocale,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.brown, size: 24.sp),
                      underline: const SizedBox(),
                      dropdownColor: Colors.white,
                      style: TextStyle(color: Colors.brown, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          AplikasiOrdoKarmel.of(context)?.setLocale(newLocale);
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: Locale('la'), child: Text("Latina")),
                        DropdownMenuItem(value: Locale('en'), child: Text("English")),
                        DropdownMenuItem(value: Locale('it'), child: Text("Italiano")),
                        DropdownMenuItem(value: Locale('es'), child: Text("Español")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 40.h),

            // TULISAN SELAMAT DATANG YANG OTOMATIS BERUBAH
            Text(
              welcomeText,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.brown),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 40.h),
            TextField(
              decoration: InputDecoration(
                labelText: "Username / Email", 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h)
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password", 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h)
              ),
            ),
            SizedBox(height: 40.h),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanUtama()));
              },
              child: Text("Login sebagai Anggota", style: TextStyle(fontSize: 16.sp)),
            ),
            
            SizedBox(height: 15.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: Colors.white,
                foregroundColor: Colors.brown,
                side: const BorderSide(color: Colors.brown, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanAdmin()));
              },
              child: Text("Login sebagai Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ),
          ],
        ),
      ),
    );
  }
}

/// =================================================================
/// 3. HALAMAN UTAMA (PROFIL PENGGUNA)
/// =================================================================
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
      ),
      drawer: Drawer(
        width: 280.w,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.brown),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30.r, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.brown, size: 30.sp)),
                  SizedBox(height: 10.h),
                  Text("Abraham", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
                  Text("Student", style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
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
              leading: Icon(Icons.logout, size: 24.sp),
              title: Text("Logout", style: TextStyle(fontSize: 14.sp)),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin())),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50.r, child: Icon(Icons.person, size: 50.sp)),
            SizedBox(height: 20.h),
            Text("Selamat Datang, Abraham", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Text("Mahasiswa Universitas", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Text("Klik garis tiga di pojok kiri atas untuk melihat direktori Ordo Karmel.", 
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      onTap: () {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Membuka: $title")));

        if (title == "Curia Generalis") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanCuriaGeneralis()));
        } else if (title == "Episcopi Ex Ordines Assumpti") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanEpiscopi()));
        } else if (title == "Sub Immediata Jurisdictione Prioris Generalis") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanSubImmediata()));
        } else if (title == "CITOC") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanCitoc()));
        } else if (title == "FRATRES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanFratres()));
        } else if (title == "HEREMITI") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanHeremiti()));
        } else if (title == "MONIALES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMoniales()));
        } else if (title.contains("MONASTERIA ORDINIS")) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMonasteriaOrdiniss()));
        } else if (title == "HEREMITAE") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanHeremitae()));
        } else if (title == "INSTITUTA") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanInstituta()));
        } else if (title == "STATISTICA") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanStatistica()));
        } else if (title == "Ministries") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMinistries()));
        }
      },
    );
  }
}

/// =================================================================
/// 4. HALAMAN ADMIN
/// =================================================================
class HalamanAdmin extends StatelessWidget {
  const HalamanAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dasbor Admin"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            "Menu Pengelolaan Direktori",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          SizedBox(height: 15.h),

          _buildAdminMenuCard(
            context: context,
            title: "Kelola Data Master",
            subtitle: "Alamat, Entitas, dan Biara",
            icon: Icons.domain,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanDaftarDataNonAnggota()));
            },
          ),
          _buildAdminMenuCard(
            context: context,
            title: "Kelola Data Anggota",
            subtitle: "Tambah, Edit, dan Hapus Personalia",
            icon: Icons.people,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanDaftarAnggota()));
            },
          ),
          _buildAdminMenuCard(
            context: context,
            title: "Kelola Pejabat Pusat & Curia",
            subtitle: "Tunjuk pejabat Curia Generalis & Sub Immediata",
            icon: Icons.assignment_ind,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanKelolaPejabatPusat()));
            },
          ),
          _buildAdminMenuCard(
            context: context,
            title: "Kelola Data Uskup",
            subtitle: "Kelola daftar Uskup Ex Ordines Assumpti",
            icon: Icons.shield,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanDaftarEpiscopi()));
            },
          ),
          _buildAdminMenuCard(
            context: context,
            title: "Kelola Berita CITOC",
            subtitle: "Tambahkan tautan berita terbaru",
            icon: Icons.newspaper,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanKelolaCitoc()));
            },
          ),
          _buildAdminMenuCard(
            context: context,
            title: "Kelola Komisi Jenderal",
            subtitle: "Atur divisi komisi kerja dan anggotanya",
            icon: Icons.assignment,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanKelolaKomisi()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3, 
      margin: EdgeInsets.symmetric(vertical: 8.h), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), 
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w), 
        leading: CircleAvatar(
          radius: 24.r,
          backgroundColor: Colors.brown,
          child: Icon(icon, color: Colors.white, size: 24.sp),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 16.sp),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13.sp)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
        onTap: onTap,
      ),
    );
  }
}

/// =================================================================
/// DELEGATE KUSTOM UNTUK MENDUKUNG LOCALE LATIN ('la')
/// (Jangan dihapus agar aplikasi tidak force close)
/// =================================================================

class _LaMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _LaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'la';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return DefaultMaterialLocalizations();
  }

  @override
  bool shouldReload(_LaMaterialLocalizationsDelegate old) => false;
}

class _LaMaterialLocalizations {
  static const LocalizationsDelegate<MaterialLocalizations> delegate = _LaMaterialLocalizationsDelegate();
}

class _LaCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _LaCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'la';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return const DefaultCupertinoLocalizations();
  }

  @override
  bool shouldReload(_LaCupertinoLocalizationsDelegate old) => false;
}

class _LaCupertinoLocalizations {
  static const LocalizationsDelegate<CupertinoLocalizations> delegate = _LaCupertinoLocalizationsDelegate();
}