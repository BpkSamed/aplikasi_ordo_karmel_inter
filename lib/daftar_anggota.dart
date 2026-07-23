import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart'; // Import form tambah anggota

class HalamanDaftarAnggota extends StatefulWidget {
  const HalamanDaftarAnggota({super.key});

  @override
  State<HalamanDaftarAnggota> createState() => _HalamanDaftarAnggotaState();
}

class _HalamanDaftarAnggotaState extends State<HalamanDaftarAnggota> {
  List<dynamic> _members = [];
  bool _isLoading = true;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  // Fungsi untuk mengambil data anggota dengan relasi inner join
  Future<void> _fetchMembers() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('members')
          .select('*, entities(name), conventus(name)')
          .order('full_name', ascending: true);
      
      setState(() {
        _members = response as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Error fetching members: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fitur filter berdasarkan nama
    final filteredMembers = _members.where((m) {
      return (m['full_name'] ?? '').toString().toLowerCase().contains(_query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Data Anggota"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMembers),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _query = val.toLowerCase()),
              decoration: const InputDecoration(
                labelText: "Cari Nama Anggota...",
                prefixIcon: Icon(Icons.search, color: Colors.brown),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.brown))
              : filteredMembers.isEmpty
                  ? const Center(child: Text("Belum ada data anggota."))
                  : ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown.shade100,
                              child: const Icon(Icons.person, color: Colors.brown),
                            ),
                            title: Text(member['full_name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("${member['vocation_status'] ?? 'Status (?)'} • ${member['entities']?['name'] ?? 'Belum ditentukan'}"),
                            trailing: const Icon(Icons.edit, size: 16),
                            onTap: () {
                              // TODO: Tambahkan navigasi edit data (update) ke depannya
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Edit menyusul")));
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      
      // TOMBOL INI YANG MENGARAH KE HALAMAN PENAMBAHAN
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Anggota"),
        onPressed: () async {
          // await menunggu konfirmasi jika ada anggota baru ditambahkan
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HalamanTambahAnggota()),
          );
          
          // Jika result == true (data berhasil disubmit), otomatis refresh tabel
          if (result == true) {
            _fetchMembers();
          }
        },
      ),
    );
  }
}