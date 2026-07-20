import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN TAMBAH/EDIT DATA ANGGOTA (PERBAIKAN KATEGORI KAPITAL)
/// =================================================================
class HalamanTambahAnggota extends StatefulWidget {
  const HalamanTambahAnggota({super.key});

  @override
  State<HalamanTambahAnggota> createState() => _HalamanTambahAnggotaState();
}

class _HalamanTambahAnggotaState extends State<HalamanTambahAnggota> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; 

  // Kategori Peran (Role)
  String? _kategoriTerpilih;
  final List<String> _kategoriAnggota = [
    "FRATRES - SODALES",
    "HEREMITI",
    "MONIALES",
    "HEREMITAE",
    "INSTITUTA"
  ];

  // Controller Teks
  final _entityController = TextEditingController();
  final _conventusController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _kotaKelahiranController = TextEditingController();
  final _negaraKelahiranController = TextEditingController();
  
  final _tglLahirController = TextEditingController();
  final _tglKaulPerdanaController = TextEditingController();
  final _tglKaulKekalController = TextEditingController();
  final _tglTahbisanController = TextEditingController();

  @override
  void dispose() {
    _entityController.dispose();
    _conventusController.dispose();
    _nameController.dispose();
    _passwordController.dispose(); 
    _kotaKelahiranController.dispose();
    _negaraKelahiranController.dispose();
    _tglLahirController.dispose();
    _tglKaulPerdanaController.dispose();
    _tglKaulKekalController.dispose();
    _tglTahbisanController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context, TextEditingController controller) async {
    DateTime? tanggalTerpilih = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.brown, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (tanggalTerpilih != null) {
      setState(() {
        controller.text = "${tanggalTerpilih.year}-${tanggalTerpilih.month.toString().padLeft(2, '0')}-${tanggalTerpilih.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // FUNGSI UTAMA: MENYIMPAN DATA
  Future<void> _simpanKeDatabase() async {
    final nama = _nameController.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi Nama terlebih dahulu!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // 1. Tangani Entitas (Pencocokan & Normalisasi Huruf Kapital)
      int? idEntitas;
      final namaEntitas = _entityController.text.trim();
      if (namaEntitas.isNotEmpty) {
        final entitasRes = await supabase
            .from('entities')
            .select('id')
            .ilike('name', namaEntitas) 
            .maybeSingle();
        
        if (entitasRes != null) {
          idEntitas = entitasRes['id'] as int;
        } else {
          // PERBAIKAN: Pemetaan string kategori agar sesuai dengan pencarian halaman direktori
          String kategoriNormal = 'Umum';
          if (_kategoriTerpilih == "FRATRES - SODALES") kategoriNormal = "Fratres";
          else if (_kategoriTerpilih == "HEREMITI") kategoriNormal = "Heremiti";
          else if (_kategoriTerpilih == "MONIALES") kategoriNormal = "Moniales";
          else if (_kategoriTerpilih == "HEREMITAE") kategoriNormal = "Heremitae";
          else if (_kategoriTerpilih == "INSTITUTA") kategoriNormal = "Instituta";

          final newEntity = await supabase.from('entities').insert({
            'name': namaEntitas,
            'entity_category': kategoriNormal, // Menyimpan dengan format standar (Ex: 'Fratres')
          }).select('id').single();
          
          idEntitas = newEntity['id'] as int;
        }
      }

      // 2. Tangani Conventus / Biara
      int? idConventus;
      final namaConventus = _conventusController.text.trim();
      if (namaConventus.isNotEmpty) {
        final conventusRes = await supabase
            .from('conventus')
            .select('id')
            .ilike('name', namaConventus)
            .maybeSingle();

        if (conventusRes != null) {
          idConventus = conventusRes['id'] as int;
        } else {
          final newConventus = await supabase.from('conventus').insert({
            'name': namaConventus,
            'parent_entity_id': idEntitas 
          }).select('id').single();

          idConventus = newConventus['id'] as int;
        }
      }

      String? parsingTanggal(String teks) => teks.isEmpty ? null : teks;

      // 3. Simpan Profil Anggota Baru
      await supabase.from('members').insert({
        'full_name': nama,
        'role': _kategoriTerpilih,
        'entity_id': idEntitas, 
        'conventus_id': idConventus, 
        'city_of_birth': _kotaKelahiranController.text.trim(),
        'country_of_birth': _negaraKelahiranController.text.trim(),
        'date_of_birth': parsingTanggal(_tglLahirController.text),
        'first_profession_date': parsingTanggal(_tglKaulPerdanaController.text),
        'solemn_profession_date': parsingTanggal(_tglKaulKekalController.text),
        'ordination_date': parsingTanggal(_tglTahbisanController.text),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data anggota '$nama' berhasil disimpan ke database!")),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Data Anggota")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lengkapi Biodata & Akun Anggota",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 20),

              // Dropdown Kategori Peran
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Kategori Data / Peran", border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
                value: _kategoriTerpilih,
                items: _kategoriAnggota.map((kategori) => DropdownMenuItem(value: kategori, child: Text(kategori))).toList(),
                onChanged: (val) => setState(() => _kategoriTerpilih = val),
              ),
              const SizedBox(height: 15),

              // Input ENTITAS
              TextFormField(
                controller: _entityController,
                decoration: const InputDecoration(
                  labelText: "Entity / Provinsi Induk", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.domain),
                  helperText: "Ketik lokasi/entitas (Akan dibuat otomatis jika belum ada)"
                ),
              ),
              const SizedBox(height: 15),

              // Input CONVENTUS
              TextFormField(
                controller: _conventusController,
                decoration: const InputDecoration(
                  labelText: "Rumah Biara / Komunitas", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.holiday_village),
                  helperText: "Ketik nama biara (Akan dibuat otomatis jika belum ada)"
                ),
              ),
              const SizedBox(height: 15),

              // Input NAMA
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name (Nama Lengkap)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 15),

              // Input PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: true, 
                decoration: const InputDecoration(labelText: "Password Akun", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock), helperText: "Opsional untuk login."),
              ),
              const SizedBox(height: 15),

              // Row KOTA & NEGARA
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _kotaKelahiranController, decoration: const InputDecoration(labelText: "Kota Lahir", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city)))),
                  const SizedBox(width: 10),
                  Expanded(child: TextFormField(controller: _negaraKelahiranController, decoration: const InputDecoration(labelText: "Negara Lahir", border: OutlineInputBorder(), prefixIcon: Icon(Icons.flag)))),
                ],
              ),
              const SizedBox(height: 15),

              // TANGGAL-TANGGAL
              TextFormField(controller: _tglLahirController, readOnly: true, decoration: const InputDecoration(labelText: "Tanggal Lahir", border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)), onTap: () => _pilihTanggal(context, _tglLahirController)),
              const SizedBox(height: 15),
              TextFormField(controller: _tglKaulPerdanaController, readOnly: true, decoration: const InputDecoration(labelText: "Tanggal Kaul Perdana", border: OutlineInputBorder(), prefixIcon: Icon(Icons.event)), onTap: () => _pilihTanggal(context, _tglKaulPerdanaController)),
              const SizedBox(height: 15),
              TextFormField(controller: _tglKaulKekalController, readOnly: true, decoration: const InputDecoration(labelText: "Tanggal Kaul Kekal", border: OutlineInputBorder(), prefixIcon: Icon(Icons.event_available)), onTap: () => _pilihTanggal(context, _tglKaulKekalController)),
              const SizedBox(height: 15),
              TextFormField(controller: _tglTahbisanController, readOnly: true, decoration: const InputDecoration(labelText: "Tanggal Tahbisan (Bila ada)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.church)), onTap: () => _pilihTanggal(context, _tglTahbisanController)),
              const SizedBox(height: 30),

              // TOMBOL SIMPAN
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.brown, foregroundColor: Colors.white),
                onPressed: _isLoading ? null : _simpanKeDatabase,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN DATA ANGGOTA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}