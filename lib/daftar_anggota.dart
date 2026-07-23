import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart'; // Impor halaman tambah anggota

class HalamanDaftarAnggota extends StatefulWidget {
  const HalamanDaftarAnggota({super.key});

  @override
  State<HalamanDaftarAnggota> createState() => _HalamanDaftarAnggotaState();
}

class _HalamanDaftarAnggotaState extends State<HalamanDaftarAnggota> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _membersList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('members')
          .select('*, conventus(name)')
          .order('full_name', ascending: true);
      
      setState(() {
        _membersList = response as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Gagal mengambil data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- FUNGSI HAPUS ANGGOTA ---
  Future<void> _hapusAnggota(int id, String nama) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus data anggota '$nama'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _supabase.from('members').delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data '$nama' berhasil dihapus.")));
        }
        _fetchMembers();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Anggota"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMembers),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _membersList.isEmpty
              ? const Center(child: Text("Belum ada data anggota."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _membersList.length,
                  itemBuilder: (context, index) {
                    final member = _membersList[index];
                    final String? photoUrl = member['photo_url'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        // Ruang dalam kotak diperbesar (~50% lebih tinggi)
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                        child: Row(
                          children: [
                            // --- FOTO PROFIL ---
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: photoUrl == null || photoUrl.isEmpty
                                  ? const Icon(Icons.person, size: 32, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 18),
                            
                            // --- IDENTITAS ANGGOTA ---
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    member['full_name'] ?? '-',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Asal: ${member['conventus']?['name'] ?? 'Belum ditentukan'}",
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                  ),
                                  if (member['date_of_birth'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "Lahir: ${member['city_of_birth'] ?? ''}, ${member['date_of_birth']}",
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            
                            // --- TOMBOL EDIT & HAPUS ---
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  tooltip: 'Edit Data',
                                  onPressed: () {
                                    // Arahkan ke halaman edit data jika ada
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Arahkan ke Halaman Edit")),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Hapus Data',
                                  onPressed: () => _hapusAnggota(member['id'], member['full_name']),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      // --- TOMBOL TAMBAH ANGGOTA BARU ---
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text("Tambah Anggota"),
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HalamanTambahAnggota()),
          );
          if (refresh == true) {
            _fetchMembers(); // Otomatis refresh daftar setelah menambah anggota baru
          }
        },
      ),
    );
  }
}