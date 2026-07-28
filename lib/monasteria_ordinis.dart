import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // UNTUK CLIPBOARD (SALIN TEKS)
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // UNTUK LINK WEBSITE
import 'l10n/app_localizations.dart'; // Import lokalisasi

/// =================================================================
/// WIDGET HELPER GLOBAL: ROW INFORMASI DENGAN FITUR LONG PRESS COPY
/// =================================================================
Widget _buildCopyableRow({
  required BuildContext context,
  required String label,
  required String value,
  required double baseWidth,
  bool isCopyable = true,
}) {
  final bool canCopy = isCopyable && value != '-' && value.trim().isNotEmpty;

  return InkWell(
    onLongPress: canCopy
        ? () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$label $value berhasil disalin"),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        : null,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: baseWidth * 0.012),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: baseWidth * 0.28,
            child: Text(
              "$label: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: baseWidth * 0.035,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: baseWidth * 0.035,
                      color: canCopy ? Colors.brown.shade900 : Colors.black87,
                      fontWeight: canCopy ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                if (canCopy)
                  Padding(
                    padding: EdgeInsets.only(left: baseWidth * 0.01),
                    child: Icon(Icons.copy, size: baseWidth * 0.035, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// =================================================================
/// HALAMAN UTAMA: MENU UTAMA DATA MONASTERIA ORDINIS
/// =================================================================
class HalamanMonasteriaOrdinis extends StatelessWidget {
  const HalamanMonasteriaOrdinis({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.monasteriaOrdinisTitle ?? "Direktori Monasteria Ordinis"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              _buildMenuCard(
                context,
                title: t.federatioEntitiesTitle ?? "Federatio / Entities",
                icon: Icons.account_balance,
                subtitle: t.federatioEntitiesSubtitle ?? "Daftar Federasi, Sejarah, & Website Resmi",
                page: const HalamanMonasteriaOrdinisEntities(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.monialesConventusTitle ?? "Monasteria / Conventus (Biara)",
                icon: Icons.church,
                subtitle: t.monialesConventusSubtitle ?? "Daftar Rumah Biara dan Alamat Kontak",
                page: const HalamanMonasteriaOrdinisConventus(),
                baseWidth: baseWidth,
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(
                context,
                title: t.sororesTitle ?? "Sorores (Anggota Suster)",
                icon: Icons.face_3,
                subtitle: t.sororesSubtitle ?? "Daftar Suster, Asal Lahir, & Tanggal Kaul",
                page: const HalamanMonasteriaOrdinisSorores(),
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
/// SUB-HALAMAN 1: DATA ENTITIES / FEDERATIO
/// =================================================================
class HalamanMonasteriaOrdinisEntities extends StatefulWidget {
  const HalamanMonasteriaOrdinisEntities({super.key});

  @override
  State<HalamanMonasteriaOrdinisEntities> createState() => _HalamanMonasteriaOrdinisEntitiesState();
}

class _HalamanMonasteriaOrdinisEntitiesState extends State<HalamanMonasteriaOrdinisEntities> {
  String _query = "";

  Future<List<dynamic>> _fetchEntities() async {
    final response = await Supabase.instance.client
        .from('entities')
        .select('*, addresses(*)')
        .eq('entity_category', 'Monasteria Ordinis')
        .order('name', ascending: true);
    return response as List<dynamic>;
  }

  Future<void> _launchExternalURL(BuildContext context, String urlString) async {
    String finalUrl = urlString.trim();
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }
    final Uri url = Uri.parse(finalUrl);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membuka tautan web: $finalUrl")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.federatioAndEntities ?? "Federatio & Entities")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchFederation ?? "Cari Federasi / Entitas...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchEntities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noMonialesEntitiesData ?? "Tidak ada data Entitas.", baseWidth);

                    final filtered = snapshot.data!.where((item) {
                      return (item['name'] ?? '').toString().toLowerCase().contains(_query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.all(baseWidth * 0.03),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final entity = filtered[index];
                        final address = entity['addresses'];
                        final String? webUrl = entity['website_url'];

                        return Card(
                          child: ExpansionTile(
                            leading: Icon(Icons.account_balance, color: Colors.brown, size: baseWidth * 0.06),
                            title: Text(entity['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text(address?['city'] ?? (t.locationNotSet ?? 'Lokasi belum diatur'), style: TextStyle(fontSize: baseWidth * 0.032)),
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
                                    
                                    if (webUrl != null && webUrl.trim().isNotEmpty) ...[
                                      Text("${t.officialWebsite ?? 'Website Resmi'}:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                      SizedBox(height: baseWidth * 0.01),
                                      InkWell(
                                        onTap: () => _launchExternalURL(context, webUrl),
                                        child: Text(
                                          webUrl,
                                          style: TextStyle(fontSize: baseWidth * 0.035, color: Colors.blue, decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Divider(),
                                    ],

                                    Text("${t.domusAddress ?? 'Domus/Kantor Pusat'}:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                    SizedBox(height: baseWidth * 0.01),
                                    if (address != null) ...[
                                      _buildCopyableRow(context: context, label: t.houseName ?? 'Gedung/Rumah', value: address['house_name'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.street ?? 'Jalan/No', value: address['street'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.city ?? 'Kota', value: address['city'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.country ?? 'Negara', value: address['country'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.postalCode ?? 'Kode Pos', value: address['postal_code'] ?? '-', baseWidth: baseWidth, isCopyable: true),
                                      _buildCopyableRow(context: context, label: t.telephone ?? 'Telepon', value: address['telephone'] ?? '-', baseWidth: baseWidth, isCopyable: true),
                                      _buildCopyableRow(context: context, label: t.faxcimile ?? 'Fax', value: address['faxcimile'] ?? '-', baseWidth: baseWidth, isCopyable: true),
                                      _buildCopyableRow(context: context, label: t.email ?? 'Email', value: address['email'] ?? '-', baseWidth: baseWidth, isCopyable: true),
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
/// SUB-HALAMAN 2: DATA CONVENTUS (MONASTERIA / BIARA)
/// =================================================================
class HalamanMonasteriaOrdinisConventus extends StatefulWidget {
  const HalamanMonasteriaOrdinisConventus({super.key});

  @override
  State<HalamanMonasteriaOrdinisConventus> createState() => _HalamanMonasteriaOrdinisConventusState();
}

class _HalamanMonasteriaOrdinisConventusState extends State<HalamanMonasteriaOrdinisConventus> {
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
      appBar: AppBar(title: Text(t.monasteriaTitle ?? "Monasteria (Biara)")),
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
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noMonialesMonasteryData ?? "Tidak ada data Biara.", baseWidth);

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
                            leading: Icon(Icons.church, color: Colors.brown, size: baseWidth * 0.06),
                            title: Text(conv['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text("${t.federationLabel ?? 'Federasi'}: ${conv['entities']?['name'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.monasteryLocationDetail ?? "Detail Informasi Lokasi Biara:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)),
                                    SizedBox(height: baseWidth * 0.01),
                                    if (addr != null) ...[
                                      _buildCopyableRow(context: context, label: t.houseName ?? 'Gedung/Rumah', value: addr['house_name'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.street ?? 'Jalan/No', value: addr['street'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.city ?? 'Kota', value: addr['city'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.country ?? 'Negara', value: addr['country'] ?? '-', baseWidth: baseWidth, isCopyable: false),
                                      _buildCopyableRow(context: context, label: t.postalCode ?? 'Kode Pos', value: addr['postal_code'] ?? '-', baseWidth: baseWidth, isCopyable: true),
                                      _buildCopyableRow(context: context, label: t.telephone ?? 'Telepon', value: addr['telephone'] ?? '-', baseWidth: baseWidth, isCopyable: true),
                                      _buildCopyableRow(context: context, label: t.faxcimile ?? 'Fax', value: addr['faxcimile'] ?? '-', baseWidth: baseWidth, isCopyable: true),
                                      _buildCopyableRow(context: context, label: t.email ?? 'Email', value: addr['email'] ?? '-', baseWidth: baseWidth, isCopyable: true),
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
/// SUB-HALAMAN 3: DATA SORORES (ANGGOTA SUSTER)
/// =================================================================
class HalamanMonasteriaOrdinisSorores extends StatefulWidget {
  const HalamanMonasteriaOrdinisSorores({super.key});

  @override
  State<HalamanMonasteriaOrdinisSorores> createState() => _HalamanMonasteriaOrdinisSororesState();
}

class _HalamanMonasteriaOrdinisSororesState extends State<HalamanMonasteriaOrdinisSorores> {
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
      appBar: AppBar(title: Text(t.sororesTitle ?? "Sorores (Anggota Suster)")),
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
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noSororesData ?? "Tidak ada data Suster.", baseWidth);

                    final filtered = snapshot.data!.where((item) {
                      return (item['full_name'] ?? '').toString().toLowerCase().contains(_query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.all(baseWidth * 0.03),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final member = filtered[index];
                        final String? photoUrl = member['photo_url'];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown,
                              radius: baseWidth * 0.05,
                              backgroundImage: (photoUrl != null && photoUrl.trim().isNotEmpty)
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: (photoUrl == null || photoUrl.trim().isEmpty)
                                  ? Icon(Icons.woman, color: Colors.white, size: baseWidth * 0.05)
                                  : null,
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