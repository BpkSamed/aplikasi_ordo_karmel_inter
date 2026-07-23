import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanDataNonAnggota extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final int initialTabIndex;

  const HalamanDataNonAnggota({
    super.key, 
    this.initialData, 
    this.initialTabIndex = 0
  });

  @override
  State<HalamanDataNonAnggota> createState() => _HalamanDataNonAnggotaState();
}

class _HalamanDataNonAnggotaState extends State<HalamanDataNonAnggota> with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  late TabController _tabController;
  
  // Data untuk Dropdown
  List<dynamic> _addresses = [];
  List<dynamic> _entities = [];

  // ID Mode Edit
  int? _editAlamatId;
  int? _editEntitasId;
  int? _editBiaraId;

  // Controllers untuk TAB 1: ALAMAT
  final _houseNameCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // Controllers & Variabel untuk TAB 2: ENTITAS
  final _entityNameCtrl = TextEditingController();
  final _historiaCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  String? _selectedCategory;
  String? _selectedMinistryType;
  int? _selectedAddressForEntity;
  final _entityAddressDisplayCtrl = TextEditingController(); // TAMBAHAN: Untuk teks penampil alamat entitas

  final List<String> _entityCategories = [
    'Provincia', 'Commissariatus Generalis', 'Delegatio Generalis', 
    'Moniales', 'Heremiti', 'Instituta', 'Ministries','Monasteria Ordinis','Heremitae'
  ];
  final List<String> _ministryTypes = [
    'Parishes', 'Elementary School', 'Secondary School', 'Academy', 
    'University / Institute', 'Retreat Centers', 'Spirituality Institute', 
    'Social Ministries', 'Libraries', 'Hospitals / Clinics'
  ];

  // Controllers & Variabel untuk TAB 3: BIARA (CONVENTUS)
  final _conventusNameCtrl = TextEditingController();
  int? _selectedParentEntity;
  final _conventusParentDisplayCtrl = TextEditingController(); // TAMBAHAN: Untuk teks penampil induk entitas
  int? _selectedAddressForConventus;
  final _conventusAddressDisplayCtrl = TextEditingController(); // TAMBAHAN: Untuk teks penampil alamat biara

  bool _isLoading = true; // Set true di awal untuk memuat data master

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Bersihkan controller baru
    _entityAddressDisplayCtrl.dispose();
    _conventusParentDisplayCtrl.dispose();
    _conventusAddressDisplayCtrl.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _fetchMasterData(); // Muat data alamat & entitas untuk dropdown

    // Jika mode Edit, isi nilai form sesuai initialData
    if (widget.initialData != null) {
      if (widget.initialTabIndex == 0) { // Mode Edit Alamat
        _editAlamatId = widget.initialData!['id'];
        _houseNameCtrl.text = widget.initialData!['house_name'] ?? '';
        _streetCtrl.text = widget.initialData!['street'] ?? '';
        _cityCtrl.text = widget.initialData!['city'] ?? '';
        _countryCtrl.text = widget.initialData!['country'] ?? '';
        _postalCodeCtrl.text = widget.initialData!['postal_code'] ?? '';
        _phoneCtrl.text = widget.initialData!['telephone'] ?? '';
        _emailCtrl.text = widget.initialData!['email'] ?? '';
      } 
      else if (widget.initialTabIndex == 1) { // Mode Edit Entitas
        _editEntitasId = widget.initialData!['id'];
        _entityNameCtrl.text = widget.initialData!['name'] ?? '';
        _historiaCtrl.text = widget.initialData!['historia'] ?? '';
        _websiteCtrl.text = widget.initialData!['website_url'] ?? '';
        
        final cat = widget.initialData!['entity_category'];
        if (_entityCategories.contains(cat)) _selectedCategory = cat;

        final minType = widget.initialData!['ministry_type'];
        if (_ministryTypes.contains(minType)) _selectedMinistryType = minType;

        final addrId = widget.initialData!['address_id'];
        if (_addresses.any((a) => a['id'] == addrId)) {
          _selectedAddressForEntity = addrId;
          // Set teks tampilan alamat di mode edit
          final a = _addresses.firstWhere((a) => a['id'] == addrId);
          _entityAddressDisplayCtrl.text = "${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}";
        }
      } 
      else if (widget.initialTabIndex == 2) { // Mode Edit Biara
        _editBiaraId = widget.initialData!['id'];
        _conventusNameCtrl.text = widget.initialData!['name'] ?? '';

        final parentId = widget.initialData!['parent_entity_id'];
        if (_entities.any((e) => e['id'] == parentId)) {
          _selectedParentEntity = parentId;
          // Set teks tampilan entitas induk di mode edit
          final e = _entities.firstWhere((e) => e['id'] == parentId);
          _conventusParentDisplayCtrl.text = "${e['name']} (${e['entity_category']})";
        }

        final addrId = widget.initialData!['address_id'];
        if (_addresses.any((a) => a['id'] == addrId)) {
          _selectedAddressForConventus = addrId;
          // Set teks tampilan alamat di mode edit
          final a = _addresses.firstWhere((a) => a['id'] == addrId);
          _conventusAddressDisplayCtrl.text = "${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}";
        }
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _fetchMasterData() async {
    try {
      final addrResponse = await _supabase.from('addresses').select('id, house_name, city, country').order('id', ascending: false);
      final entResponse = await _supabase.from('entities').select('id, name, entity_category').order('name', ascending: true);
      
      _addresses = addrResponse;
      _entities = entResponse;
    } catch (e) {
      debugPrint("Gagal mengambil data dropdown: $e");
    }
  }

  // ================= FUNGSI SAKTI POPUP PENCARIAN =================
  Future<void> _tampilkanDialogPencarian({
    required BuildContext context,
    required String judul,
    required List<dynamic> daftarData,
    required String Function(dynamic) buildDisplayText,
    required void Function(Map<String, dynamic>) onPilih,
  }) async {
    String kataKunci = "";

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final hasilFilter = daftarData.where((item) {
              final nilaiTeks = buildDisplayText(item).toLowerCase();
              return nilaiTeks.contains(kataKunci.toLowerCase());
            }).toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text("Pilih $judul", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Cari $judul...",
                        prefixIcon: const Icon(Icons.search, color: Colors.brown),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) {
                        setStateDialog(() {
                          kataKunci = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    Expanded(
                      child: hasilFilter.isEmpty
                          ? const Center(child: Text("Data tidak ditemukan", style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              itemCount: hasilFilter.length,
                              itemBuilder: (context, index) {
                                final data = hasilFilter[index];
                                return ListTile(
                                  leading: const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20),
                                  title: Text(buildDisplayText(data)),
                                  onTap: () {
                                    onPilih(data as Map<String, dynamic>);
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup", style: TextStyle(color: Colors.grey)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= FUNGSI SIMPAN/UPDATE =================

  Future<void> _submitAlamat() async {
    if (_cityCtrl.text.isEmpty || _countryCtrl.text.isEmpty) {
      _showSnackbar("Kota dan Negara wajib diisi!");
      return;
    }
    setState(() => _isLoading = true);
    final data = {
      'house_name': _houseNameCtrl.text,
      'street': _streetCtrl.text,
      'city': _cityCtrl.text,
      'country': _countryCtrl.text,
      'postal_code': _postalCodeCtrl.text,
      'telephone': _phoneCtrl.text,
      'email': _emailCtrl.text,
    };

    try {
      if (_editAlamatId != null) {
        await _supabase.from('addresses').update(data).eq('id', _editAlamatId!);
        _showSnackbar("Data Alamat berhasil diperbarui!");
        Navigator.pop(context, true); // Kembali setelah update
      } else {
        await _supabase.from('addresses').insert(data);
        _showSnackbar("Data Alamat berhasil disimpan!");
        _clearAlamatForm();
        await _fetchMasterData(); 
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitEntitas() async {
    if (_selectedCategory == null || _entityNameCtrl.text.isEmpty) {
      _showSnackbar("Kategori dan Nama Entitas wajib diisi!");
      return;
    }
    if (_selectedCategory == 'Ministries' && _selectedMinistryType == null) {
      _showSnackbar("Pilih Tipe Karya (Ministry Type)!");
      return;
    }

    setState(() => _isLoading = true);
    final data = {
      'entity_category': _selectedCategory,
      'ministry_type': _selectedCategory == 'Ministries' ? _selectedMinistryType : null,
      'name': _entityNameCtrl.text,
      'historia': _historiaCtrl.text,
      'website_url': _websiteCtrl.text,
      'address_id': _selectedAddressForEntity,
    };

    try {
      if (_editEntitasId != null) {
        await _supabase.from('entities').update(data).eq('id', _editEntitasId!);
        _showSnackbar("Data Entitas berhasil diperbarui!");
        Navigator.pop(context, true);
      } else {
        await _supabase.from('entities').insert(data);
        _showSnackbar("Data Entitas berhasil disimpan!");
        _clearEntitasForm();
        await _fetchMasterData(); 
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitBiara() async {
    if (_selectedParentEntity == null || _conventusNameCtrl.text.isEmpty) {
      _showSnackbar("Pilih Induk Entitas dan isi Nama Biara!");
      return;
    }
    setState(() => _isLoading = true);
    final data = {
      'parent_entity_id': _selectedParentEntity,
      'name': _conventusNameCtrl.text,
      'address_id': _selectedAddressForConventus,
    };

    try {
      if (_editBiaraId != null) {
        await _supabase.from('conventus').update(data).eq('id', _editBiaraId!);
        _showSnackbar("Data Biara berhasil diperbarui!");
        Navigator.pop(context, true);
      } else {
        await _supabase.from('conventus').insert(data);
        _showSnackbar("Data Biara berhasil disimpan!");
        _conventusNameCtrl.clear();
        _conventusParentDisplayCtrl.clear();
        _conventusAddressDisplayCtrl.clear();
        setState(() {
          _selectedParentEntity = null;
          _selectedAddressForConventus = null;
        });
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearAlamatForm() {
    _houseNameCtrl.clear();
    _streetCtrl.clear();
    _cityCtrl.clear();
    _countryCtrl.clear();
    _postalCodeCtrl.clear();
    _phoneCtrl.clear();
    _emailCtrl.clear();
  }

  void _clearEntitasForm() {
    _entityNameCtrl.clear();
    _historiaCtrl.clear();
    _websiteCtrl.clear();
    _entityAddressDisplayCtrl.clear();
    setState(() {
      _selectedCategory = null;
      _selectedMinistryType = null;
      _selectedAddressForEntity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData != null ? "Edit Data Master" : "Kelola Data Master"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.location_on), text: "Alamat"),
            Tab(icon: Icon(Icons.domain), text: "Entitas"),
            Tab(icon: Icon(Icons.home), text: "Biara"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTabAlamat(),
                _buildTabEntitas(),
                _buildTabBiara(),
              ],
            ),
    );
  }

  // ================= TAB 1: FORM ALAMAT =================
  Widget _buildTabAlamat() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_editAlamatId != null ? "Edit Alamat" : "Tambah Alamat Baru", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 15),
          TextField(controller: _houseNameCtrl, decoration: const InputDecoration(labelText: "Nama Gedung/Rumah (Opsional)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _streetCtrl, decoration: const InputDecoration(labelText: "Jalan / Detail Lokasi", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: TextField(controller: _cityCtrl, decoration: const InputDecoration(labelText: "Kota (Wajib)", border: OutlineInputBorder()))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _countryCtrl, decoration: const InputDecoration(labelText: "Negara (Wajib)", border: OutlineInputBorder()))),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: _postalCodeCtrl, decoration: const InputDecoration(labelText: "Kode Pos", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: "Telepon", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email Resmi", border: OutlineInputBorder())),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _submitAlamat,
            child: Text(_editAlamatId != null ? "UPDATE ALAMAT" : "SIMPAN ALAMAT", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ================= TAB 2: FORM ENTITAS =================
  Widget _buildTabEntitas() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_editEntitasId != null ? "Edit Entitas" : "Tambah Entitas (Lembaga/Provinsi)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: "Kategori Entitas (Wajib)", border: OutlineInputBorder()),
            items: _entityCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() {
              _selectedCategory = val;
              _selectedMinistryType = null;
            }),
          ),
          const SizedBox(height: 10),
          if (_selectedCategory == 'Ministries')
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField<String>(
                value: _selectedMinistryType,
                decoration: const InputDecoration(labelText: "Tipe Karya / Ministry (Wajib)", border: OutlineInputBorder()),
                items: _ministryTypes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => _selectedMinistryType = val),
              ),
            ),
          TextField(controller: _entityNameCtrl, decoration: const InputDecoration(labelText: "Nama Entitas (Wajib)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _historiaCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Sejarah / Deskripsi (Historia)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _websiteCtrl, decoration: const InputDecoration(labelText: "Tautan Website", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          
          // --- PENGGANTIAN DROPDOWN MENJADI POPUP PENCARIAN (ALAMAT ENTITAS) ---
          TextField(
            controller: _entityAddressDisplayCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Pilih Alamat Pusat (Opsional)",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.brown),
            ),
            onTap: () {
              _tampilkanDialogPencarian(
                context: context,
                judul: "Alamat Pusat",
                daftarData: _addresses,
                buildDisplayText: (a) => "${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}",
                onPilih: (pilihan) {
                  setState(() {
                    _selectedAddressForEntity = pilihan['id'];
                    _entityAddressDisplayCtrl.text = "${pilihan['house_name'] ?? ''} - ${pilihan['city']}, ${pilihan['country']}";
                  });
                },
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _submitEntitas,
            child: Text(_editEntitasId != null ? "UPDATE ENTITAS" : "SIMPAN ENTITAS", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ================= TAB 3: FORM BIARA =================
  Widget _buildTabBiara() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_editBiaraId != null ? "Edit Biara / Komunitas" : "Tambah Biara / Komunitas", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 15),
          
          // --- PENGGANTIAN DROPDOWN MENJADI POPUP PENCARIAN (INDUK ENTITAS BIARA) ---
          TextField(
            controller: _conventusParentDisplayCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Induk Entitas / Provinsi (Wajib)",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.brown),
            ),
            onTap: () {
              _tampilkanDialogPencarian(
                context: context,
                judul: "Induk Entitas",
                daftarData: _entities,
                buildDisplayText: (e) => "${e['name']} (${e['entity_category']})",
                onPilih: (pilihan) {
                  setState(() {
                    _selectedParentEntity = pilihan['id'];
                    _conventusParentDisplayCtrl.text = "${pilihan['name']} (${pilihan['entity_category']})";
                  });
                },
              );
            },
          ),
          const SizedBox(height: 10),
          TextField(controller: _conventusNameCtrl, decoration: const InputDecoration(labelText: "Nama Biara (Wajib)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          
          // --- PENGGANTIAN DROPDOWN MENJADI POPUP PENCARIAN (ALAMAT BIARA) ---
          TextField(
            controller: _conventusAddressDisplayCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Pilih Alamat Biara (Opsional)",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.brown),
            ),
            onTap: () {
              _tampilkanDialogPencarian(
                context: context,
                judul: "Alamat Biara",
                daftarData: _addresses,
                buildDisplayText: (a) => "${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}",
                onPilih: (pilihan) {
                  setState(() {
                    _selectedAddressForConventus = pilihan['id'];
                    _conventusAddressDisplayCtrl.text = "${pilihan['house_name'] ?? ''} - ${pilihan['city']}, ${pilihan['country']}";
                  });
                },
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _submitBiara,
            child: Text(_editBiaraId != null ? "UPDATE BIARA" : "SIMPAN BIARA", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}