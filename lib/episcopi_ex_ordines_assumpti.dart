import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // IMPORT LOKALISASI

/// =================================================================
/// HALAMAN UTAMA: DAFTAR EPISCOPI (USKUP) - DENGAN SUPABASE & RESPONSIVE
/// =================================================================
class HalamanEpiscopi extends StatelessWidget {
  const HalamanEpiscopi({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final t = AppLocalizations.of(context)!; // Inisialisasi lokalisasi

    return Scaffold(
      appBar: AppBar(
        title: Text(t.episcopiTitle), // Translate title
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: supabase.from('episcopi').select('*, addresses(*)'), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.brown));
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "${t.errorOccurred ?? 'Error'}: ${snapshot.error}", 
                    style: TextStyle(fontSize: baseWidth * 0.04)
                  )
                );
              }

              // 1. SIAPKAN DATA CADANGAN (FALLBACK) SAAT DATABASE KOSONG
              final List<Map<String, dynamic>> dataKosong = [
                {
                  "name": t.noBishopData, // Translate data kosong
                  "diocese": "-",
                  "ex_carmelite_entity": "-",
                  "status": "-",
                  "photo_url": null,
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
              final daftarUskup = (snapshot.data == null || snapshot.data!.isEmpty) 
                  ? dataKosong 
                  : snapshot.data!;

              // 3. GAMBAR TAMPILAN
              return ListView.builder(
                padding: EdgeInsets.all(baseWidth * 0.03),
                itemCount: daftarUskup.length,
                itemBuilder: (context, index) {
                  final uskup = daftarUskup[index];
                  final String? photoUrl = uskup["photo_url"];

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: baseWidth * 0.03),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: baseWidth * 0.04, 
                        vertical: baseWidth * 0.02
                      ),
                      // MENAMPILKAN FOTO DI DAFTAR USKUP
                      leading: CircleAvatar(
                        radius: baseWidth * 0.06,
                        backgroundColor: Colors.brown,
                        backgroundImage: (photoUrl != null && photoUrl.toString().trim().isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.toString().trim().isEmpty)
                            ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.065)
                            : null,
                      ),
                      title: Text(
                        uskup["name"] ?? '-', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)
                      ),
                      subtitle: Text(
                        uskup["diocese"] ?? '-', 
                        style: TextStyle(color: Colors.black54, fontSize: baseWidth * 0.035)
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04, color: Colors.brown),
                      onTap: () {
                        if (uskup["name"] == t.noBishopData) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                t.emptyDataDetailWarning ?? "Data empty, cannot open details.",
                                style: TextStyle(fontSize: baseWidth * 0.035)
                              )
                            ),
                          );
                          return; 
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
    final t = AppLocalizations.of(context)!; // Inisialisasi lokalisasi
    final Map<String, dynamic> address = dataUskup["addresses"] ?? {};
    final String? photoUrl = dataUskup["photo_url"];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.episcopiDetailTitle ?? "Episcopi Detail"), // Translate title
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.all(baseWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Header (Nama, Keuskupan, dan Foto)
                Center(
                  child: Column(
                    children: [
                      // MENAMPILKAN FOTO DI HALAMAN DETAIL
                      CircleAvatar(
                        radius: baseWidth * 0.12,
                        backgroundColor: Colors.brown,
                        backgroundImage: (photoUrl != null && photoUrl.toString().trim().isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.toString().trim().isEmpty)
                            ? Icon(Icons.person, size: baseWidth * 0.12, color: Colors.white)
                            : null,
                      ),
                      SizedBox(height: baseWidth * 0.04),
                      Text(
                        dataUskup["name"] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: baseWidth * 0.055, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.brown
                        ),
                      ),
                      SizedBox(height: baseWidth * 0.02),
                      Text(
                        dataUskup["diocese"] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: baseWidth * 0.045, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Divider(height: baseWidth * 0.1, thickness: 2),

                // Data Informasi Utama
                Text(
                  t.mainInfo ?? "Main Information", 
                  style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.brown)
                ),
                SizedBox(height: baseWidth * 0.025),
                _buildInfoRow(Icons.account_balance, t.exCarmeliteEntity ?? "Ex Carmelite Entity", dataUskup["ex_carmelite_entity"] ?? '-', baseWidth),
                _buildInfoRow(Icons.info, t.status ?? "Status", dataUskup["status"] ?? '-', baseWidth),
                SizedBox(height: baseWidth * 0.06),

                // Data Alamat
                Text(
                  t.addressLabel ?? "Address", 
                  style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.brown)
                ),
                SizedBox(height: baseWidth * 0.025),
                Container(
                  padding: EdgeInsets.all(baseWidth * 0.04),
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
                      _buildAddressRow(t.houseName ?? "House Name", address["house_name"] ?? '-', baseWidth),
                      const Divider(),
                      _buildAddressRow(t.street ?? "Street", address["street"] ?? '-', baseWidth),
                      const Divider(),
                      _buildAddressRow(t.city ?? "City", address["city"] ?? '-', baseWidth),
                      const Divider(),
                      _buildAddressRow(t.country ?? "Country", address["country"] ?? '-', baseWidth),
                      const Divider(),
                      _buildAddressRow(t.postalCode ?? "Postal Code", address["postal_code"] ?? '-', baseWidth),
                    ],
                  ),
                ),
                SizedBox(height: baseWidth * 0.06),

                // Data Kontak
                Text(
                  t.contactLabel ?? "Contact", 
                  style: TextStyle(fontSize: baseWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.brown)
                ),
                SizedBox(height: baseWidth * 0.025),
                _buildInfoRow(Icons.phone, t.telephone ?? "Telephone", address["telephone"] ?? '-', baseWidth),
                _buildInfoRow(Icons.fax, t.faxcimile ?? "Faxcimile", address["faxcimile"] ?? '-', baseWidth),
                _buildInfoRow(Icons.email, t.email ?? "Email", address["email"] ?? '-', baseWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, double baseWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: baseWidth * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown, size: baseWidth * 0.06),
          SizedBox(width: baseWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: baseWidth * 0.03, color: Colors.grey)),
                Text(value, style: TextStyle(fontSize: baseWidth * 0.04, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(String label, String value, double baseWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: baseWidth * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: baseWidth * 0.25,
            child: Text(label, style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          Text(":  ", style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.035)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: baseWidth * 0.035, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}