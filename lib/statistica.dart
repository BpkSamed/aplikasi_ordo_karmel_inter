import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

/// =================================================================
/// HALAMAN UTAMA: MENU PILIHAN STATISTIKA
/// =================================================================
class HalamanStatistica extends StatelessWidget {
  const HalamanStatistica({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.statisticaTitle ?? "Statistica (Data Statistik)"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              Text(
                t.selectStatisticCategory ?? "Pilih Kategori Statistik:",
                style: TextStyle(
                  fontSize: baseWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.statisticaFratres ?? "Statistica Fratres",
                subtitle: t.statisticaFratresSubtitle ?? "Per Provincia / Commissariatus / Delegatio Generalis",
                icon: Icons.bar_chart,
                kategoriDb: "Fratres",
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.statisticaMoniales ?? "Statistica Moniales",
                subtitle: t.statisticaMonialesSubtitle ?? "General Moniales",
                icon: Icons.pie_chart,
                kategoriDb: "Moniales",
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.statisticaHeremiti ?? "Statistica Heremiti",
                subtitle: t.statisticaHeremitiSubtitle ?? "General Heremiti",
                icon: Icons.stacked_bar_chart,
                kategoriDb: "Heremiti",
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.statisticaMonasteria ?? "Statistica Monasteria Ordinis",
                subtitle: t.statisticaMonasteriaSubtitle ?? "General Monasteria (Propriis Utuntur)",
                icon: Icons.donut_large,
                kategoriDb: "Monasteria Ordinis",
                baseWidth: baseWidth,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String kategoriDb,
    required double baseWidth,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: baseWidth * 0.03,
          horizontal: baseWidth * 0.04,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.brown,
          child: Icon(icon, color: Colors.white, size: baseWidth * 0.055),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown,
            fontSize: baseWidth * 0.038,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: baseWidth * 0.032)),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04),
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judul),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          if (_errorMessage != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(baseWidth * 0.04),
                child: Text(
                  "${t.databaseError ?? 'Terjadi kesalahan'}: $_errorMessage",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: baseWidth * 0.038),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(baseWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.dataRecapitulation ?? "Rekapitulasi Data",
                  style: TextStyle(
                    fontSize: baseWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: baseWidth * 0.035),

                // Grid Kartu Angka Statistik
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: baseWidth * 0.025,
                  mainAxisSpacing: baseWidth * 0.025,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStatCard(
                      t.domusHouse ?? "Domus (Rumah)",
                      _jumlahDomus.toString(),
                      Icons.holiday_village,
                      baseWidth,
                    ),
                    _buildStatCard(
                      t.noviatus ?? "Noviatus",
                      _jumlahNoviatus.toString(),
                      Icons.spa,
                      baseWidth,
                    ),
                    _buildStatCard(
                      t.profTemporaneae ?? "Prof. Temporaneae\n(Kaul Perdana)",
                      _jumlahTemporaneae.toString(),
                      Icons.event,
                      baseWidth,
                    ),
                    _buildStatCard(
                      t.solemnProfessus ?? "Solemn. Professus\n(Kaul Kekal)",
                      _jumlahSolemniter.toString(),
                      Icons.event_available,
                      baseWidth,
                    ),
                    
                    // Tampilkan Tahbisan Imam (Sacerdotalis) HANYA untuk Fratres/Heremiti
                    if (widget.kategoriEntitas == "Fratres" || widget.kategoriEntitas == "Heremiti")
                      _buildStatCard(
                        t.sacerdotalisPriest ?? "Sacerdotalis\n(Imam)",
                        _jumlahSacerdotalis.toString(),
                        Icons.church,
                        baseWidth,
                      ),
                  ],
                ),
                SizedBox(height: baseWidth * 0.075),

                // Daftar Negara Tempat Berkarya
                Text(
                  t.listCountriesWork ?? "Daftar Negara Tempat Berkarya:",
                  style: TextStyle(
                    fontSize: baseWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: baseWidth * 0.025),
                _daftarNegara.isEmpty
                    ? Text(
                        t.noCountriesData ?? "Belum ada data negara yang terdaftar pada alamat biara/komunitas.",
                        style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.grey),
                      )
                    : Wrap(
                        spacing: baseWidth * 0.02,
                        runSpacing: baseWidth * 0.02,
                        children: _daftarNegara.map((negara) {
                          return Chip(
                            label: Text(
                              negara,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: baseWidth * 0.035,
                              ),
                            ),
                            backgroundColor: Colors.brown.shade50,
                            side: const BorderSide(color: Colors.brown),
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget Kartu Individual untuk tiap kategori angka
  Widget _buildStatCard(String title, String count, IconData icon, double baseWidth) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(baseWidth * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.brown, size: baseWidth * 0.065),
                SizedBox(width: baseWidth * 0.02),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: baseWidth * 0.075,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            SizedBox(height: baseWidth * 0.02),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: baseWidth * 0.03,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}