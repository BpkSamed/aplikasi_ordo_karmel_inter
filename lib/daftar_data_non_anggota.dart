import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data_non_anggota.dart'; // Import form tambah/edit data
import 'l10n/app_localizations.dart'; // Import lokalisasi

class HalamanDaftarDataNonAnggota extends StatefulWidget {
  const HalamanDaftarDataNonAnggota({super.key});

  @override
  State<HalamanDaftarDataNonAnggota> createState() => _HalamanDaftarDataNonAnggotaState();
}

class _HalamanDaftarDataNonAnggotaState extends State<HalamanDaftarDataNonAnggota> {
  final _supabase = Supabase.instance.client;
  int _refreshKey = 0; // Kunci untuk me-refresh FutureBuilder saat data dihapus/diubah

  void _refreshData() {
    setState(() {
      _refreshKey++;
    });
  }

  // Fungsi Global untuk menghapus data dengan Dialog Konfirmasi
  Future<void> _deleteData(String table, int id, String itemName, AppLocalizations t) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final baseWidth = constraints.maxWidth;
            return AlertDialog(
              title: Text(t.deleteConfirmTitle ?? "Konfirmasi Hapus", style: TextStyle(fontSize: baseWidth * 0.05)),
              content: Text(
                t.deleteConfirmMessage(itemName),
                style: TextStyle(fontSize: baseWidth * 0.04),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), 
                  child: Text(t.cancelButton ?? "Batal", style: TextStyle(fontSize: baseWidth * 0.038))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(t.deleteButton ?? "Hapus", style: TextStyle(fontSize: baseWidth * 0.038)),
                ),
              ],
            );
          },
        );
      }
    );

    if (confirm == true) {
      try {
        await _supabase.from(table).delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.deleteSuccessMessage(itemName)))
          );
          _refreshData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.deleteErrorMessage(e.toString())))
          );
        }
      }
    }
  }

  // Navigasi ke Halaman Edit dengan membawa Data dan TabIndex yang sesuai
  Future<void> _navigateToEdit(Map<String, dynamic> data, int tabIndex) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanDataNonAnggota(
          initialData: data,
          initialTabIndex: tabIndex,
        ),
      ),
    );

    // Refresh daftar jika admin menyimpan/update data
    if (result == true) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.nonMemberDataListTitle ?? "Daftar Data Non-Anggota"),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: const Icon(Icons.location_on), text: t.tabAddress ?? "Alamat"),
              Tab(icon: const Icon(Icons.domain), text: t.tabEntity ?? "Entitas"),
              Tab(icon: const Icon(Icons.home), text: t.tabMonastery ?? "Biara"),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double baseWidth = constraints.maxWidth;

            return TabBarView(
              children: [
                _buildListAlamat(baseWidth, t),
                _buildListEntitas(baseWidth, t),
                _buildListBiara(baseWidth, t),
              ],
            );
          },
        ),
        
        // TOMBOL TAMBAH DATA MENGARAH KE FORM 'data_non_anggota.dart'
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(t.addDataButton ?? "Tambah Data"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HalamanDataNonAnggota()),
            );
            // Otomatis refresh jika admin kembali dari halaman tambah
            if (result == true) {
               _refreshData();
            }
          },
        ),
      ),
    );
  }

  // ================= TAB 1: DAFTAR ALAMAT =================
  Widget _buildListAlamat(double baseWidth, AppLocalizations t) {
    return FutureBuilder<List<dynamic>>(
      key: ValueKey("alamat_$_refreshKey"),
      future: _supabase.from('addresses').select().order('id', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noAddressData ?? "Belum ada data alamat.", baseWidth);

        return ListView.builder(
          padding: EdgeInsets.all(baseWidth * 0.03),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final addr = snapshot.data![index];
            final title = addr['city'] != null ? "${addr['city']}, ${addr['country']}" : (t.noCity ?? "Tanpa Kota");
            return _buildListItem(
              title: title,
              subtitle: "${addr['street'] ?? '-'} • ${addr['house_name'] ?? ''}",
              onEdit: () => _navigateToEdit(addr, 0), // TabIndex 0 untuk Alamat
              onDelete: () => _deleteData('addresses', addr['id'], title, t),
              baseWidth: baseWidth,
              t: t,
            );
          },
        );
      },
    );
  }

  // ================= TAB 2: DAFTAR ENTITAS =================
  Widget _buildListEntitas(double baseWidth, AppLocalizations t) {
    return FutureBuilder<List<dynamic>>(
      key: ValueKey("entitas_$_refreshKey"),
      future: _supabase.from('entities').select('*, addresses(city)').order('name', ascending: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noEntityData ?? "Belum ada data entitas.", baseWidth);

        return ListView.builder(
          padding: EdgeInsets.all(baseWidth * 0.03),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final entity = snapshot.data![index];
            return _buildListItem(
              title: entity['name'] ?? (t.noName ?? 'Tanpa Nama'),
              subtitle: "${entity['entity_category']} ${entity['ministry_type'] != null ? '(${entity['ministry_type']})' : ''}\n${t.centerHeadquarters ?? 'Pusat'}: ${entity['addresses']?['city'] ?? '-'}",
              onEdit: () => _navigateToEdit(entity, 1), // TabIndex 1 untuk Entitas
              onDelete: () => _deleteData('entities', entity['id'], entity['name'] ?? 'Entitas', t),
              baseWidth: baseWidth,
              t: t,
            );
          },
        );
      },
    );
  }

  // ================= TAB 3: DAFTAR BIARA =================
  Widget _buildListBiara(double baseWidth, AppLocalizations t) {
    return FutureBuilder<List<dynamic>>(
      key: ValueKey("biara_$_refreshKey"),
      future: _supabase.from('conventus').select('*, entities(name), addresses(city)').order('name', ascending: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noMonasteryData ?? "Belum ada data biara.", baseWidth);

        return ListView.builder(
          padding: EdgeInsets.all(baseWidth * 0.03),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final conventus = snapshot.data![index];
            return _buildListItem(
              title: conventus['name'] ?? (t.noName ?? 'Tanpa Nama'),
              subtitle: "${t.parentInduk ?? 'Induk'}: ${conventus['entities']?['name'] ?? '-'}\n${t.location ?? 'Lokasi'}: ${conventus['addresses']?['city'] ?? '-'}",
              onEdit: () => _navigateToEdit(conventus, 2), // TabIndex 2 untuk Biara
              onDelete: () => _deleteData('conventus', conventus['id'], conventus['name'] ?? 'Biara', t),
              baseWidth: baseWidth,
              t: t,
            );
          },
        );
      },
    );
  }

  // ================= WIDGET HELPER =================
  Widget _buildListItem({
    required String title, 
    required String subtitle, 
    required VoidCallback onEdit, 
    required VoidCallback onDelete, 
    required double baseWidth,
    required AppLocalizations t,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02), // Margin responsif
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.03),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: baseWidth * 0.01),
          child: Text(subtitle, style: TextStyle(fontSize: baseWidth * 0.032, height: 1.3)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue, size: baseWidth * 0.055),
              onPressed: onEdit,
              tooltip: t.editTooltip ?? "Edit",
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: baseWidth * 0.055),
              onPressed: onDelete,
              tooltip: t.deleteButton ?? "Hapus",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator(color: Colors.brown));
  
  Widget _buildError(Object? error, AppLocalizations t, double baseWidth) => Center(
    child: Text(
      "Error: $error", 
      style: TextStyle(color: Colors.red, fontSize: baseWidth * 0.035)
    )
  );
  
  Widget _buildEmpty(String msg, double baseWidth) => Center(
    child: Text(
      msg, 
      style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.038)
    )
  );
}