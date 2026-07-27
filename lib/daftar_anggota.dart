import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart';
import 'l10n/app_localizations.dart';

class HalamanDaftarAnggota extends StatefulWidget {
  const HalamanDaftarAnggota({super.key});

  @override
  State<HalamanDaftarAnggota> createState() => _HalamanDaftarAnggotaState();
}

class _HalamanDaftarAnggotaState extends State<HalamanDaftarAnggota> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _members = [];
  List<dynamic> _filteredMembers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMembers() async {
    setState(() => _isLoading = true);
    try {
      // Mengambil data anggota beserta relasi entitas dan biara
      final response = await _supabase
          .from('members')
          .select('*, entities(name), conventus(name)')
          .order('full_name', ascending: true);

      setState(() {
        _members = response;
        _filterMembers(_searchQuery);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching members: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterMembers(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredMembers = List.from(_members);
    } else {
      _filteredMembers = _members.where((member) {
        final name = (member['full_name'] ?? '').toString().toLowerCase();
        final role = (member['role'] ?? '').toString().toLowerCase();
        final vocation = (member['vocation_status'] ?? '').toString().toLowerCase();
        final q = query.toLowerCase();
        return name.contains(q) || role.contains(q) || vocation.contains(q);
      }).toList();
    }
  }

  // --- FUNGSI EDIT DATA ANGGOTA ---
  Future<void> _editMember(Map<String, dynamic> memberData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanTambahAnggota(
          initialData: memberData,
        ),
      ),
    );

    // Jika proses edit berhasil (mengembalikan true), muat ulang data dari database
    if (result == true) {
      _fetchMembers();
    }
  }

  // --- FUNGSI HAPUS DATA ANGGOTA ---
  Future<void> _deleteMember(int id, AppLocalizations t) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.confirmDeleteTitle ?? "Konfirmasi Hapus"),
        content: Text(t.confirmDeleteMemberMsg ?? "Apakah Anda yakin ingin menghapus data anggota ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancelBtn ?? "Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.deleteBtn ?? "Hapus"),
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
            SnackBar(content: Text(t.memberDeleteSuccess ?? "Data anggota berhasil dihapus!")),
          );
        }
        _fetchMembers();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
          setState(() => _isLoading = false);
        }
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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HalamanTambahAnggota(),
                ),
              );
              if (result == true) {
                _fetchMembers();
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              // --- BARIS PENCARIAN ANGGOTA ---
              Padding(
                padding: EdgeInsets.all(baseWidth * 0.04),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.searchMemberHint ?? "Cari nama, peran, atau status...",
                    prefixIcon: const Icon(Icons.search, color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(baseWidth * 0.025),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: baseWidth * 0.03,
                      vertical: baseWidth * 0.025,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _filterMembers(val);
                    });
                  },
                ),
              ),

              // --- DAFTAR ANGGOTA (LISTVIEW) ---
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                    : _filteredMembers.isEmpty
                        ? Center(
                            child: Text(
                              t.dataNotFound ?? "Data anggota tidak ditemukan",
                              style: TextStyle(fontSize: baseWidth * 0.038, color: Colors.grey),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchMembers,
                            color: Colors.brown,
                            child: ListView.builder(
                              itemCount: _filteredMembers.length,
                              itemBuilder: (context, index) {
                                final member = _filteredMembers[index];
                                final photoUrl = member['photo_url'];
                                final entityName = member['entities'] != null ? member['entities']['name'] : '-';
                                final conventusName = member['conventus'] != null ? member['conventus']['name'] : null;

                                return Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: baseWidth * 0.04,
                                    vertical: baseWidth * 0.015,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(baseWidth * 0.03),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(baseWidth * 0.03),
                                    leading: CircleAvatar(
                                      radius: baseWidth * 0.07,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage: photoUrl != null && photoUrl.toString().isNotEmpty
                                          ? NetworkImage(photoUrl)
                                          : null,
                                      child: photoUrl == null || photoUrl.toString().isEmpty
                                          ? Icon(Icons.person, size: baseWidth * 0.07, color: Colors.white)
                                          : null,
                                    ),
                                    title: Text(
                                      member['full_name'] ?? '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: baseWidth * 0.04,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: baseWidth * 0.01),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${member['vocation_status'] ?? '-'} • ${member['role'] ?? 'Sodales'}",
                                            style: TextStyle(
                                              fontSize: baseWidth * 0.033,
                                              color: Colors.brown,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: baseWidth * 0.008),
                                          Text(
                                            conventusName != null ? "$entityName ($conventusName)" : entityName,
                                            style: TextStyle(
                                              fontSize: baseWidth * 0.032,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _editMember(member);
                                        } else if (value == 'delete') {
                                          _deleteMember(member['id'], t);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              const Icon(Icons.edit, color: Colors.blue, size: 20),
                                              const SizedBox(width: 8),
                                              Text(t.editBtn ?? "Edit"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              const Icon(Icons.delete, color: Colors.red, size: 20),
                                              const SizedBox(width: 8),
                                              Text(t.deleteBtn ?? "Hapus"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}