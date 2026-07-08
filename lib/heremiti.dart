import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: HEREMITI
/// Berdasarkan alur: Menampilkan daftar nama pertapaan 
/// =================================================================
class HalamanHeremiti extends StatelessWidget {
  const HalamanHeremiti({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy daftar nama pertapaan
    final List<String> daftarPertapaan = [
      "Hermits of the Blessed Virgin Mary (Minnesota)",
      "Hermitage of Santa Maria (Italy)",
      "Pertapaan Karmel (Indonesia)"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("HEREMITI")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarPertapaan.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(daftarPertapaan[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => HalamanDetailHeremiti(namaPertapaan: daftarPertapaan[index])
              )),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DETAIL HEREMITI (Tab Bar: Historia, Website, dll)
/// Menampilkan 5 pilihan sesuai dokumen 
/// =================================================================
class HalamanDetailHeremiti extends StatelessWidget {
  final String namaPertapaan;
  const HalamanDetailHeremiti({super.key, required this.namaPertapaan});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Historia, Website, Domus, Consilium, Sodales 
      child: Scaffold(
        appBar: AppBar(
          title: Text(namaPertapaan),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.yellowAccent, // Warna teks saat tab dipilih (Terang)
            unselectedLabelColor: Colors.white70, // Warna teks tab lain (Sedikit pudar)
            indicatorColor: Colors.yellowAccent, // Warna garis bawah tab (Terang)
            indicatorWeight: 3.0, // Ketebalan garis bawah
            tabs: [
              Tab(text: "Historia"),
              Tab(text: "Website"),
              Tab(text: "Domus Heremiti"),
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

  // [cite: 126]
  Widget _buildHistoria() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text("Sejarah pertapaan terkait akan dimuat di sini..."),
    );
  }

  // [cite: 127]
  Widget _buildWebsite() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.language),
        label: const Text("Kunjungi Website Pertapaan"),
        onPressed: () {},
      ),
    );
  }

  // 
  Widget _buildDomus() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _InfoField(label: "Nama Biara", value: "Pertapaan Santo Albertus"),
        _InfoField(label: "Diosis", value: "Keuskupan Agung Malang"),
        _InfoField(label: "Federasi", value: "Federasi Internasional Heremiti"),
        _InfoField(label: "Alamat", value: "Jl. Pegunungan No. 1, Batu"),
        _InfoField(label: "Negara", value: "Indonesia"),
        _InfoField(label: "Telepon", value: "+62 341 123456"),
        _InfoField(label: "Email", value: "heremiti@ocarm.org"),
      ],
    );
  }

  // [cite: 129]
  Widget _buildConsilium(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("P. John Doe, O.Carm"),
          subtitle: const Text("Prior"),
          onTap: () => _bukaDetailPerson(context, "P. John Doe, O.Carm"),
        ),
      ],
    );
  }

  //  - Diurutkan berdasarkan tanggal kaul perdana
  Widget _buildSodales(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Text("F")),
          title: const Text("Fr. Mario Rossi"),
          subtitle: const Text("Kaul Perdana: 15-08-2015"),
          onTap: () => _bukaDetailPerson(context, "Fr. Mario Rossi"),
        ),
      ],
    );
  }

  // Halaman Detail Person [cite: 129, 130, 214]
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
            const _InfoField(label: "Kota Kelahiran", value: "Rome"),
            const _InfoField(label: "Negara Kelahiran", value: "Italy"),
            const _InfoField(label: "Tanggal Lahir", value: "01-01-1980"),
            const _InfoField(label: "Tanggal Kaul Perdana", value: "15-08-2015"),
            const _InfoField(label: "Tanggal Kaul Kekal", value: "15-08-2018"),
            const _InfoField(label: "Tanggal Tahbisan", value: "20-05-2020"),
          ],
        ),
      ),
    )));
  }
}

/// Widget kecil untuk menampilkan label dan nilai secara rapi
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