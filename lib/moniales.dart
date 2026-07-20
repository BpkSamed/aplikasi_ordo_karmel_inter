import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart'; // Jika nantinya admin ingin menambah anggota langsung dari halaman ini

/// =================================================================
/// HALAMAN UTAMA: MENU UTAMA DATA MONIALES
/// =================================================================
class HalamanMoniales extends StatelessWidget {
  const HalamanMoniales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direktori Moniales"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildMenuCard(
            context,
            title: "Federatio / Entities",
            icon: Icons.account_balance,
            subtitle: "Daftar Federasi Moniales, Sejarah, & Website Resmi",
            page: const HalamanMonialesEntities(),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Monasteria / Conventus (Biara)",
            icon: Icons.church,
            subtitle: "Daftar Rumah Biara Moniales dan Alamat Kontak",
            page: const HalamanMonialesConventus(),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Sorores (Anggota Suster)",
            icon: Icons.face_3,
            subtitle: "Daftar Suster, Asal Lahir, & Tanggal Kaul",
            page: const HalamanMonialesSorores(),
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
/// SUB-HALAMAN 1: DATA MONIALES – FEDERATIO / ENTITIES
/// =================================================================
class HalamanMonialesEntities extends StatefulWidget {
  const HalamanMonialesEntities({super.key});

  @override
  State<HalamanMonialesEntities> createState() => _HalamanMonialesEntitiesState();
}

class _HalamanMonialesEntitiesState extends State<HalamanMonialesEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Moniales')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Federatio & Entities")),
      body: Column(
        children: [
          _buildSearchBar("Cari Federasi / Entitas...", (val) => setState(() => _query = val.toLowerCase())),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchEntities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                if (snapshot.hasError) return _buildError(snapshot.error);
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Tidak ada data Entitas Moniales.");

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
                        title: Text(entity['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(entity['website_url'] ?? 'Tidak ada Website'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Historia:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                const SizedBox(height: 4),
                                Text(entity['historia'] ?? 'Belum ada data sejarah.'),
                                const Divider(),
                                Text("Domus/Kantor Pusat:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
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
/// SUB-HALAMAN 2: DATA MONIALES – CONVENTUS (MONASTERIA / BIARA)
/// =================================================================
class HalamanMonialesConventus extends StatefulWidget {
  const HalamanMonialesConventus({super.key});

  @override
  State<HalamanMonialesConventus> createState() => _HalamanMonialesConventusState();
}

class _HalamanMonialesConventusState extends State<HalamanMonialesConventus> {
  String _query = "";

  Future<List<dynamic>> _fetchConventus() async {
    final response = await Supabase.instance.client
        .from('conventus')
        .select('*, addresses(*), entities!inner(*)')
        .eq('entities.entity_category', 'Moniales')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monasteria (Biara Moniales)")),
      body: Column(
        children: [
          _buildSearchBar("Cari Nama Biara / Kota...", (val) => setState(() => _query = val.toLowerCase())),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchConventus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                if (snapshot.hasError) return _buildError(snapshot.error);
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Tidak ada data Biara Moniales.");

                final filtered = snapshot.data!.where((item) {
                  final name = (item['name'] ?? '').toString().toLowerCase();
                  final city = (item['addresses']?['city'] ?? '').toString().toLowerCase();
                  return name.contains(_query) || city.contains(_query);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final conv = filtered[index];
                    final addr = conv['addresses'];
                    return Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.gite, color: Colors.brown),
                        title: Text(conv['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Federasi: ${conv['entities']?['name'] ?? '-'}"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Detail Informasi Lokasi Biara:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                const SizedBox(height: 4),
                                if (addr != null) ...[
                                  Text("Rumah/Gedung: ${addr['house_name'] ?? '-'}"),
                                  Text("Jalan/No: ${addr['street'] ?? '-'}"),
                                  Text("Kota: ${addr['city'] ?? '-'}"),
                                  Text("Negara: ${addr['country'] ?? '-'}"),
                                  Text("Kode Pos: ${addr['postal_code'] ?? '-'}"),
                                  Text("Telepon: ${addr['telephone'] ?? '-'}"),
                                  Text("Fax: ${addr['faxcimile'] ?? '-'}"),
                                  Text("Email: ${addr['email'] ?? '-'}"),
                                ] else
                                  const Text("Data alamat belum dilengkapi."),
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
/// SUB-HALAMAN 3: DATA MONIALES – SORORES (ANGGOTA SUSTER)
/// =================================================================
class HalamanMonialesSorores extends StatefulWidget {
  const HalamanMonialesSorores({super.key});

  @override
  State<HalamanMonialesSorores> createState() => _HalamanMonialesSororesState();
}

class _HalamanMonialesSororesState extends State<HalamanMonialesSorores> {
  String _query = "";

  Future<List<dynamic>> _fetchSorores() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities!inner(*), conventus(*)')
        .eq('entities.entity_category', 'Moniales')
        .order('full_name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sorores (Anggota Suster)")),
      body: Column(
        children: [
          _buildSearchBar("Cari Nama Suster...", (val) => setState(() => _query = val.toLowerCase())),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchSorores(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                if (snapshot.hasError) return _buildError(snapshot.error);
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty("Tidak ada data Suster Moniales.");

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
                          child: Icon(Icons.woman, color: Colors.white),
                        ),
                        title: Text(member['full_name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Biara: ${member['conventus']?['name'] ?? 'Belum ditentukan'}"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow("Kategori/Peran", member['role']),
                                _buildDetailRow("Kota Kelahiran", member['city_of_birth']),
                                _buildDetailRow("Negara Kelahiran", member['country_of_birth']),
                                _buildDetailRow("Tanggal Lahir", member['date_of_birth']),
                                const Divider(),
                                _buildDetailRow("Tanggal Kaul Perdana", member['first_profession_date']),
                                _buildDetailRow("Tanggal Kaul Kekal", member['solemn_profession_date']),
                                // Catatan: Moniales tidak memiliki klerikal/Tahbisan Imam, kolom ordination_date dilewati otomatis sesuai format tabel Word
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