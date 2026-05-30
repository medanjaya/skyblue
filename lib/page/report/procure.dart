import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Procure extends StatefulWidget {
  const Procure({super.key});

  @override
  State<Procure> createState() => _ProcureState();
}

class _ProcureState extends State<Procure> {
  final List<Map> debugItems = List.generate(
    64,
    (i) {
      return i.isOdd
      ? {
        'ID': 'SKB-001',
        'TIME': DateTime.now(),
        'CUSTOMER': 'James Rusli',
        'SOURCE': 'SHOPEE',
        'ITEM': ['a', 'b', 'c', 'd'],
        'PRICE': 1819999,
        'STATUS': 'Completed',
      }
      : {
        'ID': 'SKB-002',
        'TIME': DateTime.parse('2012-02-27'),
        'CUSTOMER': 'Daniel Wiyarta',
        'SOURCE': 'LOCAL',
        'ITEM': ['a'],
        'PRICE': 40000,
        'STATUS': 'On Progress',
      };
    },
  ); //TODO ganti ke api

  List display = [];
  int rows = 10, current = 1;

  @override
  void initState() {
    super.initState();
    display = List.from(debugItems);
  }

  @override
  Widget build(BuildContext context) {
    final
    total = display.length,
    first = (current - 1) * rows,
    last = (first + rows > total) ? total : first + rows,
    pages = display.sublist(first, last);

    return Column(
      spacing: 16.0,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Laporan Pembelian'),
                ElevatedButton(
                  onPressed: () {
                    //TODO
                  },
                  child: const Text('Bulan Berjalan'),
                ),
              ],
            ),
            const Text(
              'Review Pembelian dari 13 April 2026 - 13 Mei 2026',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Total Pembelian'),
              Text('328'),
              Text('12 Transaksi dalam Perjalanan'),
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
              spacing: 8.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8.0,
                      children: [
                        const Text('Show'),
                        Container(
                          height: 32.0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black54,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: DropdownButton(
                            onChanged: (v) {
                              setState(
                                () {
                                  rows = v!;
                                  current = 1;
                                },
                              );
                            },
                            value: rows,
                            underline: const SizedBox(),
                            items: [10, 25, 50].map(
                              (e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                );  
                              },
                            ).toList(),
                          ),
                        ),
                        const Text('entries'),
                      ],
                    ),
                    Row(
                      spacing: 8.0,
                      children: [
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.filter_list),
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable( //FIXME jarak kolom berubah ketika kosong
                      columns: [
                        'NOMOR PO',
                        'TANGGAL',
                        'CUSTOMER',
                        'SUMBER',
                        'BARANG',
                        'NOMINAL',
                        'STATUS',
                      ].map(
                        (e) {
                          return DataColumn(
                            label: Text(e),
                          );
                        }
                      ).toList(),
                      rows: pages.map(
                        (e) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(e['ID']),
                              ),
                              DataCell(
                                Text(e['TIME'].toString()),
                              ),
                              DataCell(
                                Text(e['CUSTOMER']),
                              ),
                              DataCell(
                                Text(e['SOURCE']),
                              ),
                              DataCell(
                                Text(NumberFormat.decimalPattern('id_ID').format(e['ITEM'].length).toString()),
                              ),
                              DataCell(
                                Text(NumberFormat.decimalPattern('id_ID').format(e['PRICE']).toString()),
                              ),
                              DataCell(
                                Text(
                                  e['STATUS'],
                                  style: TextStyle(
                                    color: e['STATUS'].toLowerCase() == 'cancelled'
                                    ? Colors.red
                                    : Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Showing ${total == 0 ? 0 : first + 1} to $last from $total entries'),
                    Row(
                      children: List.generate(
                        max(1, (total / rows).ceil()),
                        (i) {
                          final page = i + 1;
            
                          return InkWell(
                            onTap: () {
                              setState(
                                () {
                                  current = page;
                                }
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: current == page
                                ? const Color.fromARGB(120, 135, 206, 235)
                                : const Color.fromARGB(40, 135, 206, 235),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(page.toString()),
                            ),
                          );
                        }
                      ),
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