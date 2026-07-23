import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanKelolaCitoc extends StatefulWidget {
  const HalamanKelolaCitoc({super.key});

  @override
  State<HalamanKelolaCitoc> createState() => _HalamanKelolaCitocState();
}

class _HalamanKelolaCitocState extends State<HalamanKelolaCitoc> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _beritaCitoc = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCitoc();
  }

  Future<void> _fetchCitoc() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('citoc_news')
          .select()
          .order('id', ascending: false);
      setState(() {
        _beritaCitoc = response;
      });
    } catch (e) {
      debugPrint("Error fetching CITOC: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCitoc(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Berita"),
        content: const Text("Apakah Anda yakin ingin menghapus tautan berita ini?"),
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
        await _supabase.from('citoc_news').delete().eq('id', id);
        _fetchCitoc();
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berita dihapus.")));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Berita CITOC")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _beritaCitoc.isEmpty
              ? const Center(child: Text("Belum ada berita CITOC."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _beritaCitoc.length,
                  itemBuilder: (context, index) {
                    final berita = _beritaCitoc[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.newspaper, color: Colors.brown),
                        title: Text(berita['title'] ?? 'Tanpa Judul', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(berita['url'] ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blue)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCitoc(berita['id']),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Berita"),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanFormCitoc()));
          if (result == true) _fetchCitoc();
        },
      ),
    );
  }
}

/// =================================================================
/// FORM TAMBAH BERITA CITOC
/// =================================================================
class HalamanFormCitoc extends StatefulWidget {
  const HalamanFormCitoc({super.key});

  @override
  State<HalamanFormCitoc> createState() => _HalamanFormCitocState();
}

class _HalamanFormCitocState extends State<HalamanFormCitoc> {
  final _supabase = Supabase.instance.client;
  final _titleCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _urlCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Judul dan Tautan Web (URL) wajib diisi!")));
      return;
    }

    // Validasi sederhana agar link selalu dimulai dengan http/https
    String finalUrl = _urlCtrl.text.trim();
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }

    setState(() => _isLoading = true);
    try {
      await _supabase.from('citoc_news').insert({
        'title': _titleCtrl.text,
        'url': finalUrl,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Berita Baru")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: "Judul Berita", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _urlCtrl,
              decoration: const InputDecoration(labelText: "Tautan Web (Link URL)", hintText: "Contoh: https://ocarm.org/news", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: _submit,
                    child: const Text("SIMPAN BERITA", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
          ],
        ),
      ),
    );
  }
}