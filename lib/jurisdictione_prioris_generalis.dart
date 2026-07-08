import 'package:flutter/material.dart';

/// =================================================================
/// HALAMAN UTAMA: SUB IMMEDIATA JURISDICTIONE PRIORIS GENERALIS
/// Berdasarkan alur: Menampilkan daftar entitas di bawah yurisdiksi 
/// =================================================================
class HalamanSubImmediata extends StatelessWidget {
  const HalamanSubImmediata({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar menu sesuai dokumen flow 
    final List<Map<String, dynamic>> menuEntities = [
      {"title": "Curia Generalitia", "type": "curia"},
      {"title": "Institutum Carmelitarum", "type": "institutum"},
      {"title": "Centrum Internationale S. Alberti", "type": "centrum"},
      {"title": "Carmelite NGO", "type": "ngo"},
      {"title": "Edizioni Carmelitani", "type": "edizioni"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Immediata Jurisdictione"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: menuEntities.length,
        itemBuilder: (context, index) {
          final item = menuEntities[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.brown),
              onTap: () {
                // Navigasi ke halaman detail berdasarkan tipe
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanDetailSubImmediata(
                      title: item["title"],
                      type: item["type"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// HALAMAN DETAIL: MENAMPILKAN ISIAN SESUAI ENTITAS
/// =================================================================
class HalamanDetailSubImmediata extends StatelessWidget {
  final String title;
  final String type;

  const HalamanDetailSubImmediata({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildContentBasedOnType(),
      ),
    );
  }

  /// Fungsi untuk membangun konten berdasarkan tipe entitas yang dipilih 
  Widget _buildContentBasedOnType() {
    switch (type) {
      case "curia": // Curia Generalitia [cite: 72]
        return Column(
          children: [
            _buildDetailTile("Priore", "Data Priore [cite: 73]"),
            _buildDetailTile("Sub Priore", "Data Sub Priore [cite: 74]"),
            _buildDetailTile("Sodales", "Daftar 5-15 orang [cite: 75]"),
          ],
        );
      case "institutum": // Institutum Carmelitarum [cite: 76]
        return Column(
          children: [
            _buildDetailTile("Praeses", "Data Praeses [cite: 77]"),
            _buildDetailTile("Secretariatus", "Data Secretariatus [cite: 78]"),
            _buildDetailTile("Archivum Generale", "Data Archivum [cite: 79]"),
            _buildDetailTile("Bibliotheca Generalis", "Data Bibliotheca [cite: 80]"),
            _buildDetailTile("Analecta Ordinis", "Data Analecta [cite: 81]"),
            _buildDetailTile("Carmelus", "Commentarii Editi [cite: 82]"),
            _buildDetailTile("Consilium Scientificum", "Daftar 5-10 orang [cite: 83]"),
          ],
        );
      case "centrum": // Centrum Internationale S. Alberti [cite: 84]
        return Column(
          children: [
            _buildDetailTile("Generale Liaison", "Data Liaison [cite: 85]"),
            _buildDetailTile("Priore", "Data Priore [cite: 86]"),
            _buildDetailTile("Sub Priore", "Data Sub Priore [cite: 87]"),
            _buildDetailTile("Oeconomus", "Data Oeconomus [cite: 88]"),
            _buildDetailTile("Sodales", "Data Sodales [cite: 89]"),
          ],
        );
      case "ngo": // Carmelite NGO [cite: 90]
        return Column(
          children: [
            _buildDetailTile("Generale Liaison", "Data Liaison [cite: 91]"),
            _buildDetailTile("President", "Data President [cite: 92]"),
            _buildDetailTile("Vice President", "Data Vice President [cite: 93]"),
            _buildDetailTile("Sodales", "Data Sodales [cite: 94]"),
          ],
        );
      case "edizioni": // Edizioni Carmelitane [cite: 95]
        return Column(
          children: [
            _buildDetailTile("President", "Data President [cite: 96]"),
            _buildDetailTile("Sodales", "Data Sodales [cite: 97]"),
          ],
        );
      default:
        return const Center(child: Text("Data tidak ditemukan"));
    }
  }

  Widget _buildDetailTile(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
        subtitle: Text(value),
      ),
    );
  }
}