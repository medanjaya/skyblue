import 'dart:math';

import 'package:flutter/material.dart';

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  final List<Map> debugUsers = List.generate(
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

  final user = TextEditingController();

  List display = [];
  int rows = 5, current = 1;

  @override
  void initState() {
    super.initState();
    display = List.from(debugUsers);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                'Data User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO tambah user
              },
              child: const Text('Tambah User'),
            ),
          ],
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
                            items: [5, 10, 20].map(
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
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.0,
                        children: [
                          const Text(
                            'USER ID / NAMA',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                            ),
                          ),
                          TextField(
                            onChanged: (v) {
                              //TODO filter by name
                            },
                            controller: user,
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
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable( //FIXME jarak kolom berubah ketika kosong
                      columns: [
                        'ACTION',
                        'USER ID',
                        'NAMA',
                        'USERNAME',
                        'ROLE',
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
}