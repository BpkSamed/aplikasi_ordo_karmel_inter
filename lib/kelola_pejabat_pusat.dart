import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

class HalamanKelolaPejabatPusat extends StatefulWidget {
  const HalamanKelolaPejabatPusat({super.key});

  @override
  State<HalamanKelolaPejabatPusat> createState() => _HalamanKelolaPejabatPusatState();
}

class _HalamanKelolaPejabatPusatState extends State<HalamanKelolaPejabatPusat> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  
  // Data dari database: menyimpan siapa menjabat apa
  List<dynamic> _pejabatAktif = [];

  // Struktur Statis Jabatan berdasarkan Dokumen Induk
  final Map<String, List<String>> _strukturJabatan = {
    'Consilium Generale': [
      'Prior Generalis', 'Vice Prior Generalis', 'Procurator Generalis', 
      'Oeconomus Generalis', 'Consiliarius pro Ambitu Americarum', 
      'Consiliarius pro Ambitu Africae', 'Consiliarius pro Ambitu Asiae, Australiae et Oceaniae', 
      'Consiliarius pro Ambitu Europae'
    ],
    'Officia Generalia et Sectores Laborum': [
      'Oeconomatus Generalis', 'Secretariatus Generalis', 
      'Delegatus Monacorum, Heremiti et Instituta', 'Delegatus Formationis', 
      'Delegatus Iuvenibus', 'Delegatus TOC', 'Delegatus Laicorum', 
      'Postulatura Generalis', 'Legale Rappresentante'
    ],
    'Sub Immediata Jurisdictione Prioris Generalis': [
      'Delegatio Generalis pro Monialibus', 'Institutum Carmelitanum (Praeses)', 
      'Centrum S. Alberti (CISA) (Priore)', 'Domus S. Alberti (Priore)'
    ]
  };

  @override
  void initState() {
    super.initState();
    _fetchPejabat();
  }

  Future<void> _fetchPejabat() async {
    setState(() => _isLoading = true);
    try {
      // TAMBAHAN: Menambahkan photo_url pada query select
      final response = await _supabase
          .from('curia_officers')
          .select('*, members:members!member_id(full_name, photo_url, conventus(name))');
      if (mounted) {
        setState(() {
          _pejabatAktif = response as List<dynamic>;
        });
      }
    } catch (e) {
      debugPrint("Error fetching curia: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Memeriksa apakah suatu jabatan saat ini sedang terisi atau tidak
  bool _isJabatanTerisi(String officeTitle) {
    final pejabat = _pejabatAktif.where((p) => p['office_title'] == officeTitle).toList();
    return pejabat.isNotEmpty && pejabat.first['member_id'] != null;
  }

  // Fungsi menunjuk/mengubah pejabat
  Future<void> _tunjukPejabat(String category, String title, AppLocalizations t) async {
    final int? selectedMemberId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HalamanPilihAnggota()),
    );

    if (selectedMemberId != null) {
      setState(() => _isLoading = true);
      try {
        final cekJabatan = await _supabase
            .from('curia_officers')
            .select()
            .eq('office_title', title)
            .maybeSingle();

        if (cekJabatan != null) {
          await _supabase
              .from('curia_officers')
              .update({'member_id': selectedMemberId})
              .eq('office_title', title);
        } else {
          await _supabase
              .from('curia_officers')
              .insert({
                'office_category': category,
                'office_title': title,
                'member_id': selectedMemberId
              });
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.jabatanUpdateSuccess(title))));
        }
        _fetchPejabat();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.failedToUpdate(e.toString()))));
        }
        setState(() => _isLoading = false);
      }
    }
  }

  // ==========================================
  // FUNGSI MENGOSONGKAN JABATAN (SET NULL)
  // ==========================================
  Future<void> _kosongkanJabatan(String title, AppLocalizations t) async {
    setState(() => _isLoading = true);
    try {
      // Mengubah member_id menjadi null pada jabatan yang dipilih
      await _supabase
          .from('curia_officers')
          .update({'member_id': null})
          .eq('office_title', title);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.jabatanEmptySuccess(title))));
      }
      _fetchPejabat();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.failedToEmpty(e.toString()))));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.manageCuriaTitle ?? "Kelola Curia & Sub Immediata")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _strukturJabatan.keys.length,
            itemBuilder: (context, index) {
              final category = _strukturJabatan.keys.elementAt(index);
              final titles = _strukturJabatan[category]!;

              return Card(
                margin: EdgeInsets.only(bottom: baseWidth * 0.04),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    category, 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.04)
                  ),
                  children: titles.map((title) {
                    
                    // MENGAMBIL DATA ANGGOTA DAN FOTO UNTUK JABATAN INI
                    final pejabatList = _pejabatAktif.where((p) => p['office_title'] == title).toList();
                    final memberData = (pejabatList.isNotEmpty && pejabatList.first['member_id'] != null) 
                        ? pejabatList.first['members'] 
                        : null;
                    
                    final isKosong = memberData == null;
                    final String? photoUrl = memberData?['photo_url'];
                    
                    // Memformat nama yang akan ditampilkan
                    String namaTampil = t.notDetermined ?? "Belum ditentukan";
                    if (memberData != null) {
                      final nama = memberData['full_name'] ?? '';
                      final biara = memberData['conventus']?['name'] ?? '';
                      namaTampil = biara.isNotEmpty ? "$nama\n(${t.originPrefix ?? 'Asal'}: $biara)" : nama;
                    }
                    
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.015),
                      // TAMBAHAN: FOTO PROFIL UNTUK LISTTILE UTAMA
                      leading: CircleAvatar(
                        radius: baseWidth * 0.06,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: photoUrl != null && photoUrl.toString().isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl == null || photoUrl.toString().isEmpty
                            ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.06)
                            : null,
                      ),
                      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: baseWidth * 0.038)),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: baseWidth * 0.01),
                        child: Text(
                          namaTampil, 
                          style: TextStyle(
                            fontSize: baseWidth * 0.035,
                            color: isKosong ? Colors.red : Colors.green.shade800, 
                            fontWeight: isKosong ? FontWeight.normal : FontWeight.bold
                          )
                        ),
                      ),
                      // Menampilkan dua opsi tombol berdampingan (Pilih/Ganti & Kosongkan)
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown.shade50, 
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: baseWidth * 0.02)
                            ),
                            onPressed: () => _tunjukPejabat(category, title, t),
                            child: Text(
                              t.selectOrChangeBtn ?? "Pilih / Ganti", 
                              style: TextStyle(color: Colors.brown, fontSize: baseWidth * 0.032)
                            ),
                          ),
                          if (!isKosong) ...[
                            SizedBox(width: baseWidth * 0.02),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(baseWidth * 0.09, baseWidth * 0.09),
                              ),
                              onPressed: () => _kosongkanJabatan(title, t),
                              child: Icon(Icons.clear, size: baseWidth * 0.045),
                            ),
                          ]
                        ],
                      ),
                    );
                  }).toList(),
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
/// WIDGET BANTUAN: HALAMAN PENCARIAN ANGGOTA
/// =================================================================
class HalamanPilihAnggota extends StatefulWidget {
  const HalamanPilihAnggota({super.key});

