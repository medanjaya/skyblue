import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Laporan Penjualan'),
                Row(
                  spacing: 8.0,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //TODO
                      },
                      child: const Text('Last 30 Days'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //TODO
                      },
                      child: const Text('Export to CSV'),
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'Review Penjualan dari 13 April 2026 - 13 Mei 2026',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 212.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.0,
            children: [
              Column(
                spacing: 16.0,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Column(
                        children: [
                          Text('Total Sales'),
                          Row(
                            children: [
                              Icon(Icons.arrow_upward),
                              Text('34%'),
                            ],
                          ),
                          Text('Dibanding April 2026.')
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
                      child: const Column(
                        children: [
                          Text('Total Order'),
                          Row(
                            children: [
                              Icon(Icons.arrow_downward),
                              Text('5%'),
                            ],
                          ),
                          Text('Dibanding April 2026.')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kinerja'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 8.0,
                            children: [
                              Icon(Icons.store_mall_directory_outlined),
                              Text('Local'),
                            ],
                          ),
                          Row(
                            spacing: 8.0,
                            children: [
                              Text('561'),
                              Icon(Icons.arrow_downward),
                            ],
                          )
                        ],
                      ),
                      LinearProgressIndicator(
                        value: 0.08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 8.0,
                            children: [
                              Icon(Icons.shopping_bag_outlined),
                              Text('Shopee'),
                            ],
                          ),
                          Row(
                            spacing: 8.0,
                            children: [
                              Text('1284'),
                              Icon(Icons.arrow_upward),
                            ],
                          )
                        ],
                      ),
                      LinearProgressIndicator(
                        value: 0.34,
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tren Penjualan'),
                          Row(
                            spacing: 8.0,
                            children: [
                              Text('Local'),
                              Text('Shopee'),
                            ],
                          ),
                        ],
                      ),
                      Text('Grafik disini'),
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
                        'ID TRANSAKSI',
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