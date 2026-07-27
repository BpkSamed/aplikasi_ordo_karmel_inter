import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_episcopi.dart'; // Impor form tambah/edit uskup
import 'l10n/app_localizations.dart';

class HalamanDaftarEpiscopi extends StatefulWidget {
  const HalamanDaftarEpiscopi({super.key});

  @override
  State<HalamanDaftarEpiscopi> createState() => _HalamanDaftarEpiscopiState();
}

class _HalamanDaftarEpiscopiState extends State<HalamanDaftarEpiscopi> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _episcopiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEpiscopi();
  }

  Future<void> _fetchEpiscopi() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('episcopi')
          .select('*')
          .order('name', ascending: true);
      
      if (mounted) {
        setState(() => _episcopiList = response as List<dynamic>);
      }
    } catch (e) {
      debugPrint("Gagal mengambil data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _hapusEpiscopus(int id, String nama, AppLocalizations t, double baseWidth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.deleteEpiscopusConfirmTitle ?? "Konfirmasi Hapus", style: TextStyle(fontSize: baseWidth * 0.045)),
        content: Text(t.deleteEpiscopusConfirmMsg(nama), style: TextStyle(fontSize: baseWidth * 0.038)),
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
      try {
        await _supabase.from('episcopi').delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.deleteEpiscopusSuccess(nama))));
        }
        _fetchEpiscopi();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.deleteMemberError(e.toString()))));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.episcopiListTitle ?? "Daftar Uskup"),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchEpiscopi)],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) return const Center(child: CircularProgressIndicator(color: Colors.brown));

          if (_episcopiList.isEmpty) {
            return Center(child: Text(t.noEpiscopusDataAdded ?? "Belum ada data.", style: TextStyle(fontSize: baseWidth * 0.038)));
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _episcopiList.length,
            itemBuilder: (context, index) {
              final epi = _episcopiList[index];
              return Card(
                margin: EdgeInsets.only(bottom: baseWidth * 0.02),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.brown, child: Icon(Icons.account_balance, color: Colors.white, size: baseWidth * 0.05)),
                  title: Text(epi['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)),
                  subtitle: Text("${t.episcopusTitle ?? 'Uskup'}: ${epi['diocese'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue, size: baseWidth * 0.05),
                        onPressed: () { /* Navigasi ke edit */ },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: baseWidth * 0.05),
                        onPressed: () => _hapusEpiscopus(epi['id'], epi['name'], t, baseWidth),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(t.addEpiscopusBtn ?? "Tambah Uskup", style: const TextStyle(color: Colors.white)),
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HalamanTambahEpiscopi()),
          );
          if (refresh == true) _fetchEpiscopi();
        },
      ),
    );
  }
}