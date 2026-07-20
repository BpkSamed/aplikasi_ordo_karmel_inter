import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'curia_generalis.dart';
import'episcopi_ex_ordines_assumpti.dart';
import 'heremitae.dart';
import 'heremiti.dart';
import 'instituta.dart';
import'jurisdictione_prioris_generalis.dart';
import'citoc.dart';
import'fratres.dart';
import 'monasteria_ordinis.dart';
import 'moniales.dart';
import 'statistica.dart';
import 'ministries.dart';
import 'tambah_admin.dart';
import 'tambah_anggota.dart';
import 'daftar_admin.dart';
import 'daftar_anggota.dart';
import 'data_non_anggota.dart'; // Tambahkan baris ini // Tambahkan baris ini
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dcvbectolbungkxutiio.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjdmJlY3RvbGJ1bmdreHV0aWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMyMTA3NTAsImV4cCI6MjA5ODc4Njc1MH0.gXn1syMkQ1WvrZS7qxAwcE9InVBjzsj4Qq5ppZEL9ME',
  );
  //await cekKoneksiSupabase();
  runApp(const AplikasiOrdoKarmel());
}
/*Future<void> cekKoneksiSupabase() async {
  print("========================================");
  print("⏳ MENGUJI KONEKSI SUPABASE...");
  try {
    // Kita coba panggil tabel paling dasar tanpa join (relasi) dulu
    final response = await Supabase.instance.client.from('episcopi').select().limit(1);
    print("✅ BERHASIL! Tabel ditemukan.");
    print("📦 Data Sampel: $response");
  } catch (error) {
    print("❌ GAGAL! Terjadi Error.");
    print("🔍 Detail Error: $error");
    print("💡 Kemungkinan: Nama tabel salah ketik di database, atau tabel benar-benar belum dibuat.");
  }
  print("========================================");
}*/

class AplikasiOrdoKarmel extends StatelessWidget {
  const AplikasiOrdoKarmel({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
    return Scaffold(
      appBar: AppBar(title: const Text("Informasi Aplikasi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Info 1: Gambar dan Judul [cite: 2]
            const Icon(Icons.church, size: 100, color: Colors.brown),
            const Text("APLIKASI ORDO KARMEL", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown)),
            const Divider(height: 40),

            // Info 2: Alamat Kantor Pusat [cite: 3]
            const ListTile(
              leading: Icon(Icons.location_on, color: Colors.brown),
              title: Text("Kantor Pusat", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Curia Generalitia\nVia di San Martino ai Monti, 8\n00184 Rome, Italy"),
            ),
            const Divider(),

            // Info 3: Contact Person [cite: 4]
            const ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.brown),
              title: Text("Hubungi Kami", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Email: info@ocarm.org\nTelp: +39 06 4620181"),
            ),
            
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
              },
              child: const Text("Lanjut ke Login"),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Username / Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            
            // Tombol Login sebagai Anggota
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Tetap mengarah ke HalamanUtama
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanUtama()));
              },
              child: const Text("Login sebagai Anggota"),
            ),
            
            const SizedBox(height: 15),

            // Tombol Login sebagai Admin
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white, // Warna dibedakan agar kontras
                foregroundColor: Colors.brown,
                side: const BorderSide(color: Colors.brown, width: 2), // Efek outline
              ),
              onPressed: () {
                // Mengarah ke HalamanAdmin
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanAdmin()));
              },
              child: const Text("Login sebagai Admin", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
      ),
      // Drawer (Menu Garis 3 di pojok kiri atas) 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.brown)),
                  SizedBox(height: 10),
                  Text("Abraham", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("Student", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            // Daftar menu utama dari dokumen 
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
              title: const Text("Logout"),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin())),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 20),
            Text("Selamat Datang, Abraham", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Mahasiswa Universitas", style: TextStyle(color: Colors.grey)),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Klik garis tiga di pojok kiri atas untuk melihat direktori Ordo Karmel.", 
                textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat list menu di Drawer
  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Tutup Drawer
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Membuka: $title")));

      if (title == "Curia Generalis") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanCuriaGeneralis()),
        );
      } 
      else if (title == "Episcopi Ex Ordines Assumpti") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanEpiscopi()),
        );
      }
      else if (title == "Sub Immediata Jurisdictione Prioris Generalis") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanSubImmediata()),
        );
      }
      else if (title == "CITOC") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanCitoc()),
        );
      }
      else if (title == "FRATRES") {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanFratres()));
      }
      else if (title == "HEREMITI") {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanHeremiti()));
      }
      else if (title == "MONIALES") {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanMoniales()));
      }
      else if (title.contains("MONASTERIA ORDINIS")) {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanMonasteriaOrdiniss()));
      }
      else if (title == "HEREMITAE") {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanHeremitae()));
      }
      else if (title == "INSTITUTA") {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanInstituta()));
      }
      else if (title == "STATISTICA") {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanStatistica()));
      }
      else if (title == "Ministries") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HalamanMinistries()),
  );
}
      
      },
    );
  }
}

class HalamanAdmin extends StatelessWidget {
  const HalamanAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dasbor Admin"),
        actions: [
          // Tambahan tombol logout untuk admin
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Menu Pengelolaan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 20),
          
          // Menu 1: Edit Data Admin
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.brown),
              title: const Text("Edit Data Admin", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Arahkan ke halaman form edit data admin nantinya
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Membuka menu Edit Data Admin..."))
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanDaftarAdmin()),
                );
              },
            ),
          ),
          
          const SizedBox(height: 10),

          // Menu 2: Edit Data Anggota
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.people, color: Colors.brown),
              title: const Text("Edit Data Anggota", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Arahkan ke halaman form edit data anggota nantinya
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Membuka menu Edit Data Anggota..."))
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanDaftarAnggota()),
                );
              },
            ),
          ),
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.dvr, color: Colors.brown),
              title: const Text("Edit Data Non Anggota", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Kelola Provinsi, Rumah Biara, Uskup, & Alamat"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanDataNonAnggota()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
