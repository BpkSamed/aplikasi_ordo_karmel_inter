import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_admin.dart'; // Import halaman tambah admin

// Model data untuk Admin
class AdminData {
  final int id;
  final String name;
  final String createdAt;

  AdminData({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory AdminData.fromMap(Map<String, dynamic> map) {
    return AdminData(
      id: map['id'],
      name: map['name'] ?? 'Tanpa Nama',
      // Memotong string waktu agar hanya menampilkan format YYYY-MM-DD
      createdAt: map['created_at'] != null ? map['created_at'].toString().substring(0, 10) : '-',
    );
  }
}

/// =================================================================
/// HALAMAN DAFTAR ADMIN (TERKONEKSI DATABASE SUPABASE)
/// =================================================================
class HalamanDaftarAdmin extends StatefulWidget {
  const HalamanDaftarAdmin({super.key});

  @override
  State<HalamanDaftarAdmin> createState() => _HalamanDaftarAdminState();
}

class _HalamanDaftarAdminState extends State<HalamanDaftarAdmin> {
  List<AdminData> _allAdmins = [];
  List<AdminData> _filteredAdmins = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDataAdmin(); // Ambil data saat halaman pertama kali dibuka
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // FUNGSI 1: MENGAMBIL DATA DARI TABEL 'admins'
  Future<void> _fetchDataAdmin() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('admins')
          .select('id, name, created_at') // Password sengaja tidak di-select demi keamanan
          .order('name', ascending: true);

      final List<AdminData> loadedData = (response as List<dynamic>)
          .map((e) => AdminData.fromMap(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _allAdmins = loadedData;
        _filterList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data admin: $e"), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  // Fungsi Search Lokal
  void _filterList() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAdmins = _allAdmins.where((admin) {
        return admin.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  // FUNGSI 2: MENGHAPUS DATA ADMIN DENGAN AMAN
  void _deleteAdmin(AdminData admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun Admin"),
        content: Text("Apakah Anda yakin ingin mencabut hak akses dan menghapus akun '${admin.name}' secara permanen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              // Simpan referensi sebelum pop/await agar tidak crash
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              navigator.pop(); // Tutup dialog konfirmasi

              try {
                await Supabase.instance.client
                    .from('admins')
                    .delete()
                    .eq('id', admin.id); // Hapus berdasarkan ID

                messenger.showSnackBar(
                  SnackBar(content: Text("Akun admin '${admin.name}' berhasil dihapus.")),
                );
                
                _fetchDataAdmin(); // Segarkan daftar setelah dihapus
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text("Gagal menghapus admin: $e"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Akun Admin"),
      ),
      body: Column(
        children: [
          // 1. Fitur Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Cari Nama Admin...",
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
            ),
          ),

          // 2. Daftar Admin (ListView)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : _filteredAdmins.isEmpty
                    ? const Center(child: Text("Tidak ada akun admin yang terdaftar."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _filteredAdmins.length,
                        itemBuilder: (context, index) {
                          final admin = _filteredAdmins[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              leading: const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.brown,
                                child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
                              ),
                              title: Text(
                                admin.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text("Ditambahkan pada: ${admin.createdAt}"),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: "Hapus Admin",
                                onPressed: () => _deleteAdmin(admin),
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // 3. Tombol Tambah Admin Baru
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Arahkan ke form, lalu segarkan data saat kembali
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanTambahAdmin()),
                ).then((_) {
                  // Fungsi ini akan dipanggil saat pengguna menekan tombol 'Back' dari form
                  _fetchDataAdmin();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "TAMBAH ADMIN BARU",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}