import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_admin.dart';
import 'l10n/app_localizations.dart';

class HalamanDaftarAdmin extends StatefulWidget {
  final int currentAdminId; // ID dari Admin yang sedang login

  const HalamanDaftarAdmin({super.key, required this.currentAdminId});

  @override
  State<HalamanDaftarAdmin> createState() => _HalamanDaftarAdminState();
}

class _HalamanDaftarAdminState extends State<HalamanDaftarAdmin> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _admins = [];

  // Konstanta untuk mengidentifikasi Master Admin di Database (Biasanya ID yang pertama dibuat)
  final int _masterAdminId = 1; 

  @override
  void initState() {
    super.initState();
    _fetchAdmins();
  }

  Future<void> _fetchAdmins() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase.from('admins').select().order('name');
      setState(() => _admins = response);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _hapusAdmin(int id, AppLocalizations t, double baseWidth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.deleteButton ?? "Hapus", style: TextStyle(fontSize: baseWidth * 0.045)),
        content: Text(t.deleteAdminConfirm ?? "Hapus admin ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancelButton ?? "Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.deleteButton ?? "Hapus", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _supabase.from('admins').delete().eq('id', id);
      _fetchAdmins();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.adminListTitle ?? "Daftar Admin")),
      body: LayoutBuilder(builder: (context, constraints) {
        final baseWidth = constraints.maxWidth;
        if (_isLoading) return const Center(child: CircularProgressIndicator(color: Colors.brown));

        return ListView.builder(
          padding: EdgeInsets.all(baseWidth * 0.04),
          itemCount: _admins.length,
          itemBuilder: (context, index) {
            final admin = _admins[index];
            
            final bool isThisMasterAdmin = admin['id'] == _masterAdminId;
            final bool isMe = admin['id'] == widget.currentAdminId;
            
            // Logika: 
            // - Jika data ini adalah Master Admin, HANYA pengguna itu sendiri (isMe) yang bisa menghapusnya/mengubahnya.
            // - Jika ini admin biasa, maka bisa dihapus.
            final bool canEditOrDelete = !isThisMasterAdmin || isMe;

            return Card(
              margin: EdgeInsets.only(bottom: baseWidth * 0.03),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isThisMasterAdmin ? Colors.amber : Colors.brown, 
                  child: Icon(
                    isThisMasterAdmin ? Icons.workspace_premium : Icons.person, 
                    color: Colors.white
                  )
                ),
                title: Row(
                  children: [
                    Text(
                      admin['name'], 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: baseWidth * 0.04,
                        color: isThisMasterAdmin ? Colors.amber[900] : Colors.black
                      )
                    ),
                    if (isThisMasterAdmin) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.amber)
                        ),
                        child: const Text('Master', style: TextStyle(fontSize: 10, color: Colors.brown, fontWeight: FontWeight.bold)),
                      )
                    ]
                  ],
                ),
                // Tombol aksi hanya akan dimunculkan jika yang sedang dilooping boleh diubah oleh user yang aktif
                trailing: canEditOrDelete 
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _hapusAdmin(admin['id'], t, baseWidth),
                    )
                  : null, 
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanTambahAdmin()));
          if (res == true) _fetchAdmins();
        },
      ),
    );
  }
}