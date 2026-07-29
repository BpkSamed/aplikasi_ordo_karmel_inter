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
/// HALAMAN UTAMA: MENU DATA MINISTRIES (KARYA KERASULAN)
/// =================================================================
class HalamanMinistries extends StatefulWidget {
  const HalamanMinistries({super.key});

  @override
  State<HalamanMinistries> createState() => _HalamanMinistriesState();
}

class _HalamanMinistriesState extends State<HalamanMinistries> {
  bool _isSchoolsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.ministriesDirectoryTitle ?? "Direktori Ministries"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              Text(
                t.apostolicMinistryCategories ?? "Kategori Karya Kerasulan",
                style: TextStyle(
                  fontSize: baseWidth * 0.045, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.brown
                ),
              ),
              SizedBox(height: baseWidth * 0.04),
              
              _buildMenuCard(context, t.parishes ?? "Parishes", Icons.church, 'Parishes', baseWidth),
              
              // Menu Schools (Scholae) - Disamakan ukuran & panah mengarah ke kanan saat tertutup
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(vertical: baseWidth * 0.015, horizontal: baseWidth * 0.04),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown, 
                    child: Icon(Icons.school, color: Colors.white, size: baseWidth * 0.055)
                  ),
                  title: Text(
                    t.schools ?? "Schools", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038)
                  ),
                  trailing: Icon(
                    _isSchoolsExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
                    size: baseWidth * 0.04,
                    color: Colors.brown,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isSchoolsExpanded = expanded;
                    });
                  },
                  children: [
                    _buildSubMenuCard(context, t.elementarySchool ?? "Elementary School", 'Elementary School', baseWidth),
                    _buildSubMenuCard(context, t.secondarySchool ?? "Secondary School", 'Secondary School', baseWidth),
                    _buildSubMenuCard(context, t.academy ?? "Academy", 'Academy', baseWidth),
                    _buildSubMenuCard(context, t.universityInstitute ?? "University / Institute", 'University / Institute', baseWidth),
                  ],
                ),
              ),

              _buildMenuCard(context, t.retreatCenters ?? "Retreat Centers", Icons.holiday_village, 'Retreat Centers', baseWidth),
              _buildMenuCard(context, t.spiritualityInstitute ?? "Spirituality Institute", Icons.self_improvement, 'Spirituality Institute', baseWidth),
              _buildMenuCard(context, t.socialMinistries ?? "Social Ministries", Icons.volunteer_activism, 'Social Ministries', baseWidth),
              _buildMenuCard(context, t.libraries ?? "Libraries", Icons.local_library, 'Libraries', baseWidth),
              _buildMenuCard(context, t.hospitalsClinics ?? "Hospitals / Clinics", Icons.local_hospital, 'Hospitals / Clinics', baseWidth),

              SizedBox(height: baseWidth * 0.05),
              const Divider(),
              SizedBox(height: baseWidth * 0.03),
              
              // Menu tambahan untuk melihat daftar keseluruhan personalia (anggota)
              Card(
                elevation: 3,
                color: Colors.brown.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: baseWidth * 0.02, horizontal: baseWidth * 0.04),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown, 
                    child: Icon(Icons.group_work, color: Colors.white, size: baseWidth * 0.055)
                  ),
                  title: Text(
                    t.allMinistriesPersonnel ?? "Seluruh Personalia Ministries", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038)
                  ),
                  subtitle: Text(
                    t.allPersonnelSubtitle ?? "Daftar anggota yang berkarya di semua lembaga",
                    style: TextStyle(fontSize: baseWidth * 0.032)
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanMinistriesMembers()));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String filterKategori, double baseWidth) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: baseWidth * 0.015, horizontal: baseWidth * 0.04),
        leading: CircleAvatar(
          backgroundColor: Colors.brown, 
          child: Icon(icon, color: Colors.white, size: baseWidth * 0.055)
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04, color: Colors.brown),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanMinistriesEntities(kategori: filterKategori, kategoriTampil: title)));
        },
      ),
    );
  }

  Widget _buildSubMenuCard(BuildContext context, String title, String filterKategori, double baseWidth) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: baseWidth * 0.15, right: baseWidth * 0.04),
      title: Text(title, style: TextStyle(fontSize: baseWidth * 0.038)),
      trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.035, color: Colors.grey),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanMinistriesEntities(kategori: filterKategori, kategoriTampil: title)));
      },
    );
  }
}

/// =================================================================
/// SUB-HALAMAN 1: DATA MINISTRIES – LEMBAGA / KARYA (ENTITIES)
/// =================================================================
class HalamanMinistriesEntities extends StatefulWidget {
  final String kategori;
  final String kategoriTampil;

  const HalamanMinistriesEntities({super.key, required this.kategori, required this.kategoriTampil});

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
        .eq('ministry_type', widget.kategori) 
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
      appBar: AppBar(title: Text(t.ministriesListTitle(widget.kategoriTampil))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(
                t.searchMinistryCategory(widget.kategoriTampil), 
                (val) => setState(() => _query = val.toLowerCase()), 
                baseWidth
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchEntities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noDataForCategory(widget.kategoriTampil), baseWidth);

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
                          margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
                          child: ExpansionTile(
                            leading: Icon(Icons.domain, color: Colors.brown, size: baseWidth * 0.06),
                            title: Text(entity['name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text(address?['city'] ?? (t.locationNotSet ?? 'Lokasi belum diatur'), style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.descriptionHistoria ?? "Deskripsi / Historia:", 
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)
                                    ),
                                    SizedBox(height: baseWidth * 0.01),
                                    Text(entity['historia'] ?? (t.noDescriptionData ?? 'Belum ada data deskripsi.'), style: TextStyle(fontSize: baseWidth * 0.035)),
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

                                    Text(
                                      t.officialMinistryAddress ?? "Alamat Resmi Pelayanan:", 
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)
                                    ),
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.personnelWorkingMembers ?? "Personalia (Anggota Berkarya)")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              _buildSearchBar(t.searchPersonnelName ?? "Cari Nama Personalia...", (val) => setState(() => _query = val.toLowerCase()), baseWidth),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
                    if (snapshot.hasError) return _buildError(snapshot.error, t, baseWidth);
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty(t.noMinistriesPersonnelData ?? "Tidak ada data Personalia Ministries.", baseWidth);

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
                                  ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.05)
                                  : null,
                            ),
                            title: Text(member['full_name'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                            subtitle: Text("${t.ministryWork ?? 'Karya:'} ${member['entities']?['name'] ?? (t.notDetermined ?? 'Belum ditentukan')}", style: TextStyle(fontSize: baseWidth * 0.032)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(baseWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(t.positionRole ?? "Tugas / Peran", member['role'], baseWidth),
                                    _buildDetailRow(t.communityOrigin ?? "Asal Komunitas", member['conventus']?['name'] ?? '-', baseWidth),
                                    _buildDetailRow(t.birthPlace ?? "Kota Kelahiran", member['city_of_birth'], baseWidth),
                                    _buildDetailRow(t.birthCountry ?? "Negara Kelahiran", member['country_of_birth'], baseWidth),
                                    _buildDetailRow(t.birthDate ?? "Tanggal Lahir", member['date_of_birth'], baseWidth),
                                    const Divider(),
                                    _buildDetailRow(t.solemnProfession ?? "Kaul Kekal", member['solemn_profession_date'], baseWidth),
                                    if (member['ordination_date'] != null)
                                      _buildDetailRow(t.ordinationDate ?? "Tahbisan Imam", member['ordination_date'], baseWidth),
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