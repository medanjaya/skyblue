import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DeviceInfoPlugin device = DeviceInfoPlugin();

  @override
  Widget build(BuildContext context) {
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ //TODO cek status semua user
                      Text('Device'),
                      Text('Type'),
                      Text('Last Signed In'),
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
                const Text('Transaksi Terbaru'),
                DataTable(
                  columns: [
                    'ID TRANSAKSI',
                    'TANGGAL',
                    'CUSTOMER',
                    'JUMLAH ITEM',
                    'STATUS',
                    'NOMINAL',
                  ]
                  .map(
                    (e) {
                      return DataColumn(
                        label: Text(e),
                      );
                    }
                  )
                  .toList(),
                  rows: [
                    const DataRow( //TODO transaksi terbaru
                      cells: [
                        DataCell(
                          Text('a'),
                        ),
                        DataCell(
                          Text('a'),
                        ),
                        DataCell(
                          Text('a'),
                        ),
                        DataCell(
                          Text('a'),
                        ),
                        DataCell(
                          Text('a'),
                        ),
                        DataCell(
                          Text('a'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}