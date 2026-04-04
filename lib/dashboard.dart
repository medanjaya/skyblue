import 'package:flutter/material.dart';

import 'package:skyblue/stock.dart';
import 'package:skyblue/screens/vendor_screen.dart';
import 'package:skyblue/screens/sales_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpand = false;
  String current = 'MASTER - Stok';
  
  Widget buildMenuItem(String key, IconData icon, String label) {
    final isSelected = current == key;
    
    return ListTile(
      onTap: () {
        setState(
          () {
            current = key;
          }
        );
      },
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
        ),
        softWrap: false,
      ),
    );
  }

  Widget buildExpansionMenu(IconData icon, String label, List<Widget> children) {
    return ExpansionTile(
      onExpansionChanged: (v) {
        setState(
          () {
            isExpand = true;
          }
        );
      },
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        softWrap: false,
      ),
      showTrailingIcon: false,
      children: children,
    );
  }

  Widget buildSubMenuItem(String key, String label) {
    final isSelected = current == key;

    return ListTile(
      onTap: () {
        setState(
          () {
            current = key;
          }
        );
      },
      contentPadding: const EdgeInsets.only(
        left: 48.0,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.black,
        ),
        softWrap: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          InkWell(
            onTap: () {},
            onHover: (v) {
              setState(
                () {
                  isExpand = !isExpand;
                }
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpand ? 256.0 : 56.0,
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        buildMenuItem(
                          'DASHBOARD',
                          Icons.home_outlined,
                          'DASHBOARD',
                        ),
                        buildExpansionMenu(
                          Icons.menu_book_outlined,
                          'MASTER',
                          [
                            buildSubMenuItem(
                              'MASTER - Stok',
                              'Stok',
                            ),
                            buildSubMenuItem(
                              'MASTER - Vendor',
                              'Vendor',
                            ),
                          ],
                        ),
                        buildExpansionMenu(
                          Icons.shopping_cart_outlined,
                          'TRANSAKSI',
                          [
                            buildSubMenuItem(
                              'TRANSAKSI - Penjualan',
                              'Penjualan',
                            ),
                            buildSubMenuItem(
                              'TRANSAKSI - Pembelian',
                              'Pembelian',
                            ),
                          ],
                        ),
                        buildMenuItem(
                          'LAPORAN',
                          Icons.description_outlined,
                          'LAPORAN',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: IconButton(
                      onPressed: () {
                        //TODO
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),
                  ),
                ],
              ),
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
                    child: switch (current) {
                      'MASTER - Stok' => const Stock(),
                      'MASTER - Vendor' => const VendorScreen(),
                      'TRANSAKSI - Penjualan' => const SalesScreen(),
                      String() => Center(
                        child: Text(
                          'Halaman $current',
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