import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart'; // Import form tambah anggota

// Model data disesuaikan dengan struktur Supabase
class AnggotaData {
  final int id; // ID di Supabase menggunakan Integer
  final String kategori; // Diambil dari kolom 'role'
  final String entity;
  final String conventus;
  final String namaLengkap;
  final String kotaKelahiran;
  final String negaraKelahiran;
  final String tglLahir;
  final String tglKaulPerdana;
  final String tglKaulKekal;
  final String tglTahbisan; 
  bool isSelected;

  AnggotaData({
    required this.id,
    required this.kategori,
    required this.entity,
    required this.conventus,
    required this.namaLengkap,
    required this.kotaKelahiran,
    required this.negaraKelahiran,
    required this.tglLahir,
    required this.tglKaulPerdana,
    required this.tglKaulKekal,
    this.tglTahbisan = "-",
    this.isSelected = false,
  });

  // Factory untuk memetakan data JSON dari Supabase ke Object Dart
  factory AnggotaData.fromMap(Map<String, dynamic> map) {
    return AnggotaData(
      id: map['id'],
      kategori: map['role'] ?? '-',
      entity: map['entities']?['name'] ?? 'Entitas tidak diketahui',
      conventus: map['conventus']?['name'] ?? 'Belum ditentukan',
      namaLengkap: map['full_name'] ?? '-',
      kotaKelahiran: map['city_of_birth'] ?? '-',
      negaraKelahiran: map['country_of_birth'] ?? '-',
      tglLahir: map['date_of_birth']?.toString() ?? '-',
      tglKaulPerdana: map['first_profession_date']?.toString() ?? '-',
      tglKaulKekal: map['solemn_profession_date']?.toString() ?? '-',
      tglTahbisan: map['ordination_date']?.toString() ?? '-',
    );
  }
}

class HalamanDaftarAnggota extends StatefulWidget {
  const HalamanDaftarAnggota({super.key});

  @override
  State<HalamanDaftarAnggota> createState() => _HalamanDaftarAnggotaState();
}

class _HalamanDaftarAnggotaState extends State<HalamanDaftarAnggota> {
  List<AnggotaData> _allAnggota = [];
  List<AnggotaData> _filteredAnggota = [];
  final TextEditingController _searchController = TextEditingController();
  
  bool _isMultiSelectMode = false;
  bool _isLoading = true; // Indikator pemuatan database

  @override
  void initState() {
    super.initState();
    _loadDataDariDatabase(); // Memanggil data dari Supabase saat halaman dibuka
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 1. FUNGSI MENGAMBIL DATA DARI SUPABASE
  Future<void> _loadDataDariDatabase() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('members')
          .select('*, entities(name, entity_category), conventus(name)')
          .order('full_name', ascending: true);

      final List<AnggotaData> loadedData = (response as List<dynamic>)
          .map((e) => AnggotaData.fromMap(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _allAnggota = loadedData;
        _filterList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e"), backgroundColor: Colors.red),
      );
      setState(() => _isLoading = false);
    }
  }

