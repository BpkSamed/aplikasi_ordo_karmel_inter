import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN UTAMA: MENU PILIHAN STATISTIKA
/// =================================================================
class HalamanStatistica extends StatelessWidget {
  const HalamanStatistica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistica (Data Statistik)"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Pilih Kategori Statistik:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Statistica Fratres",
            subtitle: "Per Provincia / Commissariatus / Delegatio Generalis",
            icon: Icons.bar_chart,
            kategoriDb: "Fratres",
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Statistica Moniales",
            subtitle: "General Moniales",
            icon: Icons.pie_chart,
            kategoriDb: "Moniales",
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Statistica Heremiti",
            subtitle: "General Heremiti",
            icon: Icons.stacked_bar_chart,
            kategoriDb: "Heremiti",
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Statistica Monasteria Ordinis",
            subtitle: "General Monasteria (Propriis Utuntur)",
            icon: Icons.donut_large,
            kategoriDb: "Monasteria Ordinis",
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String kategoriDb,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.brown,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanDetailStatistika(
                judul: title,
                kategoriEntitas: kategoriDb,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// HALAMAN DASBOR STATISTIK DINAMIS (MENGHITUNG OTOMATIS DARI DB)
/// =================================================================
class HalamanDetailStatistika extends StatefulWidget {
  final String judul;
  final String kategoriEntitas;

  const HalamanDetailStatistika({
    super.key,
    required this.judul,
    required this.kategoriEntitas,
  });

  @override
  State<HalamanDetailStatistika> createState() => _HalamanDetailStatistikaState();
}

class _HalamanDetailStatistikaState extends State<HalamanDetailStatistika> {
  // Variabel penampung hasil kalkulasi
  int _jumlahDomus = 0;
  int _jumlahSacerdotalis = 0;
  int _jumlahSolemniter = 0;
  int _jumlahTemporaneae = 0;
  int _jumlahNoviatus = 0;
  List<String> _daftarNegara = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStatistica();
  }

  Future<void> _fetchStatistica() async {
    try {
      final supabase = Supabase.instance.client;

      // 1. Mengambil Data Conventus untuk menghitung Domus & Persebaran Negara
      final responseConventus = await supabase
          .from('conventus')
          .select('addresses(country), entities!inner(entity_category)')
          .eq('entities.entity_category', widget.kategoriEntitas);

      Set<String> uniqueCountries = {};
      int countDomus = 0;

      for (var conv in responseConventus) {
        countDomus++;
        final address = conv['addresses'];
        if (address != null && address['country'] != null) {
          final String negara = address['country'].toString().trim();
          if (negara.isNotEmpty) {
            uniqueCountries.add(negara);
          }
        }
      }

      // 2. Mengambil Data Anggota (Members) untuk Klasifikasi Kaul & Tahbisan
      final responseMembers = await supabase
          .from('members')
          .select('first_profession_date, solemn_profession_date, ordination_date, entities!inner(entity_category)')
          .eq('entities.entity_category', widget.kategoriEntitas);

      int countSacerdotalis = 0;
      int countSolemniter = 0;
      int countTemporaneae = 0;
      int countNoviatus = 0;

      for (var member in responseMembers) {
        bool isSacerdotalis = member['ordination_date'] != null && member['ordination_date'].toString().isNotEmpty;
        bool isSolemniter = member['solemn_profession_date'] != null && member['solemn_profession_date'].toString().isNotEmpty;
        bool isTemporaneae = member['first_profession_date'] != null && member['first_profession_date'].toString().isNotEmpty && !isSolemniter;
        bool isNovice = !isSolemniter && !isTemporaneae; // Belum kaul perdana masuk Novis/Postulan

        if (isSacerdotalis) countSacerdotalis++;
        if (isSolemniter) countSolemniter++;
        if (isTemporaneae) countTemporaneae++;
        if (isNovice) countNoviatus++;
      }

      setState(() {
        _jumlahDomus = countDomus;
        _daftarNegara = uniqueCountries.toList()..sort();
        _jumlahSacerdotalis = countSacerdotalis;
        _jumlahSolemniter = countSolemniter;
        _jumlahTemporaneae = countTemporaneae;
        _jumlahNoviatus = countNoviatus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judul),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _errorMessage != null
              ? Center(child: Text("Terjadi kesalahan: $_errorMessage", style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rekapitulasi Data",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                      const SizedBox(height: 15),

                      // Grid Kartu Angka Statistik
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.3,
                        children: [
                          _buildStatCard("Domus (Rumah)", _jumlahDomus.toString(), Icons.holiday_village),
                          _buildStatCard("Noviatus", _jumlahNoviatus.toString(), Icons.spa),
                          _buildStatCard("Prof. Temporaneae\n(Kaul Perdana)", _jumlahTemporaneae.toString(), Icons.event),
                          _buildStatCard("Solemn. Professus\n(Kaul Kekal)", _jumlahSolemniter.toString(), Icons.event_available),
                          
                          // Tampilkan Tahbisan Imam (Sacerdotalis) HANYA untuk Fratres/Heremiti
                          if (widget.kategoriEntitas == "Fratres" || widget.kategoriEntitas == "Heremiti")
                            _buildStatCard("Sacerdotalis\n(Imam)", _jumlahSacerdotalis.toString(), Icons.church),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Daftar Negara Tempat Berkarya
                      const Text(
                        "Daftar Negara Tempat Berkarya:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                      const SizedBox(height: 10),
                      _daftarNegara.isEmpty
                          ? const Text("Belum ada data negara yang terdaftar pada alamat biara/komunitas.")
                          : Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: _daftarNegara.map((negara) {
                                return Chip(
                                  label: Text(negara, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.brown.shade50,
                                  side: const BorderSide(color: Colors.brown),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
    );
  }

  // Widget Kartu Individual untuk tiap kategori angka
  Widget _buildStatCard(String title, String count, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.brown, size: 28),
                const SizedBox(width: 8),
                Text(
                  count,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}