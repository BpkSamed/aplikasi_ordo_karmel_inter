import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data_non_anggota.dart'; // Import form tambah data

class HalamanDaftarDataNonAnggota extends StatefulWidget {
  const HalamanDaftarDataNonAnggota({super.key});

  @override
  State<HalamanDaftarDataNonAnggota> createState() => _HalamanDaftarDataNonAnggotaState();
}

class _HalamanDaftarDataNonAnggotaState extends State<HalamanDaftarDataNonAnggota> {
  final _supabase = Supabase.instance.client;
  int _refreshKey = 0; // Kunci untuk me-refresh FutureBuilder saat data dihapus

  void _refreshData() {
    setState(() {
      _refreshKey++;
    });
  }

  // Fungsi Global untuk menghapus data dengan Dialog Konfirmasi
  Future<void> _deleteData(String table, int id, String itemName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus data '$itemName'?\n\nPeringatan: Data yang terhubung mungkin akan ikut terhapus atau kehilangan relasinya."),
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
      try {
        await _supabase.from(table).delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data '$itemName' berhasil dihapus.")));
          _refreshData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menghapus data: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daftar Data Non-Anggota"),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.location_on), text: "Alamat"),
              Tab(icon: Icon(Icons.domain), text: "Entitas"),
              Tab(icon: Icon(Icons.home), text: "Biara"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListAlamat(),
            _buildListEntitas(),
            _buildListBiara(),
          ],
        ),
        
        // TOMBOL TAMBAH DATA MENGARAH KE FORM 'data_non_anggota.dart'
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text("Tambah Data"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HalamanDataNonAnggota()),
            );
            // Otomatis refresh jika admin kembali dari halaman tambah
            _refreshData();
          },
        ),
      ),
    );
  }

  // ================= TAB 1: DAFTAR ALAMAT =================
  Widget _buildListAlamat() {
    return FutureBuilder<List<dynamic>>(
      key: ValueKey("alamat_$_refreshKey"),
      future: _supabase.from('addresses').select().order('id', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Belum ada data alamat.");

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final addr = snapshot.data![index];
            final title = addr['city'] != null ? "${addr['city']}, ${addr['country']}" : "Tanpa Kota";
            return _buildListItem(
              title: title,
              subtitle: "${addr['street'] ?? '-'} • ${addr['house_name'] ?? ''}",
              onEdit: () => _showEditPlaceholder(),
              onDelete: () => _deleteData('addresses', addr['id'], title),
            );
          },
        );
      },
    );
  }

  // ================= TAB 2: DAFTAR ENTITAS =================
  Widget _buildListEntitas() {
    return FutureBuilder<List<dynamic>>(
      key: ValueKey("entitas_$_refreshKey"),
      future: _supabase.from('entities').select('*, addresses(city)').order('name', ascending: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Belum ada data entitas.");

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final entity = snapshot.data![index];
            return _buildListItem(
              title: entity['name'] ?? 'Tanpa Nama',
              subtitle: "${entity['entity_category']} ${entity['ministry_type'] != null ? '(${entity['ministry_type']})' : ''}\nPusat: ${entity['addresses']?['city'] ?? '-'}",
              onEdit: () => _showEditPlaceholder(),
              onDelete: () => _deleteData('entities', entity['id'], entity['name']),
            );
          },
        );
      },
    );
  }

  // ================= TAB 3: DAFTAR BIARA =================
  Widget _buildListBiara() {
    return FutureBuilder<List<dynamic>>(
      key: ValueKey("biara_$_refreshKey"),
      future: _supabase.from('conventus').select('*, entities(name), addresses(city)').order('name', ascending: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Belum ada data biara.");

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final conventus = snapshot.data![index];
            return _buildListItem(
              title: conventus['name'] ?? 'Tanpa Nama',
              subtitle: "Induk: ${conventus['entities']?['name'] ?? '-'}\nLokasi: ${conventus['addresses']?['city'] ?? '-'}",
              onEdit: () => _showEditPlaceholder(),
              onDelete: () => _deleteData('conventus', conventus['id'], conventus['name']),
            );
          },
        );
      },
    );
  }

  // ================= WIDGET HELPER =================
  Widget _buildListItem({required String title, required String subtitle, required VoidCallback onEdit, required VoidCallback onDelete}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: "Edit",
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Hapus",
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur form Edit akan diimplementasikan menyusul.")));
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator(color: Colors.brown));
  Widget _buildError(Object? error) => Center(child: Text("Error: $error", style: const TextStyle(color: Colors.red)));
  Widget _buildEmpty(String msg) => Center(child: Text(msg, style: const TextStyle(color: Colors.grey)));
}