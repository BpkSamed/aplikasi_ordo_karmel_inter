import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';

/// =================================================================
/// HALAMAN SUB IMMEDIATA JURISDICTIONE PRIORIS GENERALIS
/// =================================================================
class HalamanSubImmediata extends StatefulWidget {
  const HalamanSubImmediata({super.key});

  @override
  State<HalamanSubImmediata> createState() => _HalamanSubImmediataState();
}

class _HalamanSubImmediataState extends State<HalamanSubImmediata> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;

  // Data Pejabat & Entitas Sub Immediata
  List<dynamic> _pejabatSubImmediata = [];
  List<dynamic> _entitasSubImmediata = [];

  // Daftar Entitas Resmi Sub Immediata sesuai dokumen flow
  final List<String> _kategoriSubImmediata = [
    'Curia Generalitia',
    'Institutum Carmelitanum',
    'Centrum Internationale S. Alberti',
    'Carmelite NGO',
    'Edizioni Carmelitane',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 1. Ambil data pejabat curia_officers khusus Sub Immediata beserta foto
      final officersRes = await _supabase
          .from('curia_officers')
          .select('''
            *,
            members:member_id (
              id,
              full_name,
              photo_url,
              city_of_birth,
              country_of_birth,
              date_of_birth,
              first_profession_date,
              solemn_profession_date,
              ordination_date,
              conventus (name)
            )
          ''')
          .eq('office_category', 'Sub Immediata Jurisdictione Prioris Generalis');

      // 2. Ambil entitas Sub Immediata beserta daftar anggota & foto mereka
      final entitiesRes = await _supabase
          .from('entities')
          .select('''
            *,
            addresses (*),
            members (
              id,
              full_name,
              role,
              photo_url,
              city_of_birth,
              country_of_birth,
              date_of_birth,
              first_profession_date,
              solemn_profession_date,
              ordination_date
            )
          ''')
          .or('entity_category.eq.Sub Immediata Jurisdictione Prioris Generalis,entity_category.eq.Sub Immediata');

      setState(() {
        _pejabatSubImmediata = officersRes as List<dynamic>;
        _entitasSubImmediata = entitiesRes as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Gagal mengambil data Sub Immediata: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.subImmediataTitle ?? "Sub Immediata Jurisdictione"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _kategoriSubImmediata.length,
            itemBuilder: (context, index) {
              final namaKategori = _kategoriSubImmediata[index];

              // Cari entitas yang cocok di database
              final entitasMatches = _entitasSubImmediata.where(
                (e) => (e['name'] ?? '').toString().toLowerCase().contains(namaKategori.toLowerCase())
              );
              final entitasMatch = entitasMatches.isNotEmpty ? entitasMatches.first : null;

              // Cari pimpinan/pejabat yang cocok di database
              final pejabatMatch = _pejabatSubImmediata.where(
                (p) => (p['office_title'] ?? '').toString().toLowerCase().contains(namaKategori.toLowerCase()),
              ).toList();

              // Mengambil foto pimpinan utama (jika ada)
              String? fotoPimpinan;
              if (pejabatMatch.isNotEmpty && pejabatMatch.first['members'] != null) {
                fotoPimpinan = pejabatMatch.first['members']['photo_url'];
              } else if (entitasMatch != null && entitasMatch['members'] != null && (entitasMatch['members'] as List).isNotEmpty) {
                fotoPimpinan = entitasMatch['members'][0]['photo_url'];
              }

              final membersList = entitasMatch != null && entitasMatch['members'] != null
                  ? (entitasMatch['members'] as List<dynamic>)
                  : [];

              return Card(
                margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02),
                elevation: 3,
                child: ExpansionTile(
                  // MENAMPILKAN FOTO PEMIMPIN / IKON ENTITAS
                  leading: CircleAvatar(
                    radius: baseWidth * 0.06,
                    backgroundColor: Colors.brown,
                    backgroundImage: (fotoPimpinan != null && fotoPimpinan.trim().isNotEmpty)
                        ? NetworkImage(fotoPimpinan)
                        : null,
                    child: (fotoPimpinan == null || fotoPimpinan.trim().isEmpty)
                        ? Icon(Icons.account_balance, color: Colors.white, size: baseWidth * 0.06)
                        : null,
                  ),
                  title: Text(
                    namaKategori,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      fontSize: baseWidth * 0.04,
                    ),
                  ),
                  subtitle: Text(
                    entitasMatch != null
                        ? "${entitasMatch['name']} (${membersList.length} ${t.membersLabel ?? 'Anggota'})"
                        : (pejabatMatch.isNotEmpty && pejabatMatch.first['members'] != null
                            ? pejabatMatch.first['members']['full_name']
                            : (t.noDataAvailable ?? 'Belum ada data')),
                    style: TextStyle(fontSize: baseWidth * 0.033, color: Colors.black54),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(baseWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. TAMPILKAN DATA PEJABAT PUSAT DI BAWAH JABATAN INI (JIKA ADA)
                          if (pejabatMatch.isNotEmpty) ...[
                            Text(
                              t.officersLabel ?? "Pejabat / Pimpinan:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade700,
                                fontSize: baseWidth * 0.036,
                              ),
                            ),
                            SizedBox(height: baseWidth * 0.015),
                            ...pejabatMatch.map((p) {
                              final member = p['members'];
                              final String? fotoPejabat = member?['photo_url'];
                              final namaPejabat = member?['full_name'] ?? (t.unassignedOfficial ?? 'Belum diisi');
                              final jabatanTitle = p['office_title'] ?? '-';

                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: baseWidth * 0.01),
                                leading: CircleAvatar(
                                  radius: baseWidth * 0.045,
                                  backgroundColor: Colors.brown.shade300,
                                  backgroundImage: (fotoPejabat != null && fotoPejabat.trim().isNotEmpty)
                                      ? NetworkImage(fotoPejabat)
                                      : null,
                                  child: (fotoPejabat == null || fotoPejabat.trim().isEmpty)
                                      ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.045)
                                      : null,
                                ),
                                title: Text(namaPejabat, style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.036)),
                                subtitle: Text(jabatanTitle, style: TextStyle(fontSize: baseWidth * 0.032, color: Colors.brown)),
                              );
                            }),
                            const Divider(),
                          ],

                          // 2. TAMPILKAN DAFTAR ANGGOTA (SODALES) BESERTA FOTO MEREKA
                          Text(
                            t.commissionMembersLabel ?? "Daftar Anggota (Sodales):",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade700,
                              fontSize: baseWidth * 0.036,
                            ),
                          ),
                          SizedBox(height: baseWidth * 0.015),

                          if (membersList.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: baseWidth * 0.02),
                              child: Text(
                                t.noCommissionMembers ?? "Belum ada anggota terdaftar.",
                                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: baseWidth * 0.035),
                              ),
                            )
                          else
                            Column(
                              children: membersList.map((m) {
                                final String? fotoAnggota = m['photo_url'];
                                final namaAnggota = m['full_name'] ?? (t.unknown ?? 'Tanpa Nama');
                                final peran = m['role'] ?? 'Sodales';

                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: baseWidth * 0.01),
                                  // FOTO TIAP ANGGOTA
                                  leading: CircleAvatar(
                                    radius: baseWidth * 0.045,
                                    backgroundColor: Colors.brown.shade200,
                                    backgroundImage: (fotoAnggota != null && fotoAnggota.trim().isNotEmpty)
                                        ? NetworkImage(fotoAnggota)
                                        : null,
                                    child: (fotoAnggota == null || fotoAnggota.trim().isEmpty)
                                        ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.045)
                                        : null,
                                  ),
                                  title: Text(
                                    namaAnggota,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: baseWidth * 0.035),
                                  ),
                                  subtitle: Text(
                                    "${t.positionPrefix ?? 'Peran'}: $peran",
                                    style: TextStyle(fontSize: baseWidth * 0.032),
                                  ),
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
          );
        },
      ),
    );
  }
}