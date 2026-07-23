import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanTambahEpiscopi extends StatefulWidget {
  const HalamanTambahEpiscopi({super.key});

  @override
  State<HalamanTambahEpiscopi> createState() => _HalamanTambahEpiscopiState();
}

class _HalamanTambahEpiscopiState extends State<HalamanTambahEpiscopi> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers untuk input teks
  final _nameCtrl = TextEditingController();
  final _dioceseCtrl = TextEditingController();
  final _exEntityCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();

  // Variabel untuk relasi alamat
  int? _selectedAddressId;
  List<dynamic> _addresses = [];

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  // Mengambil daftar alamat master untuk pilihan dropdown
  Future<void> _fetchAddresses() async {
    try {
      final response = await _supabase
          .from('addresses')
          .select('id, house_name, city, country')
          .order('id', ascending: false);
      setState(() {
        _addresses = response;
      });
    } catch (e) {
      debugPrint("Gagal mengambil data alamat: $e");
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _supabase.from('episcopi').insert({
        'name': _nameCtrl.text,
        'diocese': _dioceseCtrl.text,
        'ex_carmelite_entity': _exEntityCtrl.text.isEmpty ? null : _exEntityCtrl.text,
        'status': _statusCtrl.text.isEmpty ? null : _statusCtrl.text,
        'address_id': _selectedAddressId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Uskup berhasil ditambahkan!")),
        );
        Navigator.pop(context, true); // Kembali ke halaman daftar dan kirim sinyal refresh
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Data Uskup Baru")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Formulir Data Uskup",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                    const SizedBox(height: 15),
                    
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: "Nama Lengkap Uskup (Wajib)", border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty ? "Nama tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _dioceseCtrl,
                      decoration: const InputDecoration(labelText: "Keuskupan / Diocese (Wajib)", border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty ? "Keuskupan tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _exEntityCtrl,
                      decoration: const InputDecoration(labelText: "Asal Entitas Karmel (Opsional)", hintText: "Contoh: Provinsi Indonesia", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _statusCtrl,
                      decoration: const InputDecoration(labelText: "Status Saat Ini (Opsional)", hintText: "Contoh: Aktif / Emeritus", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    
                    DropdownButtonFormField<int>(
                      value: _selectedAddressId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: "Pilih Alamat Resmi (Opsional)", border: OutlineInputBorder()),
                      items: _addresses.map((a) {
                        final house = a['house_name'] ?? '';
                        return DropdownMenuItem<int>(
                          value: a['id'],
                          child: Text("$house ${a['city']}, ${a['country']}".trim()),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedAddressId = val),
                    ),
                    const SizedBox(height: 25),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _submitData,
                      child: const Text("SIMPAN DATA USKUP", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}