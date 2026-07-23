import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_episcopi.dart';

class HalamanDaftarEpiscopi extends StatefulWidget {
  const HalamanDaftarEpiscopi({super.key});

  @override
  State<HalamanDaftarEpiscopi> createState() => _HalamanDaftarEpiscopiState();
}

class _HalamanDaftarEpiscopiState extends State<HalamanDaftarEpiscopi> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _bishops = [];
  bool _isLoading = true;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _fetchBishops();
  }

  Future<void> _fetchBishops() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('episcopi')
          .select('*, addresses(*)')
          .order('name', ascending: true);
      setState(() {
        _bishops = response as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Error fetching bishops: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBishop(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus data Uskup '$name'?"),
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
        await _supabase.from('episcopi').delete().eq('id', id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data '$name' berhasil dihapus.")));
        _fetchBishops();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _bishops.where((b) {
      return (b['name'] ?? '').toString().toLowerCase().contains(_query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Data Uskup"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchBishops),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _query = val.toLowerCase()),
              decoration: const InputDecoration(
                labelText: "Cari Nama Uskup...",
                prefixIcon: Icon(Icons.search, color: Colors.brown),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : filtered.isEmpty
                    ? const Center(child: Text("Tidak ada data Uskup ditemukan."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final bishop = filtered[index];
                          final addr = bishop['addresses'];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ExpansionTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.brown,
                                child: Icon(Icons.shield, color: Colors.white),
                              ),
                              title: Text(bishop['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("Keuskupan: ${bishop['diocese'] ?? '-'}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteBishop(bishop['id'], bishop['name']),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow("Status", bishop['status']),
                                      _buildDetailRow("Asal Entitas", bishop['ex_carmelite_entity']),
                                      const Divider(),
                                      Text("Alamat Tinggal Resmi:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                      const SizedBox(height: 4),
                                      if (addr != null) ...[
                                        Text("${addr['house_name'] ?? ''} ${addr['street'] ?? ''}".trim()),
                                        Text("${addr['city'] ?? ''}, ${addr['country'] ?? ''} (${addr['postal_code'] ?? ''})"),
                                        Text("Telp: ${addr['telephone'] ?? '-'} • Email: ${addr['email'] ?? '-'}"),
                                      ] else
                                        const Text("Alamat belum diatur."),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Uskup"),
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HalamanTambahEpiscopi()),
          );
          if (refresh == true) _fetchBishops();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value?.toString() ?? '-'),
        ],
      ),
    );
  }
}