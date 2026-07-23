import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      // Ambil data pejabat beserta nama anggota yang menjabat
      final response = await _supabase
          .from('curia_officers')
          .select('*, members(full_name, conventus(name))');
      setState(() {
        _pejabatAktif = response as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Error fetching curia: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Mencari nama anggota berdasarkan nama jabatannya
  String _getNamaPejabat(String officeTitle) {
    final pejabat = _pejabatAktif.where((p) => p['office_title'] == officeTitle).toList();
    if (pejabat.isNotEmpty && pejabat.first['members'] != null) {
      final nama = pejabat.first['members']['full_name'];
      final biara = pejabat.first['members']['conventus']?['name'] ?? '';
      return biara.isNotEmpty ? "$nama\n(Asal: $biara)" : nama;
    }
    return "Belum ditentukan";
  }

  // Fungsi saat Admin menekan tombol "Pilih / Ganti Pejabat"
  Future<void> _tunjukPejabat(String category, String title) async {
    // Membuka halaman pencarian anggota
    final int? selectedMemberId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HalamanPilihAnggota()),
    );

    if (selectedMemberId != null) {
      setState(() => _isLoading = true);
      try {
        // Cek apakah jabatan ini sudah ada yang menempati di database
        final cekJabatan = await _supabase
            .from('curia_officers')
            .select()
            .eq('office_title', title)
            .maybeSingle();

        if (cekJabatan != null) {
          // Jika sudah ada, UPDATE (ganti orang)
          await _supabase
              .from('curia_officers')
              .update({'member_id': selectedMemberId})
              .eq('office_title', title);
        } else {
          // Jika belum ada, INSERT data baru
          await _supabase
              .from('curia_officers')
              .insert({
                'office_category': category,
                'office_title': title,
                'member_id': selectedMemberId
              });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Jabatan '$title' berhasil diperbarui!")));
        _fetchPejabat(); // Refresh data
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Curia & Sub Immediata")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.brown))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _strukturJabatan.keys.length,
            itemBuilder: (context, index) {
              final category = _strukturJabatan.keys.elementAt(index);
              final titles = _strukturJabatan[category]!;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                  children: titles.map((title) {
                    final namaPejabat = _getNamaPejabat(title);
                    final isKosong = namaPejabat == "Belum ditentukan";
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        namaPejabat, 
                        style: TextStyle(color: isKosong ? Colors.red : Colors.green.shade800, fontWeight: isKosong ? FontWeight.normal : FontWeight.bold)
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade100, elevation: 0),
                        onPressed: () => _tunjukPejabat(category, title),
                        child: const Text("Pilih / Ganti", style: TextStyle(color: Colors.brown)),
                      ),
                    );
                  }).toList(),
                ),
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
      final response = await Supabase.instance.client
          .from('members')
          .select('id, full_name, entities(name)')
          .order('full_name');
      setState(() => _members = response as List<dynamic>);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _members.where((m) => (m['full_name'] ?? '').toString().toLowerCase().contains(_query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Cari & Pilih Anggota")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (val) => setState(() => _query = val.toLowerCase()),
              decoration: const InputDecoration(labelText: "Ketik Nama Anggota...", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final member = filtered[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(member['full_name']),
                      subtitle: Text("Asal: ${member['entities']?['name'] ?? '-'}"),
                      trailing: const Icon(Icons.check_circle_outline),
                      onTap: () {
                        // Mengembalikan ID Anggota ke halaman sebelumnya
                        Navigator.pop(context, member['id']);
                      },
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
}