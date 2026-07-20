import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN TAMBAH DATA ADMIN LENGKAP (TERKONEKSI DATABASE)
/// =================================================================
class HalamanTambahAdmin extends StatefulWidget {
  const HalamanTambahAdmin({super.key});

  @override
  State<HalamanTambahAdmin> createState() => _HalamanTambahAdminState();
}

class _HalamanTambahAdminState extends State<HalamanTambahAdmin> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controller hanya untuk Nama dan Password sesuai kebutuhan
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // FUNGSI UTAMA: MENYIMPAN DATA ADMIN BARU KE SUPABASE
  Future<void> _simpanAdminKeDatabase() async {
    final nama = _nameController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi form dasar
    if (nama.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi Nama dan Password terlebih dahulu!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      // Jalankan perintah INSERT langsung ke tabel 'admins'
      await supabase.from('admins').insert({
        'name': nama,
        'password': password,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Admin baru '$nama' berhasil didaftarkan!")),
        );
        // Kembali ke halaman dasbor admin sebelumnya
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mendaftarkan admin: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Admin Baru"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pendaftaran Akun Admin",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Akun ini akan memiliki hak akses penuh untuk mengelola direktori.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // 1. INPUT NAMA ADMIN
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Admin / Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_add),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. INPUT PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Menyembunyikan ketikan password
                  decoration: const InputDecoration(
                    labelText: "Password Akses",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                    helperText: "Gunakan kombinasi password yang aman.",
                  ),
                ),
                const SizedBox(height: 40),

                // 3. TOMBOL SIMPAN DATA
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _simpanAdminKeDatabase,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "DAFTARKAN ADMIN BARU",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}