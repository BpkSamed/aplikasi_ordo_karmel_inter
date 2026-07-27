import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

class HalamanTambahAnggota extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Parameter untuk mode edit

  const HalamanTambahAnggota({super.key, this.initialData});

  @override
  State<HalamanTambahAnggota> createState() => _HalamanTambahAnggotaState();
}

class _HalamanTambahAnggotaState extends State<HalamanTambahAnggota> {
  int _currentStep = 0;
  final _supabase = Supabase.instance.client;

  int? _editId; // Menyimpan ID jika mode edit

  // --- Image Picker Variables ---
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes; // Foto baru yang dipilih
  String? _existingPhotoUrl; // Foto lama dari database (saat mode edit)

  // Controllers untuk Step 1: Biodata & Akun
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // TAMBAHAN: Username
  final TextEditingController _passwordController = TextEditingController(); // TAMBAHAN: Password
  bool _obscurePassword = true; // Toggle visibilitas password
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  DateTime? _dob;

  // Variabel untuk Step 2: Status Panggilan & Tanggal
  String? _vocationStatus;
  final List<String> _vocationList = ['Noviatus', 'Temporaneae', 'Solemniter', 'Sacerdotalis'];
  DateTime? _firstProfDate;
  DateTime? _solemnProfDate;
  DateTime? _ordinationDate;

  // Variabel untuk Step 3: Penempatan & Peran
  int? _selectedEntityId;
  int? _selectedConventusId;
  final TextEditingController _roleController = TextEditingController(text: 'Sodales'); // Default
  
  // Controllers untuk Tampilan Pop-up Pencarian (Step 3)
  final TextEditingController _entityDisplayCtrl = TextEditingController();
  final TextEditingController _conventusDisplayCtrl = TextEditingController();

  List<dynamic> _entities = [];
  List<dynamic> _conventusList = [];
  
  bool _isLoading = false;
  bool _isInitDataLoading = true; // Untuk memuat data awal (dropdown & pre-fill edit)

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _roleController.dispose();
    _entityDisplayCtrl.dispose();
    _conventusDisplayCtrl.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _fetchEntities(); // Ambil data entitas untuk pangkalan pencarian

    // Jika masuk dalam mode Edit, isi semua form dengan data lama
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _editId = data['id'];
      
      _nameController.text = data['full_name'] ?? '';
      _usernameController.text = data['username'] ?? '';
      _passwordController.text = data['password'] ?? '';
      _cityController.text = data['city_of_birth'] ?? '';
      _countryController.text = data['country_of_birth'] ?? '';
      _roleController.text = data['role'] ?? 'Sodales';
      _existingPhotoUrl = data['photo_url']; // Muat URL foto lama jika ada

      // Parse tanggal 
      if (data['date_of_birth'] != null) _dob = DateTime.tryParse(data['date_of_birth']);
      if (data['first_profession_date'] != null) _firstProfDate = DateTime.tryParse(data['first_profession_date']);
      if (data['solemn_profession_date'] != null) _solemnProfDate = DateTime.tryParse(data['solemn_profession_date']);
      if (data['ordination_date'] != null) _ordinationDate = DateTime.tryParse(data['ordination_date']);

      if (_vocationList.contains(data['vocation_status'])) {
        _vocationStatus = data['vocation_status'];
      }

