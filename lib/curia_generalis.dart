import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =================================================================
/// HALAMAN UTAMA: CURIA GENERALIS (MENU PILIHAN)
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
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildMenuCard(
            context,
            title: "Consilium Generale",
            icon: Icons.gavel,
            subtitle: "Prior Generalis, Vice Prior, Sekjen, & Penasihat Ambitu",
            page: const HalamanConsiliumGenerale(),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Officia Generalia et Sectores Laborum",
            icon: Icons.business_center,
            subtitle: "Oeconomatus, Sekretariat, Delegatus, & Postulatura",
            page: const HalamanOfficiaGeneralia(),
          ),
          const SizedBox(height: 15),
          _buildMenuCard(
            context,
            title: "Commisiones Generales",
            icon: Icons.assignment,
            subtitle: "Komisi Formasi, Pemuda, Liturgi, Keadilan, & Kedamaian",
            page: const HalamanCommisionesGenerales(),
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
/// SUB-HALAMAN 1: CONSILIUM GENERALE (KONEKSI DATABASE MEMBERS)
/// =================================================================
class HalamanConsiliumGenerale extends StatefulWidget {
  const HalamanConsiliumGenerale({super.key});

  @override
  State<HalamanConsiliumGenerale> createState() => _HalamanConsiliumGeneraleState();
}

class _HalamanConsiliumGeneraleState extends State<HalamanConsiliumGenerale> {
  // Fungsi untuk mengambil data dari tabel 'members' yang memiliki role Dewan Umum
  Future<List<dynamic>> _fetchConsiliumData() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities(*)')
        .ilike('role', '%Prior%') // Mengambil role seperti Prior Generalis, Vice Prior, dsb.
        .order('id', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consilium Generale")),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchConsiliumData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data Consilium Generale."));
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final member = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    member['full_name'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "Jabatan: ${member['role'] ?? '-'}\nEntity: ${member['entities']?['name'] ?? '-'}",
                  ),
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
/// SUB-HALAMAN 2: OFFICIA GENERALIA (KONEKSI DATABASE MEMBERS)
/// =================================================================
class HalamanOfficiaGeneralia extends StatefulWidget {
  const HalamanOfficiaGeneralia({super.key});

  @override
  State<HalamanOfficiaGeneralia> createState() => _HalamanOfficiaGeneraliaState();
}

class _HalamanOfficiaGeneraliaState extends State<HalamanOfficiaGeneralia> {
  // Fungsi mengambil data pejabat struktural umum dari tabel 'members'
  Future<List<dynamic>> _fetchOfficiaData() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities(*)')
        .or('role.ilike.%Delegatus%,role.ilike.%Secretariatus%,role.ilike.%Oeconomatus%,role.ilike.%Postulatura%')
        .order('id', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Officia Generalia")),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchOfficiaData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data Officia Generalia."));
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final member = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.assignment_ind, color: Colors.white),
                  ),
                  title: Text(
                    member['full_name'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "Bidang/Jabatan: ${member['role'] ?? '-'}\nKantor: ${member['entities']?['name'] ?? '-'}",
                  ),
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
/// SUB-HALAMAN 3: COMMISSIONES GENERALES (KONEKSI DATABASE ENTITIES)
/// =================================================================
class HalamanCommisionesGenerales extends StatefulWidget {
  const HalamanCommisionesGenerales({super.key});

  @override
  State<HalamanCommisionesGenerales> createState() => _HalamanCommisionesGeneralesState();
}

class _HalamanCommisionesGeneralesState extends State<HalamanCommisionesGenerales> {
  // Fungsi mengambil data daftar komisi dari tabel 'entities' dengan kategori terkait
  Future<List<dynamic>> _fetchCommisionesData() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Commisiones Generales') // Menyesuaikan kolom entity_category pada skema SQL
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commisiones Generales")),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchCommisionesData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data Komisi ditemukan."));
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final komisi = data[index];
              final alamat = komisi['addresses'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.group, color: Colors.white),
                  ),
                  title: Text(
                    komisi['name'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(komisi['website_url'] ?? 'Tidak ada tautan website'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Historia / Deskripsi:",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700),
                          ),
                          const SizedBox(height: 4),
                          Text(komisi['historia'] ?? 'Deskripsi tidak tersedia.'),
                          const Divider(),
                          Text(
                            "Informasi Kontak & Alamat:",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700),
                          ),
                          const SizedBox(height: 4),
                          if (alamat != null) ...[
                            Text("Rumah/Gedung: ${alamat['house_name'] ?? '-'}"),
                            Text("Jalan: ${alamat['street'] ?? '-'}"),
                            Text("Kota/Negara: ${alamat['city'] ?? '-'}, ${alamat['country'] ?? '-'}"),
                            Text("Telepon: ${alamat['telephone'] ?? '-'}"),
                            Text("Email: ${alamat['email'] ?? '-'}"),
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