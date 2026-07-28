import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart'; // Import lokalisasi

/// =================================================================
/// HELPER: FUNGSI POPUP PENCARIAN GLOBAL UNTUK FILE INI
/// =================================================================
Future<void> _tampilkanDialogPencarian({
  required BuildContext context,
  required String judul,
  required List<dynamic> daftarData,
  required String Function(dynamic) buildDisplayText,
  required void Function(Map<String, dynamic>) onPilih,
  required AppLocalizations t,
}) async {
  String kataKunci = "";

  await showDialog(
    context: context,
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          return StatefulBuilder(
            builder: (context, setStateDialog) {
              final hasilFilter = daftarData.where((item) {
                final nilaiTeks = buildDisplayText(item).toLowerCase();
                return nilaiTeks.contains(kataKunci.toLowerCase());
              }).toList();

              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(baseWidth * 0.04)),
                title: Text(
                  t.selectItemTitle(judul), 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.045)
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: baseWidth * 0.8,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: t.searchItemHint(judul),
                          hintStyle: TextStyle(fontSize: baseWidth * 0.035),
                          prefixIcon: Icon(Icons.search, color: Colors.brown, size: baseWidth * 0.05),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(baseWidth * 0.025)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setStateDialog(() {
                            kataKunci = value;
                          });
                        },
                      ),
                      SizedBox(height: baseWidth * 0.03),
                      const Divider(),
                      Expanded(
                        child: hasilFilter.isEmpty
                            ? Center(
                                child: Text(
                                  t.dataNotFound ?? "Data tidak ditemukan", 
                                  style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.035)
                                )
                              )
                            : ListView.builder(
                                itemCount: hasilFilter.length,
                                itemBuilder: (context, index) {
                                  final data = hasilFilter[index];
                                  return ListTile(
                                    leading: Icon(Icons.radio_button_unchecked, color: Colors.grey, size: baseWidth * 0.05),
                                    title: Text(buildDisplayText(data), style: TextStyle(fontSize: baseWidth * 0.035)),
                                    onTap: () {
                                      onPilih(data as Map<String, dynamic>);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      t.closeButton ?? "Tutup", 
                      style: TextStyle(color: Colors.grey, fontSize: baseWidth * 0.035)
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

/// =================================================================
/// HALAMAN UTAMA: DAFTAR KOMISI
/// =================================================================
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

  // Mengambil daftar komisi beserta nama & foto Praeses (Ketua)
  Future<void> _fetchCommissions() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('commissions')
          .select('*, praeses:members!praeses_id(full_name, photo_url)')
          .order('name', ascending: true);
      if (mounted) {
        setState(() {
          _commissions = response as List<dynamic>;
        });
      }
    } catch (e) {
      debugPrint("Error fetch commissions: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Menghapus data komisi induk
  Future<void> _deleteCommission(int id, String name, AppLocalizations t, double baseWidth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.deleteCommissionTooltip ?? "Hapus Komisi", style: TextStyle(fontSize: baseWidth * 0.045)),
        content: Text(
          t.deleteCommissionConfirmMsg(name),
          style: TextStyle(fontSize: baseWidth * 0.038),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: Text(t.cancelButton ?? "Batal", style: TextStyle(fontSize: baseWidth * 0.035))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.deleteButton ?? "Hapus", style: TextStyle(fontSize: baseWidth * 0.035)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabase.from('commissions').delete().eq('id', id);
        _fetchCommissions();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.commissionDeletedSuccess ?? "Komisi berhasil dihapus"))
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.failedToDeleteCommission(e.toString())))
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.manageCommissionTitle ?? "Kelola Komisi Jenderal"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchCommissions),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          if (_commissions.isEmpty) {
            return Center(
              child: Text(
                t.noCommissionsRegistered ?? "Belum ada komisi terdaftar.",
                style: TextStyle(fontSize: baseWidth * 0.04, color: Colors.grey),
              )
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(baseWidth * 0.03),
            itemCount: _commissions.length,
            itemBuilder: (context, index) {
              final komisi = _commissions[index];
              final namaPraeses = komisi['praeses']?['full_name'] ?? (t.notDetermined ?? 'Belum ditentukan');
              final fotoPraeses = komisi['praeses']?['photo_url'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: baseWidth * 0.015),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: baseWidth * 0.04, vertical: baseWidth * 0.02),
                  // MENAMPILKAN FOTO PRAESES / KETUA
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown,
                    radius: baseWidth * 0.06,
                    backgroundImage: (fotoPraeses != null && fotoPraeses.toString().trim().isNotEmpty)
                        ? NetworkImage(fotoPraeses)
                        : null,
                    child: (fotoPraeses == null || fotoPraeses.toString().trim().isEmpty)
                        ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.065)
                        : null,
                  ),
                  title: Text(
                    komisi['name'] ?? '-', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.04)
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: baseWidth * 0.015),
                    child: Text(
                      "Praeses: $namaPraeses\n${t.missionApostolateTaskLabel ?? 'Misi'}: ${komisi['mission'] ?? '-'}",
                      style: TextStyle(fontSize: baseWidth * 0.032, height: 1.4),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol EDIT
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green, size: baseWidth * 0.06),
                        tooltip: t.editTooltip ?? "Edit Komisi",
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanFormKomisi(initialData: komisi),
                            ),
                          );
                          if (result == true) _fetchCommissions();
                        },
                      ),
                      // Tombol ANGGOTA KOMISI
                      IconButton(
                        icon: Icon(Icons.group, color: Colors.blue, size: baseWidth * 0.06),
                        tooltip: t.manageMembersTooltip ?? "Kelola Anggota",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanAnggotaKomisi(commission: komisi),
                            ),
                          ).then((_) => _fetchCommissions());
                        },
                      ),
                      // Tombol HAPUS
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: baseWidth * 0.06),
                        tooltip: t.deleteCommissionTooltip ?? "Hapus Komisi",
                        onPressed: () => _deleteCommission(komisi['id'], komisi['name'], t, baseWidth),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = MediaQuery.of(context).size.width;
          return FloatingActionButton.extended(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            icon: Icon(Icons.add, size: baseWidth * 0.05),
            label: Text(t.addCommissionBtn ?? "Tambah Komisi", style: TextStyle(fontSize: baseWidth * 0.038)),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanFormKomisi()),
              );
              if (result == true) _fetchCommissions();
            },
          );
        }
      ),
    );
  }
}

