import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';

class HalamanTambahAdmin extends StatefulWidget {
  const HalamanTambahAdmin({super.key});

  @override
  State<HalamanTambahAdmin> createState() => _HalamanTambahAdminState();
}

class _HalamanTambahAdminState extends State<HalamanTambahAdmin> {
  final _nameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _simpan(AppLocalizations t) async {
    if (_nameCtrl.text.isEmpty || _passCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('admins').insert({
        'name': _nameCtrl.text,
        'password': _passCtrl.text, // Catatan: Sebaiknya di-hash untuk keamanan produksi
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.adminAddSuccess ?? "Sukses")));
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.addAdminPageTitle ?? "Tambah Admin")),
      body: LayoutBuilder(builder: (context, constraints) {
        final baseWidth = constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.all(baseWidth * 0.05),
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: t.adminNameLabel ?? "Nama Admin", border: const OutlineInputBorder()),
              ),
              SizedBox(height: baseWidth * 0.04),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: t.passwordLabel ?? "Password", border: const OutlineInputBorder()),
              ),
              SizedBox(height: baseWidth * 0.06),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown, 
                      minimumSize: Size(double.infinity, baseWidth * 0.12)
                    ),
                    onPressed: () => _simpan(t),
                    child: Text(t.saveAdminBtn ?? "SIMPAN", style: const TextStyle(color: Colors.white)),
                  )
            ],
          ),
        );
      }),
    );
  }
}