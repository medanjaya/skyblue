import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final List<Map> fields = [
    {
      'key': 'CODE',
      'name': 'KODE',
      'controller': TextEditingController(),
    },
    {
      'key': 'NAME',
      'name': 'NAMA BARANG',
      'controller': TextEditingController(),
    },
    {
      'key': 'CATEGORY',
      'name': 'KATEGORI',
      'controller': TextEditingController(),
    },
    {
      'key': 'PRICE',
      'name': 'HARGA',
      'controller': TextEditingController(),
    },
    {
      'key': 'STATUS',
      'name': 'STATUS',
      'controller': TextEditingController(),
    },
  ];

  final List<Map> debugItems = List.generate(
    100,
    (i) {
      return i.isOdd
      ? {
        'CODE': 'SKB-001',
        'NAME': 'Kaos Polos Blue',
        'CATEGORY': 'Atasan',
        'PRICE': 40000,
        'STATUS': 'Tersedia',
      }
      : {
        'CODE': 'SKB-002',
        'NAME': 'Hoodie Navy',
        'CATEGORY': 'Jaket',
        'PRICE': 125000,
        'STATUS': 'Habis',
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Data Barang'),
            TextButton(
              onPressed: () {
                //TODO tambah barang, cek versi sebelumnya
              },
              child: const Text('Tambah Baru'),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(30, 135, 206, 235),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              const Text('Filter Data'),
              Row(
                spacing: 16.0,
                children: List.generate(
                  fields.length,
                  (i) {
                    final field = fields[i];
    
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.0,
                        children: [
                          Text(
                            field['name'],
                            style: const TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                          TextField(
                            onChanged: (v) {
                              filterItems();
                            },
                            controller: field['controller'],
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    for (final e in fields) {
                      e['controller'].clear();
                    }
                    
                    filterItems();
                  },
                  child: const Text('Reset Filter'),
                ),
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
              spacing: 8.0,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable( //FIXME jarak kolom berubah ketika kosong
                      columns: [
                        'ACTION',
                        'KODE',
                        'NAMA BARANG',
                        'KATEGORI',
                        'HARGA',
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
                                IconButton(
                                  onPressed: () {}, //TODO dialog informasi item
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: Colors.blue,
                                  ), 
                                ),
                              ),
                              DataCell(
                                Text(e['CODE']),
                              ),
                              DataCell(
                                Text(e['NAME']),
                              ),
                              DataCell(
                                Text(e['CATEGORY']),
                              ),
                              DataCell(
                                Text(NumberFormat('###,000').format(e['PRICE']).toString()),
                              ),
                              DataCell(
                                Text(
                                  e['STATUS'],
                                  style: TextStyle(
                                    color: e['STATUS'].toLowerCase() == 'habis'
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

  void filterItems() {
    setState(
      () {
        display = List.from(
          debugItems.where(
            (e) {
              final result = [];
              
              for (final f in fields) {
                result.add(
                  e[f['key']].toString().toLowerCase().contains(
                    f['controller'].text.toLowerCase(),
                  ),
                );
              }
              
              return result.every(
                (e) => e == true,
              );
            },
          ),
        );
      },
    );
  }
}