import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

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

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
    required AppLocalizations t,
  }) async {
    String kataKunci = "";

    await showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double baseWidth = constraints.maxWidth;

            return StatefulBuilder(
              builder: (context, setStateDialog) {
                final hasilFilter = daftarData.where((item) {
                  final nilaiTeks = buildDisplayText(item).toLowerCase();
                  return nilaiTeks.contains(kataKunci.toLowerCase());
                }).toList();

                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text(
                    t.selectItemTitle(judul), 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.045)
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    height: baseWidth * 0.8,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: t.searchItemHint(judul),
                            hintStyle: TextStyle(fontSize: baseWidth * 0.035),
                            prefixIcon: Icon(Icons.search, color: Colors.brown, size: baseWidth * 0.05),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                          onChanged: (value) {
                            setStateDialog(() {
                              kataKunci = value;
                            });
                          },
                        ),
                        SizedBox(height: baseWidth * 0.03),
                        const Divider(),
                        Expanded(
                          child: hasilFilter.isEmpty
                              ? Center(
                                  child: Text(
                                    t.dataNotFound ?? "Data tidak ditemukan", 
                                    style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.035)
                                  )
                                )
                              : ListView.builder(
                                  itemCount: hasilFilter.length,
                                  itemBuilder: (context, index) {
                                    final data = hasilFilter[index];
                                    return ListTile(
                                      leading: Icon(Icons.radio_button_unchecked, color: Colors.grey, size: baseWidth * 0.05),
                                      title: Text(buildDisplayText(data), style: TextStyle(fontSize: baseWidth * 0.035)),
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
                      child: Text(
                        t.closeButton ?? "Tutup", 
                        style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.035)
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // ================= FUNGSI SIMPAN/UPDATE =================

  Future<void> _submitAlamat(AppLocalizations t) async {
    if (_cityCtrl.text.isEmpty || _countryCtrl.text.isEmpty) {
      _showSnackbar(t.cityCountryRequired ?? "Kota dan Negara wajib diisi!");
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
        _showSnackbar(t.addressUpdateSuccess ?? "Data Alamat berhasil diperbarui!");
        if (mounted) Navigator.pop(context, true); // Kembali setelah update
      } else {
        await _supabase.from('addresses').insert(data);
        _showSnackbar(t.addressSaveSuccess ?? "Data Alamat berhasil disimpan!");
        _clearAlamatForm();
        await _fetchMasterData(); 
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitEntitas(AppLocalizations t) async {
    if (_selectedCategory == null || _entityNameCtrl.text.isEmpty) {
      _showSnackbar(t.categoryEntityNameRequired ?? "Kategori dan Nama Entitas wajib diisi!");
      return;
    }
    if (_selectedCategory == 'Ministries' && _selectedMinistryType == null) {
      _showSnackbar(t.ministryTypeRequiredAlert ?? "Pilih Tipe Karya (Ministry Type)!");
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
        _showSnackbar(t.entityUpdateSuccess ?? "Data Entitas berhasil diperbarui!");
        if (mounted) Navigator.pop(context, true);
      } else {
        await _supabase.from('entities').insert(data);
        _showSnackbar(t.entitySaveSuccess ?? "Data Entitas berhasil disimpan!");
        _clearEntitasForm();
        await _fetchMasterData(); 
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitBiara(AppLocalizations t) async {
    if (_selectedParentEntity == null || _conventusNameCtrl.text.isEmpty) {
      _showSnackbar(t.parentEntityConventusNameRequired ?? "Pilih Induk Entitas dan isi Nama Biara!");
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
        _showSnackbar(t.conventusUpdateSuccess ?? "Data Biara berhasil diperbarui!");
        if (mounted) Navigator.pop(context, true);
      } else {
        await _supabase.from('conventus').insert(data);
        _showSnackbar(t.conventusSaveSuccess ?? "Data Biara berhasil disimpan!");
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
      if (mounted) setState(() => _isLoading = false);
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialData != null 
            ? (t.editMasterData ?? "Edit Data Master") 
            : (t.manageMasterData ?? "Kelola Data Master")
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: const Icon(Icons.location_on), text: t.tabAddress ?? "Alamat"),
            Tab(icon: const Icon(Icons.domain), text: t.tabEntity ?? "Entitas"),
            Tab(icon: const Icon(Icons.home), text: t.tabMonastery ?? "Biara"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : LayoutBuilder(
              builder: (context, constraints) {
                final double baseWidth = constraints.maxWidth;

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabAlamat(baseWidth, t),
                    _buildTabEntitas(baseWidth, t),
                    _buildTabBiara(baseWidth, t),
                  ],
                );
              },
            ),
    );
  }

  // ================= TAB 1: FORM ALAMAT =================
  Widget _buildTabAlamat(double baseWidth, AppLocalizations t) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(baseWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _editAlamatId != null 
              ? (t.editAddressTitle ?? "Edit Alamat") 
              : (t.addNewAddressTitle ?? "Tambah Alamat Baru"), 
            style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.brown)
          ),
          SizedBox(height: baseWidth * 0.035),
          TextField(
            controller: _houseNameCtrl, 
            decoration: InputDecoration(
              labelText: t.houseNameOptional ?? "Nama Gedung/Rumah (Opsional)", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _streetCtrl, 
            decoration: InputDecoration(
              labelText: t.streetDetailLocation ?? "Jalan / Detail Lokasi", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityCtrl, 
                  decoration: InputDecoration(
                    labelText: t.cityRequiredLabel ?? "Kota (Wajib)", 
                    border: const OutlineInputBorder()
                  )
                )
              ),
              SizedBox(width: baseWidth * 0.025),
              Expanded(
                child: TextField(
                  controller: _countryCtrl, 
                  decoration: InputDecoration(
                    labelText: t.countryRequiredLabel ?? "Negara (Wajib)", 
                    border: const OutlineInputBorder()
                  )
                )
              ),
            ],
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _postalCodeCtrl, 
            decoration: InputDecoration(
              labelText: t.postalCode ?? "Kode Pos", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _phoneCtrl, 
            decoration: InputDecoration(
              labelText: t.telephone ?? "Telepon", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _emailCtrl, 
            decoration: InputDecoration(
              labelText: t.officialEmail ?? "Email Resmi", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown, 
              foregroundColor: Colors.white, 
              padding: EdgeInsets.symmetric(vertical: baseWidth * 0.035)
            ),
            onPressed: () => _submitAlamat(t),
            child: Text(
              _editAlamatId != null 
                ? (t.updateAddressBtn ?? "UPDATE ALAMAT") 
                : (t.saveAddressBtn ?? "SIMPAN ALAMAT"), 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 2: FORM ENTITAS =================
  Widget _buildTabEntitas(double baseWidth, AppLocalizations t) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(baseWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _editEntitasId != null 
              ? (t.editEntityTitle ?? "Edit Entitas") 
              : (t.addEntityTitle ?? "Tambah Entitas (Lembaga/Provinsi)"), 
            style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.brown)
          ),
          SizedBox(height: baseWidth * 0.035),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: t.entityCategoryRequiredLabel ?? "Kategori Entitas (Wajib)", 
              border: const OutlineInputBorder()
            ),
            items: _entityCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() {
              _selectedCategory = val;
              _selectedMinistryType = null;
            }),
          ),
          SizedBox(height: baseWidth * 0.025),
          if (_selectedCategory == 'Ministries')
            Padding(
              padding: EdgeInsets.only(bottom: baseWidth * 0.025),
              child: DropdownButtonFormField<String>(
                value: _selectedMinistryType,
                decoration: InputDecoration(
                  labelText: t.ministryTypeRequiredLabel ?? "Tipe Karya / Ministry (Wajib)", 
                  border: const OutlineInputBorder()
                ),
                items: _ministryTypes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => _selectedMinistryType = val),
              ),
            ),
          TextField(
            controller: _entityNameCtrl, 
            decoration: InputDecoration(
              labelText: t.entityNameRequiredLabel ?? "Nama Entitas (Wajib)", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _historiaCtrl, 
            maxLines: 3, 
            decoration: InputDecoration(
              labelText: t.historyDescription ?? "Sejarah / Deskripsi (Historia)", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _websiteCtrl, 
            decoration: InputDecoration(
              labelText: t.websiteLink ?? "Tautan Website", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          
          // --- PENGGANTIAN DROPDOWN MENJADI POPUP PENCARIAN (ALAMAT ENTITAS) ---
          TextField(
            controller: _entityAddressDisplayCtrl,
            readOnly: true,
            decoration: InputDecoration(
              labelText: t.selectHeadquartersAddress ?? "Pilih Alamat Pusat (Opsional)",
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
            ),
            onTap: () {
              _tampilkanDialogPencarian(
                context: context,
                judul: t.centerHeadquarters ?? "Alamat Pusat",
                daftarData: _addresses,
                buildDisplayText: (a) => "${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}",
                onPilih: (pilihan) {
                  setState(() {
                    _selectedAddressForEntity = pilihan['id'];
                    _entityAddressDisplayCtrl.text = "${pilihan['house_name'] ?? ''} - ${pilihan['city']}, ${pilihan['country']}";
                  });
                },
                t: t,
              );
            },
          ),
          SizedBox(height: baseWidth * 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown, 
              foregroundColor: Colors.white, 
              padding: EdgeInsets.symmetric(vertical: baseWidth * 0.035)
            ),
            onPressed: () => _submitEntitas(t),
            child: Text(
              _editEntitasId != null 
                ? (t.updateEntityBtn ?? "UPDATE ENTITAS") 
                : (t.saveEntityBtn ?? "SIMPAN ENTITAS"), 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 3: FORM BIARA =================
  Widget _buildTabBiara(double baseWidth, AppLocalizations t) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(baseWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _editBiaraId != null 
              ? (t.editConventusTitle ?? "Edit Biara / Komunitas") 
              : (t.addConventusTitle ?? "Tambah Biara / Komunitas"), 
            style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.brown)
          ),
          SizedBox(height: baseWidth * 0.035),
          
          // --- PENGGANTIAN DROPDOWN MENJADI POPUP PENCARIAN (INDUK ENTITAS BIARA) ---
          TextField(
            controller: _conventusParentDisplayCtrl,
            readOnly: true,
            decoration: InputDecoration(
              labelText: t.parentEntityRequiredLabel ?? "Induk Entitas / Provinsi (Wajib)",
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
            ),
            onTap: () {
              _tampilkanDialogPencarian(
                context: context,
                judul: t.parentInduk ?? "Induk Entitas",
                daftarData: _entities,
                buildDisplayText: (e) => "${e['name']} (${e['entity_category']})",
                onPilih: (pilihan) {
                  setState(() {
                    _selectedParentEntity = pilihan['id'];
                    _conventusParentDisplayCtrl.text = "${pilihan['name']} (${pilihan['entity_category']})";
                  });
                },
                t: t,
              );
            },
          ),
          SizedBox(height: baseWidth * 0.025),
          TextField(
            controller: _conventusNameCtrl, 
            decoration: InputDecoration(
              labelText: t.conventusNameRequiredLabel ?? "Nama Biara (Wajib)", 
              border: const OutlineInputBorder()
            )
          ),
          SizedBox(height: baseWidth * 0.025),
          
          // --- PENGGANTIAN DROPDOWN MENJADI POPUP PENCARIAN (ALAMAT BIARA) ---
          TextField(
            controller: _conventusAddressDisplayCtrl,
            readOnly: true,
            decoration: InputDecoration(
              labelText: t.selectConventusAddress ?? "Pilih Alamat Biara (Opsional)",
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
            ),
            onTap: () {
              _tampilkanDialogPencarian(
                context: context,
                judul: t.tabMonastery ?? "Alamat Biara",
                daftarData: _addresses,
                buildDisplayText: (a) => "${a['house_name'] ?? ''} - ${a['city']}, ${a['country']}",
                onPilih: (pilihan) {
                  setState(() {
                    _selectedAddressForConventus = pilihan['id'];
                    _conventusAddressDisplayCtrl.text = "${pilihan['house_name'] ?? ''} - ${pilihan['city']}, ${pilihan['country']}";
                  });
                },
                t: t,
              );
            },
          ),
          SizedBox(height: baseWidth * 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown, 
              foregroundColor: Colors.white, 
              padding: EdgeInsets.symmetric(vertical: baseWidth * 0.035)
            ),
            onPressed: () => _submitBiara(t),
            child: Text(
              _editBiaraId != null 
                ? (t.updateConventusBtn ?? "UPDATE BIARA") 
                : (t.saveConventusBtn ?? "SIMPAN BIARA"), 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
            ),
          ),
        ],
      ),
    );
  }
}