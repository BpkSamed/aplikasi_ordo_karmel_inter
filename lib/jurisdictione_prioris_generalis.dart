import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanSubImmediata extends StatefulWidget {
  const HalamanSubImmediata({super.key});

  @override
  State<HalamanSubImmediata> createState() => _HalamanSubImmediataState();
}

class _HalamanSubImmediataState extends State<HalamanSubImmediata> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _pejabatSubImmediata = [];

  // Struktur Jabatan Resmi Sesuai Dokumen Induk
  final List<String> _subImmediataRoles = [
    'Delegatio Generalis pro Monialibus', 
    'Institutum Carmelitanum (Praeses)', 
    'Centrum S. Alberti (CISA) (Priore)', 
    'Domus S. Alberti (Priore)'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Kueri relasi anti-ambigu mengambil data dari tabel curia_officers khusus kategori ini
      final response = await _supabase
          .from('curia_officers')
          .select('*, members:members!member_id(*, conventus(name))')
          .eq('office_category', 'Sub Immediata Jurisdictione Prioris Generalis');

      setState(() {
        _pejabatSubImmediata = response as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Gagal mengambil data Sub Immediata: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildRoleTile(String roleTitle) {
    // Mencocokkan data jabatan statis dengan data yang didapat dari database
    final match = _pejabatSubImmediata.where((p) => p['office_title'] == roleTitle).toList();
    
    if (match.isNotEmpty && match.first['members'] != null) {
      final member = match.first['members'];
      final conventusName = member['conventus']?['name'] ?? 'Biara belum diatur';

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 3,
        child: ExpansionTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.brown,
            child: Icon(Icons.account_balance, color: Colors.white),
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

    // Tampilan jika admin belum menunjuk orang untuk jabatan ini
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Colors.grey.shade100,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.grey.shade400, child: const Icon(Icons.account_balance_outlined, color: Colors.white)),
        title: Text(roleTitle, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        subtitle: const Text("Belum ada pejabat yang ditunjuk", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(child: Text(value?.toString() ?? '-')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Immediata"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              itemCount: _subImmediataRoles.length,
              itemBuilder: (context, index) {
                return _buildRoleTile(_subImmediataRoles[index]);
              },
            ),
    );
  }
}