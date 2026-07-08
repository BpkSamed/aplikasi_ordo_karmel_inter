import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: MONIALES
/// Berdasarkan alur: Menampilkan daftar nama biara rubiah 
/// =================================================================
class HalamanMoniales extends StatelessWidget {
  const HalamanMoniales({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh daftar biara rubiah berdasarkan dokumen flow 
    final List<String> daftarBiaraRubiah = [
      "Monastero San Giuseppe (Rome)",
      "Monasterium S. Mariae de Monte Carmelo",
      "Biara Rubiah Karmel (Batu)"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("MONIALES")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarBiaraRubiah.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(daftarBiaraRubiah[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => HalamanDetailMoniales(namaBiara: daftarBiaraRubiah[index])
              )),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DETAIL MONIALES (Tab Bar)
/// Menampilkan 5 pilihan: Historia, Website, Domus Moniales, Consilium, Sodales 
/// =================================================================
class HalamanDetailMoniales extends StatelessWidget {
  final String namaBiara;
  const HalamanDetailMoniales({super.key, required this.namaBiara});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(namaBiara),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.yellowAccent, // Warna teks saat tab dipilih (Terang)
            unselectedLabelColor: Colors.white70, // Warna teks tab lain (Sedikit pudar)
            indicatorColor: Colors.yellowAccent, // Warna garis bawah tab (Terang)
            indicatorWeight: 3.0, // Ketebalan garis bawah
            tabs: [
              Tab(text: "Historia"),
              Tab(text: "Website"),
              Tab(text: "Domus Moniales"),
              Tab(text: "Consilium"),
              Tab(text: "Sodales"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHistoria(),
            _buildWebsite(),
            _buildDomus(),
            _buildConsilium(context),
            _buildSodales(context),
          ],
        ),
      ),
    );
  }

  // --- Konten Tab Berdasarkan Dokumen ---

  // Tab Historia [cite: 132]
  Widget _buildHistoria() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text("Sejarah biara rubiah terkait akan dimuat di sini sesuai data historis."),
    );
  }

  // Tab Website [cite: 133]
  Widget _buildWebsite() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.language),
        label: const Text("Kunjungi Website Biara"),
        onPressed: () {},
      ),
    );
  }

  // Tab Domus Moniales 
  Widget _buildDomus() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _InfoField(label: "Nama Biara", value: "Monasterium Karmel"),
        _InfoField(label: "Diosis", value: "Keuskupan Setempat"),
        _InfoField(label: "Federasi", value: "Nama Federasi Rubiah"),
        _InfoField(label: "Alamat", value: "Jl. Biara No. 10"),
        _InfoField(label: "Kota", value: "Nama Kota"),
        _InfoField(label: "Negara", value: "Nama Negara"),
        _InfoField(label: "Telepon", value: "+xx xxx xxxx"),
        _InfoField(label: "Email", value: "moniales@ocarm.org"),
      ],
    );
  }

  // Tab Consilium Moniales [cite: 135]
  Widget _buildConsilium(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Sr. Maria Carmel, O.Carm"),
          subtitle: const Text("Prioress"),
          onTap: () => _bukaDetailPerson(context, "Sr. Maria Carmel, O.Carm"),
        ),
      ],
    );
  }

  // Tab Sodales (Urut tanggal kaul perdana) 
  Widget _buildSodales(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Text("S")),
          title: const Text("Sr. Lucia del Amor"),
          subtitle: const Text("Kaul Perdana: 10-02-2010"),
          onTap: () => _bukaDetailPerson(context, "Sr. Lucia del Amor"),
        ),
      ],
    );
  }

  // Halaman Detail Person (Tanpa Tanggal Tahbisan sesuai tabel data Moniales) 
  void _bukaDetailPerson(BuildContext context, String nama) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
      appBar: AppBar(title: const Text("Detail Anggota")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            Text(nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(),
            const _InfoField(label: "Kota Kelahiran", value: "Nama Kota"),
            const _InfoField(label: "Negara Kelahiran", value: "Nama Negara"),
            const _InfoField(label: "Tanggal Lahir", value: "01-01-1990"),
            const _InfoField(label: "Tanggal Kaul Perdana", value: "10-02-2010"),
            const _InfoField(label: "Tanggal Kaul Kekal", value: "10-02-2013"),
            // Catatan: Tidak ada field Tahbisan untuk Moniales [cite: 136, 216]
          ],
        ),
      ),
    )));
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}