import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

/// =================================================================
/// HALAMAN UTAMA: DIKTORI MONASTERIA ORDINIS (PROPRIIS UTUNTUR)
/// =================================================================
class HalamanMonasteriaOrdiniss extends StatelessWidget {
  const HalamanMonasteriaOrdiniss({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.monasteriaOrdinisTitle ?? "Monasteria Ordinis"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              _buildMenuCard(
                context,
                title: t.entitiesCongregatioTitle ?? "Entities / Congregatio",
                icon: Icons.account_balance_wallet,
                subtitle: t.entitiesCongregatioSubtitle ?? "Daftar Entitas Induk, Sejarah, & Website Resmi",
                page: const HalamanMonasteriaEntities(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.monasteriaConventusTitle ?? "Monasteria / Conventus",
                icon: Icons.gite_rounded,
                subtitle: t.monasteriaConventusSubtitle ?? "Daftar Rumah Biara Mandiri dan Kontak Resmi",
                page: const HalamanMonasteriaConventus(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.sororesMonialTitle ?? "Sorores (Anggota Suster Monial)",
                icon: Icons.woman_2,
                subtitle: t.sororesMonialSubtitle ?? "Daftar Suster, Tempat Lahir, & Tanggal Kaul",
                page: const HalamanMonasteriaSorores(),
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
/// SUB-HALAMAN 1: DATA MONASTERIA – ENTITIES / CONGREGATIO
/// =================================================================
class HalamanMonasteriaEntities extends StatefulWidget {
  const HalamanMonasteriaEntities({super.key});

  @override
  State<HalamanMonasteriaEntities> createState() => _HalamanMonasteriaEntitiesState();
}

class _HalamanMonasteriaEntitiesState extends State<HalamanMonasteriaEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Monasteria Ordinis')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.entitiesCongregatioTitle ?? "Entities & Congregatio")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchParentEntity ?? "Cari Entitas Induk...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchEntities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noMonasteriaEntitiesData ?? "Tidak ada data Entitas Monasteria Ordinis.", baseWidth);

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
                                    Text(t.historiaConstitution ?? "Historia / Konstitusi Khusus:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                    SizedBox(height: baseWidth * 0.01),
                                    Text(entity['historia'] ?? (t.noHistoriaConstitution ?? 'Belum ada data sejarah/catatan konstitusi.'), style: TextStyle(fontSize: baseWidth * 0.035)),
                                    const Divider(),
                                    Text("${t.domusAddress ?? 'Domus / Kantor Pusat'}:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
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
/// SUB-HALAMAN 2: DATA MONASTERIA – MONASTERIA / CONVENTUS (BIARA)
/// =================================================================
class HalamanMonasteriaConventus extends StatefulWidget {
  const HalamanMonasteriaConventus({super.key});

  @override
  State<HalamanMonasteriaConventus> createState() => _HalamanMonasteriaConventusState();
}

class _HalamanMonasteriaConventusState extends State<HalamanMonasteriaConventus> {
  String _query = "";

  Future<List<dynamic>> _fetchConventus() async {
    final response = await Supabase.instance.client
        .from('conventus')
        .select('*, addresses(*), entities!inner(*)')
        .eq('entities.entity_category', 'Monasteria Ordinis')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.monasteriaConventusTitle ?? "Monasteria / Conventus")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchMonasteryCity ?? "Cari Nama Biara / Kota...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchConventus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noMonasteriaConventusData ?? "Tidak ada data Biara Pertapaan.", baseWidth);

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
                            leading: Icon(Icons.gite_rounded, color: Colors.brown, size: baseWidth * 0.06),
                            title: Text(conv['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text("${t.affiliation ?? 'Afiliasi:'} ${conv['entities']?['name'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.contactAndMonasteryDetail ?? "Detail Informasi Kontak & Rumah Biara:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
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
                                      Text(t.addressNotCompleteInDb ?? "Data alamat belum dilengkapi di database.", style: TextStyle(fontSize: baseWidth * 0.035)),
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
/// SUB-HALAMAN 3: DATA MONASTERIA – SORORES (ANGGOTA SUSTER)
/// =================================================================
class HalamanMonasteriaSorores extends StatefulWidget {
  const HalamanMonasteriaSorores({super.key});

  @override
  State<HalamanMonasteriaSorores> createState() => _HalamanMonasteriaSororesState();
}

class _HalamanMonasteriaSororesState extends State<HalamanMonasteriaSorores> {
  String _query = "";

  Future<List<dynamic>> _fetchSorores() async {
    final response = await Supabase.instance.client
        .from('members')
        .select('*, entities!inner(*), conventus(*)')
        .eq('entities.entity_category', 'Monasteria Ordinis')
        .order('full_name', ascending: true);
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.sororesMembersTitle ?? "Sorores (Anggota)")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchSisterName ?? "Cari Nama Suster...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchSorores(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noSisterDataFound ?? "Tidak ada data Suster ditemukan.", baseWidth);

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
                              child: Icon(Icons.woman, color: Colors.white, size: baseWidth * 0.05),
                            ),
                            title: Text(member['full_name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text("${t.sisterMonastery ?? 'Biara'}: ${member['conventus']?['name'] ?? 'Belum ditentukan'}", style: TextStyle(fontSize: baseWidth * 0.032)),
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