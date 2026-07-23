import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class HalamanTambahAnggota extends StatefulWidget {
  const HalamanTambahAnggota({super.key});

  @override
  State<HalamanTambahAnggota> createState() => _HalamanTambahAnggotaState();
}

class _HalamanTambahAnggotaState extends State<HalamanTambahAnggota> {
  int _currentStep = 0;
  final _supabase = Supabase.instance.client;

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

  @override
  void initState() {
    super.initState();
    _fetchEntities(); // Ambil data pangkalan untuk dropdown
  }

  Future<void> _fetchEntities() async {
    try {
      final response = await _supabase.from('entities').select('id, name, entity_category').order('name');
      setState(() => _entities = response);
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
      await _supabase.from('members').insert({
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
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Anggota Berhasil Ditambahkan!")));
        Navigator.pop(context, true); // Kembali dan beri sinyal refresh
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
      appBar: AppBar(title: const Text("Pendaftaran Anggota Baru")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.brown))
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
                      child: Text(_currentStep == 2 ? 'Simpan Data' : 'Lanjut'),
                    ),
                    const SizedBox(width: 10),
                    if (_currentStep > 0)
                      TextButton(onPressed: details.onStepCancel, child: const Text("Kembali")),
                  ],
                ),
              );
            },
            steps: [
              // --- STEP 1: BIODATA ---
              Step(
                isActive: _currentStep >= 0,
                title: const Text("Biodata Pribadi"),
                content: Column(
                  children: [
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