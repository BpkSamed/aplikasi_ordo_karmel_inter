import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanTambahEpiscopi extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Tambahkan untuk menerima data Edit

  const HalamanTambahEpiscopi({super.key, this.initialData});

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

  bool get _isEdit => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
    
    // Jika ada initialData (Mode Edit), isikan ke dalam form
    if (_isEdit) {
      final data = widget.initialData!;
      _nameCtrl.text = data['name'] ?? '';
      _dioceseCtrl.text = data['diocese'] ?? '';
      _exEntityCtrl.text = data['ex_carmelite_entity'] ?? '';
      _statusCtrl.text = data['status'] ?? '';
      _selectedAddressId = data['address_id'];
    }
  }

  // Mengambil daftar alamat master
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

  // Mendapatkan nama representasi alamat yang dipilih
  String _getSelectedAddressName() {
    if (_selectedAddressId == null) return "Belum memilih alamat (Opsional)";
    final addr = _addresses.firstWhere((a) => a['id'] == _selectedAddressId, orElse: () => null);
    if (addr != null) {
      final house = addr['house_name'] ?? '';
      return "$house ${addr['city']}, ${addr['country']}".trim();
    }
    return "Memuat Alamat...";
  }

  // Fungsi memunculkan dialog pencarian untuk Dropdown Alamat
  Future<void> _showSearchableAddressDialog() async {
    String searchQuery = "";
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final filtered = _addresses.where((a) {
              final house = a['house_name'] ?? '';
              final fullText = "$house ${a['city']} ${a['country']}".toLowerCase();
              return fullText.contains(searchQuery.toLowerCase());
            }).toList();

            return AlertDialog(
              title: const Text("Pilih Alamat Resmi"),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Cari nama kota, negara, atau rumah...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setStateDialog(() => searchQuery = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text("Alamat tidak ditemukan"))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final a = filtered[index];
                                final house = a['house_name'] ?? '';
                                final displayName = "$house ${a['city']}, ${a['country']}".trim();
                                return ListTile(
                                  title: Text(displayName),
                                  onTap: () {
                                    setState(() => _selectedAddressId = a['id']);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _selectedAddressId = null); // Opsi Hapus pilihan
                    Navigator.pop(context);
                  },
                  child: const Text("Kosongkan Pilihan", style: TextStyle(color: Colors.red)),
                ),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final payload = {
      'name': _nameCtrl.text,
      'diocese': _dioceseCtrl.text,
      'ex_carmelite_entity': _exEntityCtrl.text.isEmpty ? null : _exEntityCtrl.text,
      'status': _statusCtrl.text.isEmpty ? null : _statusCtrl.text,
      'address_id': _selectedAddressId,
    };

    try {
      if (_isEdit) {
        // Proses Update Data
        await _supabase.from('episcopi').update(payload).eq('id', widget.initialData!['id']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Uskup berhasil diperbarui!")));
          Navigator.pop(context, true);
        }
      } else {
        // Proses Tambah Data
        await _supabase.from('episcopi').insert(payload);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Uskup berhasil ditambahkan!")));
          Navigator.pop(context, true); 
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? "Edit Data Uskup" : "Tambah Data Uskup Baru")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isEdit ? "Formulir Edit Data Uskup" : "Formulir Data Uskup Baru",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
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
                    
                    // Custom Searchable Dropdown
                    InkWell(
                      onTap: _showSearchableAddressDialog,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Pilih Alamat Resmi (Opsional)",
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getSelectedAddressName(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _submitData,
                      child: Text(
                        _isEdit ? "SIMPAN PERUBAHAN" : "SIMPAN DATA USKUP", 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}