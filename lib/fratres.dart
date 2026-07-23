import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// 1. HALAMAN UTAMA FRATRES (PILIHAN PAYUNG KATEGORI)
/// =================================================================
class HalamanFratres extends StatelessWidget {
  const HalamanFratres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Direktori Fratres")),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Pilih Kategori Fratres",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(context, "PROVINCIA", Icons.gite, 'Provincia'),
          const SizedBox(height: 15),
          _buildMenuCard(context, "COMMISSARIATUS GENERALIS", Icons.apartment, 'Commissariatus Generalis'),
          const SizedBox(height: 15),
          _buildMenuCard(context, "DELEGATIO GENERALIS", Icons.account_balance, 'Delegatio Generalis'),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String dbCategory) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(backgroundColor: Colors.brown, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HalamanDaftarEntitasFratres(categoryName: title, dbCategory: dbCategory)),
          );
        },
      ),
    );
  }
}

/// =================================================================
/// 2. HALAMAN DAFTAR ENTITAS (CONTOH: DAFTAR NAMA PROVINSI)
/// =================================================================
class HalamanDaftarEntitasFratres extends StatefulWidget {
  final String categoryName;
  final String dbCategory;

  const HalamanDaftarEntitasFratres({super.key, required this.categoryName, required this.dbCategory});

  @override
  State<HalamanDaftarEntitasFratres> createState() => _HalamanDaftarEntitasFratresState();
}

class _HalamanDaftarEntitasFratresState extends State<HalamanDaftarEntitasFratres> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', widget.dbCategory)
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar ${widget.categoryName}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _query = val.toLowerCase()),
              decoration: InputDecoration(
                labelText: "Cari Nama ${widget.categoryName}...",
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchEntities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.brown));
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("Tidak ada data ${widget.categoryName} ditemukan."));

                final filtered = snapshot.data!.where((item) {
                  return (item['name'] ?? '').toString().toLowerCase().contains(_query);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entity = filtered[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_city, color: Colors.brown),
                        title: Text(entity['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(entity['addresses']?['city'] ?? 'Lokasi tidak diset'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HalamanDetailEntitasFratres(entity: entity, categoryName: widget.categoryName)),
                          );
                        },
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
/// 3. HALAMAN MENU PILIHAN DI DALAM ENTITAS (HISTORIA, SODALES, DLL)
/// =================================================================
class HalamanDetailEntitasFratres extends StatelessWidget {
  final dynamic entity;
  final String categoryName;

  const HalamanDetailEntitasFratres({super.key, required this.entity, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entity['name'] ?? 'Detail')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(entity['name'] ?? '-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 20),
          
          _buildSubMenuTile(context, "Historia", Icons.history, () => _bukaHalamanInfo(context, "Historia", entity['historia'] ?? "Belum ada riwayat sejarah.")),
          _buildSubMenuTile(context, "Website", Icons.language, () => _bukaHalamanInfo(context, "Website Resmi", "Tautan Web: ${entity['website_url'] ?? 'Tidak ada website'}")),
          
          _buildSubMenuTile(context, "Consilium (Dewan Pimpinan)", Icons.assignment_ind, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanSubMenuAnggotaFratres(entityId: entity['id'], tipeView: 'consilium', title: "Consilium Pimpinan")));
          }),
          
          _buildSubMenuTile(context, "Domus (Alamat Pimpinan)", Icons.mail_outline, () {
            final addr = entity['addresses'];
            String fullAddr = "Alamat tidak tersedia.";
            if (addr != null) {
              fullAddr = "Biara/Gedung: ${addr['house_name'] ?? '-'}\nJalan: ${addr['street'] ?? '-'}\nKota: ${addr['city'] ?? '-'}\nNegara: ${addr['country'] ?? '-'}\nKode Pos: ${addr['postal_code'] ?? '-'}\nTelp: ${addr['telephone'] ?? '-'}\nFax: ${addr['faxcimile'] ?? '-'}\nEmail: ${addr['email'] ?? '-'}";
            }
            _bukaHalamanInfo(context, "Domus Resmi", fullAddr);
          }),
          
          _buildSubMenuTile(context, "Conventus (Daftar Biara)", Icons.maps_home_work, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanSubMenuConventusFratres(entityId: entity['id'])));
          }),
          
          _buildSubMenuTile(context, "Sodales (Daftar Anggota)", Icons.people_outline, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanSubMenuAnggotaFratres(entityId: entity['id'], tipeView: 'sodales', title: "Daftar Anggota (Sodales)")));
          }),
        ],
      ),
    );
  }

  Widget _buildSubMenuTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }

  void _bukaHalamanInfo(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
          ),
        ),
      ),
    );
  }
}