  @override
  State<HalamanPilihAnggota> createState() => _HalamanPilihAnggotaState();
}

class _HalamanPilihAnggotaState extends State<HalamanPilihAnggota> {
  String _query = "";
  List<dynamic> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      // TAMBAHAN: Menambahkan photo_url pada query select anggota
      final response = await Supabase.instance.client
          .from('members')
          .select('id, full_name, photo_url, conventus(name)')
          .order('full_name');
      if (mounted) {
        setState(() => _members = response as List<dynamic>);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final filtered = _members.where((m) => (m['full_name'] ?? '').toString().toLowerCase().contains(_query)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(t.searchAndSelectMemberTitle ?? "Cari & Pilih Anggota")),
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
                    labelText: t.typeMemberNameHint ?? "Ketik Nama Anggota...", 
                    prefixIcon: Icon(Icons.search, size: baseWidth * 0.06), 
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(fontSize: baseWidth * 0.038)
                  ),
                ),
              ),
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                  : filtered.isEmpty
                      ? Center(child: Text(t.dataNotFound ?? "Data tidak ditemukan", style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.038)))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final member = filtered[index];
                            final String? photoUrl = member['photo_url']; // Variabel untuk foto
                            
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.01),
                              // TAMBAHAN: FOTO PROFIL UNTUK POP-UP PENCARIAN
                              leading: CircleAvatar(
                                backgroundColor: Colors.brown.shade300,
                                radius: baseWidth * 0.05,
                                backgroundImage: photoUrl != null && photoUrl.toString().isNotEmpty
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl == null || photoUrl.toString().isEmpty
                                    ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.05)
                                    : null,
                              ),
                              title: Text(member['full_name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)),
                              subtitle: Text("${t.originPrefix ?? 'Asal'}: ${member['conventus']?['name'] ?? '-'}", style: TextStyle(fontSize: baseWidth * 0.032)),
                              trailing: Icon(Icons.check_circle_outline, color: Colors.green, size: baseWidth * 0.06),
                              onTap: () {
                                Navigator.pop(context, member['id']);
                              },
                            );
                          },
                        ),
              )
            ],
          );
        }
      ),
    );
  }
}