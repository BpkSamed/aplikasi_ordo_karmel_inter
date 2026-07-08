import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. IMPORT SUPABASE

/// =================================================================
/// HALAMAN UTAMA: DAFTAR EPISCOPI (USKUP) - DENGAN SUPABASE
/// =================================================================
class HalamanEpiscopi extends StatelessWidget {
  const HalamanEpiscopi({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Episcopi Ex Ordines Assumpti"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase.from('episcopi').select('*, addresses(*)'), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // 1. SIAPKAN DATA CADANGAN (FALLBACK) SAAT DATABASE KOSONG
          // Struktur ini harus sama persis dengan kolom Supabase agar Halaman Detail tidak error
          final List<Map<String, dynamic>> dataKosong = [
            {
              "name": "Belum ada data uskup",
              "diocese": "-",
              "ex_carmelite_entity": "-",
              "status": "-",
              "addresses": {
                "house_name": "-",
                "street": "-",
                "city": "-",
                "country": "-",
                "postal_code": "-",
                "telephone": "-",
                "faxcimile": "-",
                "email": "-"
              }
            }
          ];

          // 2. LOGIKA PENGECEKAN
          // Jika snapshot null atau kosong, gunakan 'dataKosong'. Jika ada isinya, gunakan data asli.
          final daftarUskup = (snapshot.data == null || snapshot.data!.isEmpty) 
              ? dataKosong 
              : snapshot.data!;

          // 3. GAMBAR TAMPILAN
          // Komputer akan selalu menggambar Card, entah itu data asli dari database atau dataKosong di atas
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: daftarUskup.length,
            itemBuilder: (context, index) {
              final uskup = daftarUskup[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(uskup["name"] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(uskup["diocese"] ?? '-', style: const TextStyle(color: Colors.black54)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.brown),
                  onTap: () {
                    // Mencegah klik masuk ke halaman detail jika datanya adalah data kosong
                    if (uskup["name"] == "Belum ada data uskup") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Data masih kosong, tidak dapat membuka detail.")),
                      );
                      return; // Hentikan fungsi onTap di sini
                    }
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanDetailEpiscopi(dataUskup: uskup),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// =================================================================
/// HALAMAN DETAIL: MENAMPILKAN DATA HASIL RELASI KEDUA TABEL
/// =================================================================
class HalamanDetailEpiscopi extends StatelessWidget {
  final Map<String, dynamic> dataUskup;

  const HalamanDetailEpiscopi({super.key, required this.dataUskup});

  @override
  Widget build(BuildContext context) {
    // 4. MEMBACA DATA ALAMAT YANG TERSEMAT DI DALAM DATA USKUP
    // 'addresses' di sini berupa Map/Objek karena hasil join dari database
    final Map<String, dynamic> address = dataUskup["addresses"] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Episcopi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header (Nama dan Keuskupan)
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dataUskup["name"] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dataUskup["diocese"] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Divider(height: 40, thickness: 2),

            // Data Informasi Utama (Gunakan nama kolom database berformat snake_case)
            const Text("Informasi Utama", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.account_balance, "Ex Carmelite Entity", dataUskup["ex_carmelite_entity"] ?? '-'),
            _buildInfoRow(Icons.info, "Status", dataUskup["status"] ?? '-'),
            const SizedBox(height: 24),

            // Data Alamat (Address) - Diambil dari variabel 'address' hasil join
            const Text("Alamat (Address)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  _buildAddressRow("House Name", address["house_name"] ?? '-'),
                  const Divider(),
                  _buildAddressRow("Street", address["street"] ?? '-'),
                  const Divider(),
                  _buildAddressRow("City", address["city"] ?? '-'),
                  const Divider(),
                  _buildAddressRow("Country", address["country"] ?? '-'),
                  const Divider(),
                  _buildAddressRow("Code Post", address["postal_code"] ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data Kontak
            const Text("Kontak", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.phone, "Telephone", address["telephone"] ?? '-'),
            _buildInfoRow(Icons.fax, "Faxcimile", address["faxcimile"] ?? '-'),
            _buildInfoRow(Icons.email, "Email", address["email"] ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          const Text(":  ", style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}