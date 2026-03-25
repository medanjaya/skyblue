import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpanded = true; // Status sidebar buka/tutup
  String selectedMenu = 'Dashboard'; // Menu yang aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ================= SIDEBAR =================
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isExpanded ? 250 : 70, // Lebar berubah sesuai status
            color: Colors.grey[300],
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Tombol Hamburger untuk Toggle
                Align(
                  alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                
                // Daftar Menu
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(Icons.home_outlined, "DASHBOARD"),
                      _buildExpansionMenu(Icons.menu_book_outlined, "MASTER", ["Stok", "Vendor", "User"]),
                      _buildExpansionMenu(Icons.shopping_cart_outlined, "TRANSAKSI", ["Penjualan", "Pembelian"]),
                      _buildExpansionMenu(Icons.description_outlined, "LAPORAN", ["Penjualan", "Pembelian", "Stock"]),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= MAIN CONTENT =================
          Expanded(
            child: Column(
              children: [
                // Header / Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.dark_mode_outlined),
                      SizedBox(width: 10),
                      Text("Administrator", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                
                // Area Konten Utama (Biru seperti di gambar)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90CAF9), // Warna biru muda
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Halaman $selectedMenu",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menu biasa (tanpa dropdown)
  Widget _buildMenuItem(IconData icon, String title) {
    bool isSelected = selectedMenu == title;
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: isExpanded ? Text(title, style: const TextStyle(fontWeight: FontWeight.bold)) : null,
      onTap: () => setState(() => selectedMenu = title),
      tileColor: isSelected ? Colors.grey[400] : null,
    );
  }

  // Widget untuk menu dengan Dropdown (ExpansionTile)
  Widget _buildExpansionMenu(IconData icon, String title, List<String> subItems) {
    if (!isExpanded) {
      // Jika sidebar mengecil, hanya tampilkan Icon saja
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: IconButton(
          icon: Icon(icon),
          onPressed: () => setState(() => isExpanded = true),
        ),
      );
    }

    return ExpansionTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: subItems.map((subTitle) {
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 50),
          title: Text(subTitle),
          onTap: () => setState(() => selectedMenu = "$title - $subTitle"),
        );
      }).toList(),
    );
  }
}