import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

class HalamanTambahEpiscopi extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Parameter untuk mode edit

  const HalamanTambahEpiscopi({super.key, this.initialData});

  @override
  State<HalamanTambahEpiscopi> createState() => _HalamanTambahEpiscopiState();
}

class _HalamanTambahEpiscopiState extends State<HalamanTambahEpiscopi> {
  final _supabase = Supabase.instance.client;
  
  int? _editId; // Menyimpan ID jika dalam mode edit
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dioceseController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Jika masuk dalam mode Edit, isi form dengan data lama
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _editId = data['id'];
      _nameController.text = data['name'] ?? '';
      _dioceseController.text = data['diocese'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dioceseController.dispose();
    super.dispose();
  }

  Future<void> _submitData(AppLocalizations t) async {
    if (_nameController.text.trim().isEmpty || _dioceseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.mandatoryFieldsEmpty ?? "Semua kolom wajib diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final submitData = {
      'name': _nameController.text.trim(),
      'diocese': _dioceseController.text.trim(),
    };

    try {
      if (_editId != null) {
        // Mode UPDATE
        await _supabase.from('episcopi').update(submitData).eq('id', _editId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.episcopusUpdateSuccess ?? "Data Uskup berhasil diperbarui!")),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Mode INSERT
        await _supabase.from('episcopi').insert(submitData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.episcopusAddSuccess ?? "Data Uskup berhasil ditambahkan!")),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.errorSavingEpiscopus(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editId != null
              ? (t.editEpiscopusPageTitle ?? "Edit Data Uskup")
              : (t.addEpiscopusPageTitle ?? "Pendaftaran Uskup Baru"),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.brown),
                  SizedBox(height: baseWidth * 0.04),
                  Text(
                    t.processingData ?? "Memproses data...",
                    style: TextStyle(fontSize: baseWidth * 0.038, color: Colors.brown),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(baseWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: baseWidth * 0.02),
                
                // Form Input Nama Uskup
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: t.episcopusNameLabel ?? "Nama Uskup",
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: Colors.brown, size: baseWidth * 0.055),
                  ),
                ),
                SizedBox(height: baseWidth * 0.035),

                // Form Input Keuskupan
                TextField(
                  controller: _dioceseController,
                  decoration: InputDecoration(
                    labelText: t.dioceseLabel ?? "Keuskupan / Dioecesis",
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance, color: Colors.brown, size: baseWidth * 0.055),
                  ),
                ),
                SizedBox(height: baseWidth * 0.06),

                // Tombol Simpan / Update
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: baseWidth * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _submitData(t),
                  child: Text(
                    _editId != null
                        ? (t.updateEpiscopusBtn ?? "UPDATE USKUP")
                        : (t.saveEpiscopusBtn ?? "SIMPAN USKUP"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: baseWidth * 0.038,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}