/// =================================================================
/// FORM TAMBAH & EDIT KOMISI BESERTA PRAESES
/// =================================================================
class HalamanFormKomisi extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const HalamanFormKomisi({super.key, this.initialData});

  @override
  State<HalamanFormKomisi> createState() => _HalamanFormKomisiState();
}

class _HalamanFormKomisiState extends State<HalamanFormKomisi> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  
  final _nameCtrl = TextEditingController();
  final _missionCtrl = TextEditingController();
  final _praesesDisplayCtrl = TextEditingController();
  
  int? _selectedPraesesId;
  List<dynamic> _members = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    setState(() => _isLoading = true);
    await _fetchMembers();

    if (widget.initialData != null) {
      _nameCtrl.text = widget.initialData!['name'] ?? '';
      _missionCtrl.text = widget.initialData!['mission'] ?? '';
      _selectedPraesesId = widget.initialData!['praeses_id'];
      
      if (_selectedPraesesId != null) {
        try {
          final member = _members.firstWhere((m) => m['id'] == _selectedPraesesId);
          _praesesDisplayCtrl.text = member['full_name'];
        } catch (_) {
          _praesesDisplayCtrl.text = widget.initialData!['praeses']?['full_name'] ?? '';
        }
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchMembers() async {
    try {
      final response = await _supabase.from('members').select('id, full_name').order('full_name');
      if (mounted) {
        _members = response as List<dynamic>;
      }
    } catch (e) {
      debugPrint("Error fetch members: $e");
    }
  }

  Future<void> _submit(AppLocalizations t) async {
    if (!_formKey.currentState!.validate() || _selectedPraesesId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.fillDataAndSelectPraesesWarning ?? "Mohon lengkapi data dan pilih Praeses!"))
      );
      return;
    }
    setState(() => _isLoading = true);
    
    final dataKomisi = {
      'name': _nameCtrl.text,
      'mission': _missionCtrl.text,
      'praeses_id': _selectedPraesesId,
    };

    try {
      if (widget.initialData != null) {
        await _supabase.from('commissions').update(dataKomisi).eq('id', widget.initialData!['id']);
      } else {
        await _supabase.from('commissions').insert(dataKomisi);
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _missionCtrl.dispose();
    _praesesDisplayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isEditMode = widget.initialData != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? (t.editCommissionTitle ?? "Edit Komisi") : (t.addNewCommissionTitle ?? "Tambah Komisi Baru"))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          return Padding(
            padding: EdgeInsets.all(baseWidth * 0.04),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: t.commissionNameLabel ?? "Nama Komisi (Wajib)", 
                      border: const OutlineInputBorder()
                    ),
                    validator: (val) => val!.isEmpty ? (t.commissionNameRequired ?? "Nama komisi harus diisi") : null,
                  ),
                  SizedBox(height: baseWidth * 0.03),
                  TextFormField(
                    controller: _missionCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: t.missionApostolateTaskLabel ?? "Misi / Tugas Kerasulan", 
                      border: const OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: baseWidth * 0.03),
                  
                  TextField(
                    controller: _praesesDisplayCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: t.selectPraesesPresidentLabel ?? "Pilih Ketua (Praeses)",
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.search, color: Colors.brown),
                    ),
                    onTap: () {
                      _tampilkanDialogPencarian(
                        context: context,
                        judul: t.selectPraesesPresidentLabel ?? "Ketua (Praeses)",
                        daftarData: _members,
                        buildDisplayText: (m) => m['full_name'],
                        onPilih: (pilihan) {
                          setState(() {
                            _selectedPraesesId = pilihan['id'];
                            _praesesDisplayCtrl.text = pilihan['full_name'];
                          });
                        },
                        t: t,
                      );
                    },
                  ),

                  SizedBox(height: baseWidth * 0.06),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown, 
                      foregroundColor: Colors.white, 
                      padding: EdgeInsets.symmetric(vertical: baseWidth * 0.035)
                    ),
                    onPressed: () => _submit(t),
                    child: Text(
                      isEditMode ? (t.updateCommissionBtn ?? "UPDATE KOMISI") : (t.saveCommissionBtn ?? "SIMPAN KOMISI"), 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseWidth * 0.038)
                    ),
                  )
                ],
              ),
            ),
          );
        }
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
  late TextEditingController _positionCtrl;
  final _memberDisplayCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _positionCtrl = TextEditingController();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Default teks posisi/jabatan dibuat "Sodales"
    if (_positionCtrl.text.isEmpty) {
      _positionCtrl.text = "Sodales"; 
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 1. Ambil anggota komisi beserta nama & foto
      final resCom = await _supabase
          .from('commission_members')
          .select('*, member:members!member_id(full_name, photo_url)')
          .eq('commission_id', widget.commission['id']);
      
      // 2. Ambil semua master anggota untuk opsi penambahan
      final resAll = await _supabase.from('members').select('id, full_name').order('full_name');

      if (mounted) {
        setState(() {
          _comMembers = resCom as List<dynamic>;
          _allMembers = resAll as List<dynamic>;
        });
      }
    } catch (e) {
      debugPrint("Error load members: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addMemberToCommission(AppLocalizations t) async {
    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.selectMemberNameLabel ?? "Mohon pilih nama anggota!"))
      );
      return;
    }
    try {
      await _supabase.from('commission_members').insert({
        'commission_id': widget.commission['id'],
        'member_id': _selectedMemberId,
        'position': _positionCtrl.text.isEmpty ? "Sodales" : _positionCtrl.text,
      });
      _positionCtrl.text = "Sodales"; // Reset ke default Sodales
      _memberDisplayCtrl.clear();
      _selectedMemberId = null;
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.memberAddedToCommissionSuccess ?? "Anggota berhasil ditambahkan ke komisi"))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.memberAlreadyRegisteredOrError(e.toString())))
        );
      }
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
    _memberDisplayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.commissionMembersTitle(widget.commission['name']))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double baseWidth = constraints.maxWidth;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          return Column(
            children: [
              // PANEL PENAMBAHAN ANGGOTA BARU KEDALAM KOMISI
              Card(
                margin: EdgeInsets.all(baseWidth * 0.03),
                child: Padding(
                  padding: EdgeInsets.all(baseWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        t.addCommissionMemberPanelTitle ?? "Tambah Anggota Komisi", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: baseWidth * 0.04)
                      ),
                      SizedBox(height: baseWidth * 0.025),
                      
                      TextField(
                        controller: _memberDisplayCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: t.selectMemberNameLabel ?? "Pilih Nama Anggota",
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.search, color: Colors.brown),
                        ),
                        onTap: () {
                          _tampilkanDialogPencarian(
                            context: context,
                            judul: t.selectMemberNameLabel ?? "Nama Anggota",
                            daftarData: _allMembers,
                            buildDisplayText: (m) => m['full_name'],
                            onPilih: (pilihan) {
                              setState(() {
                                _selectedMemberId = pilihan['id'];
                                _memberDisplayCtrl.text = pilihan['full_name'];
                              });
                            },
                            t: t,
                          );
                        },
                      ),

                      SizedBox(height: baseWidth * 0.025),
                      TextField(
                        controller: _positionCtrl,
                        decoration: InputDecoration(
                          labelText: t.positionInCommissionLabel ?? "Jabatan di Komisi", 
                          border: const OutlineInputBorder()
                        ),
                      ),
                      SizedBox(height: baseWidth * 0.03),
                      ElevatedButton.icon(
                        icon: Icon(Icons.person_add, size: baseWidth * 0.05),
                        label: Text(t.addToCommissionBtn ?? "Masukkan ke Komisi", style: TextStyle(fontSize: baseWidth * 0.035)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown, 
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: baseWidth * 0.03)
                        ),
                        onPressed: () => _addMemberToCommission(t),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(),
              // DAFTAR ANGGOTA YANG AKTIF DI KOMISI SAAT INI
              Expanded(
                child: _comMembers.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(baseWidth * 0.04),
                          child: Text(
                            t.noAdditionalMembersInCommission ?? "Komisi ini belum memiliki anggota tambahan.", 
                            textAlign: TextAlign.center,
                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: baseWidth * 0.038, color: Colors.grey)
                          ),
                        )
                      )
                    : ListView.builder(
                        itemCount: _comMembers.length,
                        itemBuilder: (context, index) {
                          final cm = _comMembers[index];
                          final nama = cm['member']?['full_name'] ?? (t.unknownName ?? 'Tidak diketahui');
                          final fotoMember = cm['member']?['photo_url'];

                          return ListTile(
                            // MENAMPILKAN FOTO MAASING-MASING ANGGOTA
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown,
                              radius: baseWidth * 0.05,
                              backgroundImage: (fotoMember != null && fotoMember.toString().trim().isNotEmpty)
                                  ? NetworkImage(fotoMember)
                                  : null,
                              child: (fotoMember == null || fotoMember.toString().trim().isEmpty)
                                  ? Icon(Icons.person, color: Colors.white, size: baseWidth * 0.055)
                                  : null,
                            ),
                            title: Text(nama, style: TextStyle(fontWeight: FontWeight.w600, fontSize: baseWidth * 0.038)),
                            subtitle: Text("${t.positionPrefix ?? 'Jabatan'}: ${cm['position'] ?? 'Sodales'}"),
                            trailing: IconButton(
                              icon: Icon(Icons.person_remove, color: Colors.red, size: baseWidth * 0.06),
                              onPressed: () => _removeMember(cm['id']),
                            ),
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