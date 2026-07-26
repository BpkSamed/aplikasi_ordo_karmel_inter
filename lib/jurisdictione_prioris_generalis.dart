import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

class HalamanSubImmediata extends StatefulWidget {
  const HalamanSubImmediata({super.key});

  @override
  State<HalamanSubImmediata> createState() => _HalamanSubImmediataState();
}

class _HalamanSubImmediataState extends State<HalamanSubImmediata> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _pejabatSubImmediata = [];

  // Struktur Jabatan Resmi Sesuai Dokumen Induk (Sama seperti GitHub)
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
      // Kueri relasi anti-ambigu mengambil data dari tabel curia_officers khusus kategori ini (Sesuai GitHub)
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

  Widget _buildRoleTile(String roleTitle, AppLocalizations t, double baseWidth) {
    // Mencocokkan data jabatan statis dengan data yang didapat dari database
    final match = _pejabatSubImmediata.where((p) => p['office_title'] == roleTitle).toList();
    
    if (match.isNotEmpty && match.first['members'] != null) {
      final member = match.first['members'];
      final conventusName = member['conventus']?['name'] ?? t.unassignedMonastery;

      return Card(
        margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02, horizontal: baseWidth * 0.03),
        elevation: 3,
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: baseWidth * 0.05,
            backgroundColor: Colors.brown,
            child: Icon(Icons.account_balance, color: Colors.white, size: baseWidth * 0.05),
          ),
          title: Text(
            roleTitle, 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.038)
          ),
          subtitle: Text(
            member['full_name'] ?? '-', 
            style: TextStyle(fontSize: baseWidth * 0.035, fontWeight: FontWeight.w600, color: Colors.black87)
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
            )
          ],
        ),
      );
    }

    // Tampilan jika admin belum menunjuk orang untuk jabatan ini
    return Card(
      margin: EdgeInsets.symmetric(vertical: baseWidth * 0.02, horizontal: baseWidth * 0.03),
      color: Colors.grey.shade100,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: baseWidth * 0.05,
          backgroundColor: Colors.grey.shade400, 
          child: Icon(Icons.account_balance_outlined, color: Colors.white, size: baseWidth * 0.05)
        ),
        title: Text(
          roleTitle, 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: baseWidth * 0.038)
        ),
        subtitle: Text(
          t.unassignedOfficial, 
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: baseWidth * 0.032)
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
          Text(
            "$label: ", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: baseWidth * 0.035)
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-', 
              style: TextStyle(fontSize: baseWidth * 0.035)
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // Deklarasi lokalisasi

    return Scaffold(
      appBar: AppBar(
        title: Text(t.subImmediataTitle ?? "Sub Immediata"),
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
            padding: EdgeInsets.only(top: baseWidth * 0.03, bottom: baseWidth * 0.05),
            itemCount: _subImmediataRoles.length,
            itemBuilder: (context, index) {
              return _buildRoleTile(_subImmediataRoles[index], t, baseWidth);
            },
          );
        },
      ),
    );
  }
}