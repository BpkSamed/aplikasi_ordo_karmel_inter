import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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

  // Controllers untuk Step 1: Biodata
  final TextEditingController _nameController = TextEditingController();
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
  
  List<dynamic> _entities = [];
  List<dynamic> _conventusList = [];
  
  bool _isLoading = false;
  bool _isInitDataLoading = true; // Untuk memuat data awal (dropdown & pre-fill edit)

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchEntities(); // Ambil data pangkalan untuk dropdown

    // Jika masuk dalam mode Edit, isi semua form dengan data lama
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _editId = data['id'];
      
      _nameController.text = data['full_name'] ?? '';
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

      // Pre-fill dropdown Entitas
      final eId = data['entity_id'];
      if (eId != null && _entities.any((e) => e['id'] == eId)) {
        _selectedEntityId = eId;
        await _fetchConventus(eId); 

        // Pre-fill dropdown Biara
        final cId = data['conventus_id'];
        if (cId != null && _conventusList.any((c) => c['id'] == cId)) {
          _selectedConventusId = cId;
        }
      }
    }

    setState(() {
      _isInitDataLoading = false;
    });
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

  // --- Fungsi Pilih Foto ---
  Future<void> _pickImage() async {
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
          _existingPhotoUrl = null; // Hapus referensi foto lama karena akan diganti baru
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memilih gambar: $e")));
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

  String _formatDate(DateTime? date) {
    if (date == null) return "Pilih Tanggal";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _submitData() async {
    if (_nameController.text.isEmpty || _selectedEntityId == null || _vocationStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama, Status, dan Entitas harus diisi!")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? finalPhotoUrl = _existingPhotoUrl; // Gunakan foto lama sebagai default

      // 1. Logika Unggah Foto Baru (Jika ada foto baru yang dipilih)
      if (_imageBytes != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        await _supabase.storage.from('member_photos').uploadBinary(
          fileName,
          _imageBytes!,
          fileOptions: const FileOptions(upsert: true),
        );

        finalPhotoUrl = _supabase.storage.from('member_photos').getPublicUrl(fileName);
      }

      // 2. Kumpulkan data yang akan disubmit
      final submitData = {
        'full_name': _nameController.text,
        'city_of_birth': _cityController.text,
        'country_of_birth': _countryController.text,
        'date_of_birth': _dob != null ? _formatDate(_dob) : null,
        'vocation_status': _vocationStatus,
        'first_profession_date': _firstProfDate != null ? _formatDate(_firstProfDate) : null,
        'solemn_profession_date': _solemnProfDate != null ? _formatDate(_solemnProfDate) : null,
        'ordination_date': _ordinationDate != null ? _formatDate(_ordinationDate) : null,
        'entity_id': _selectedEntityId,
        'conventus_id': _selectedConventusId,
        'role': _roleController.text,
        'photo_url': finalPhotoUrl, // Simpan URL foto final
      };

      if (_editId != null) {
        // Mode UPDATE
        await _supabase.from('members').update(submitData).eq('id', _editId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Anggota Berhasil Diperbarui!")));
          Navigator.pop(context, true);
        }
      } else {
        // Mode INSERT
        await _supabase.from('members').insert(submitData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Anggota Berhasil Ditambahkan!")));
          Navigator.pop(context, true); 
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editId != null ? "Edit Data Anggota" : "Pendaftaran Anggota Baru")),
      body: _isInitDataLoading || _isLoading 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.brown),
                const SizedBox(height: 16),
                Text(_isLoading ? "Memproses data..." : "Memuat data anggota..."),
              ],
            ),
          )
        : Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _submitData(); // Simpan jika di step terakhir
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep -= 1);
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                      onPressed: details.onStepContinue,
                      child: Text(_currentStep == 2 
                        ? (_editId != null ? 'Simpan Perubahan' : 'Simpan Data') 
                        : 'Lanjut'),
                    ),
                    const SizedBox(width: 10),
                    if (_currentStep > 0)
                      TextButton(onPressed: details.onStepCancel, child: const Text("Kembali")),
                  ],
                ),
              );
            },
            steps: [
              // --- STEP 1: BIODATA & FOTO ---
              Step(
                isActive: _currentStep >= 0,
                title: const Text("Biodata Pribadi"),
                content: Column(
                  children: [
                    // --- WIDGET FOTO ---
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade300,
                              // Cek apakah ada foto baru yang dipilih, jika tidak, cek foto lama
                              backgroundImage: _imageBytes != null 
                                ? MemoryImage(_imageBytes!) as ImageProvider
                                : (_existingPhotoUrl != null ? NetworkImage(_existingPhotoUrl!) : null),
                              child: (_imageBytes == null && _existingPhotoUrl == null)
                                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text("Ketuk ikon untuk mengubah foto", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    const SizedBox(height: 20),

                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Lengkap")),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: "Kota Kelahiran"))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _countryController, decoration: const InputDecoration(labelText: "Negara"))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Tanggal Lahir"),
                      subtitle: Text(_formatDate(_dob)),
                      trailing: const Icon(Icons.calendar_today, color: Colors.brown),
                      onTap: () => _selectDate(context, (d) => _dob = d),
                    ),
                  ],
                )
              ),
              // --- STEP 2: STATUS PANGGILAN ---
              Step(
                isActive: _currentStep >= 1,
                title: const Text("Status & Tanggal Panggilan"),
                content: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _vocationStatus,
                      decoration: const InputDecoration(labelText: "Status Panggilan (Wajib)"),
                      items: _vocationList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => _vocationStatus = val),
                    ),
                    // Tampilkan form tanggal berdasarkan status yang dipilih
                    if (_vocationStatus != 'Noviatus' && _vocationStatus != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Tanggal Kaul Perdana"),
                        subtitle: Text(_formatDate(_firstProfDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context, (d) => _firstProfDate = d),
                      ),
                    if (_vocationStatus == 'Solemniter' || _vocationStatus == 'Sacerdotalis')
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Tanggal Kaul Kekal"),
                        subtitle: Text(_formatDate(_solemnProfDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context, (d) => _solemnProfDate = d),
                      ),
                    if (_vocationStatus == 'Sacerdotalis')
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Tanggal Tahbisan"),
                        subtitle: Text(_formatDate(_ordinationDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context, (d) => _ordinationDate = d),
                      ),
                  ],
                )
              ),
              // --- STEP 3: PENEMPATAN LOKASI ---
              Step(
                isActive: _currentStep >= 2,
                title: const Text("Penempatan Wilayah"),
                content: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: _selectedEntityId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: "Entitas / Provinsi (Wajib)"),
                      items: _entities.map((e) => DropdownMenuItem<int>(
                        value: e['id'], 
                        child: Text("${e['name']} (${e['entity_category']})")
                      )).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedEntityId = val;
                          _selectedConventusId = null; // Reset biara jika provinsi ganti
                        });
                        if (val != null) _fetchConventus(val);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: _selectedConventusId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: "Biara / Komunitas (Opsional)"),
                      items: _conventusList.map((c) => DropdownMenuItem<int>(
                        value: c['id'], 
                        child: Text(c['name'])
                      )).toList(),
                      onChanged: (val) => setState(() => _selectedConventusId = val),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _roleController, 
                      decoration: const InputDecoration(labelText: "Peran Pribadi", hintText: "Contoh: Sodales, Prior, dll")
                    ),
                  ],
                )
              ),
            ],
          ),
    );
  }
}