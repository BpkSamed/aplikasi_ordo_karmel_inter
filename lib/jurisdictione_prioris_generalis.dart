import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN: SUB IMMEDIATA JURISDICTIONE PRIORIS GENERALIS
/// =================================================================
class HalamanSubImmediata extends StatefulWidget {
  const HalamanSubImmediata({super.key});

  @override
  State<HalamanSubImmediata> createState() => _HalamanSubImmediataState();
}

class _HalamanSubImmediataState extends State<HalamanSubImmediata> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Fungsi asinkron untuk mengambil data langsung dari tabel 'entities' Supabase
  Future<List<dynamic>> _fetchSubImmediataData() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Sub Immediata Jurisdictione Prioris Generalis')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Immediata Jurisdictione"),
      ),
      body: Column(
        children: [
          // 1. Fitur Search Bar untuk memfilter entitas
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: "Cari Entitas / Wilayah...",
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 2. Konten Utama Menggunakan FutureBuilder (Koneksi Database)
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchSubImmediataData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.brown));
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data Sub Immediata ditemukan."));
                }

                // Memfilter data di memori berdasarkan input pencarian pengguna
                final data = snapshot.data!.where((item) {
                  final name = (item['name'] ?? '').toString().toLowerCase();
                  final historia = (item['historia'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery) || historia.contains(_searchQuery);
                }).toList();

                if (data.isEmpty) {
                  return const Center(child: Text("Tidak ada hasil pencarian yang cocok."));
                }

                // Tampilan List Data menggunakan ExpansionTile agar rapi
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final entity = data[index];
                    final alamat = entity['addresses'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ExpansionTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.brown,
                          child: Icon(Icons.account_balance, color: Colors.white),
                        ),
                        title: Text(
                          entity['name'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          entity['website_url'] ?? 'Tidak ada tautan website',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Menampilkan Sejarah/Historia jika tersedia di DB
                                if (entity['historia'] != null && entity['historia'].toString().isNotEmpty) ...[
                                  Text(
                                    "Historia / Sejarah:",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(entity['historia']),
                                  const Divider(),
                                ],
                                
                                // Menampilkan Informasi Kontak & Alamat dari hasil join tabel addresses
                                Text(
                                  "Detail Kontak & Lokasi Resmi:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700),
                                ),
                                const SizedBox(height: 6),
                                if (alamat != null) ...[
                                  _buildAddressRow(Icons.home, "Nama Rumah/Gedung", alamat['house_name']),
                                  _buildAddressRow(Icons.location_on, "Jalan", alamat['street']),
                                  _buildAddressRow(Icons.location_city, "Kota", alamat['city']),
                                  _buildAddressRow(Icons.public, "Negara", alamat['country']),
                                  _buildAddressRow(Icons.local_post_office, "Kode Pos", alamat['postal_code']),
                                  _buildAddressRow(Icons.phone, "Telepon", alamat['telephone']),
                                  _buildAddressRow(Icons.print, "Faksimili", alamat['faxcimile']),
                                  _buildAddressRow(Icons.email, "Email", alamat['email']),
                                ] else
                                  const Text("Detail alamat belum diisi di database.", style: TextStyle(color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu untuk menyusun baris informasi alamat secara bersih
  Widget _buildAddressRow(IconData icon, String label, dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.brown.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}