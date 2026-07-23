import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN UTAMA: MENU DATA MINISTRIES (KARYA KERASULAN)
/// =================================================================
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN UTAMA: MENU DATA MINISTRIES (KARYA KERASULAN)
/// =================================================================
class HalamanMinistries extends StatelessWidget {
  const HalamanMinistries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direktori Ministries"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Kategori Karya Kerasulan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 15),
          
          _buildMenuCard(context, "Parishes", Icons.church, 'Parishes'),
          
          // Menu Schools menggunakan ExpansionTile karena memiliki sub-kategori
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.brown, 
                child: Icon(Icons.school, color: Colors.white)
              ),
              title: const Text("Schools", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
              children: [
                _buildSubMenuCard(context, "Elementary School", 'Elementary School'),
                _buildSubMenuCard(context, "Secondary School", 'Secondary School'),
                _buildSubMenuCard(context, "Academy", 'Academy'),
                _buildSubMenuCard(context, "University / Institute", 'University / Institute'),
              ],
            ),
          ),

          _buildMenuCard(context, "Retreat Centers", Icons.holiday_village, 'Retreat Centers'),
          _buildMenuCard(context, "Spirituality Institute", Icons.self_improvement, 'Spirituality Institute'),
          _buildMenuCard(context, "Social Ministries", Icons.volunteer_activism, 'Social Ministries'),
          _buildMenuCard(context, "Libraries", Icons.local_library, 'Libraries'),
          _buildMenuCard(context, "Hospitals / Clinics", Icons.local_hospital, 'Hospitals / Clinics'),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          
          // Menu tambahan untuk melihat daftar keseluruhan personalia (anggota) yang berkarya di semua lembaga
          Card(
            elevation: 3,
            color: Colors.brown.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.brown, 
                child: Icon(Icons.group_work, color: Colors.white)
              ),
              title: const Text("Seluruh Personalia Ministries", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
              subtitle: const Text("Daftar anggota yang berkarya di semua lembaga"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMinistriesMembers()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String filterKategori) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.brown, 
          child: Icon(icon, color: Colors.white)
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanMinistriesEntities(kategori: filterKategori)));
        },
      ),
    );
  }

  Widget _buildSubMenuCard(BuildContext context, String title, String filterKategori) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 70, right: 16),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanMinistriesEntities(kategori: filterKategori)));
      },
    );
  }
}

/// =================================================================
/// SUB-HALAMAN 1: DATA MINISTRIES – LEMBAGA / KARYA (ENTITIES)
/// =================================================================
class HalamanMinistriesEntities extends StatefulWidget {
  final String kategori; // Menangkap filter tipe karya dari halaman sebelumnya

  const HalamanMinistriesEntities({super.key, required this.kategori});

  @override
  State<HalamanMinistriesEntities> createState() => _HalamanMinistriesEntitiesState();
}

class _HalamanMinistriesEntitiesState extends State<HalamanMinistriesEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    // PASTIKAN: Anda sudah menambahkan kolom 'ministry_type' di tabel 'entities' database Supabase Anda 
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Ministries')
        .eq('ministry_type', widget.kategori) // Memfilter spesifik paroki, sekolah, rumah sakit, dll
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar ${widget.kategori}")),
      body: Column(
        children: [
          _buildSearchBar("Cari Nama ${widget.kategori}...", (val) => setState(() => _query = val.toLowerCase())),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchEntities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                if (snapshot.hasError) return _buildError(snapshot.error);
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Tidak ada data untuk ${widget.kategori}.");

                final filtered = snapshot.data!.where((item) {
                  return (item['name'] ?? '').toString().toLowerCase().contains(_query);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entity = filtered[index];
                    final address = entity['addresses'];
                    return Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.domain, color: Colors.brown),
                        title: Text(entity['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(entity['website_url'] ?? 'Tidak ada Website'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deskripsi / Historia:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                const SizedBox(height: 4),
                                Text(entity['historia'] ?? 'Belum ada data deskripsi.'),
                                const Divider(),
                                Text("Alamat Resmi Pelayanan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                const SizedBox(height: 4),
                                if (address != null) ...[
                                  Text("${address['house_name'] ?? ''} ${address['street'] ?? ''}"),
                                  Text("${address['city'] ?? ''}, ${address['country'] ?? ''} (${address['postal_code'] ?? ''})"),
                                  Text("Telp: ${address['telephone'] ?? '-'} • Email: ${address['email'] ?? '-'}"),
                                ] else
                                  const Text("Alamat tidak tersedia."),
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
}

/// =================================================================
/// SUB-HALAMAN 2: DATA MINISTRIES – PERSONALIA (MEMBERS) GLOBAL
/// =================================================================
class HalamanMinistriesMembers extends StatefulWidget {
  const HalamanMinistriesMembers({super.key});

  @override
  State<HalamanMinistriesMembers> createState() => _HalamanMinistriesMembersState();
}

class _HalamanMinistriesMembersState extends State<HalamanMinistriesMembers> {
  String _query = "";

  Future<List<dynamic>> _fetchMembers() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities!inner(*), conventus(*)')
        .eq('entities.entity_category', 'Ministries')
        .order('full_name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personalia (Anggota Berkarya)")),
      body: Column(
        children: [
          _buildSearchBar("Cari Nama Personalia...", (val) => setState(() => _query = val.toLowerCase())),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                if (snapshot.hasError) return _buildError(snapshot.error);
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Tidak ada data Personalia Ministries.");

                final filtered = snapshot.data!.where((item) {
                  return (item['full_name'] ?? '').toString().toLowerCase().contains(_query);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final member = filtered[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ExpansionTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.brown,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(member['full_name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Karya: ${member['entities']?['name'] ?? 'Belum ditentukan'}"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow("Tugas / Peran", member['role']),
                                _buildDetailRow("Asal Komunitas", member['conventus']?['name'] ?? '-'),
                                _buildDetailRow("Kota Kelahiran", member['city_of_birth']),
                                _buildDetailRow("Negara Kelahiran", member['country_of_birth']),
                                _buildDetailRow("Tanggal Lahir", member['date_of_birth']),
                                const Divider(),
                                _buildDetailRow("Kaul Kekal", member['solemn_profession_date']),
                                if (member['ordination_date'] != null)
                                  _buildDetailRow("Tahbisan Imam", member['ordination_date']),
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

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value?.toString() ?? '-'),
        ],
      ),
    );
  }
}

/// =================================================================
/// WIDGET HELPER GLOBAL (REUSABLE)
/// =================================================================
Widget _buildSearchBar(String hint, ValueChanged<String> onChanged) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: const Icon(Icons.search, color: Colors.brown),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

Widget _buildLoading() {
  return const Center(child: CircularProgressIndicator(color: Colors.brown));
}

Widget _buildError(Object? error) {
  return Center(child: Text("Terjadi kesalahan database: $error", style: const TextStyle(color: Colors.red)));
}

Widget _buildEmpty(String message) {
  return Center(child: Text(message, style: const TextStyle(color: Colors.grey)));
}