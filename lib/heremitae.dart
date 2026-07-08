import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: HEREMITAE
/// Berdasarkan alur: Menampilkan daftar nama pertapaan
/// =================================================================
class HalamanHeremitae extends StatelessWidget {
  const HalamanHeremitae({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy daftar nama pertapaan kategori Heremitae
    final List<String> daftarPertapaan = [
      "Eremo della Madonna del Granato",
      "Hermitage of St. Mary Magdalene",
      "Pertapaan Karmelit Heremitae"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("HEREMITAE")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarPertapaan.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(daftarPertapaan[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => HalamanDetailHeremitae(namaPertapaan: daftarPertapaan[index])
              )),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DETAIL HEREMITAE (Tab Bar)
/// Menampilkan: Historia, Website, Domus Heremiti, Consilium Heremiti, Sodales
/// =================================================================
class HalamanDetailHeremitae extends StatelessWidget {
  final String namaPertapaan;
  const HalamanDetailHeremitae({super.key, required this.namaPertapaan});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(namaPertapaan, style: const TextStyle(fontSize: 16)),
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
              Tab(text: "Consilium Heremiti"),
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

  // Tab Historia [cite: 144]
  Widget _buildHistoria() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text("Sejarah pertapaan Heremitae terkait akan dimuat di sini..."),
    );
  }

  // Tab Website [cite: 145]
  Widget _buildWebsite() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.language),
        label: const Text("Kunjungi Website Pertapaan"),
        onPressed: () {},
      ),
    );
  }

  // Tab Domus Heremiti [cite: 146]
  Widget _buildDomus() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _InfoField(label: "Nama Biara", value: "Eremo della Madonna"),
        _InfoField(label: "Diosis", value: "Keuskupan Setempat"),
        _InfoField(label: "Federasi", value: "Federasi Heremitae"),
        _InfoField(label: "Nama Jalan dan Nomor", value: "Via dell'Eremo 12"),
        _InfoField(label: "Nama Kota", value: "Capaccio"),
        _InfoField(label: "Nama Negara", value: "Italy"),
        _InfoField(label: "Kode Pos", value: "84047"),
        _InfoField(label: "Nomor Telepon", value: "+39 0828 123456"),
        _InfoField(label: "Nomor Faxcimile", value: "+39 0828 123457"),
        _InfoField(label: "Alamat Email", value: "eremo@heremitae.org"),
      ],
    );
  }

  // Tab Consilium Heremiti [cite: 147]
  Widget _buildConsilium(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("P. Antonio, O.Carm"),
          subtitle: const Text("Prior"),
          onTap: () => _bukaDetailPerson(context, "P. Antonio, O.Carm"),
        ),
      ],
    );
  }

  // Tab Sodales (Urut tanggal kaul perdana) [cite: 148]
  Widget _buildSodales(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Text("G")),
          title: const Text("Fr. Giovanni"),
          subtitle: const Text("Kaul Perdana: 12-10-2012"),
          onTap: () => _bukaDetailPerson(context, "Fr. Giovanni"),
        ),
      ],
    );
  }

  // Halaman Detail Person (Mencakup Tanggal Tahbisan) 
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
            const _InfoField(label: "Kota Kelahiran", value: "Naples"),
            const _InfoField(label: "Negara Kelahiran", value: "Italy"),
            const _InfoField(label: "Tanggal Lahir", value: "10-05-1985"),
            const _InfoField(label: "Tanggal Kaul Perdana", value: "12-10-2012"),
            const _InfoField(label: "Tanggal Kaul Kekal", value: "12-10-2015"),
            const _InfoField(label: "Tanggal Tahbisan", value: "24-06-2016"),
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