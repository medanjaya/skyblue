import 'package:flutter/material.dart';
import 'package:skyblue/api.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DeviceInfoPlugin device = DeviceInfoPlugin();

  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard Overview'),
            Text(
              'Ringkasan operasional bulan ini',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 144.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.0,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('NAMA'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('PERANGKAT'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('TERAKHIR MASUK'),
                          ),
                        ],
                      ),
                      const Divider(),
                      StreamBuilder(
                        stream: sb
                        .from('user')
                        .select()
                        .asStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final users = snapshot.data!;
                            
                            if (users.isNotEmpty) {
                              return ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  final user = users[i];
                              
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(user['name']),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          spacing: 8.0,
                                          children: [
                                            Icon(
                                              switch (user['type'].toString()) {
                                                'android' => Icons.android,
                                                'ios' => Icons.phone_iphone,
                                                'linux' => Icons.terminal,
                                                'macos' => Icons.tablet_mac,
                                                'web' => Icons.language,
                                                'windows' => Icons.window,
                                                String() => Icons.question_mark,
                                              },
                                            ),
                                            user['device'].isNotEmpty
                                            ? Text(user['device'])
                                            : const Text(
                                              'Tidak dikenali',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          DateFormat('dd/MM/yyyy hh:mm:ss').format(
                                            DateTime.parse(user['last_signed_at']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, i) {
                                  return const Divider();
                                },
                                itemCount: users.length,
                              );
                            }

                            return const Expanded(
                              child: Center(
                                child: Text(
                                  'Tidak ada user untuk ditampilkan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                          else {
                            return const Expanded(
                              child: Center(
                                child: Text(
                                  'Sedang memperbarui aktivitas user..',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    spacing: 12.0,
                    children: [
                      const Row(
                        spacing: 8.0,
                        children: [
                          Icon(Icons.warning_amber),
                          Text('Stok Hampir Habis'),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 8.0,
                          children: List.generate( //TODO stok kritis
                            8,
                            (i) {
                              return Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(40, 135, 206, 235),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Column(
                                  children: [
                                    Text('Sonic Pro Pods'),
                                    Text(
                                      '0 units left',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Column(
                  spacing: 16.0,
                  children: [
                    Row(
                      spacing: 8.0,
                      children: [
                        Icon(Icons.history),
                        Text('Transaksi Terbaru'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('ID TRANSAKSI'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('TANGGAL'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('CUSTOMER'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('JUMLAH ITEM'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('STATUS'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('NOMINAL'),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                FutureBuilder(
                  future: getOrderList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final orders = snapshot.data!;
                      
                      if (orders.isNotEmpty) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            final order = orders[i];
                        
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(order['order_sn']),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat('dd/MM/yyyy hh:mm').format(
                                      DateTime.parse(order['create_time']),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('a'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(order['buyer_username']),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(order['order_status']),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('a'),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider();
                          },
                          itemCount: orders.length,
                        );
                      }

                      return const Expanded(
                        child: Center(
                          child: Text(
                            'Tidak ada riwayat untuk ditampilkan',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }
                    else {
                      return const Expanded(
                        child: Center(
                          child: Text(
                            'Sedang memperbarui riwayat transaksi..',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
