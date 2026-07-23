import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanDataNonAnggota extends StatefulWidget {
  const HalamanDataNonAnggota({super.key});

  @override
  State<HalamanDataNonAnggota> createState() => _HalamanDataNonAnggotaState();
}

class _HalamanDataNonAnggotaState extends State<HalamanDataNonAnggota> {
  final _supabase = Supabase.instance.client;
  
  // Data untuk Dropdown
  List<dynamic> _addresses = [];
  List<dynamic> _entities = [];

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
  int? _selectedAddressForConventus;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMasterData();
  }

  // Mengambil daftar Alamat dan Entitas untuk mengisi Dropdown
  Future<void> _fetchMasterData() async {
    try {
      final addrResponse = await _supabase.from('addresses').select('id, house_name, city, country').order('id', ascending: false);
      final entResponse = await _supabase.from('entities').select('id, name, entity_category').order('name', ascending: true);
      
      setState(() {
        _addresses = addrResponse;
        _entities = entResponse;
      });
    } catch (e) {
      debugPrint("Gagal mengambil data dropdown: $e");
    }
  }

  // FUNGSI SIMPAN TAB 1: ALAMAT
  Future<void> _submitAlamat() async {
    if (_cityCtrl.text.isEmpty || _countryCtrl.text.isEmpty) {
      _showSnackbar("Kota dan Negara wajib diisi!");
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _supabase.from('addresses').insert({
        'house_name': _houseNameCtrl.text,
        'street': _streetCtrl.text,
        'city': _cityCtrl.text,
        'country': _countryCtrl.text,
        'postal_code': _postalCodeCtrl.text,
        'telephone': _phoneCtrl.text,
        'email': _emailCtrl.text,
      });
      _showSnackbar("Data Alamat berhasil disimpan!");
      _clearAlamatForm();
      await _fetchMasterData(); // Refresh dropdown
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // FUNGSI SIMPAN TAB 2: ENTITAS
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
    try {
      await _supabase.from('entities').insert({
        'entity_category': _selectedCategory,
        'ministry_type': _selectedCategory == 'Ministries' ? _selectedMinistryType : null,
        'name': _entityNameCtrl.text,
        'historia': _historiaCtrl.text,
        'website_url': _websiteCtrl.text,
        'address_id': _selectedAddressForEntity,
      });
      _showSnackbar("Data Entitas berhasil disimpan!");
      _clearEntitasForm();
      await _fetchMasterData(); // Refresh dropdown
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // FUNGSI SIMPAN TAB 3: BIARA (CONVENTUS)
  Future<void> _submitBiara() async {
    if (_selectedParentEntity == null || _conventusNameCtrl.text.isEmpty) {
      _showSnackbar("Pilih Induk Entitas dan isi Nama Biara!");
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _supabase.from('conventus').insert({
        'parent_entity_id': _selectedParentEntity,
        'name': _conventusNameCtrl.text,
        'address_id': _selectedAddressForConventus,
      });
      _showSnackbar("Data Biara berhasil disimpan!");
      _conventusNameCtrl.clear();
      setState(() {
        _selectedParentEntity = null;
        _selectedAddressForConventus = null;
      });
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
    setState(() {
      _selectedCategory = null;
      _selectedMinistryType = null;
      _selectedAddressForEntity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kelola Data Master"),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.location_on), text: "Alamat"),
              Tab(icon: Icon(Icons.domain), text: "Entitas"),
              Tab(icon: Icon(Icons.home), text: "Biara"),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.brown))
            : TabBarView(
                children: [
                  _buildTabAlamat(),
                  _buildTabEntitas(),
                  _buildTabBiara(),
                ],
              ),
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
          const Text("Tambah Alamat Baru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
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
            child: const Text("SIMPAN ALAMAT", style: TextStyle(fontWeight: FontWeight.bold)),
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
          const Text("Tambah Entitas (Lembaga/Provinsi)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: "Kategori Entitas (Wajib)", border: OutlineInputBorder()),
            items: _entityCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() {
              _selectedCategory = val;
              _selectedMinistryType = null; // Reset jika kategori berubah
            }),
          ),
          const SizedBox(height: 10),
          // Muncul HANYA jika kategori = Ministries
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
          DropdownButtonFormField<int>(
            value: _selectedAddressForEntity,
            isExpanded: true,
            decoration: const InputDecoration(labelText: "Pilih Alamat Pusat (Opsional)", border: OutlineInputBorder()),
            items: _addresses.map((a) => DropdownMenuItem<int>(
              value: a['id'], 
              child: Text("${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}")
            )).toList(),
            onChanged: (val) => setState(() => _selectedAddressForEntity = val),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _submitEntitas,
            child: const Text("SIMPAN ENTITAS", style: TextStyle(fontWeight: FontWeight.bold)),
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
          const Text("Tambah Biara / Komunitas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 15),
          DropdownButtonFormField<int>(
            value: _selectedParentEntity,
            isExpanded: true,
            decoration: const InputDecoration(labelText: "Induk Entitas / Provinsi (Wajib)", border: OutlineInputBorder()),
            items: _entities.map((e) => DropdownMenuItem<int>(
              value: e['id'], 
              child: Text("${e['name']} (${e['entity_category']})")
            )).toList(),
            onChanged: (val) => setState(() => _selectedParentEntity = val),
          ),
          const SizedBox(height: 10),
          TextField(controller: _conventusNameCtrl, decoration: const InputDecoration(labelText: "Nama Biara (Wajib)", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: _selectedAddressForConventus,
            isExpanded: true,
            decoration: const InputDecoration(labelText: "Pilih Alamat Biara (Opsional)", border: OutlineInputBorder()),
            items: _addresses.map((a) => DropdownMenuItem<int>(
              value: a['id'], 
              child: Text("${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}")
            )).toList(),
            onChanged: (val) => setState(() => _selectedAddressForConventus = val),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _submitBiara,
            child: const Text("SIMPAN BIARA", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}