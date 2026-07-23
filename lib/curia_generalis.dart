import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Struktur Jabatan Resmi Sesuai Dokumen Induk
  final List<String> _consiliumRoles = [
    'Prior Generalis', 'Vice Prior Generalis', 'Procurator Generalis', 
    'Oeconomus Generalis', 'Consiliarius pro Ambitu Americarum', 
    'Consiliarius pro Ambitu Africae', 'Consiliarius pro Ambitu Asiae, Australiae et Oceaniae', 
    'Consiliarius pro Ambitu Europae'
  ];

  final List<String> _officiaRoles = [
    'Oeconomatus Generalis', 'Secretariatus Generalis', 
    'Delegatus Monacorum, Heremiti et Instituta', 'Delegatus Formationis', 
    'Delegatus Iuvenibus', 'Delegatus TOC', 'Delegatus Laicorum', 
    'Postulatura Generalis', 'Legale Rappresentante'
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

  Widget _buildRoleTile(String roleTitle) {
    final match = _pejabatCuria.where((p) => p['office_title'] == roleTitle).toList();
    
    if (match.isNotEmpty && match.first['members'] != null) {
      final member = match.first['members'];
      final conventusName = member['conventus']?['name'] ?? 'Biara belum diatur';

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ExpansionTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.brown,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(roleTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
          subtitle: Text(member['full_name'] ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Asal Komunitas", conventusName),
                  _buildDetailRow("Tempat Lahir", member['city_of_birth']),
                  _buildDetailRow("Negara Lahir", member['country_of_birth']),
                  _buildDetailRow("Tanggal Lahir", member['date_of_birth']),
                  const Divider(),
                  _buildDetailRow("Kaul Perdana", member['first_profession_date']),
                  _buildDetailRow("Kaul Kekal", member['solemn_profession_date']),
                  if (member['ordination_date'] != null)
                    _buildDetailRow("Tahbisan Imam", member['ordination_date']),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.grey.shade100,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.grey.shade400, child: const Icon(Icons.person_outline, color: Colors.white)),
        title: Text(roleTitle, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        subtitle: const Text("Belum ada pejabat yang ditunjuk", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value?.toString() ?? '-'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Curia Generalis"),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCuriaData),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: "Consilium Generale"),
              Tab(text: "Officia Generalia"),
              Tab(text: "Commissiones Generales"),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.brown))
            : TabBarView(
                children: [
                  // TAB 1: CONSILIUM GENERALE
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _consiliumRoles.length,
                    itemBuilder: (context, index) => _buildRoleTile(_consiliumRoles[index]),
                  ),

                  // TAB 2: OFFICIA GENERALIA
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _officiaRoles.length,
                    itemBuilder: (context, index) => _buildRoleTile(_officiaRoles[index]),
                  ),

                  // TAB 3: COMMISSIONES GENERALES
                  _daftarKomisi.isEmpty
                      ? const Center(child: Text("Belum ada data Komisi terdaftar."))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _daftarKomisi.length,
                          itemBuilder: (context, index) {
                            final komisi = _daftarKomisi[index];
                            final praeses = komisi['praeses']; 
                            final membersList = komisi['commission_members'] as List<dynamic>? ?? []; 

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ExpansionTile(
                                leading: const Icon(Icons.assignment, color: Colors.brown),
                                title: Text(komisi['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                                subtitle: Text("Praeses: ${praeses != null ? praeses['full_name'] : 'Belum ditentukan'}"),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Mission / Tugas Kerasulan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                        const SizedBox(height: 4),
                                        Text(komisi['mission'] ?? 'Belum ada deskripsi misi.', style: const TextStyle(height: 1.4)),
                                        const Divider(height: 24),
                                        Text("Sodales (Anggota Komisi):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
                                        const SizedBox(height: 6),
                                        if (membersList.isEmpty)
                                          const Text("Belum ada anggota komisi yang ditambahkan.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                                        else
                                          Column(
                                            children: membersList.map((cm) {
                                              final namaAnggota = cm['member']?['full_name'] ?? 'Tidak diketahui';
                                              final jabatanDiKomisi = cm['position'] ?? 'Anggota';
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(Icons.fiber_manual_record, size: 12, color: Colors.brown),
                                                title: Text(namaAnggota, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                subtitle: Text("Jabatan: $jabatanDiKomisi"),
                                              );
                                            }).toList(),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}