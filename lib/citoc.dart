import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanCitoc extends StatefulWidget {
  const HalamanCitoc({super.key});

  @override
  State<HalamanCitoc> createState() => _HalamanCitocState();
}

class _HalamanCitocState extends State<HalamanCitoc> {
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
          .order('id', ascending: false); // Mengurutkan dari berita terbaru
      setState(() {
        _beritaCitoc = response;
      });
    } catch (e) {
      debugPrint("Error fetching CITOC: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fungsi sakti untuk membuka tautan/URL
  Future<void> _bukaTautan(String urlString) async {
    final Uri url = Uri.parse(urlString);
    
    try {
      // mode externalApplication memaksa link terbuka di browser asli HP (Chrome/Safari)
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Tidak dapat membuka $urlString');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal membuka tautan. Pastikan format link benar.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CITOC News"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchCitoc),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _beritaCitoc.isEmpty
              ? const Center(child: Text("Belum ada rilis berita saat ini."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _beritaCitoc.length,
                  itemBuilder: (context, index) {
                    final berita = _beritaCitoc[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.brown,
                          child: Icon(Icons.public, color: Colors.white),
                        ),
                        title: Text(berita['title'] ?? 'Berita Terbaru', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text("Ketuk untuk membaca selengkapnya...", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                        trailing: const Icon(Icons.open_in_browser, color: Colors.blue),
                        onTap: () {
                          if (berita['url'] != null) {
                            _bukaTautan(berita['url']);
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}