import 'package:flutter/material.dart';

class Sync extends StatefulWidget {
  const Sync({super.key});

  @override
  State<Sync> createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  final TextEditingController
  partner = TextEditingController(),
  secret = TextEditingController();

  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        const Text('Sinkronisasi API'),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            spacing: 8.0,
            children: [
              const Row(
                spacing: 8.0,
                children: [
                  Icon(Icons.key),
                  Text('Kunci API'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    'Partner ID',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  TextField(
                    controller: partner,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                            () {
                              isHide = !isHide;
                            },
                          );
                        },
                        icon: Icon(
                          isHide
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: isHide,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    'Secret Key',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  TextField(
                    controller: secret,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                            () {
                              secret.clear();
                            },
                          );
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Aktivitas Terbaru'),
                DataTable(
                  columns: [
                    'TANGGAL',
                    'EVENT',
                    'STATUS',
                    'LOG',
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