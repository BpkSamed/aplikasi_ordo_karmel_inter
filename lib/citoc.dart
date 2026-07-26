import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

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
  Future<void> _bukaTautan(String urlString, BuildContext context, AppLocalizations t) async {
    final Uri url = Uri.parse(urlString);
    
    try {
      // mode externalApplication memaksa link terbuka di browser asli HP (Chrome/Safari)
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Tidak dapat membuka $urlString');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.linkOpenError ?? "Gagal membuka tautan. Pastikan format link benar."))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // Inisialisasi lokalisasi

    return Scaffold(
      appBar: AppBar(
        title: Text(t.citocNewsTitle ?? "CITOC News"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchCitoc),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          if (_beritaCitoc.isEmpty) {
            return Center(
              child: Text(
                t.noCitocNews ?? "Belum ada rilis berita saat ini.",
                style: TextStyle(fontSize: baseWidth * 0.04),
              )
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _beritaCitoc.length,
            itemBuilder: (context, index) {
              final berita = _beritaCitoc[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: baseWidth * 0.04, 
                    vertical: baseWidth * 0.04
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown,
                    radius: baseWidth * 0.065, 
                    child: Icon(Icons.public, color: Colors.white, size: baseWidth * 0.07),
                  ),
                  title: Text(
                    berita['title'] ?? t.latestNews ?? 'Berita Terbaru', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: baseWidth * 0.015),
                    child: Text(
                      t.tapToReadMore ?? "Ketuk untuk membaca selengkapnya...", 
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: baseWidth * 0.035)
                    ),
                  ),
                  trailing: Icon(Icons.open_in_browser, color: Colors.blue, size: baseWidth * 0.06),
                  onTap: () {
                    if (berita['url'] != null) {
                      _bukaTautan(berita['url'], context, t);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}