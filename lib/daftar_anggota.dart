import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart'; // Impor halaman tambah anggota
import 'l10n/app_localizations.dart'; // Import lokalisasi

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
      
      if (mounted) {
        setState(() {
          _membersList = response as List<dynamic>;
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- FUNGSI HAPUS ANGGOTA ---
  Future<void> _hapusAnggota(int id, String nama, AppLocalizations t, double baseWidth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.deleteMemberConfirmTitle ?? "Konfirmasi Hapus", style: TextStyle(fontSize: baseWidth * 0.045)),
        content: Text(
          t.deleteMemberConfirmMsg(nama), 
          style: TextStyle(fontSize: baseWidth * 0.038)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: Text(t.cancelButton ?? "Batal", style: TextStyle(fontSize: baseWidth * 0.035))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.deleteButton ?? "Hapus", style: TextStyle(fontSize: baseWidth * 0.035)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _supabase.from('members').delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.deleteMemberSuccess(nama)))
          );
        }
        _fetchMembers();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.deleteMemberError(e.toString())))
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.memberListTitle ?? "Daftar Anggota"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMembers),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          if (_membersList.isEmpty) {
            return Center(
              child: Text(
                t.noMemberDataAdded ?? "Belum ada data anggota.",
                style: TextStyle(fontSize: baseWidth * 0.038, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _membersList.length,
            itemBuilder: (context, index) {
              final member = _membersList[index];
              final String? photoUrl = member['photo_url'];

              return Card(
                margin: EdgeInsets.only(bottom: baseWidth * 0.03),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.045),
                  child: Row(
                    children: [
                      // --- FOTO PROFIL ---
                      CircleAvatar(
                        radius: baseWidth * 0.08,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl == null || photoUrl.isEmpty
                            ? Icon(Icons.person, size: baseWidth * 0.08, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: baseWidth * 0.04),
                      
                      // --- IDENTITAS ANGGOTA ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              member['full_name'] ?? '-',
                              style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: baseWidth * 0.015),
                            Text(
                              "${t.originPrefix ?? 'Asal'}: ${member['conventus']?['name'] ?? (t.notDetermined ?? 'Belum ditentukan')}",
                              style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.grey.shade700),
                            ),
                            if (member['date_of_birth'] != null) ...[
                              SizedBox(height: baseWidth * 0.01),
                              Text(
                                "${t.bornPrefix ?? 'Lahir'}: ${member['city_of_birth'] ?? ''}, ${member['date_of_birth']}",
                                style: TextStyle(fontSize: baseWidth * 0.032, color: Colors.grey.shade600),
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
                            icon: Icon(Icons.edit, color: Colors.blue, size: baseWidth * 0.06),
                            tooltip: t.editDataTooltip ?? 'Edit Data',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.goToEditPageMsg ?? "Arahkan ke Halaman Edit")),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red, size: baseWidth * 0.06),
                            tooltip: t.deleteDataTooltip ?? 'Hapus Data',
                            onPressed: () => _hapusAnggota(member['id'], member['full_name'], t, baseWidth),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // --- TOMBOL TAMBAH ANGGOTA BARU ---
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = MediaQuery.of(context).size.width;
          return FloatingActionButton.extended(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            icon: Icon(Icons.person_add, size: baseWidth * 0.05),
            label: Text(
              t.addMemberBtn ?? "Tambah Anggota", 
              style: TextStyle(fontSize: baseWidth * 0.038)
            ),
            onPressed: () async {
              final refresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanTambahAnggota()),
              );
              if (refresh == true) {
                _fetchMembers(); // Otomatis refresh daftar setelah menambah anggota baru
              }
            },
          );
        }
      ),
    );
  }
}