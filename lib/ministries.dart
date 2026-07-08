import 'package:flutter/material.dart';

/// =================================================================
/// HALAMAN UTAMA: MINISTRIES
/// Menampilkan daftar pelayanan dengan menu dropdown untuk Schools
/// =================================================================
class HalamanMinistries extends StatelessWidget {
  const HalamanMinistries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MINISTRIES")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildKategoriMenu(context, "Parishes", Icons.church),
          
          // Menu Khusus Schools (Bisa mekar ke bawah)
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              leading: const Icon(Icons.school, color: Colors.brown),
              title: const Text("Schools", style: TextStyle(fontWeight: FontWeight.bold)),
              childrenPadding: const EdgeInsets.only(left: 20, bottom: 10),
              children: [
                _buildSubMenuSchool(context, "Elementary School"),
                _buildSubMenuSchool(context, "Secondary School"),
                _buildSubMenuSchool(context, "Academy"),
                _buildSubMenuSchool(context, "University / Institute"),
              ],
            ),
          ),

          _buildKategoriMenu(context, "Retreat Centers", Icons.nature_people),
          _buildKategoriMenu(context, "Spirituality Institute", Icons.self_improvement),
          _buildKategoriMenu(context, "Social Ministries", Icons.volunteer_activism),
          _buildKategoriMenu(context, "Libraries", Icons.local_library),
          _buildKategoriMenu(context, "Hospitals / Clinics", Icons.local_hospital),
        ],
      ),
    );
  }

  // --- Widget Pembantu untuk Menu Biasa ---
  Widget _buildKategoriMenu(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Navigasi ke halaman detail daftar berdasarkan kategori
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanDaftarMinistries(kategori: title),
            ),
          );
        },
      ),
    );
  }

  // --- Widget Pembantu untuk Sub-Menu Schools ---
  Widget _buildSubMenuSchool(BuildContext context, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 10, color: Colors.brown),
      title: Text(subtitle, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDaftarMinistries(kategori: "Schools - $subtitle"),
          ),
        );
      },
    );
  }
}

/// =================================================================
/// HALAMAN DAFTAR (Tampilan Dummy untuk Detail Tiap Kategori)
/// =================================================================
class HalamanDaftarMinistries extends StatelessWidget {
  final String kategori;
  const HalamanDaftarMinistries({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    // Dummy daftar nama tempat sesuai kategori yang diklik
    final List<String> daftarTempat = [
      "Tempat Pelayanan 1",
      "Tempat Pelayanan 2",
      "Tempat Pelayanan 3",
    ];

    return Scaffold(
      appBar: AppBar(title: Text(kategori, style: const TextStyle(fontSize: 18))),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarTempat.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.brown,
                child: Icon(Icons.location_on, color: Colors.white, size: 18),
              ),
              title: Text(daftarTempat[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Informasi kota atau keuskupan..."),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // Nantinya bisa diarahkan ke detail lengkap (alamat, kontak, dll)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Membuka detail ${daftarTempat[index]}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}