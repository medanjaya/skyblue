import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:skyblue/login.dart';
import 'package:skyblue/stock.dart';
import 'package:skyblue/screens/vendor.dart';
import 'package:skyblue/screens/sales_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpand = true; //FIXME kenapa harus true baru tidak eror?
  String current = 'DASHBOARD';
  
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
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.black,
        ),
        softWrap: false,
      ),
    );
  }

  Widget buildExpansionMenu(String key, IconData icon, String label, List<Widget> children) {
    final isSelected = current.startsWith(key);
    
    return ExpansionTile(
      onExpansionChanged: (v) {
        setState(
          () {
            isExpand = v;
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
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.black,
        ),
        softWrap: false,
      ),
      showTrailingIcon: false,
      shape: const Border(),
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
        left: 60.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          InkWell(
            //FIXME '(event is PointerAddedEvent) == (lastEvent is PointerRemovedEvent)': is not true.
            onTap: () {},
            onHover: (v) {
              setState(
                () {
                  isExpand = v;
                },
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpand ? 256.0 : 56.0,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(
                            () {
                              isExpand = !isExpand;
                            },
                          );
                        },
                        icon: const Icon(Icons.menu), //FIXME hilangkan splash dan highlight
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
                            'MASTER',
                            Icons.book_outlined,
                            'MASTER',
                            [
                              buildSubMenuItem(
                                'MASTER_ITEM',
                                'BARANG',
                              ),
                              buildSubMenuItem(
                                'MASTER_VENDOR',
                                'VENDOR',
                              ),
                              buildSubMenuItem(
                                'MASTER_USER',
                                'USER',
                              ),
                            ],
                          ),
                          buildExpansionMenu(
                            'STOCK',
                            Icons.inventory_outlined,
                            'STOK',
                            [
                              buildSubMenuItem(
                                'STOCK_DATA',
                                'DATA',
                              ),
                              buildSubMenuItem(
                                'STOCK_ADJUST',
                                'PENYESUAIAN',
                              ),
                            ],
                          ),
                          buildExpansionMenu(
                            'TRANSACTION',
                            Icons.shopping_cart_outlined,
                            'TRANSAKSI',
                            [
                              buildSubMenuItem(
                                'TRANSACTION_SELL',
                                'PENJUALAN',
                              ),
                              buildSubMenuItem(
                                'TRANSACTION_BUY',
                                'PEMBELIAN',
                              ),
                            ],
                          ),
                          buildMenuItem(
                            'REPORT',
                            Icons.description_outlined,
                            'LAPORAN',
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(
                          () async {
                            await Supabase.instance.client.auth.signOut()
                            .then(
                              (r) {
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text('Sampai jumpa lain waktu.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                )
                                .closed
                                .then(
                                  (r) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                        );
                      },
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'LOGOUT',
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
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
                    child: switch (current) { //TODO tambahkan menu lainnya
                      'MASTER_VENDOR' => const Vendor(),
                      'STOCK_DATA' => const Stock(),
                      'TRANSACTION_SELL' => const SalesScreen(),
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