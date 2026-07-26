import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';

/// =================================================================
/// 1. HALAMAN UTAMA FRATRES (PILIHAN PAYUNG KATEGORI)
/// =================================================================
class HalamanFratres extends StatelessWidget {
  const HalamanFratres({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.fratresDirectoryTitle ?? "Direktori Fratres")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              Text(
                t.selectFratresCategory ?? "Pilih Kategori Fratres",
                style: TextStyle(
                  fontSize: baseWidth * 0.045, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.brown
                ),
              ),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(context, t.provincia ?? "PROVINCIA", Icons.gite, 'Provincia', baseWidth),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(context, t.commissariatusGeneralis ?? "COMMISSARIATUS GENERALIS", Icons.apartment, 'Commissariatus Generalis', baseWidth),
              SizedBox(height: baseWidth * 0.04),
              _buildMenuCard(context, t.delegatioGeneralis ?? "DELEGATIO GENERALIS", Icons.account_balance, 'Delegatio Generalis', baseWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String dbCategory, double baseWidth) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: baseWidth * 0.03, horizontal: baseWidth * 0.04),
        leading: CircleAvatar(
          backgroundColor: Colors.brown, 
          child: Icon(icon, color: Colors.white, size: baseWidth * 0.055)
        ),
        title: Text(
          title, 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038)
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanDaftarEntitasFratres(categoryName: title, dbCategory: dbCategory),
            ),
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.listCategoryTitle(widget.categoryName))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(baseWidth * 0.03),
                child: TextField(
                  onChanged: (val) => setState(() => _query = val.toLowerCase()),
                  decoration: InputDecoration(
                    labelText: t.searchCategoryName(widget.categoryName),
                    labelStyle: TextStyle(fontSize: baseWidth * 0.035),
                    prefixIcon: Icon(Icons.search, color: Colors.brown, size: baseWidth * 0.055),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchEntities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.brown));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(fontSize: baseWidth * 0.038)));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text(t.noCategoryData(widget.categoryName), style: TextStyle(fontSize: baseWidth * 0.038)));
                    }

                    final filtered = snapshot.data!.where((item) {
                      return (item['name'] ?? '').toString().toLowerCase().contains(_query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: baseWidth * 0.03),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final entity = filtered[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.location_city, color: Colors.brown, size: baseWidth * 0.06),
                            title: Text(
                              entity['name'] ?? '-', 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
                            ),
                            subtitle: Text(
                              entity['addresses']?['city'] ?? (t.locationNotSet ?? 'Lokasi tidak diset'),
                              style: TextStyle(fontSize: baseWidth * 0.032)
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.04),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HalamanDetailEntitasFratres(entity: entity, categoryName: widget.categoryName),
                                ),
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
          );
        },
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(entity['name'] ?? (t.detail ?? 'Detail'))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return ListView(
            padding: EdgeInsets.all(baseWidth * 0.05),
            children: [
              Text(
                entity['name'] ?? '-', 
                style: TextStyle(fontSize: baseWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.brown)
              ),
              SizedBox(height: baseWidth * 0.05),
              
              _buildSubMenuTile(context, t.historia ?? "Historia", Icons.history, () {
                _bukaHalamanInfo(context, t.historia ?? "Historia", entity['historia'] ?? (t.noHistory ?? "Belum ada riwayat sejarah."));
              }, baseWidth),
              
              _buildSubMenuTile(context, t.website ?? "Website", Icons.language, () {
                _bukaHalamanInfo(context, t.officialWebsite ?? "Website Resmi", "${t.webLink ?? 'Tautan Web'}: ${entity['website_url'] ?? (t.noWebsite ?? 'Tidak ada website')}");
              }, baseWidth),
              
              _buildSubMenuTile(context, t.consiliumCouncil ?? "Consilium", Icons.assignment_ind, () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => HalamanSubMenuAnggotaFratres(
                      entityId: entity['id'], 
                      tipeView: 'consilium', 
                      title: t.leadershipConsilium ?? "Consilium Pimpinan"
                    )
                  )
                );
              }, baseWidth),
              
              _buildSubMenuTile(context, t.domusAddress ?? "Domus", Icons.mail_outline, () {
                final addr = entity['addresses'];
                String fullAddr = t.addressNotAvailable ?? "Alamat tidak tersedia.";
                if (addr != null) {
                  fullAddr = "${t.monasteryBuilding ?? 'Biara/Gedung'}: ${addr['house_name'] ?? '-'}\n${t.street ?? 'Jalan'}: ${addr['street'] ?? '-'}\n${t.city ?? 'Kota'}: ${addr['city'] ?? '-'}\n${t.country ?? 'Negara'}: ${addr['country'] ?? '-'}\n${t.postalCode ?? 'Kode Pos'}: ${addr['postal_code'] ?? '-'}\n${t.telephone ?? 'Telp'}: ${addr['telephone'] ?? '-'}\n${t.faxcimile ?? 'Fax'}: ${addr['faxcimile'] ?? '-'}\n${t.email ?? 'Email'}: ${addr['email'] ?? '-'}";
                }
                _bukaHalamanInfo(context, t.officialDomus ?? "Domus Resmi", fullAddr);
              }, baseWidth),
              
              _buildSubMenuTile(context, t.conventusList ?? "Conventus", Icons.maps_home_work, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanSubMenuConventusFratres(entityId: entity['id'])));
              }, baseWidth),
              
              _buildSubMenuTile(context, t.sodalesList ?? "Sodales", Icons.people_outline, () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => HalamanSubMenuAnggotaFratres(
                      entityId: entity['id'], 
                      tipeView: 'sodales', 
                      title: t.memberListSodales ?? "Daftar Anggota (Sodales)"
                    )
                  )
                );
              }, baseWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubMenuTile(BuildContext context, String title, IconData icon, VoidCallback onTap, double baseWidth) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown, size: baseWidth * 0.055),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
        trailing: Icon(Icons.arrow_forward_ios, size: baseWidth * 0.035),
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                child: SingleChildScrollView(
                  child: Text(
                    content, 
                    style: TextStyle(fontSize: constraints.maxWidth * 0.038, height: 1.5)
                  ),
                ),
              );
            },
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
  final String tipeView; 
  final String title;

  const HalamanSubMenuAnggotaFratres({super.key, required this.entityId, required this.tipeView, required this.title});

  @override
  State<HalamanSubMenuAnggotaFratres> createState() => _HalamanSubMenuAnggotaFratresState();
}