/// =================================================================
/// 4. SUB-MENU DATA ANGGOTA (CONSILIUM & SODALES BERDASARKAN KAUL PERDANA)
/// =================================================================
class HalamanSubMenuAnggotaFratres extends StatefulWidget {
  final int entityId;
  final String tipeView; // 'consilium' atau 'sodales'
  final String title;

  const HalamanSubMenuAnggotaFratres({super.key, required this.entityId, required this.tipeView, required this.title});

  @override
  State<HalamanSubMenuAnggotaFratres> createState() => _HalamanSubMenuAnggotaFratresState();
}

class _HalamanSubMenuAnggotaFratresState extends State<HalamanSubMenuAnggotaFratres> {
  Future<List<dynamic>> _fetchMembers() async {
    if (widget.tipeView == 'consilium') {
      // Menampilkan pimpinan (bukan sodales biasa)
      final response = await Supabase.instance.client
          .from('members')
          .select()
          .eq('entity_id', widget.entityId)
          .neq('role', 'Sodales'); 
          
      return response as List<dynamic>;
    } else {
      // Menampilkan daftar Sodales dan mutlak diurutkan berdasarkan tanggal kaul perdana
      final response = await Supabase.instance.client
          .from('members')
          .select()
          .eq('entity_id', widget.entityId)
          .order('first_profession_date', ascending: true);
          
      return response as List<dynamic>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.brown));
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Tidak ada data anggota."));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final member = snapshot.data![index];
              return Card(
                child: ExpansionTile(
                  leading: const CircleAvatar(backgroundColor: Colors.brown, child: Icon(Icons.person, color: Colors.white)),
                  title: Text(member['full_name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Jabatan/Peran: ${member['role'] ?? '-'}"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("Tempat Lahir", "${member['city_of_birth'] ?? '-'}, ${member['country_of_birth'] ?? '-'}"),
                          _buildDetailRow("Tanggal Lahir", member['date_of_birth']),
                          _buildDetailRow("Kaul Perdana", member['first_profession_date']),
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
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
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
/// 5. SUB-MENU DAFTAR BIARA (CONVENTUS)
/// =================================================================
class HalamanSubMenuConventusFratres extends StatelessWidget {
  final int entityId;

  const HalamanSubMenuConventusFratres({super.key, required this.entityId});

  Future<List<dynamic>> _fetchConventus() async {
    final response = await Supabase.instance.client
        .from('conventus')
        .select('*, addresses(*)')
        .eq('parent_entity_id', entityId)
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Rumah Biara (Conventus)")),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchConventus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.brown));
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada data biara terdaftar."));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final conv = snapshot.data![index];
              final addr = conv['addresses'];
              return Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.maps_home_work, color: Colors.brown),
                  title: Text(conv['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Kota: ${addr?['city'] ?? '-'}"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Alamat Lengkap Biara:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                          const SizedBox(height: 5),
                          if (addr != null) ...[
                            Text("Jalan: ${addr['street'] ?? '-'}"),
                            Text("Negara: ${addr['country'] ?? '-'} (${addr['postal_code'] ?? '-'})"),
                            Text("Telp: ${addr['telephone'] ?? '-'}"),
                            Text("Fax: ${addr['faxcimile'] ?? '-'}"),
                            Text("Email: ${addr['email'] ?? '-'}"),
                          ] else
                            const Text("Detail alamat belum diisi."),
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
    );
  }
}