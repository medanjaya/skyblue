import 'dart:math';

import 'package:flutter/material.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  final List<Map> fields = [
    {
      'key': 'CODE',
      'name': 'KODE BARANG',
      'controller': TextEditingController(),
    },
    {
      'key': 'NAME',
      'name': 'NAMA BARANG',
      'controller': TextEditingController(),
    },
    {
      'key': 'BRAND',
      'name': 'MEREK',
      'controller': TextEditingController(),
    },
    {
      'key': 'TYPE',
      'name': 'TIPE',
      'controller': TextEditingController(),
    },
    {
      'key': 'STATUS',
      'name': 'STATUS',
      'controller': TextEditingController(),
    },
    {
      'key': 'QUANTITY',
      'name': 'QTY',
      'controller': TextEditingController(),
    },
    {
      'key': 'UNIT',
      'name': 'SATUAN',
      'controller': TextEditingController(),
    },
    {
      'key': 'DETAIL',
      'name': 'KETERANGAN',
      'controller': TextEditingController(),
    },
  ];

  final List<Map> debugItems = List.generate(
    2,
    (i) {
      return i.isOdd
      ? {
        'CODE': 'SKB-001',
        'NAME': 'Kaos Polos Blue',
        'BRAND': 'Skyblue',
        'TYPE': 'Atasan',
        'STATUS': 'Tersedia',
        'QUANTITY': 100,
        'UNIT': 'Pcs',
        'DETAIL': '',
      }
      : {
        'CODE': 'SKB-002',
        'NAME': 'Hoodie Navy',
        'BRAND': 'Skyblue',
        'TYPE': 'Jaket',
        'STATUS': 'Habis',
        'QUANTITY': 50,
        'UNIT': 'Pcs',
        'DETAIL': '',
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
      spacing: 20.0,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 135, 206, 235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Data Stok',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              const Text(
                'Filter Data',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              Row(
                spacing: 16.0,
                children: List.generate(
                  fields.indexWhere(
                    (e) => e['key'] == 'QUANTITY',
                  ),
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
                              color: Colors.grey,
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
                child: OutlinedButton(
                  onPressed: () {
                    for (final e in fields) {
                      e['controller'].clear();
                    }
                    
                    filterItems();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.black,
                    ),
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
              border: Border.all(
                color: Colors.grey.shade300,
              ),
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
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
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
                        'KODE BARANG',
                        'NAMA BARANG',
                        'MEREK',
                        'TIPE',
                        'STATUS',
                        'QTY',
                        'SATUAN',
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
                                Text(e['BRAND']),
                              ),
                              DataCell(
                                Text(e['TYPE']),
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
                              DataCell(
                                Text(e['QUANTITY'].toString()),
                              ),
                              DataCell(
                                Text(e['UNIT']),
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
                                ? const Color.fromARGB(255, 135, 206, 235)
                                : Colors.grey,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
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