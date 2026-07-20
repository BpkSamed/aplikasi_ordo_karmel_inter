import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN UTAMA: DASBOR KELOLA DATA NON ANGGOTA
/// =================================================================
class HalamanDataNonAnggota extends StatelessWidget {
  const HalamanDataNonAnggota({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Data Non Anggota")),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Pilih Tabel Referensi yang Ingin Diisi:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 15),
          _buildSubMenu(context, "1. Kelola Entities / Provinsi Induk", "Isi Sejarah, Kategori, Website, & Alamat Pusat Wilayah", const FormTambahEntity()),
          _buildSubMenu(context, "2. Kelola Conventus / Rumah Biara", "Daftarkan Rumah Biara/Pertapaan baru serta Lokasinya", const FormTambahConventus()),
          _buildSubMenu(context, "3. Kelola Episcopi / Daftar Uskup", "Isi nama Uskup ex-Carmelite, Keuskupan, & Alamat Kontak", const FormTambahEpiscopi()),
        ],
      ),
    );
  }

  Widget _buildSubMenu(BuildContext context, String title, String subtitle, Widget targetPage) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.add_circle, color: Colors.brown),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
      ),
    );
  }
}

/// =================================================================
/// KODE BLOCK REUSABLE: FORM INPUT ALAMAT (TABEL ADDRESSES)
/// =================================================================
class WidgetFormAlamat {
  final houseNameCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final postalCodeCtrl = TextEditingController();
  final telephoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mapsUrlCtrl = TextEditingController(); // Untuk menampung Link Share Google Maps

  Widget buildUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40, thickness: 2),
        const Text("Informasi Alamat & Kontak (Tabel Address)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
        const SizedBox(height: 15),
        TextFormField(controller: houseNameCtrl, decoration: const InputDecoration(labelText: "Nama Rumah / Gedung Resmi", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextFormField(
          controller: mapsUrlCtrl, 
          decoration: const InputDecoration(
            labelText: "Link Share Location Google Maps", 
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.pin_drop, color: Colors.red),
            hintText: "https://maps.app.goo.gl/..."
          )
        ),
        const SizedBox(height: 12),
        TextFormField(controller: streetCtrl, maxLines: 2, decoration: const InputDecoration(labelText: "Nama Jalan / Detail Alamat Manual", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: TextFormField(controller: cityCtrl, decoration: const InputDecoration(labelText: "Kota", border: OutlineInputBorder()))),
            const SizedBox(width: 10),
            Expanded(child: TextFormField(controller: countryCtrl, decoration: const InputDecoration(labelText: "Negara", border: OutlineInputBorder()))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: TextFormField(controller: postalCodeCtrl, decoration: const InputDecoration(labelText: "Kode Pos", border: OutlineInputBorder()))),
            const SizedBox(width: 10),
            Expanded(child: TextFormField(controller: telephoneCtrl, decoration: const InputDecoration(labelText: "No. Telepon Kontat", border: OutlineInputBorder()))),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email Resmi Kantor/Biara", border: OutlineInputBorder())),
      ],
    );
  }

  // Fungsi internal untuk memproses insert ke tabel addresses terlebih dahulu
  Future<int?> simpanAlamatKeDatabase() async {
    final supabase = Supabase.instance.client;
    
    // Gabungkan detail jalan manual dengan link Google Maps jika ada agar terdokumentasi rapi di database
    String alamatLengkap = streetCtrl.text.trim();
    if (mapsUrlCtrl.text.trim().isNotEmpty) {
      alamatLengkap += "\nGoogle Maps: ${mapsUrlCtrl.text.trim()}";
    }

    if (houseNameCtrl.text.isEmpty && alamatLengkap.isEmpty) return null;

    final resAddress = await supabase.from('addresses').insert({
      'house_name': houseNameCtrl.text.trim(),
      'street': alamatLengkap,
      'city': cityCtrl.text.trim(),
      'country': countryCtrl.text.trim(),
      'postal_code': postalCodeCtrl.text.trim(),
      'telephone': telephoneCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
    }).select('id').single();

    return resAddress['id'] as int;
  }
}

/// =================================================================
/// 1. FORM TAMBAH DATA ENTITIES (PROVINSI / KOMISI / FEDERASI)
/// =================================================================
class FormTambahEntity extends StatefulWidget {
  const FormTambahEntity({super.key});
  @override
  State<FormTambahEntity> createState() => _FormTambahEntityState();
}

class _FormTambahEntityState extends State<FormTambahEntity> {
  bool _isLoading = false;
  String? _kategoriTerpilih = "Fratres";
  final _nameCtrl = TextEditingController();
  final _historiaCtrl = TextEditingController();
  final _webCtrl = TextEditingController();
  final _formAlamat = WidgetFormAlamat();