class _HalamanSubMenuAnggotaFratresState extends State<HalamanSubMenuAnggotaFratres> {
  Future<List<dynamic>> _fetchMembers() async {
    if (widget.tipeView == 'consilium') {
      final response = await Supabase.instance.client
          .from('members')
          .select()
          .eq('entity_id', widget.entityId)
          .neq('role', 'Sodales'); 
          
      return response as List<dynamic>;
    } else {
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return FutureBuilder<List<dynamic>>(
            future: _fetchMembers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.brown));
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(fontSize: baseWidth * 0.038)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(t.noMemberData ?? "Tidak ada data anggota.", style: TextStyle(fontSize: baseWidth * 0.038)));
              }

              return ListView.builder(
                padding: EdgeInsets.all(baseWidth * 0.03),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final member = snapshot.data![index];
                  return Card(
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown, 
                        radius: baseWidth * 0.05,
                        child: Icon(Icons.person, color: Colors.white, size: baseWidth * 0.05)
                      ),
                      title: Text(
                        member['full_name'] ?? '-', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
                      ),
                      subtitle: Text(
                        "${t.positionRole ?? 'Jabatan/Peran'}: ${member['role'] ?? '-'}",
                        style: TextStyle(fontSize: baseWidth * 0.032)
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(baseWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(t.birthPlace, "${member['city_of_birth'] ?? '-'}, ${member['country_of_birth'] ?? '-'}", baseWidth),
                              _buildDetailRow(t.birthDate, member['date_of_birth'], baseWidth),
                              _buildDetailRow(t.firstProfession, member['first_profession_date'], baseWidth),
                              _buildDetailRow(t.solemnProfession, member['solemn_profession_date'], baseWidth),
                              if (member['ordination_date'] != null)
                                _buildDetailRow(t.ordinationDate, member['ordination_date'], baseWidth),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, double baseWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: baseWidth * 0.008),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: baseWidth * 0.035)),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: TextStyle(fontSize: baseWidth * 0.035)
            ),
          ),
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.conventusMonasteriesTitle ?? "Daftar Rumah Biara (Conventus)")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return FutureBuilder<List<dynamic>>(
            future: _fetchConventus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.brown));
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(fontSize: baseWidth * 0.038)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(t.noRegisteredMonastery ?? "Belum ada data biara terdaftar.", style: TextStyle(fontSize: baseWidth * 0.038)));
              }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final conv = snapshot.data![index];
              final addr = conv['addresses'];
              return Card(
                child: ExpansionTile(
                  leading: Icon(Icons.maps_home_work, color: Colors.brown, size: baseWidth * 0.055),
                  title: Text(
                    conv['name'] ?? '-', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
                  ),
                  subtitle: Text(
                    "${t.city ?? 'Kota'}: ${addr?['city'] ?? '-'}",
                    style: TextStyle(fontSize: baseWidth * 0.032)
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(baseWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.completeMonasteryAddress ?? "Alamat Lengkap Biara:", 
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035)
                          ),
                          SizedBox(height: baseWidth * 0.01),
                          if (addr != null) ...[
                            Text("${t.street ?? 'Jalan'}: ${addr['street'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                            Text("${t.country ?? 'Negara'}: ${addr['country'] ?? '-'} (${addr['postal_code'] ?? '-'})", style: TextStyle(fontSize: baseWidth * 0.035)),
                            Text("${t.telephone ?? 'Telp'}: ${addr['telephone'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                            Text("${t.faxcimile ?? 'Fax'}: ${addr['faxcimile'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                            Text("${t.email ?? 'Email'}: ${addr['email'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.035)),
                          ] else
                            Text(t.addressNotFilled ?? "Detail alamat belum diisi.", style: TextStyle(fontSize: baseWidth * 0.035)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    },
      ),
    );
  }
}