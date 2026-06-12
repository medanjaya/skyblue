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

  int totalPages() {
    return (display.length / rows).ceil();
  }


  List<int> paginationList() {

    final pages = totalPages();

    if (pages <= 5) {
      return List.generate(
        pages,
        (i) => i + 1,
      );
    }


    if (current <= 3) {
      return [
        1,
        2,
        3,
        -1,
        pages,
      ];
    }


    if (current >= pages - 2) {
      return [
        1,
        -1,
        pages - 2,
        pages - 1,
        pages,
      ];
    }


    return [
      1,
      -1,
      current,
      -1,
      pages,
    ];
  }

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
                            )
                            .toList(),
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
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('NOMOR PO'),
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
                            child: Text('SUMBER'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('BARANG'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('NOMINAL'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('STATUS'),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, i) {
                            final item = pages[i];

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(item['ID']),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(item['TIME'].toString()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(item['CUSTOMER']),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(item['SOURCE']),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    NumberFormat.decimalPattern('id_ID')
                                    .format(item['ITEM'].length)
                                    .toString(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    NumberFormat.decimalPattern('id_ID')
                                    .format(item['PRICE'])
                                    .toString(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    item['STATUS'],
                                    style: TextStyle(
                                      color: item['STATUS'].toLowerCase() == 'cancelled'
                                      ? Colors.red
                                      : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider();
                          },
                          itemCount: pages.length,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Showing ${total == 0 ? 0 : first + 1} to $last from $total entries'),
                    Row(
                      spacing: 4,
                      children: [
                        // tombol previous
                        InkWell(
                          onTap: current > 1
                          ? () {
                            setState(() {
                              current = current - 1;
                            });
                          }
                          : null,

                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.chevron_left,
                              size: 20,
                            ),
                          ),
                        ),

                        ...paginationList().map(
                          (page) {

                            if(page == -1){
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('...'),
                              );
                            }

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  current = page;
                                });
                              },

                              child: Container(
                                width: 32,
                                height: 32,

                                margin: const EdgeInsets.only(
                                  left: 4,
                                ),

                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  color: current == page
                                  ? const Color(0xFF007BFF)
                                  : Colors.transparent,

                                  borderRadius:
                                    BorderRadius.circular(6),
                                ),

                                child: Text(
                                  '$page',

                                  style: TextStyle(
                                    color: current == page
                                    ? Colors.white
                                    : Colors.black87,

                                    fontWeight:
                                    current == page
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),


                        InkWell(
                          onTap: current < (total / rows).ceil()
                          ? () {
                              setState(() {
                                current = current + 1;
                              });
                            }
                          : null,

                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.chevron_right,
                              size: 20,
                            ),
                          ),
                        ),
                      ]
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