  Future<void> _submitData() async {
    if (_nameCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final idAlamat = await _formAlamat.simpanAlamatKeDatabase();
      await Supabase.instance.client.from('entities').insert({
        'entity_category': _kategoriTerpilih,
        'name': _nameCtrl.text.trim(),
        'historia': _historiaCtrl.text.trim(),
        'website_url': _webCtrl.text.trim(),
        'address_id': idAlamat,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Entitas Baru Berhasil Tersimpan!")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Data Entitas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _kategoriTerpilih,
              decoration: const InputDecoration(labelText: "Kategori Entitas", border: OutlineInputBorder()),
              items: ["Fratres", "Moniales", "Heremiti", "Heremitae", "Instituta", "Curia Generalis"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _kategoriTerpilih = v),
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nama Entitas (Contoh: Provinsi Indonesia)", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextFormField(controller: _webCtrl, decoration: const InputDecoration(labelText: "Website Resmi URL", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextFormField(controller: _historiaCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Historia / Catatan Sejarah Ringkas", border: OutlineInputBorder())),
            _formAlamat.buildUI(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.brown, foregroundColor: Colors.white),
              onPressed: _isLoading ? null : _submitData,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN ENTITAS", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

/// =================================================================
/// 2. FORM TAMBAH DATA CONVENTUS (RUMAH BIARA)
/// =================================================================
class FormTambahConventus extends StatefulWidget {
  const FormTambahConventus({super.key});
  @override
  State<FormTambahConventus> createState() => _FormTambahConventusState();
}

class _FormTambahConventusState extends State<FormTambahConventus> {
  bool _isLoading = false;
  bool _isFetching = true;
  List<dynamic> _listEntities = [];
  int? _selectedEntityId;
  final _nameCtrl = TextEditingController();
  final _formAlamat = WidgetFormAlamat();

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    final res = await Supabase.instance.client.from('entities').select('id, name').order('name');
    setState(() {
      _listEntities = res;
      _isFetching = false;
    });
  }

  Future<void> _submitData() async {
    if (_nameCtrl.text.isEmpty || _selectedEntityId == null) return;
    setState(() => _isLoading = true);
    try {
      final idAlamat = await _formAlamat.simpanAlamatKeDatabase();
      await Supabase.instance.client.from('conventus').insert({
        'name': _nameCtrl.text.trim(),
        'parent_entity_id': _selectedEntityId,
        'address_id': idAlamat,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Rumah Biara Berhasil Ditambahkan!")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Data Biara / Conventus")),
      body: _isFetching 
        ? const Center(child: CircularProgressIndicator(color: Colors.brown))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedEntityId,
                  hint: const Text("Pilih Provinsi / Entitas Induk..."),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: _listEntities.map((e) => DropdownMenuItem<int>(value: e['id'] as int, child: Text(e['name']))).toList(),
                  onChanged: (v) => setState(() => _selectedEntityId = v),
                ),
                const SizedBox(height: 12),
                TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nama Rumah Biara / Komunitas", border: OutlineInputBorder())),
                _formAlamat.buildUI(),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  onPressed: _isLoading ? null : _submitData,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN RUMAH BIARA", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
    );
  }
}

/// =================================================================
/// 3. FORM TAMBAH DATA EPISCOPI (USKUP)
/// =================================================================
class FormTambahEpiscopi extends StatefulWidget {
  const FormTambahEpiscopi({super.key});
  @override
  State<FormTambahEpiscopi> createState() => _FormTambahEpiscopiState();
}

class _FormTambahEpiscopiState extends State<FormTambahEpiscopi> {
  bool _isLoading = false;
  final _nameCtrl = TextEditingController();
  final _dioceseCtrl = TextEditingController();
  final _exCarmCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();
  final _formAlamat = WidgetFormAlamat();

  Future<void> _submitData() async {
    if (_nameCtrl.text.isEmpty || _dioceseCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final idAlamat = await _formAlamat.simpanAlamatKeDatabase();
      await Supabase.instance.client.from('episcopi').insert({
        'name': _nameCtrl.text.trim(),
        'diocese': _dioceseCtrl.text.trim(),
        'ex_carmelite_entity': _exCarmCtrl.text.trim(),
        'status': _statusCtrl.text.trim(),
        'address_id': idAlamat,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Uskup Baru Berhasil Ditambahkan!")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Data Uskup (Episcopi)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nama Lengkap Uskup", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextFormField(controller: _dioceseCtrl, decoration: const InputDecoration(labelText: "Wilayah Keuskupan (Diocese)", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextFormField(controller: _exCarmCtrl, decoration: const InputDecoration(labelText: "Asal Provinsi Karmel (Ex-Carmelite Entity)", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextFormField(controller: _statusCtrl, decoration: const InputDecoration(labelText: "Status (Contoh: Aktif / Emeritus)", border: OutlineInputBorder())),
            _formAlamat.buildUI(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.brown, foregroundColor: Colors.white),
              onPressed: _isLoading ? null : _submitData,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN DATA USKUP", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}