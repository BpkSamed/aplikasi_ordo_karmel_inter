import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

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
      
      if (mounted) {
        setState(() {
          _beritaCitoc = response;
        });
      }
    } catch (e) {
      debugPrint("Error fetching CITOC: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteCitoc(int id, AppLocalizations t, double baseWidth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.deleteNewsTitle ?? "Hapus Berita", style: TextStyle(fontSize: baseWidth * 0.045)),
        content: Text(t.deleteNewsConfirmMsg ?? "Apakah Anda yakin ingin menghapus tautan berita ini?", style: TextStyle(fontSize: baseWidth * 0.038)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancelButton ?? "Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.deleteButton ?? "Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabase.from('citoc_news').delete().eq('id', id);
        _fetchCitoc();
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.newsDeletedSuccess ?? "Berita dihapus.")));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.operationFailed(e.toString()))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.manageCitocNewsTitle ?? "Kelola Berita CITOC")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          if (_beritaCitoc.isEmpty) {
            return Center(
              child: Text(
                t.noCitocNewsYet ?? "Belum ada berita CITOC.",
                style: TextStyle(fontSize: baseWidth * 0.04, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _beritaCitoc.length,
            itemBuilder: (context, index) {
              final berita = _beritaCitoc[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02), // Margin antar kotak
                elevation: 2,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.03),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown,
                    radius: baseWidth * 0.06, 
                    child: Icon(Icons.newspaper, color: Colors.white, size: baseWidth * 0.065),
                  ),
                  title: Text(
                    berita['title'] ?? (t.noTitle ?? 'Tanpa Judul'), 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: baseWidth * 0.015),
                    child: Text(
                      berita['url'] ?? '-', 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis, 
                      style: TextStyle(color: Colors.blue, fontSize: baseWidth * 0.035)
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- TOMBOL EDIT ---
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue, size: baseWidth * 0.06),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanFormCitoc(initialData: berita),
                            ),
                          );
                          if (result == true) _fetchCitoc();
                        },
                      ),
                      // --- TOMBOL HAPUS ---
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: baseWidth * 0.06),
                        onPressed: () => _deleteCitoc(berita['id'], t, baseWidth),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final baseWidth = MediaQuery.of(context).size.width;
          return FloatingActionButton.extended(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            icon: Icon(Icons.add, size: baseWidth * 0.05),
            label: Text(t.addNewsBtn ?? "Tambah Berita", style: TextStyle(fontSize: baseWidth * 0.038)),
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanFormCitoc()));
              if (result == true) _fetchCitoc();
            },
          );
        }
      ),
    );
  }
}

/// =================================================================
/// FORM TAMBAH / EDIT BERITA CITOC
/// =================================================================
class HalamanFormCitoc extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const HalamanFormCitoc({super.key, this.initialData});

  @override
  State<HalamanFormCitoc> createState() => _HalamanFormCitocState();
}

class _HalamanFormCitocState extends State<HalamanFormCitoc> {
  final _supabase = Supabase.instance.client;
  final _titleCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _isEdit => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    // Mengisi data awal jika mode Edit
    if (_isEdit) {
      _titleCtrl.text = widget.initialData!['title'] ?? '';
      _urlCtrl.text = widget.initialData!['url'] ?? '';
    }
  }

  Future<void> _submit(AppLocalizations t) async {
    if (_titleCtrl.text.isEmpty || _urlCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.titleAndUrlRequired ?? "Judul dan Tautan Web (URL) wajib diisi!")));
      return;
    }

    // Validasi sederhana agar link selalu dimulai dengan http/https
    String finalUrl = _urlCtrl.text.trim();
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }

    setState(() => _isLoading = true);
    try {
      if (_isEdit) {
        // Proses Update Data
        await _supabase.from('citoc_news').update({
          'title': _titleCtrl.text,
          'url': finalUrl,
        }).eq('id', widget.initialData!['id']);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.newsUpdateSuccess ?? "Berita berhasil diperbarui!")));
          Navigator.pop(context, true);
        }
      } else {
        // Proses Tambah Data Baru
        await _supabase.from('citoc_news').insert({
          'title': _titleCtrl.text,
          'url': finalUrl,
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.newsAddSuccess ?? "Berita berhasil ditambahkan!")));
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.operationFailed(e.toString()))));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? (t.editCitocNewsTitle ?? "Edit Berita CITOC") : (t.addNewNewsTitle ?? "Tambah Berita Baru"))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Padding(
            padding: EdgeInsets.all(baseWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: t.newsTitleLabel ?? "Judul Berita", 
                    border: const OutlineInputBorder()
                  ),
                ),
                SizedBox(height: baseWidth * 0.04),
                TextField(
                  controller: _urlCtrl,
                  decoration: InputDecoration(
                    labelText: t.webLinkLabel ?? "Tautan Web (Link URL)", 
                    hintText: t.webLinkHint ?? "Contoh: https://ocarm.org/news", 
                    border: const OutlineInputBorder()
                  ),
                ),
                SizedBox(height: baseWidth * 0.05),
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown, 
                          foregroundColor: Colors.white, 
                          padding: EdgeInsets.symmetric(vertical: baseWidth * 0.035)
                        ),
                        onPressed: () => _submit(t),
                        child: Text(
                          _isEdit ? (t.saveChangesBtn ?? "SIMPAN PERUBAHAN") : (t.saveNewsBtn ?? "SIMPAN BERITA"), 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
                        ),
                      )
              ],
            ),
          );
        }
      ),
    );
  }
}