import 'package:flutter/material.dart';

/// =================================================================
/// 1. HALAMAN UTAMA: FRATRES
/// =================================================================
class HalamanFratres extends StatelessWidget {
  const HalamanFratres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FRATRES")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(context, "PROVINCIA", "Daftar Provinsi"),
          _buildCategoryCard(context, "COMMISSARIATUS GENERALIS", "Daftar Komisariat Jenderal"),
          _buildCategoryCard(context, "DELEGATIO GENERALIS", "Daftar Delegatus Jenderal"),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => HalamanDaftarEntitasFratres(kategori: title)
        )),
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DAFTAR NAMA ENTITAS (Dinamis sesuai kategori)
/// =================================================================
class HalamanDaftarEntitasFratres extends StatelessWidget {
  final String kategori;
  const HalamanDaftarEntitasFratres({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    // Menyiapkan variabel daftar nama kosong
    List<String> daftarNama = [];

    // Logika untuk mengubah isi daftar berdasarkan kategori yang diklik
    if (kategori == "PROVINCIA") {
      daftarNama = ["Provinsi Indonesia", "Provinsi Belanda", "Provinsi Amerika"];
    } else if (kategori == "COMMISSARIATUS GENERALIS") {
      daftarNama = ["Commissariatus 1", "Commissariatus 2", "Commissariatus 3"];
    } else if (kategori == "DELEGATIO GENERALIS") {
      daftarNama = ["Delegatio 1", "Delegatio 2", "Delegatio 3"];
    }

    return Scaffold(
      appBar: AppBar(title: Text(kategori)),
      body: ListView.builder(
        itemCount: daftarNama.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(daftarNama[index], style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => HalamanDetailEntitasFratres(namaEntitas: daftarNama[index])
            )),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 3. HALAMAN DETAIL ENTITAS (Tab Bar dengan warna terang)
/// =================================================================
class HalamanDetailEntitasFratres extends StatelessWidget {
  final String namaEntitas;
  const HalamanDetailEntitasFratres({super.key, required this.namaEntitas});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(namaEntitas, style: const TextStyle(fontSize: 18)),
          bottom: const TabBar(
            isScrollable: true,
            // --- PENGATURAN WARNA TAB BAR TERANG ---
            labelColor: Colors.yellowAccent, // Warna teks saat tab dipilih (Terang)
            unselectedLabelColor: Colors.white70, // Warna teks tab lain (Sedikit pudar)
            indicatorColor: Colors.yellowAccent, // Warna garis bawah tab (Terang)
            indicatorWeight: 3.0, // Ketebalan garis bawah
            tabs: [
              Tab(text: "Historia"),
              Tab(text: "Website"),
              Tab(text: "Consilium"),
              Tab(text: "Domus"),
              Tab(text: "Conventus"),
              Tab(text: "Sodales"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHistoria(),
            _buildWebsite(),
            _buildConsilium(context),
            _buildDomus(),
            _buildConventus(context),
            _buildSodales(context),
          ],
        ),
      ),
    );
  }

  // --- Masing-masing Tab Content ---

  Widget _buildHistoria() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text("Sejarah lengkap entitas terkait akan muncul di sini..."),
    );
  }

  Widget _buildWebsite() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
        onPressed: () {}, 
        icon: const Icon(Icons.language),
        label: const Text("Buka Website Resmi")
      ),
    );
  }

  Widget _buildConsilium(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person, color: Colors.brown),
          title: const Text("P. Nama Pimpinan"),
          subtitle: const Text("Prior Provincialis"),
          onTap: () => _bukaDetailOrang(context, "P. Nama Pimpinan"),
        ),
      ],
    );
  }

  Widget _buildDomus() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Alamat Pimpinan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
          SizedBox(height: 8),
          Text("Nama Biara, Nama Jalan, Kota, Negara, Kodepos..."),
        ],
      ),
    );
  }

  Widget _buildConventus(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_city, color: Colors.brown),
          title: const Text("Biara Titus Brandsma"),
          subtitle: const Text("Malang"),
          trailing: const Icon(Icons.info_outline),
          onTap: () {}, // Buka alamat lengkap biara
        ),
      ],
    );
  }

  Widget _buildSodales(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(backgroundColor: Colors.brown, child: Icon(Icons.person, color: Colors.white)),
          title: const Text("Fr. Nama Anggota"),
          subtitle: const Text("Kaul Perdana: 01-01-2020"),
          onTap: () => _bukaDetailOrang(context, "Fr. Nama Anggota"),
        ),
      ],
    );
  }

  void _bukaDetailOrang(BuildContext context, String nama) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
      appBar: AppBar(title: Text(nama)),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Data Lengkap: Foto, Kota Lahir, Tanggal Lahir, Kaul, Tahbisan..."),
      ),
    )));
  }
}