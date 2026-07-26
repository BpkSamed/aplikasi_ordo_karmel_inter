import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';

class HalamanCuriaGeneralis extends StatefulWidget {
  const HalamanCuriaGeneralis({super.key});

  @override
  State<HalamanCuriaGeneralis> createState() => _HalamanCuriaGeneralisState();
}

class _HalamanCuriaGeneralisState extends State<HalamanCuriaGeneralis> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;

  List<dynamic> _pejabatCuria = [];
  List<dynamic> _daftarKomisi = [];

  // Struktur Jabatan Resmi Sesuai Dokumen Induk (Dipertahankan untuk kueri DB)
  final List<String> _consiliumRoles = [
    'Prior Generalis',
    'Vice Prior Generalis',
    'Procurator Generalis',
    'Oeconomus Generalis',
    'Consiliarius pro Ambitu Americarum',
    'Consiliarius pro Ambitu Africae',
    'Consiliarius pro Ambitu Asiae, Australiae et Oceaniae',
    'Consiliarius pro Ambitu Europae',
  ];

  final List<String> _officiaRoles = [
    'Oeconomatus Generalis',
    'Secretariatus Generalis',
    'Delegatus Monacorum, Heremiti et Instituta',
    'Delegatus Formationis',
    'Delegatus Iuvenibus',
    'Delegatus TOC',
    'Delegatus Laicorum',
    'Postulatura Generalis',
    'Legale Rappresentante',
  ];

  @override
  void initState() {
    super.initState();
    _loadCuriaData();
  }

  Future<void> _loadCuriaData() async {
    setState(() => _isLoading = true);
    try {
      // 1. Ambil data pejabat Curia & Sub Immediata
      final curiaResponse = await _supabase
          .from('curia_officers')
          .select('*, members(*, conventus(name))');

      // 2. Kueri Spesifik Menggunakan Kolom ID untuk Menghindari Ambiguitas Relasi
      final commissionsResponse = await _supabase
          .from('commissions')
          .select('*, praeses:praeses_id(full_name), commission_members(*, member:member_id(full_name))');

      setState(() {
        _pejabatCuria = curiaResponse as List<dynamic>;
        _daftarKomisi = commissionsResponse as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Gagal mengambil data Curia: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Helper untuk mendapatkan terjemahan nama jabatan dari file lokalisasi (.arb)
  String _getLocalizedRole(String role, AppLocalizations t) {
    switch (role) {
      case 'Prior Generalis':
        return t.priorGeneralis;
      case 'Vice Prior Generalis':
        return t.vicePriorGeneralis;
      case 'Procurator Generalis':
        return t.procuratorGeneralis;
      case 'Oeconomus Generalis':
        return t.oeconomusGeneralis;
      case 'Consiliarius pro Ambitu Americarum':
        return t.consiliariusAmericarum;
      case 'Consiliarius pro Ambitu Africae':
        return t.consiliariusAfricae;
      case 'Consiliarius pro Ambitu Asiae, Australiae et Oceaniae':
        return t.consiliariusAsiae;
      case 'Consiliarius pro Ambitu Europae':
        return t.consiliariusEuropae;
      case 'Oeconomatus Generalis':
        return t.oeconomatusGeneralis;
      case 'Secretariatus Generalis':
        return t.secretariatusGeneralis;
      case 'Delegatus Monacorum, Heremiti et Instituta':
        return t.delegatusMonacorum;
      case 'Delegatus Formationis':
        return t.delegatusFormationis;
      case 'Delegatus Iuvenibus':
        return t.delegatusIuvenibus;
      case 'Delegatus TOC':
        return t.delegatusToc;
      case 'Delegatus Laicorum':
        return t.delegatusLaicorum;
      case 'Postulatura Generalis':
        return t.postulaturaGeneralis;
      case 'Legale Rappresentante':
        return t.legaleRappresentante;
      default:
        return role;
    }
  }

  Widget _buildRoleTile(String roleTitle, AppLocalizations t, double baseWidth) {
    final match = _pejabatCuria.where((p) => p['office_title'] == roleTitle).toList();
    final localizedRole = _getLocalizedRole(roleTitle, t);

    if (match.isNotEmpty && match.first['members'] != null) {
      final member = match.first['members'];
      final conventusName = member['conventus']?['name'] ?? t.unassignedMonastery;

      return Card(
        margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: baseWidth * 0.05,
            backgroundColor: Colors.brown,
            child: Icon(Icons.person, color: Colors.white, size: baseWidth * 0.05),
          ),
          title: Text(
            localizedRole,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038),
          ),
          subtitle: Text(
            member['full_name'] ?? '-',
            style: TextStyle(fontSize: baseWidth * 0.035, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(baseWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(t.communityOrigin, conventusName, baseWidth),
                  _buildDetailRow(t.birthPlace, member['city_of_birth'], baseWidth),
                  _buildDetailRow(t.birthCountry, member['country_of_birth'], baseWidth),
                  _buildDetailRow(t.birthDate, member['date_of_birth'], baseWidth),
                  const Divider(),
                  _buildDetailRow(t.firstProfession, member['first_profession_date'], baseWidth),
                  _buildDetailRow(t.solemnProfession, member['solemn_profession_date'], baseWidth),
                  if (member['ordination_date'] != null)
                    _buildDetailRow(t.ordinationDate, member['ordination_date'], baseWidth),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
      color: Colors.grey.shade100,
      child: ListTile(
        leading: CircleAvatar(
          radius: baseWidth * 0.05,
          backgroundColor: Colors.grey.shade400,
          child: Icon(Icons.person_outline, color: Colors.white, size: baseWidth * 0.05),
        ),
        title: Text(
          localizedRole,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: baseWidth * 0.038),
        ),
        subtitle: Text(
          t.unassignedOfficial,
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: baseWidth * 0.032),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, double baseWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: baseWidth * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: baseWidth * 0.035)),
          Expanded(child: Text(value?.toString() ?? '-', style: TextStyle(fontSize: baseWidth * 0.035))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.curiaGeneralisTitle),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCuriaData),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: t.consiliumGenerale),
              Tab(text: t.officiaGeneralia),
              Tab(text: t.commissionesGenerales),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double baseWidth = constraints.maxWidth;

            if (_isLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.brown));
            }

            return TabBarView(
              children: [
                // TAB 1: CONSILIUM GENERALE
                ListView.builder(
                  padding: EdgeInsets.all(baseWidth * 0.03),
                  itemCount: _consiliumRoles.length,
                  itemBuilder: (context, index) => _buildRoleTile(_consiliumRoles[index], t, baseWidth),
                ),

                // TAB 2: OFFICIA GENERALIA
                ListView.builder(
                  padding: EdgeInsets.all(baseWidth * 0.03),
                  itemCount: _officiaRoles.length,
                  itemBuilder: (context, index) => _buildRoleTile(_officiaRoles[index], t, baseWidth),
                ),

                // TAB 3: COMMISSIONES GENERALES
                _daftarKomisi.isEmpty
                    ? Center(child: Text(t.noCommissionData, style: TextStyle(fontSize: baseWidth * 0.04)))
                    : ListView.builder(
                        padding: EdgeInsets.all(baseWidth * 0.03),
                        itemCount: _daftarKomisi.length,
                        itemBuilder: (context, index) {
                          final komisi = _daftarKomisi[index];
                          final praeses = komisi['praeses'];
                          final membersList = komisi['commission_members'] as List<dynamic>? ?? [];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02),
                            elevation: 3,
                            child: ExpansionTile(
                              leading: Icon(Icons.assignment, color: Colors.brown, size: baseWidth * 0.06),
                              title: Text(
                                komisi['name'] ?? '-',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038),
                              ),
                              subtitle: Text(
                                "${t.praeses}: ${praeses != null ? praeses['full_name'] : t.unassignedPresident}",
                                style: TextStyle(fontSize: baseWidth * 0.032),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(baseWidth * 0.04),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.missionTask,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035),
                                      ),
                                      SizedBox(height: baseWidth * 0.01),
                                      Text(
                                        komisi['mission'] ?? t.noMissionDesc,
                                        style: TextStyle(height: 1.4, fontSize: baseWidth * 0.035),
                                      ),
                                      Divider(height: baseWidth * 0.06),
                                      Text(
                                        t.commissionMembersLabel,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700, fontSize: baseWidth * 0.035),
                                      ),
                                      SizedBox(height: baseWidth * 0.015),
                                      if (membersList.isEmpty)
                                        Text(
                                          t.noCommissionMembers,
                                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: baseWidth * 0.035),
                                        )
                                      else
                                        Column(
                                          children: membersList.map((cm) {
                                            final namaAnggota = cm['member']?['full_name'] ?? t.unknown;
                                            final jabatanDiKomisi = cm['position'] ?? t.memberRole;
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(Icons.fiber_manual_record, size: baseWidth * 0.03, color: Colors.brown),
                                              title: Text(namaAnggota, style: TextStyle(fontWeight: FontWeight.w600, fontSize: baseWidth * 0.035)),
                                              subtitle: Text("${t.positionLabel}: $jabatanDiKomisi", style: TextStyle(fontSize: baseWidth * 0.032)),
                                            );
                                          }).toList(),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}