      // Pre-fill Pop-up Entitas & Biara
      final eId = data['entity_id'];
      if (eId != null && _entities.any((e) => e['id'] == eId)) {
        _selectedEntityId = eId;
        final selectedEnt = _entities.firstWhere((e) => e['id'] == eId);
        _entityDisplayCtrl.text = "${selectedEnt['name']} (${selectedEnt['entity_category']})";

        await _fetchConventus(eId); 

        final cId = data['conventus_id'];
        if (cId != null && _conventusList.any((c) => c['id'] == cId)) {
          _selectedConventusId = cId;
          final selectedConv = _conventusList.firstWhere((c) => c['id'] == cId);
          _conventusDisplayCtrl.text = selectedConv['name'];
        }
      }
    }

    if (mounted) {
      setState(() {
        _isInitDataLoading = false;
      });
    }
  }

  Future<void> _fetchEntities() async {
    try {
      final response = await _supabase.from('entities').select('id, name, entity_category').order('name');
      _entities = response;
    } catch (e) {
      debugPrint("Gagal mengambil data entitas: $e");
    }
  }

  Future<void> _fetchConventus(int entityId) async {
    try {
      final response = await _supabase.from('conventus').select('id, name').eq('parent_entity_id', entityId).order('name');
      setState(() => _conventusList = response);
    } catch (e) {
      debugPrint("Gagal mengambil data biara: $e");
    }
  }

  // ================= POPUP DIALOG PENCARIAN (ADAPTIF & RESPONSIVE) =================
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(baseWidth * 0.04)),
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(baseWidth * 0.025)),
                            contentPadding: EdgeInsets.zero,
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

  // --- Fungsi Pilih Foto ---
  Future<void> _pickImage(AppLocalizations t) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, 
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
          _existingPhotoUrl = null; // Hapus referensi foto lama
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.pickImageFailed(e.toString()))));
    }
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onPicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => onPicked(picked));
    }
  }

  String _formatDate(DateTime? date, AppLocalizations t) {
    if (date == null) return t.selectDatePrompt ?? "Pilih Tanggal";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _submitData(AppLocalizations t) async {
    if (_nameController.text.isEmpty || _selectedEntityId == null || _vocationStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.mandatoryFieldsEmpty ?? "Nama, Status, dan Entitas harus diisi!")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? finalPhotoUrl = _existingPhotoUrl;

      // 1. Logika Unggah Foto Baru
      if (_imageBytes != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        await _supabase.storage.from('member_photos').uploadBinary(
          fileName,
          _imageBytes!,
          fileOptions: const FileOptions(upsert: true),
        );

        finalPhotoUrl = _supabase.storage.from('member_photos').getPublicUrl(fileName);
      }

      // 2. Kumpulkan data termasuk Username dan Password
      final submitData = {
        'full_name': _nameController.text,
        'username': _usernameController.text.isEmpty ? null : _usernameController.text,
        'password': _passwordController.text.isEmpty ? null : _passwordController.text,
        'city_of_birth': _cityController.text,
        'country_of_birth': _countryController.text,
        'date_of_birth': _dob != null ? DateFormat('yyyy-MM-dd').format(_dob!) : null,
        'vocation_status': _vocationStatus,
        'first_profession_date': _firstProfDate != null ? DateFormat('yyyy-MM-dd').format(_firstProfDate!) : null,
        'solemn_profession_date': _solemnProfDate != null ? DateFormat('yyyy-MM-dd').format(_solemnProfDate!) : null,
        'ordination_date': _ordinationDate != null ? DateFormat('yyyy-MM-dd').format(_ordinationDate!) : null,
        'entity_id': _selectedEntityId,
        'conventus_id': _selectedConventusId,
        'role': _roleController.text,
        'photo_url': finalPhotoUrl,
      };

      if (_editId != null) {
        // Mode UPDATE
        await _supabase.from('members').update(submitData).eq('id', _editId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.memberUpdateSuccess ?? "Data Anggota Berhasil Diperbarui!")));
          Navigator.pop(context, true);
        }
      } else {
        // Mode INSERT
        await _supabase.from('members').insert(submitData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.memberAddSuccess ?? "Data Anggota Berhasil Ditambahkan!")));
          Navigator.pop(context, true); 
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${t.databaseError ?? 'Error'}: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_editId != null 
            ? (t.editMemberPageTitle ?? "Edit Data Anggota") 
            : (t.addMemberPageTitle ?? "Pendaftaran Anggota Baru")
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isInitDataLoading || _isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.brown),
                  SizedBox(height: baseWidth * 0.04),
                  Text(
                    _isLoading 
                        ? (t.processingData ?? "Memproses data...") 
                        : (t.loadingMemberData ?? "Memuat data anggota..."),
                    style: TextStyle(fontSize: baseWidth * 0.038, color: Colors.brown),
                  ),
                ],
              ),
            );
          }

          return Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _submitData(t);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep -= 1);
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: EdgeInsets.only(top: baseWidth * 0.05),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown, 
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: baseWidth * 0.05, vertical: baseWidth * 0.03)
                      ),
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep == 2 
                            ? (_editId != null ? (t.saveChangesBtn ?? 'Simpan Perubahan') : (t.saveDataBtn ?? 'Simpan Data')) 
                            : (t.nextBtn ?? 'Lanjut'),
                        style: TextStyle(fontSize: baseWidth * 0.038),
                      ),
                    ),
                    SizedBox(width: baseWidth * 0.03),
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel, 
                        child: Text(t.backBtn ?? "Kembali", style: TextStyle(fontSize: baseWidth * 0.038, color: Colors.grey.shade700))
                      ),
                  ],
                ),
              );
            },
            steps: [
              // --- STEP 1: BIODATA & AKUN LOGIN ---
              Step(
                isActive: _currentStep >= 0,
                title: Text(t.step1Title ?? "Biodata & Akun Login", style: TextStyle(fontSize: baseWidth * 0.04, fontWeight: FontWeight.bold)),
                content: Column(
                  children: [
                    // --- WIDGET FOTO ---
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickImage(t),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: baseWidth * 0.12,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _imageBytes != null 
                                ? MemoryImage(_imageBytes!) as ImageProvider
                                : (_existingPhotoUrl != null ? NetworkImage(_existingPhotoUrl!) : null),
                              child: (_imageBytes == null && _existingPhotoUrl == null)
                                  ? Icon(Icons.person, size: baseWidth * 0.12, color: Colors.white)
                                  : null,
                            ),
                            Container(
                              padding: EdgeInsets.all(baseWidth * 0.01),
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white, size: baseWidth * 0.045),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: baseWidth * 0.02),
                    Center(
                      child: Text(
                        t.changePhotoPrompt ?? "Ketuk ikon untuk mengubah foto", 
                        style: TextStyle(fontSize: baseWidth * 0.03, color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: baseWidth * 0.04),

                    // --- INPUT NAMA LENGKAP ---
                    TextField(
                      controller: _nameController, 
                      decoration: InputDecoration(
                        labelText: t.fullNameLabel ?? "Nama Lengkap",
                        border: const OutlineInputBorder()
                      )
                    ),
                    SizedBox(height: baseWidth * 0.025),

                    // --- INPUT USERNAME & PASSWORD ---
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: t.usernameLabel ?? "Username",
                              border: const OutlineInputBorder()
                            )
                          ),
                        ),
                        SizedBox(width: baseWidth * 0.025),
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: t.passwordLabel ?? "Password",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                  size: baseWidth * 0.05,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: baseWidth * 0.025),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController, 
                            decoration: InputDecoration(
                              labelText: t.birthCityLabel ?? "Kota Kelahiran",
                              border: const OutlineInputBorder()
                            )
                          )
                        ),
                        SizedBox(width: baseWidth * 0.025),
                        Expanded(
                          child: TextField(
                            controller: _countryController, 
                            decoration: InputDecoration(
                              labelText: t.birthCountryLabel ?? "Negara",
                              border: const OutlineInputBorder()
                            )
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: baseWidth * 0.025),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(t.birthDateLabel ?? "Tanggal Lahir", style: TextStyle(fontSize: baseWidth * 0.038)),
                      subtitle: Text(_formatDate(_dob, t), style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.brown)),
                      trailing: Icon(Icons.calendar_today, color: Colors.brown, size: baseWidth * 0.05),
                      onTap: () => _selectDate(context, (d) => _dob = d),
                    ),
                  ],
                )
              ),

              // --- STEP 2: STATUS PANGGILAN ---
              Step(
                isActive: _currentStep >= 1,
                title: Text(t.step2Title ?? "Status & Tanggal Panggilan", style: TextStyle(fontSize: baseWidth * 0.04, fontWeight: FontWeight.bold)),
                content: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _vocationStatus,
                      decoration: InputDecoration(
                        labelText: t.vocationStatusLabel ?? "Status Panggilan (Wajib)",
                        border: const OutlineInputBorder()
                      ),
                      items: _vocationList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => _vocationStatus = val),
                    ),
                    SizedBox(height: baseWidth * 0.025),
                    if (_vocationStatus != 'Noviatus' && _vocationStatus != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.firstProfessionDateLabel ?? "Tanggal Kaul Perdana", style: TextStyle(fontSize: baseWidth * 0.038)),
                        subtitle: Text(_formatDate(_firstProfDate, t), style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.brown)),
                        trailing: Icon(Icons.calendar_today, color: Colors.grey, size: baseWidth * 0.05),
                        onTap: () => _selectDate(context, (d) => _firstProfDate = d),
                      ),
                    if (_vocationStatus == 'Solemniter' || _vocationStatus == 'Sacerdotalis')
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.solemnProfessionDateLabel ?? "Tanggal Kaul Kekal", style: TextStyle(fontSize: baseWidth * 0.038)),
                        subtitle: Text(_formatDate(_solemnProfDate, t), style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.brown)),
                        trailing: Icon(Icons.calendar_today, color: Colors.grey, size: baseWidth * 0.05),
                        onTap: () => _selectDate(context, (d) => _solemnProfDate = d),
                      ),
                    if (_vocationStatus == 'Sacerdotalis')
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.ordinationDateLabel ?? "Tanggal Tahbisan", style: TextStyle(fontSize: baseWidth * 0.038)),
                        subtitle: Text(_formatDate(_ordinationDate, t), style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.brown)),
                        trailing: Icon(Icons.calendar_today, color: Colors.grey, size: baseWidth * 0.05),
                        onTap: () => _selectDate(context, (d) => _ordinationDate = d),
                      ),
                  ],
                )
              ),

              // --- STEP 3: PENEMPATAN LOKASI (POPUP PENCARIAN) ---
              Step(
                isActive: _currentStep >= 2,
                title: Text(t.step3Title ?? "Penempatan Wilayah", style: TextStyle(fontSize: baseWidth * 0.04, fontWeight: FontWeight.bold)),
                content: Column(
                  children: [
                    // POPUP PENCARIAN ENTITAS / PROVINSI
                    TextField(
                      controller: _entityDisplayCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: t.entityProvinceLabel ?? "Entitas / Provinsi (Wajib)",
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
                      ),
                      onTap: () {
                        _tampilkanDialogPencarian(
                          context: context,
                          judul: t.entityProvinceLabel ?? "Entitas / Provinsi",
                          daftarData: _entities,
                          buildDisplayText: (e) => "${e['name']} (${e['entity_category']})",
                          onPilih: (pilihan) {
                            setState(() {
                              _selectedEntityId = pilihan['id'];
                              _entityDisplayCtrl.text = "${pilihan['name']} (${pilihan['entity_category']})";
                              _selectedConventusId = null;
                              _conventusDisplayCtrl.clear();
                            });
                            _fetchConventus(pilihan['id']);
                          },
                          t: t,
                        );
                      },
                    ),
                    SizedBox(height: baseWidth * 0.025),

                    // POPUP PENCARIAN BIARA / KOMUNITAS
                    TextField(
                      controller: _conventusDisplayCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: t.conventusCommunityLabel ?? "Biara / Komunitas (Opsional)",
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
                      ),
                      onTap: () {
                        if (_selectedEntityId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.selectEntityFirstPrompt ?? "Pilih Entitas/Provinsi terlebih dahulu!"))
                          );
                          return;
                        }
                        _tampilkanDialogPencarian(
                          context: context,
                          judul: t.conventusCommunityLabel ?? "Biara / Komunitas",
                          daftarData: _conventusList,
                          buildDisplayText: (c) => c['name'] ?? '',
                          onPilih: (pilihan) {
                            setState(() {
                              _selectedConventusId = pilihan['id'];
                              _conventusDisplayCtrl.text = pilihan['name'] ?? '';
                            });
                          },
                          t: t,
                        );
                      },
                    ),
                    SizedBox(height: baseWidth * 0.025),

                    TextField(
                      controller: _roleController, 
                      decoration: InputDecoration(
                        labelText: t.personalRoleLabel ?? "Peran Pribadi", 
                        hintText: t.roleHint ?? "Contoh: Sodales, Prior, dll",
                        border: const OutlineInputBorder()
                      )
                    ),
                  ],
                )
              ),
            ],
          );
        },
      ),
    );
  }
}