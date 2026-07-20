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
            "Karya Kerasulan & Pelayanan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Lembaga / Karya (Entities)",
            icon: Icons.volunteer_activism,
            subtitle: "Daftar Paroki, Sekolah, Rumah Bina, & Yayasan",
            page: const HalamanMinistriesEntities(),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Personalia / Anggota (Sodales)",
            icon: Icons.group_work,
            subtitle: "Daftar Anggota yang Berkarya di Lembaga Pelayanan",
            page: const HalamanMinistriesMembers(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.brown,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}

/// =================================================================
/// SUB-HALAMAN 1: DATA MINISTRIES – LEMBAGA / KARYA (ENTITIES)
/// =================================================================
class HalamanMinistriesEntities extends StatefulWidget {
  const HalamanMinistriesEntities({super.key});

  @override
  State<HalamanMinistriesEntities> createState() => _HalamanMinistriesEntitiesState();
}

class _HalamanMinistriesEntitiesState extends State<HalamanMinistriesEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Ministries')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lembaga & Karya Kerasulan")),
      body: Column(
        children: [
          _buildSearchBar("Cari Nama Lembaga / Karya...", (val) => setState(() => _query = val.toLowerCase())),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchEntities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                if (snapshot.hasError) return _buildError(snapshot.error);
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Tidak ada data Lembaga/Karya Ministries.");

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
/// SUB-HALAMAN 2: DATA MINISTRIES – PERSONALIA (MEMBERS)
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