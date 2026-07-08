import 'package:flutter/material.dart';

/// =================================================================
/// MENU UTAMA: CURIA GENERALIS
/// =================================================================
class HalamanCuriaGeneralis extends StatelessWidget {
  const HalamanCuriaGeneralis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Curia Generalis"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _buildMenuTile(context, "Consilium Generale", const HalamanConsiliumGenerale()),
          _buildMenuTile(context, "Officia Generalia et Sectores Laborum", const HalamanOfficiaGeneralia()),
          _buildMenuTile(context, "Commissiones Generales", const HalamanCommissionesGenerales()),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, Widget targetPage) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.brown),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
      ),
    );
  }
}

/// =================================================================
/// SUB-MENU 1: CONSILIUM GENERALE
/// =================================================================
class HalamanConsiliumGenerale extends StatelessWidget {
  const HalamanConsiliumGenerale({super.key});

  @override
  Widget build(BuildContext context) {
    // Data List Jabatan
    final List<String> daftarJabatan = [
      "Prior Generalis",
      "Vice Prior Generalis",
      "Procurator Generalis",
      "Oeconomus Generalis",
      "Consiliarius pro Ambitu Americarum",
      "Consiliarius pro Ambitu Africae",
      "Consiliarius pro Ambitu Asiae, Australiae et Oceaniae",
      "Consiliarius pro Ambitu Europae",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Consilium Generale")),
      body: ListView.separated(
        itemCount: daftarJabatan.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.brown),
            title: Text(daftarJabatan[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Nama Pejabat (Data dari Database)"),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// SUB-MENU 2: OFFICIA GENERALIA ET SECTORES LABORUM
/// =================================================================
class HalamanOfficiaGeneralia extends StatelessWidget {
  const HalamanOfficiaGeneralia({super.key});

  @override
  Widget build(BuildContext context) {
    // Data List Kantor/Sektor
    final List<String> daftarKantor = [
      "Oeconomatus Generalis",
      "Secretariatus Generalis",
      "Delegatus Monacorum, Heremiti et Instituta",
      "Delegatus Formationis",
      "Delegatus Iuvenibus",
      "Delegatus TOC",
      "Delegatus Laicorum",
      "Postulatura Generalis",
      "Legale Rappresentante",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Officia Generalia")),
      body: ListView.separated(
        itemCount: daftarKantor.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.business_center_outlined, color: Colors.brown),
            title: Text(daftarKantor[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Informasi Pejabat Terkait"),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// SUB-MENU 3: COMMISSIONES GENERALES (DAFTAR KOMISI)
/// =================================================================
class HalamanCommissionesGenerales extends StatelessWidget {
  const HalamanCommissionesGenerales({super.key});

  @override
  Widget build(BuildContext context) {
    // Data List Komisi
    final List<String> daftarKomisi = [
      "Commissio Generalis de Formatione",
      "Commissio Generalis de Iuvenibus Carmelitis",
      "Commissio Generalis de Rebus Oeconomicis",
      "Commissio Generalis de Liturgia et Oratione",
      "Commissio Generalis de Communicatione",
      "Commissio Generalis de Evangelizatio, Iustitia, Pace et Creationis Integritate",
      "Commissio Generalis de Ministerium",
      "Commissio Generalis pro Tutela Minorium",
      "TOC Negotium Force",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Commissiones Generales")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarKomisi.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(daftarKomisi[index], style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.info_outline, color: Colors.brown),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HalamanDetailKomisi(namaKomisi: daftarKomisi[index])
                ));
              },
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// DETAIL HALAMAN KOMISI (PRAESES, SODALES, MISSIO)
/// =================================================================
class HalamanDetailKomisi extends StatelessWidget {
  final String namaKomisi;
  const HalamanDetailKomisi({super.key, required this.namaKomisi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Komisi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Komisi
            Text(
              namaKomisi,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const Divider(height: 40, thickness: 2),

            // Bagian Praeses (Ketua)
            _buildSection(Icons.star, "Praeses (Ketua)", "Nama Ketua dari Database"),
            
            // Bagian Sodales (Anggota)
            _buildSection(Icons.group, "Sodales (Anggota)", "1. Nama Anggota 1\n2. Nama Anggota 2\n3. Nama Anggota 3\n(5-10 orang dari Database)"),

            // Bagian Missio (Misi)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.brown.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag, color: Colors.brown),
                      SizedBox(width: 10),
                      Text("Missio (Misi)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Penjabaran misi komisi terkait akan ditampilkan di sini. Data ini nantinya diambil secara dinamis dari tabel database atau Supabase Anda.",
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat blok UI Praeses dan Sodales
  Widget _buildSection(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.brown),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown)),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 34.0),
            child: Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
          ),
        ],
      ),
    );
  }
}