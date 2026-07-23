import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanKelolaKomisi extends StatefulWidget {
  const HalamanKelolaKomisi({super.key});

  @override
  State<HalamanKelolaKomisi> createState() => _HalamanKelolaKomisiState();
}

class _HalamanKelolaKomisiState extends State<HalamanKelolaKomisi> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _commissions = [];

  @override
  void initState() {
    super.initState();
    _fetchCommissions();
  }

  // Mengambil daftar komisi beserta nama Praeses (Ketua)
  Future<void> _fetchCommissions() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('commissions')
          .select('*, praeses:members!praeses_id(full_name)')
          .order('name', ascending: true);
      setState(() {
        _commissions = response as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Error fetch commissions: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Menghapus data komisi induk
  Future<void> _deleteCommission(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Komisi"),
        content: Text("Apakah Anda yakin ingin menghapus '$name'? Semua data keanggotaan di dalam komisi ini juga akan terhapus."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabase.from('commissions').delete().eq('id', id);
        _fetchCommissions();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Komisi berhasil dihapus")));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Komisi Jenderal"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchCommissions),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _commissions.isEmpty
              ? const Center(child: Text("Belum ada komisi terdaftar."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _commissions.length,
                  itemBuilder: (context, index) {
                    final komisi = _commissions[index];
                    final namaPraeses = komisi['praeses']?['full_name'] ?? 'Belum ditentukan';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.brown,
                          child: Icon(Icons.assignment, color: Colors.white),
                        ),
                        title: Text(komisi['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Praeses: $namaPraeses\nMisi: ${komisi['mission'] ?? '-'}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.group, color: Colors.blue),
                              tooltip: "Kelola Anggota",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HalamanAnggotaKomisi(commission: komisi),
                                  ),
                                ).then((_) => _fetchCommissions());
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: "Hapus Komisi",
                              onPressed: () => _deleteCommission(komisi['id'], komisi['name']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Komisi"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HalamanFormKomisi()),
          );
          if (result == true) _fetchCommissions();
        },
      ),
    );
  }
}

/// =================================================================
/// FORM TAMBAH KOMISI BARU & PILIH PRAESES
/// =================================================================
class HalamanFormKomisi extends StatefulWidget {
  const HalamanFormKomisi({super.key});

  @override
  State<HalamanFormKomisi> createState() => _HalamanFormKomisiState();
}

class _HalamanFormKomisiState extends State<HalamanFormKomisi> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _missionCtrl = TextEditingController();
  
  int? _selectedPraesesId;
  List<dynamic> _members = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    final response = await _supabase.from('members').select('id, full_name').order('full_name');
    setState(() => _members = response as List<dynamic>);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedPraesesId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon lengkapi data dan pilih Praeses!")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _supabase.from('commissions').insert({
        'name': _nameCtrl.text,
        'mission': _missionCtrl.text,
        'praeses_id': _selectedPraesesId,
      });
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _missionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Komisi Baru")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: "Nama Komisi (Wajib)", border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? "Nama komisi harus diisi" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _missionCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: "Misi / Tugas Kerasulan", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: _selectedPraesesId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: "Pilih Ketua (Praeses)", border: OutlineInputBorder()),
                      items: _members.map((m) => DropdownMenuItem<int>(value: m['id'], child: Text(m['full_name']))).toList(),
                      onChanged: (val) => setState(() => _selectedPraesesId = val),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: _submit,
                      child: const Text("SIMPAN KOMISI"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

/// =================================================================
/// PENGELOLAAN ANGGOTA DI DALAM KOMISI (MANY TO MANY)
/// =================================================================
class HalamanAnggotaKomisi extends StatefulWidget {
  final dynamic commission;
  const HalamanAnggotaKomisi({super.key, required this.commission});

  @override
  State<HalamanAnggotaKomisi> createState() => _HalamanAnggotaKomisiState();
}

class _HalamanAnggotaKomisiState extends State<HalamanAnggotaKomisi> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _comMembers = [];
  List<dynamic> _allMembers = [];
  bool _isLoading = true;

  int? _selectedMemberId;
  final _positionCtrl = TextEditingController(text: "Anggota");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 1. Ambil anggota yang sudah bergabung di komisi ini
      final resCom = await _supabase
          .from('commission_members')
          .select('*, member:members!member_id(full_name)')
          .eq('commission_id', widget.commission['id']);
      
      // 2. Ambil semua master anggota untuk opsi penambahan
      final resAll = await _supabase.from('members').select('id, full_name').order('full_name');

      setState(() {
        _comMembers = resCom as List<dynamic>;
        _allMembers = resAll as List<dynamic>;
      });
    } catch (e) {
      debugPrint("Error load members: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addMemberToCommission() async {
    if (_selectedMemberId == null) return;
    try {
      await _supabase.from('commission_members').insert({
        'commission_id': widget.commission['id'],
        'member_id': _selectedMemberId,
        'position': _positionCtrl.text,
      });
      _positionCtrl.text = "Anggota";
      _selectedMemberId = null;
      _loadData();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Anggota berhasil ditambahkan ke komisi")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sudah terdaftar / Error: $e")));
    }
  }

  Future<void> _removeMember(int id) async {
    try {
      await _supabase.from('commission_members').delete().eq('id', id);
      _loadData();
    } catch (e) {
      debugPrint("Error remove: $e");
    }
  }

  @override
  void dispose() {
    _positionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anggota: ${widget.commission['name']}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // PANEL PENAMBAHAN ANGGOTA BARU KEDALAM KOMISI
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Tambah Anggota Komisi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        value: _selectedMemberId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: "Pilih Nama Anggota", border: OutlineInputBorder()),
                        items: _allMembers.map((m) => DropdownMenuItem<int>(value: m['id'], child: Text(m['full_name']))).toList(),
                        onChanged: (val) => setState(() => _selectedMemberId = val),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _positionCtrl,
                        decoration: const InputDecoration(labelText: "Jabatan di Komisi", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.person_add),
                        label: const Text("Masukkan ke Komisi"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                        onPressed: _addMemberToCommission,
                      )
                    ],
                  ),
                  ),
                ),
                const Divider(),
                // DAFTAR ANGGOTA YANG AKTIF DI KOMISI SAAT INI
                Expanded(
                  child: _comMembers.isEmpty
                      ? const Center(child: Text("Komisi ini belum memiliki anggota tambahan.", style: TextStyle(fontStyle: FontStyle.italic)))
                      : ListView.builder(
                          itemCount: _comMembers.length,
                          itemBuilder: (context, index) {
                            final cm = _comMembers[index];
                            final nama = cm['member']?['full_name'] ?? 'Tidak diketahui';
                            return ListTile(
                              leading: const Icon(Icons.fiber_manual_record, color: Colors.brown, size: 14),
                              title: Text(nama, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text("Jabatan: ${cm['position'] ?? '-'}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.person_remove, color: Colors.red),
                                onPressed: () => _removeMember(cm['id']),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
    );
  }
}