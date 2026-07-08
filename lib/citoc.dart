import 'package:flutter/material.dart';

/// =================================================================
/// HALAMAN: CITOC (Carmelite Information Center)
/// Berdasarkan alur: Menampilkan berita hari ini dan link ke berita CITOC
/// =================================================================
class HalamanCitoc extends StatelessWidget {
  const HalamanCitoc({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data berita berdasarkan dokumen 
    final List<Map<String, String>> beritaHariIni = [
      {
        "judul": "Pertemuan Internasional Kaum Muda Karmelit di Roma",
        "tanggal": "13 Mei 2026",
        "ringkasan": "Para pemuda dari berbagai provinsi berkumpul untuk mendiskusikan masa depan misi Ordo...",
      },
      {
        "judul": "Pembukaan Biara Baru di Wilayah Delegatio Generalis",
        "tanggal": "12 Mei 2026",
        "ringkasan": "Langkah baru dalam pengembangan kehadiran Ordo di wilayah misi baru telah dimulai...",
      },
      {
        "judul": "Publikasi Analecta Ordinis Carmelitarum Edisi Terbaru",
        "tanggal": "10 Mei 2026",
        "ringkasan": "Edisi terbaru yang memuat laporan statistik dan kegiatan Curia telah terbit...",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("CITOC News"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Logika untuk membuka link berita CITOC secara eksternal 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Membuka situs resmi CITOC...")),
              );
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Seksi Berita Hari Ini
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.brown.shade50,
            width: double.infinity,
            child: const Text(
              "Berita Hari Ini",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          
          // Daftar Berita
          Expanded(
            child: ListView.builder(
              itemCount: beritaHariIni.length,
              itemBuilder: (context, index) {
                final berita = beritaHariIni[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      berita["judul"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(berita["tanggal"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(berita["ringkasan"]!, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // Logika masuk ke detail berita
                    },
                  ),
                );
              },
            ),
          ),
          
          // Tombol Akses Cepat ke Website (Sesuai dokumen flow )
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.open_in_new),
              label: const Text("Kunjungi Website CITOC"),
              onPressed: () {
                // Tautan ke CITOC News 
              },
            ),
          ),
        ],
      ),
    );
  }
}