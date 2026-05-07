import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:skyblue/login.dart';
import 'package:skyblue/page/dashboard.dart';
import 'package:skyblue/page/master/item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isExpand = true;
  String current = 'DASHBOARD';

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
                  isExpand = v;
                },
              );
            },
            child: AnimatedContainer( //FIXME ketika sidebar minimize expansiontile tetap terbuka
              duration: const Duration(milliseconds: 300),
              color: const Color.fromARGB(40, 135, 206, 235), //FIXME kalau alphanya 255 nutupin splashnya listtile
              width: isExpand ? 256.0 : 58.0, //FIXME kurangi magic number seperti ini
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: 256.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        leading: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            menuItem(
                              'DASHBOARD',
                              Icons.home_outlined,
                              'DASHBOARD',
                            ),
                            expansionMenu(
                              'MASTER',
                              Icons.book_outlined,
                              'MASTER',
                              [
                                subMenuItem(
                                  'MASTER_ITEM',
                                  'BARANG',
                                ),
                                subMenuItem(
                                  'MASTER_MEMBER',
                                  'USER',
                                ),
                              ],
                            ),
                            expansionMenu(
                              'STOCK',
                              Icons.inventory_outlined,
                              'STOK',
                              [
                                subMenuItem(
                                  'STOCK_DATA',
                                  'DATA',
                                ),
                                subMenuItem(
                                  'STOCK_ADJUST',
                                  'PENYESUAIAN',
                                ),
                              ],
                            ),
                            expansionMenu(
                              'TRANSACTION',
                              Icons.shopping_cart_outlined,
                              'TRANSAKSI',
                              [
                                subMenuItem(
                                  'TRANSACTION_SELL',
                                  'JUAL',
                                ),
                                subMenuItem(
                                  'TRANSACTION_BUY',
                                  'BELI',
                                ),
                              ],
                            ),
                            expansionMenu(
                              'REPORT',
                              Icons.description_outlined,
                              'LAPORAN',
                              [
                                subMenuItem(
                                  'REPORT_SALES',
                                  'PENJUALAN',
                                ),
                                subMenuItem(
                                  'REPORT_PROCURE',
                                  'PEMBELIAN',
                                ),
                              ],
                            ),
                            menuItem(
                              'SYNC',
                              Icons.sync_alt,
                              'SINKRONISASI',
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          await Supabase.instance.client.auth.signOut()
                          .then(
                            (r) { //TODO ganti ke notif konfirmasi
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
                        },
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: const Text(
                          'KELUAR',
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8.0,
                      children: [
                        IconButton(
                          onPressed: () {
                            //TODO fitur terang gelap
                          },
                          icon: const Icon(Icons.dark_mode_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO fitur profil ganti password dan lain lain
                          },
                          icon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(
                          width: 128.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column( //TODO nama user dan role
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Guy Hawkins'),
                                Text(
                                  'Administrator',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
<<<<<<< HEAD
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 135, 206, 235),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: switch (current) {
                        'DASHBOARD' => const Dashboard(),
                        'MASTER_ITEM' => const Item(),
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
=======
                    child: switch (current) {
                      'DASHBOARD' => const Dashboard(),
                      'MASTER_ITEM' => const Item(),
                      'MASTER_MEMBER' => const Member(),
                      'STOCK_DATA' => const Data(),
                      'STOCK_ADJUST' => const Adjust(),
                      'TRANSACTION_SELL' => const Sell(),
                      'TRANSACTION_BUY' => const Buy(),
                      'REPORT' => const Report(),
                      String() => Center(
                        child: Text(
                          'Halaman $current',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    },
>>>>>>> skyblue/frederick
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(String key, IconData icon, String label) {
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
        color: isSelected
        ? Colors.blue
        : Colors.black,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
          ? Colors.blue
          : Colors.black,
          fontWeight: isSelected
          ? FontWeight.bold
          : FontWeight.normal,
        ),
        softWrap: false,
      ),
    );
  }

  Widget expansionMenu(String key, IconData icon, String label, List<Widget> children) {
    final isSelected = current.startsWith(key);
    
    return ExpansionTile(
      leading: Icon(
        icon,
        color: isSelected
        ? Colors.blue
        : Colors.black,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
          ? Colors.blue
          : Colors.black,
          fontWeight: isSelected
          ? FontWeight.bold
          : FontWeight.normal,
        ),
        softWrap: false,
      ),
      showTrailingIcon: false,
      shape: const Border(),
      children: children,
    );
  }

  Widget subMenuItem(String key, String label) {
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
          color: isSelected
          ? Colors.blue
          : Colors.black,
        ),
        softWrap: false,
      ),
    );
  }
}