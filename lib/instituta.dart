import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: INSTITUTA
/// Berdasarkan alur: Menampilkan daftar kongregasi yang berafiliasi
/// =================================================================
class HalamanInstituta extends StatelessWidget {
  const HalamanInstituta({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh daftar kongregasi berafiliasi berdasarkan dokumen flow
    final List<String> daftarKongregasi = [
      "Congregatio Carmelitarum (Indonesia)",
      "Congregatio Sororum Carmelitarum",
      "Instituta Berafiliasi Lainnya"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("INSTITUTA")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarKongregasi.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(daftarKongregasi[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => HalamanDetailInstituta(namaInstituta: daftarKongregasi[index])
              )),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DETAIL INSTITUTA (Tab Bar)
/// Menampilkan: Historia, Website, Consilium Generalis, Domus Generalis, Conventus
/// =================================================================
class HalamanDetailInstituta extends StatelessWidget {
  final String namaInstituta;
  const HalamanDetailInstituta({super.key, required this.namaInstituta});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Sesuai pilihan di dokumen flow
      child: Scaffold(
        appBar: AppBar(
          title: Text(namaInstituta, style: const TextStyle(fontSize: 16)),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.yellowAccent, // Warna teks saat tab dipilih (Terang)
            unselectedLabelColor: Colors.white70, // Warna teks tab lain (Sedikit pudar)
            indicatorColor: Colors.yellowAccent, // Warna garis bawah tab (Terang)
            indicatorWeight: 3.0, // Ketebalan garis bawah
            tabs: [
              Tab(text: "Historia"),
              Tab(text: "Website"),
              Tab(text: "Consilium Generalis"),
              Tab(text: "Domus Generalis"),
              Tab(text: "Conventus"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHistoria(),
            _buildWebsite(),
            _buildConsilium(),
            _buildDomusGeneralis(),
            _buildConventus(context),
          ],
        ),
      ),
    );
  }

  // --- Konten Tab Berdasarkan Dokumen ---

  // Tab Historia [cite: 150]
  Widget _buildHistoria() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text("Sejarah kongregasi terkait akan dimuat di sini sesuai data dari dokumen."),
    );
  }

  // Tab Website [cite: 151]
  Widget _buildWebsite() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.language),
        label: const Text("Kunjungi Website Kongregasi"),
        onPressed: () {},
      ),
    );
  }

  // Tab Consilium Generalis [cite: 152]
  Widget _buildConsilium() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("Dewan Pimpinan Provinsi:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Nama Pimpinan 1"),
          subtitle: Text("Jabatan"),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Nama Pimpinan 2"),
          subtitle: Text("Jabatan"),
        ),
      ],
    );
  }

  // Tab Domus Generalis [cite: 153]
  Widget _buildDomusGeneralis() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _InfoField(label: "Nama Biara", value: "Domus Generalis Instituta"),
        _InfoField(label: "Nama Jalan dan Nomor", value: "Jl. Jenderal No. 1"),
        _InfoField(label: "Nama Kota", value: "Kota Pimpinan"),
        _InfoField(label: "Nama Negara", value: "Indonesia"),
        _InfoField(label: "Kode Pos", value: "54321"),
        _InfoField(label: "Nomor Telepon", value: "+62 21 000000"),
        _InfoField(label: "Nomor Faxcimile", value: "+62 21 000001"),
        _InfoField(label: "Alamat Email", value: "general@instituta.org"),
      ],
    );
  }

  // Tab Conventus 
  Widget _buildConventus(BuildContext context) {
    // Daftar biara dalam provinsi terkait
    final List<String> daftarBiara = ["Biara Santo Yosef", "Biara Maria Imakulata"];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarBiara.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(daftarBiara[index]),
          subtitle: const Text("Nama Kota"),
          trailing: const Icon(Icons.info_outline),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => HalamanDetailConventusInstituta(namaBiara: daftarBiara[index])
          )),
        );
      },
    );
  }
}

/// =================================================================
/// 3. HALAMAN DETAIL CONVENTUS (ALAMAT LENGKAP BIARA)
/// Berdasarkan tabel: DATA CONVENTUS INSTITUTA [cite: 224]
/// =================================================================
class HalamanDetailConventusInstituta extends StatelessWidget {
  final String namaBiara;
  const HalamanDetailConventusInstituta({super.key, required this.namaBiara});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Alamat Biara")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoField(label: "Nama Biara", value: namaBiara),
          const _InfoField(label: "Nama Jalan dan Nomor", value: "Jl. Biara No. 123"),
          const _InfoField(label: "Nama Kota", value: "Kota Biara"),
          const _InfoField(label: "Nama Negara", value: "Indonesia"),
          const _InfoField(label: "Kode Pos", value: "11223"),
          const _InfoField(label: "Nomor Telepon", value: "+62 31 111111"),
          const _InfoField(label: "Nomor Faxcimile", value: "+62 31 111112"),
          const _InfoField(label: "Alamat Email", value: "biara@instituta.org"),
        ],
      ),
    );
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