  // Fungsi Search Lokal
  void _filterList() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnggota = _allAnggota.where((anggota) {
        return anggota.namaLengkap.toLowerCase().contains(query) ||
            anggota.entity.toLowerCase().contains(query) ||
            anggota.kategori.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Multi-select toggle
  void _toggleSelect(int index) {
    setState(() {
      _filteredAnggota[index].isSelected = !_filteredAnggota[index].isSelected;
      _isMultiSelectMode = _allAnggota.any((anggota) => anggota.isSelected);
    });
  }

  // Clear Selection
  void _clearSelection() {
    setState(() {
      for (var anggota in _allAnggota) {
        anggota.isSelected = false;
      }
      _isMultiSelectMode = false;
    });
  }

  // 2. FUNGSI HAPUS BANYAK (MULTI-SELECT) KE SUPABASE
  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Berkas Anggota"),
        content: const Text("Apakah Anda yakin ingin menghapus data anggota yang terpilih secara permanen?"),
        actions: [
          TextButton(
            onPressed: () async {
              // 1. SIMPAN REFERENSI CONTEXT SEBELUM AWAIT ATAU POP
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              
              // 2. Tutup dialog konfirmasi
              navigator.pop(); 
              
              final selectedIds = _allAnggota.where((a) => a.isSelected).map((a) => a.id).toList();

              try {
                await Supabase.instance.client
                    .from('members')
                    .delete()
                    .inFilter('id', selectedIds);
                
                // 3. Gunakan referensi 'messenger' yang sudah disimpan agar aman
                messenger.showSnackBar(
                  const SnackBar(content: Text("Data anggota terpilih berhasil dihapus.")),
                );
                
                _clearSelection();
                _loadDataDariDatabase(); 
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text("Gagal menghapus data: $e"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = _allAnggota.where((anggota) => anggota.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isMultiSelectMode ? "$selectedCount Terpilih" : "Daftar Anggota"),
        leading: _isMultiSelectMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
      ),
      body: Column(
        children: [
          // 1. Fitur Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Cari Anggota (Nama / Entity / Kategori)...",
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
            ),
          ),

          // 2. Tabel Data Anggota
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : _filteredAnggota.isEmpty
                    ? const Center(child: Text("Tidak ada data anggota ditemukan."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        itemCount: _filteredAnggota.length,
                        itemBuilder: (context, index) {
                          final anggota = _filteredAnggota[index];
                          return Card(
                            color: anggota.isSelected ? Colors.brown.shade50 : Colors.white,
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 12.0), // Margin 2x
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), // Padding 2x
                              leading: _isMultiSelectMode
                                  ? Transform.scale(
                                      scale: 1.5, // Checkbox 2x
                                      child: Checkbox(
                                        value: anggota.isSelected,
                                        activeColor: Colors.brown,
                                        onChanged: (bool? value) {
                                          _toggleSelect(index);
                                        },
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 40, // Avatar 2x
                                      backgroundColor: Colors.brown,
                                      child: Icon(Icons.person, color: Colors.white, size: 45),
                                    ),
                              title: Text(
                                anggota.namaLengkap,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22), // Font Title 2x
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "${anggota.entity}\n${anggota.kategori}",
                                  style: const TextStyle(fontSize: 16), // Font Subtitle 2x
                                ),
                              ),
                              onTap: () {
                                if (_isMultiSelectMode) {
                                  _toggleSelect(index);
                                } else {
                                  // Navigasi ke Detail Data Anggota
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HalamanDetailAnggota(
                                        anggota: anggota,
                                        // Panggil fungsi segarkan data (refresh) saat kembali dari halaman detail jika ada yang dihapus
                                        onRefresh: _loadDataDariDatabase, 
                                      ),
                                    ),
                                  );
                                }
                              },
                              onLongPress: () {
                                if (!_isMultiSelectMode) {
                                  _toggleSelect(index);
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),

          // 3. Tombol Delete (Di atas tombol tambah anggota, agar tidak tertumpuk)
          if (_isMultiSelectMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _deleteSelected,
                icon: const Icon(Icons.delete),
                label: Text("HAPUS DATA TERPILIH ($selectedCount)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

          // 4. Tombol Tambah Anggota (Selalu ada di bawah)
          Padding(
            padding: EdgeInsets.only(
              left: 16.0, 
              right: 16.0, 
              bottom: 16.0,
              top: _isMultiSelectMode ? 0 : 16.0 
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Arahkan ke Form Tambah Anggota
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanTambahAnggota()),
                ).then((_) {
                  // Segarkan data saat pengguna kembali ke halaman ini dari form tambah
                  _loadDataDariDatabase(); 
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("TAMBAH ANGGOTA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

/// =================================================================
/// HALAMAN DETAIL DATA ANGGOTA (TERKONEKSI DATABASE)
/// =================================================================
class HalamanDetailAnggota extends StatelessWidget {
  final AnggotaData anggota;
  final VoidCallback onRefresh; // Callback untuk menyegarkan halaman daftar

  const HalamanDetailAnggota({
    super.key,
    required this.anggota,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Data Anggota"),
      ),
      body: Column(
        children: [
          // Expanded agar bagian konten bisa di-scroll dan tombol tetap di bawah
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.brown,
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Tampilan Informasi Detail
                  _buildDetailField("Kategori / Peran", anggota.kategori, Icons.category),
                  const Divider(),
                  _buildDetailField("Entity / Provinsi", anggota.entity, Icons.domain),
                  const Divider(),
                  _buildDetailField("Biara / Komunitas", anggota.conventus, Icons.holiday_village),
                  const Divider(),
                  _buildDetailField("Nama Lengkap", anggota.namaLengkap, Icons.badge),
                  const Divider(),
                  _buildDetailField("Tempat, Tanggal Lahir", "${anggota.kotaKelahiran}, ${anggota.negaraKelahiran}\n(${anggota.tglLahir})", Icons.cake),
                  const Divider(),
                  _buildDetailField("Tanggal Kaul Perdana", anggota.tglKaulPerdana, Icons.event),
                  const Divider(),
                  _buildDetailField("Tanggal Kaul Kekal", anggota.tglKaulKekal, Icons.event_available),
                  
                  if (anggota.tglTahbisan != "-") ...[
                    const Divider(),
                    _buildDetailField("Tanggal Tahbisan", anggota.tglTahbisan, Icons.church),
                  ]
                ],
              ),
            ),
          ),

          // Menu Tombol Edit dan Delete statis di bagian bawah layar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.brown, width: 2),
                      foregroundColor: Colors.brown,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Membuka Form Edit Data Anggota...")),
                      );
                      // TODO: Nantinya arahkan ke HalamanTambahAnggota dengan mode lempar nilai (Pass Data)
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("EDIT", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Hapus Anggota"),
                          content: Text("Apakah Anda yakin ingin menghapus '${anggota.namaLengkap}' secara permanen?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () async {
                                // 1. SIMPAN REFERENSI CONTEXT SEBELUM AWAIT ATAU POP
                                final navigator = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);

                                // 2. Tutup dialog konfirmasi
                                navigator.pop(); 
                                
                                try {
                                  await Supabase.instance.client
                                      .from('members')
                                      .delete()
                                      .eq('id', anggota.id); 
                                  
                                  onRefresh(); 
                                  // 3. Tutup Halaman Detail menggunakan referensi 'navigator' aman
                                  navigator.pop(); 
                                  
                                  // 4. Munculkan pesan sukses
                                  messenger.showSnackBar(
                                    SnackBar(content: Text("Data '${anggota.namaLengkap}' berhasil dihapus.")),
                                  );
                                } catch (e) {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text("Gagal menghapus: $e"), backgroundColor: Colors.red),
                                  );
                                }
                              },
                              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("DELETE", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}