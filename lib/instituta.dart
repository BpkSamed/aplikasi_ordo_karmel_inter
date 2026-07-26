import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

/// =================================================================
/// HALAMAN UTAMA: MENU UTAMA DATA INSTITUTA
/// =================================================================
class HalamanInstituta extends StatelessWidget {
  const HalamanInstituta({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.institutaDirectoryTitle ?? "Direktori Instituta"),
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
                icon: Icons.account_balance,
                subtitle: t.institutaEntitiesSubtitle ?? "Daftar Institut Terafiliasi, Sejarah, & Website Resmi",
                page: const HalamanInstitutaEntities(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.conventusList ?? "Conventus / Rumah Institut",
                icon: Icons.gite_rounded,
                subtitle: t.institutaConventusSubtitle ?? "Daftar Rumah/Gedung Institut dan Kontak Resmi",
                page: const HalamanInstitutaConventus(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.institutaTitle ?? "Instituta (Anggota Institut)",
                icon: Icons.people_alt,
                subtitle: t.institutaMembersSubtitle ?? "Daftar Anggota Institut, Tanggal Kaul, & Tahbisan",
                page: const HalamanInstitutaMembers(),
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
/// SUB-HALAMAN 1: DATA INSTITUTA – ENTITIES / WILAYAH
/// =================================================================
class HalamanInstitutaEntities extends StatefulWidget {
  const HalamanInstitutaEntities({super.key});

  @override
  State<HalamanInstitutaEntities> createState() => _HalamanInstitutaEntitiesState();
}

class _HalamanInstitutaEntitiesState extends State<HalamanInstitutaEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Instituta')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.institutaDirectoryTitle ?? "Entities & Wilayah Instituta")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchInstitutaEntity ?? "Cari Entitas Institut...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchEntities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noInstitutaData ?? "Tidak ada data Entitas Instituta.", baseWidth);

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
/// SUB-HALAMAN 2: DATA INSTITUTA – CONVENTUS / RUMAH INSTITUT
/// =================================================================
class HalamanInstitutaConventus extends StatefulWidget {
  const HalamanInstitutaConventus({super.key});

  @override
  State<HalamanInstitutaConventus> createState() => _HalamanInstitutaConventusState();
}

class _HalamanInstitutaConventusState extends State<HalamanInstitutaConventus> {
  String _query = "";

  Future<List<dynamic>> _fetchConventus() async {
    final response = await Supabase.instance.client
        .from('conventus')
        .select('*, addresses(*), entities!inner(*)')
        .eq('entities.entity_category', 'Instituta')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.conventusMonasteriesTitle ?? "Conventus / Rumah Instituta")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchInstituta ?? "Cari Nama Rumah / Kota...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchConventus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noInstitutaData ?? "Tidak ada data Conventus Instituta.", baseWidth);

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
                                    Text(t.contactAndMonasteryDetail ?? "Detail Informasi Lokasi Rumah Institut:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
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
/// SUB-HALAMAN 3: DATA INSTITUTA – ANGGOTA
/// =================================================================
class HalamanInstitutaMembers extends StatefulWidget {
  const HalamanInstitutaMembers({super.key});

  @override
  State<HalamanInstitutaMembers> createState() => _HalamanInstitutaMembersState();
}

class _HalamanInstitutaMembersState extends State<HalamanInstitutaMembers> {
  String _query = "";

  Future<List<dynamic>> _fetchMembers() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities!inner(*), conventus(*)')
        .eq('entities.entity_category', 'Instituta')
        .order('full_name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.institutaTitle ?? "Instituta (Anggota Institut)")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchInstituta ?? "Cari Nama Anggota...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noInstitutaData ?? "Tidak ada data Anggota Instituta.", baseWidth);

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
                            subtitle: Text("Rumah: ${member['conventus']?['name'] ?? (t.notDetermined ?? 'Belum ditentukan')}", style: TextStyle(fontSize: baseWidth * 0.032)),
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
                                    if (member['ordination_date'] != null)
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

Widget _buildError(Object? error, AppLocalizations t, double baseWidth) {
  return Center(
    child: Text(
      "${t.databaseError ?? 'Terjadi kesalahan database'}: $error",
      style: TextStyle(color: Colors.red, fontSize: baseWidth * 0.038),
    ),
  );
}

Widget _buildEmpty(String message, double baseWidth) {
  return Center(child: Text(message, style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.038)));
}