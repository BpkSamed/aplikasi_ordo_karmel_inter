import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: STATISTICA
/// Berdasarkan alur: Pilihan kategori statistik Ordo
/// =================================================================
class HalamanStatistica extends StatelessWidget {
  const HalamanStatistica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("STATISTICA")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildCategoryCard(context, "FRATRES", Icons.groups),
          _buildCategoryCard(context, "MONIALES", Icons.vignette),
          _buildCategoryCard(context, "HEREMITI", Icons.landscape),
          _buildCategoryCard(context, "MONASTERIA ORDINIS...", Icons.church),
          _buildCategoryCard(context, "HEREMITAE", Icons.home_work),
          _buildCategoryCard(context, "INSTITUTA", Icons.account_balance),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => HalamanDetailStatistica(kategori: title)
        )),
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DETAIL STATISTIK PER KATEGORI
/// Menampilkan data GENERAL, PER ENTITY (khusus Fratres), dan NEGARA
/// =================================================================
class HalamanDetailStatistica extends StatelessWidget {
  final String kategori;
  const HalamanDetailStatistica({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kategori == "FRATRES" ? 3 : 2, // Fratres punya tab "Per Entity"
      child: Scaffold(
        appBar: AppBar(
          title: Text("Statistik $kategori"),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.yellowAccent, // Warna teks saat tab dipilih (Terang)
            unselectedLabelColor: Colors.white70, // Warna teks tab lain (Sedikit pudar)
            indicatorColor: Colors.yellowAccent, // Warna garis bawah tab (Terang)
            indicatorWeight: 3.0, // Ketebalan garis bawah
            tabs: [
              const Tab(text: "GENERAL"),
              if (kategori == "FRATRES") const Tab(text: "PER PROVINCIA"),
              const Tab(text: "NEGARA BERKARYA"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGeneralStats(),
            if (kategori == "FRATRES") _buildPerEntityStats(),
            _buildCountryList(),
          ],
        ),
      ),
    );
  }

  // --- Tab 1: DATA GENERAL (Rumah, Imam, Kaul, Novis) ---
  Widget _buildGeneralStats() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatItem(label: "Domus (Jumlah Rumah)", value: "150"),
        _StatItem(label: "Sacerdotalis (Imam)", value: "850"),
        _StatItem(label: "Frater/Sorores Solemniter Professus (Kaul Kekal)", value: "1200"),
        _StatItem(label: "Frater/Sorores Professionis Temporaneae (Kaul Perdana)", value: "300"),
        _StatItem(label: "Noviatus", value: "85"),
      ],
    );
  }

  // --- Tab 2: PER ENTITY (Khusus Fratres) ---
  Widget _buildPerEntityStats() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text("Statistik per Provinsi/Komisariat:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ExpansionTile(
          title: const Text("Provinsi Indonesia"),
          children: [
            _StatItem(label: "Domus", value: "25", isSubItem: true),
            _StatItem(label: "Sacerdotalis", value: "110", isSubItem: true),
          ],
        ),
        // Tambahkan entitas lain di sini...
      ],
    );
  }

  // --- Tab 3: DAFTAR NEGARA TEMPAT BERKARYA ---
  Widget _buildCountryList() {
    final List<String> negara = ["Indonesia", "Italia", "Amerika Serikat", "Filipina", "Brasil", "Kenya"];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: negara.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.public, size: 20),
          title: Text(negara[index]),
        );
      },
    );
  }
}

/// Widget bantu untuk baris data statistik
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isSubItem;

  const _StatItem({required this.label, required this.value, this.isSubItem = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: isSubItem ? 24 : 0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown)),
        ],
      ),
    );
  }
}