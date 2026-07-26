import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_anggota.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

/// =================================================================
/// HALAMAN UTAMA: MENU UTAMA DATA HEREMITI
/// =================================================================
class HalamanHeremiti extends StatelessWidget {
  const HalamanHeremiti({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.heremitiDirectoryTitle ?? "Direktori Heremiti"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              _buildMenuCard(
                context,
                title: t.exCarmeliteEntity ?? "Entities / Wilayah", 
                icon: Icons.terrain,
                subtitle: "Daftar Wilayah Pertapaan, Sejarah, & Website Resmi", // Subtitle deskriptif tetap aman jika mau dilokalisasi bertahap
                page: const HalamanHeremitiEntities(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.conventusList ?? "Conventus / Pertapaan",
                icon: Icons.gite,
                subtitle: "Daftar Rumah/Gedung Pertapaan dan Kontak Resmi",
                page: const HalamanHeremitiConventus(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.heremitiTitle ?? "Eremita (Anggota Heremiti)",
                icon: Icons.person_search,
                subtitle: "Daftar Anggota, Tanggal Kaul, & Tahbisan Imam",
                page: const HalamanHeremitiMembers(),
                baseWidth: baseWidth,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String subtitle,
    required Widget page,
    required double baseWidth,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: baseWidth * 0.03, horizontal: baseWidth * 0.04),
        leading: CircleAvatar(
          backgroundColor: Colors.brown,
          child: Icon(icon, color: Colors.white, size: baseWidth * 0.055),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: baseWidth * 0.032)),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}

/// =================================================================
/// SUB-HALAMAN 1: DATA HEREMITI – ENTITIES / WILAYAH
/// =================================================================
class HalamanHeremitiEntities extends StatefulWidget {
  const HalamanHeremitiEntities({super.key});

  @override
  State<HalamanHeremitiEntities> createState() => _HalamanHeremitiEntitiesState();
}

class _HalamanHeremitiEntitiesState extends State<HalamanHeremitiEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Heremiti')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.heremitiDirectoryTitle ?? "Entities & Wilayah Heremiti")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchHeremiti ?? "Cari Entitas Heremiti...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchEntities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noHeremitiData ?? "Tidak ada data Entitas Heremiti.", baseWidth);

                    final filtered = snapshot.data!.where((item) {
                      return (item['name'] ?? '').toString().toLowerCase().contains(_query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.all(baseWidth * 0.03),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final entity = filtered[index];
                        final address = entity['addresses'];
                        return Card(
                          child: ExpansionTile(
                            title: Text(entity['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text(entity['website_url'] ?? (t.noWebsite ?? 'Tidak ada Website'), style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${t.historia ?? 'Historia'}:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                    SizedBox(height: baseWidth * 0.01),
                                    Text(entity['historia'] ?? (t.noHistory ?? 'Belum ada data sejarah.'), style: TextStyle(fontSize: baseWidth * 0.035)),
                                    const Divider(),
                                    Text("${t.domusAddress ?? 'Domus/Kantor Wilayah'}:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                    SizedBox(height: baseWidth * 0.01),
                                    if (address != null) ...[
                                      Text("${address['house_name'] ?? ''} ${address['street'] ?? ''}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${address['city'] ?? ''}, ${address['country'] ?? ''} (${address['postal_code'] ?? ''})", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.telephone ?? 'Telp'}: ${address['telephone'] ?? '-'} • ${t.email ?? 'Email'}: ${address['email'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                    ] else
                                      Text(t.addressNotAvailable ?? "Alamat tidak tersedia.", style: TextStyle(fontSize: baseWidth * 0.035)),
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
          );
        },
      ),
    );
  }
}

/// =================================================================
/// SUB-HALAMAN 2: DATA HEREMITI – CONVENTUS (PERTAPAAN)
/// =================================================================
class HalamanHeremitiConventus extends StatefulWidget {
  const HalamanHeremitiConventus({super.key});

  @override
  State<HalamanHeremitiConventus> createState() => _HalamanHeremitiConventusState();
}

class _HalamanHeremitiConventusState extends State<HalamanHeremitiConventus> {
  String _query = "";

  Future<List<dynamic>> _fetchConventus() async {
    final response = await Supabase.instance.client
        .from('conventus')
        .select('*, addresses(*), entities!inner(*)')
        .eq('entities.entity_category', 'Heremiti')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.conventusMonasteriesTitle ?? "Pertapaan (Conventus Heremiti)")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchHeremiti ?? "Cari Nama Pertapaan / Kota...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchConventus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noHeremitiData ?? "Tidak ada data Pertapaan Heremiti.", baseWidth);

                    final filtered = snapshot.data!.where((item) {
                      final name = (item['name'] ?? '').toString().toLowerCase();
                      final city = (item['addresses']?['city'] ?? '').toString().toLowerCase();
                      return name.contains(_query) || city.contains(_query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.all(baseWidth * 0.03),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final conv = filtered[index];
                        final addr = conv['addresses'];
                        return Card(
                          child: ExpansionTile(
                            leading: Icon(Icons.gite_outlined, color: Colors.brown, size: baseWidth * 0.06),
                            title: Text(conv['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text("Entity: ${conv['entities']?['name'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.completeMonasteryAddress ?? "Detail Lokasi Rumah Pertapaan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                    SizedBox(height: baseWidth * 0.01),
                                    if (addr != null) ...[
                                      Text("${t.houseName ?? 'Gedung/Rumah'}: ${addr['house_name'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.street ?? 'Jalan/No'}: ${addr['street'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.city ?? 'Kota'}: ${addr['city'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.country ?? 'Negara'}: ${addr['country'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.postalCode ?? 'Kode Pos'}: ${addr['postal_code'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.telephone ?? 'Telepon'}: ${addr['telephone'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.faxcimile ?? 'Fax'}: ${addr['faxcimile'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                      Text("${t.email ?? 'Email'}: ${addr['email'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                                    ] else
                                      Text(t.addressNotFilled ?? "Data alamat belum dilengkapi.", style: TextStyle(fontSize: baseWidth * 0.035)),
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
          );
        },
      ),
    );
  }
}

/// =================================================================
/// SUB-HALAMAN 3: DATA HEREMITI – EREMITA (ANGGOTA)
/// =================================================================
class HalamanHeremitiMembers extends StatefulWidget {
  const HalamanHeremitiMembers({super.key});

  @override
  State<HalamanHeremitiMembers> createState() => _HalamanHeremitiMembersState();
}

class _HalamanHeremitiMembersState extends State<HalamanHeremitiMembers> {
  String _query = "";

  Future<List<dynamic>> _fetchMembers() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities!inner(*), conventus(*)')
        .eq('entities.entity_category', 'Heremiti')
        .order('full_name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.heremitiTitle ?? "Eremita (Anggota Heremiti)")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchHeremiti ?? "Cari Nama Pertapa...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noHeremitiData ?? "Tidak ada data Anggota Heremiti.", baseWidth);

                    final filtered = snapshot.data!.where((item) {
                      return (item['full_name'] ?? '').toString().toLowerCase().contains(_query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.all(baseWidth * 0.03),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final member = filtered[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown,
                              radius: baseWidth * 0.05,
                              child: Icon(Icons.person, color: Colors.white, size: baseWidth * 0.05),
                            ),
                            title: Text(member['full_name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text("${t.hermitageName ?? 'Pertapaan'}: ${member['conventus']?['name'] ?? 'Belum ditentukan'}", style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(t.positionRole ?? "Kategori/Peran", member['role'], baseWidth),
                                    _buildDetailRow(t.birthPlace ?? "Kota Kelahiran", member['city_of_birth'], baseWidth),
                                    _buildDetailRow(t.birthCountry ?? "Negara Kelahiran", member['country_of_birth'], baseWidth),
                                    _buildDetailRow(t.birthDate ?? "Tanggal Lahir", member['date_of_birth'], baseWidth),
                                    const Divider(),
                                    _buildDetailRow(t.firstProfession ?? "Tanggal Kaul Perdana", member['first_profession_date'], baseWidth),
                                    _buildDetailRow(t.solemnProfession ?? "Tanggal Kaul Kekal", member['solemn_profession_date'], baseWidth),
                                    _buildDetailRow(t.ordinationDate ?? "Tanggal Tahbisan Imam", member['ordination_date'], baseWidth),
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
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, double baseWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: baseWidth * 0.005),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: baseWidth * 0.035)),
          Expanded(child: Text(value?.toString() ?? '-', style: TextStyle(fontSize: baseWidth * 0.035))),
        ],
      ),
    );
  }
}

/// =================================================================
/// WIDGET HELPER GLOBAL (REUSABLE)
/// =================================================================
Widget _buildSearchBar(String hint, ValueChanged<String> onChanged, double baseWidth) {
  return Padding(
    padding: EdgeInsets.all(baseWidth * 0.03),
    child: TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontSize: baseWidth * 0.035),
        prefixIcon: Icon(Icons.search, color: Colors.brown, size: baseWidth * 0.055),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

Widget _buildLoading() {
  return const Center(child: CircularProgressIndicator(color: Colors.brown));
}

Widget _buildError(Object? error, double baseWidth) {
  return Center(child: Text("Terjadi kesalahan database: $error", style: TextStyle(color: Colors.red, fontSize: baseWidth * 0.038)));
}

Widget _buildEmpty(String message, double baseWidth) {
  return Center(child: Text(message, style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.038)));
}