import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  final List<Map> debugItems = List.generate(
    10,
    (i) {
      return i.isOdd
      ? {
        'UUID': '1234-5678-9010-1112',
        'NAME': 'James Rusli',
        'EMAIL': 'james.rusli@skyblue.co.id',
        'ROLE': 'Administrator',
        'STATUS': 'Aktif',
      }
      : {
        'UUID': '1314-1516-1718-0987',
        'NAME': 'Aditya Saputra',
        'EMAIL': 'aditya.saputra@skyblue.co.id',
        'ROLE': 'POS',
        'STATUS': 'Nonaktif',
      };
    },
  ); //TODO ganti ke supabase

  final TextEditingController name = TextEditingController();

  List display = [];
  int rows = 5, current = 1;

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
            const Text('Data User'),
            TextButton(
              onPressed: () {
                //TODO tambah user, cek versi sebelumnya
              },
              child: const Text('Tambah Baru'),
            ),
          ],
        ),
        SizedBox(
          height: 72.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.0,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      const Text('Total User'),
                      Text(NumberFormat('###,000').format(1248).toString()),
                    ],
                  ),
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
                    children: [
                      const Text('Aktif Saat Ini'),
                      Text(NumberFormat('###,000').format(42).toString()),
                    ],
                  ),
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
                    children: [
                      const Text('Admin'),
                      Text(NumberFormat('###,000').format(23).toString()),
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
              color: Colors.white,
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
                    SizedBox(
                      width: 256.0,
                      child: TextField(
                        onChanged: (v) {
                          setState(
                            () {
                              display = List.from(
                                debugItems.where(
                                  (e) {
                                    return e['NAME'].toString().toLowerCase().contains(
                                      name.text.toLowerCase(),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Nama User',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable( //FIXME jarak kolom berubah ketika kosong
                      columns: [
                        'ACTION',
                        'UUID',
                        'NAMA USER',
                        'EMAIL',
                        'PERAN',
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
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {}, //TODO edit user
                                      icon: const Icon(
                                        Icons.edit_note,
                                        color: Colors.red,
                                      ), 
                                    ),
                                    IconButton(
                                      onPressed: () {}, //TODO informasi user
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: Colors.blue,
                                      ), 
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(e['UUID']),
                              ),
                              DataCell(
                                Text(e['NAME']),
                              ),
                              DataCell(
                                Text(e['EMAIL']),
                              ),
                              DataCell(
                                Text(e['ROLE']),
                              ),
                              DataCell(
                                Text(
                                  e['STATUS'],
                                  style: TextStyle(
                                    color: e['STATUS'].toLowerCase() == 'nonaktif'
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