import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import 'package:skyblue/provider.dart';
import 'package:skyblue/login.dart';
import 'package:skyblue/page/dashboard.dart';
import 'package:skyblue/page/master/item.dart';
import 'package:skyblue/page/master/member.dart';
import 'package:skyblue/page/stock/data.dart';
import 'package:skyblue/page/stock/adjust.dart';
import 'package:skyblue/page/transaction/sell.dart';
import 'package:skyblue/page/transaction/buy.dart';
import 'package:skyblue/page/report/sales.dart';
import 'package:skyblue/page/report/procure.dart';
import 'package:skyblue/page/sync.dart';
import 'package:skyblue/page/sandbox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ExpansibleController
  master = ExpansibleController(),
  stock = ExpansibleController(),
  transaction = ExpansibleController(),
  report = ExpansibleController();

  bool isExpand = true;
  String current = 'DASHBOARD';

  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          InkWell(
            onTap: () {},
            onHover: (v) {
              setState(
                () {
                  isExpand = v;
                  collapseExpansions();
                },
              );
            },
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpand ? 256.0 : 58.0,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: 256.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.0,
                    children: [
                      ListTile(
                        leading: InkWell(
                          onTap: () {
                            setState(
                              () {
                                isExpand = !isExpand;
                                collapseExpansions();
                              },
                            );
                          },
                          child: Icon(
                            Icons.menu,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
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
                              master,
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
                              stock,
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
                              transaction,
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
                              report,
                            ),
                            menuItem(
                              'SYNC',
                              Icons.sync_alt,
                              'SINKRONISASI',
                            ),
                            menuItem(
                              'SANDBOX',
                              Icons.stop_circle_outlined,
                              'SANDBOX',
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          await sb.auth.signOut()
                          .then(
                            (r) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('Telah keluar dari dashboard, sampai jumpa lain waktu.'),
                                  ),
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
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).primaryIconTheme.color,
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: Stream.periodic(
                            const Duration(seconds: 1),
                          ),
                          builder: (context, snapshot) {
                            return Row(
                              spacing: 24.0,
                              children: [
                                const Icon(Icons.access_time),
                                Text(
                                  DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.now()),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        spacing: 8.0,
                        children: [
                          IconButton(
                            onPressed: () {
                              theme.toggle();
                            },
                            icon: Icon(
                              theme.isOn
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                            ),
                            splashRadius: 24.0,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  current = 'PROFILE';
                                }
                              );
                            },
                            icon: const Icon(Icons.person_outline),
                            splashRadius: 24.0,
                          ),
                          SizedBox(
                            width: 128.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: FutureBuilder(
                                future: sb
                                .from('user')
                                .select()
                                .eq('id', sb.auth.currentUser?.id ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final user = snapshot.data!.first;
                                    
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(user['name']),
                                        Text(
                                          user['role'].join(', '),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    return const Text('Offline');
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(24.0),
                    color: theme.isOn
                    ? const Color.fromARGB(255, 40, 40, 40)
                    : const Color.fromARGB(255, 245, 245, 245),
                    child: switch (current) {
                      //TODO fitur profil ganti password dan lain lain, 'PROFILE' => const Profile(),
                      'DASHBOARD' => const Dashboard(),
                      'MASTER_ITEM' => const Item(),
                      'MASTER_MEMBER' => const Member(),
                      'STOCK_DATA' => const Data(),
                      'STOCK_ADJUST' => const Adjust(),
                      'TRANSACTION_SELL' => const Sell(),
                      'TRANSACTION_BUY' => const Buy(),
                      'REPORT_SALES' => const Sales(),
                      'REPORT_PROCURE' => const Procure(),
                      'SYNC' => const Sync(),
                      'SANDBOX' => const Sandbox(),
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
        : Theme.of(context).primaryIconTheme.color,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
          ? Colors.blue
          : Theme.of(context).primaryIconTheme.color,
          fontWeight: isSelected
          ? FontWeight.bold
          : FontWeight.normal,
        ),
        softWrap: false,
      ),
    );
  }

  Widget expansionMenu(String key, IconData icon, String label, List<Widget> children, ExpansibleController controller) {
    final isSelected = current.startsWith(key);
    
    return ExpansionTile(
      onExpansionChanged: (v) {
        if (v) {
          setState(
            () {
              isExpand = true;
            },
          );
        }
      },
      controller: controller,
      leading: Icon(
        icon,
        color: isSelected
        ? Colors.blue
        : Theme.of(context).primaryIconTheme.color,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
          ? Colors.blue
          : Theme.of(context).primaryIconTheme.color,
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
          : Theme.of(context).primaryIconTheme.color,
        ),
        softWrap: false,
      ),
    );
  }

  void collapseExpansions() {
    master.collapse();
    stock.collapse();
    transaction.collapse();
    report.collapse();
  }
}