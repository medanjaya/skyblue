import 'package:flutter/material.dart';

import 'package:skyblue/screens/stok_screen.dart';
import 'package:skyblue/screens/vendor_screen.dart';
import 'package:skyblue/screens/sales_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpand = true;
  String selectedMenu = 'MASTER - Stok';

  // HELPER: Untuk Menu Biasa
  Widget buildMenuItem(IconData icon, String title, String key) {
    var isSelected = selectedMenu == key;
    return ListTile(
      onTap: () {
        setState(
          () {
            selectedMenu = key;
          }
        );
      },
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black,
      ),
      title: isExpand
      ? Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
        ),
      )
      : null,
    );
  }

  // HELPER: Untuk Menu Dropdown (MASTER/TRANSAKSI)
  Widget buildExpansionMenu({required IconData icon, required String title, required List<Widget> children}) {
    if (!isExpand) {
      return IconButton(icon: Icon(icon), onPressed: () => setState(() => isExpand = true));
    }
    return ExpansionTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: children,
    );
  }

  // HELPER: Untuk Sub-menu (Stok, Vendor, Penjualan)
  Widget buildSubMenuItem(String title, String menuKey) {
    var isSelected = selectedMenu == menuKey;
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50),
      title: Text(title, style: TextStyle(
        color: isSelected ? Colors.blue : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      onTap: () => setState(() => selectedMenu = menuKey),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isExpand ? 256.0 : 64.0,
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        isExpand = !isExpand;
                      },
                    );
                  },
                  icon: const Icon(Icons.menu),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      buildMenuItem(
                        Icons.home_outlined,
                        'DASHBOARD',
                        'DASHBOARD',
                      ),
                      buildExpansionMenu(
                        icon: Icons.menu_book_outlined,
                        title: 'MASTER',
                        children: [
                          buildSubMenuItem(
                            'Stok',
                            'MASTER - Stok',
                          ),
                          buildSubMenuItem(
                            'Vendor',
                            'MASTER - Vendor',
                          ),
                        ],
                      ),
                      buildExpansionMenu(
                        icon: Icons.shopping_cart_outlined,
                        title: 'TRANSAKSI',
                        children: [
                          buildSubMenuItem(
                            'Penjualan',
                            'TRANSAKSI - Penjualan',
                          ),
                          buildSubMenuItem(
                            'Pembelian',
                            'TRANSAKSI - Pembelian',
                          ),
                        ],
                      ),
                      buildMenuItem(
                        Icons.description_outlined,
                        'LAPORAN',
                        'LAPORAN',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    //TODO
                  },
                  icon: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16.0,
                    children: [
                      Icon(Icons.dark_mode_outlined),
                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: switch (selectedMenu) {
                      'MASTER - Stok' => const StokScreen(),
                      'MASTER - Vendor' => const VendorScreen(),
                      'TRANSAKSI - Penjualan' => const SalesScreen(),
                      String() => Center(
                        child: Text(
                          'Halaman $selectedMenu',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}