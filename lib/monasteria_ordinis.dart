import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: MONASTERIA ORDINIS...
/// Menampilkan daftar nama biara rubiah dengan konstitusi khusus
/// =================================================================
class HalamanMonasteriaOrdinis extends StatelessWidget {
  const HalamanMonasteriaOrdinis({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy daftar nama biara rubiah
    final List<String> daftarBiara = [
      "Monasterium S. Eliae",
      "Monasterium Carmelitarum Specialis",
      "Biara Rubiah Konstitusi Propria"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MONASTERIA ORDINIS QUAE CONSTITUTIONES GENERALES MONIALIUM NON ADHIBNET SED PROPRIIS UTUNTUR",
          style: TextStyle(fontSize: 12), // Diperkecil karena judul sangat panjang
          maxLines: 3,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarBiara.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(daftarBiara[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => HalamanDetailMonasteria(namaBiara: daftarBiara[index])
              )),
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DETAIL (Tab Bar)
/// Menampilkan 5 pilihan: Historia, Website, Domus Moniales, Consilium, Sodales
/// =================================================================
class HalamanDetailMonasteria extends StatelessWidget {
  final String namaBiara;
  const HalamanDetailMonasteria({super.key, required this.namaBiara});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(namaBiara, style: const TextStyle(fontSize: 16)),
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

  // Tab Historia [cite: 138]
  Widget _buildHistoria() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text("Sejarah biara rubiah dengan konstitusi propria terkait akan dimuat di sini..."),
    );
  }

  // Tab Website [cite: 139]
  Widget _buildWebsite() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.language),
        label: const Text("Kunjungi Website Biara"),
        onPressed: () {},
      ),
    );
  }

  // Tab Domus Moniales [cite: 140]
  Widget _buildDomus() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _InfoField(label: "Nama Biara", value: "Monasterium S. Eliae"),
        _InfoField(label: "Diosis", value: "Keuskupan Setempat"),
        _InfoField(label: "Federasi", value: "Federasi Propria"),
        _InfoField(label: "Nama Jalan dan Nomor", value: "Jl. Konstitusi No. 99"),
        _InfoField(label: "Nama Kota", value: "Nama Kota"),
        _InfoField(label: "Nama Negara", value: "Nama Negara"),
        _InfoField(label: "Kode Pos", value: "12345"),
        _InfoField(label: "Nomor Telepon", value: "+xx xxx xxxx"),
        _InfoField(label: "Nomor Faxcimile", value: "+xx xxx xxxx"),
        _InfoField(label: "Alamat Email", value: "contact@monasteria.org"),
      ],
    );
  }

  // Tab Consilium Moniales [cite: 141]
  Widget _buildConsilium(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Sr. Teresa de Avila"),
          subtitle: const Text("Prioress"),
          onTap: () => _bukaDetailPerson(context, "Sr. Teresa de Avila"),
        ),
      ],
    );
  }

  // Tab Sodales (Urut tanggal kaul perdana) [cite: 142]
  Widget _buildSodales(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Text("M")),
          title: const Text("Sr. Maria Magdalena"),
          subtitle: const Text("Kaul Perdana: 05-05-2005"),
          onTap: () => _bukaDetailPerson(context, "Sr. Maria Magdalena"),
        ),
      ],
    );
  }

  // Halaman Detail Person (Tanpa Tanggal Tahbisan) 
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
            const _InfoField(label: "Tanggal Lahir", value: "01-01-1980"),
            const _InfoField(label: "Tanggal Kaul Perdana", value: "05-05-2005"),
            const _InfoField(label: "Tanggal Kaul Kekal", value: "05-05-2008"),
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