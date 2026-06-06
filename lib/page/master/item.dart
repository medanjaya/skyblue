import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:skyblue/api.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final List<Map> fields = [
    {
      'key': 'item_id',
      'name': 'KODE',
      'controller': TextEditingController(),
    },
    {
      'key': 'item_name',
      'name': 'NAMA BARANG',
      'controller': TextEditingController(),
    },
    {
      'key': 'category_id',
      'name': 'KATEGORI',
      'controller': TextEditingController(),
    },
    {
      'key': 'PRICE', //FIXME
      'name': 'HARGA',
      'controller': TextEditingController(),
    },
    {
      'key': 'item_status',
      'name': 'STATUS',
      'controller': TextEditingController(),
    },
  ];

  List display = [];
  int rows = 10, current = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Data Barang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              onPressed: () {
                //TODO tambah barang, cek versi sebelumnya
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Baru'),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              const Text(
                'Filter Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007BFF),
                ),
              ),
              Row(
                spacing: 16.0,
                children: List.generate(
                  fields.indexWhere(
                    (e) => e['key'] == 'PRICE',
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
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          TextField(
                            onChanged: (v) {
                              setState(() {});
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
                child: TextButton.icon(
                  onPressed: () {
                    for (final e in fields) {
                      e['controller'].clear();
                    }
                    
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh, size: 16.0),
                  label: const Text(
                    'Reset Filter',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
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
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder(
              stream: getItemList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List items = snapshot.data!;

                  display = List.from(
                    items.where(
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

                  final
                  total = display.length,
                  first = (current - 1) * rows,
                  last = (first + rows > total) ? total : first + rows,
                  pages = display.sublist(first, last);
                  
                  if (items.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8.0,
                      children: [
                        Row(
                          spacing: 8.0,
                          children: [
                            const Text(
                              'Show',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
                                      child: Text(
                                        e.toString(),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );  
                                  },
                                )
                                .toList(),
                              ),
                            ),
                            const Text(
                              'entries',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
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
                                    child: Text(
                                      'ACTION',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'KODE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'NAMA BARANG',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'KATEGORI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'HARGA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'STATUS',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    final item = pages[i];
                                
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {}, //TODO edit item
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {}, //TODO informasi item
                                                icon: const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.blue,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(item['item_id'].toString()),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(item['item_name']),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(item['category_id'].toString()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            NumberFormat.decimalPattern('id_ID')
                                            .format(item['price_info']?[0]['current_price'] ?? 0)
                                            .toString(),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                              horizontal: 16.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: item['item_status'] == 'NORMAL'
                                              ? const Color.fromARGB(120, 0, 128, 0).withOpacity(0.1)
                                              : item['item_status'] == 'BANNED'
                                              ? const Color.fromARGB(120, 255, 0, 0).withOpacity(0.1)
                                              : item['item_status'] == 'UNLIST'
                                              ? const Color.fromARGB(120, 255, 165, 0).withOpacity(0.1)
                                              : item['item_status'] == 'REVIEWING'
                                              ? const Color.fromARGB(120, 255, 255, 0).withOpacity(0.1)
                                              : const Color.fromARGB(120, 128, 128, 128).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Text(
                                              item['item_status'],
                                              style: TextStyle(
                                                color: item['item_status'] == 'NORMAL'
                                                ? Colors.green
                                                : item['item_status'] == 'BANNED'
                                                ? Colors.red
                                                : item['item_status'] == 'UNLIST'
                                                ? Colors.orange
                                                : item['item_status'] == 'REVIEWING'
                                                ? Colors.yellow
                                                : Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
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
                            Text(
                              'Showing ${total == 0 ? 0 : first + 1} to $last from $total entries',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
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
                    );
                  }
                  return const Center(
                    child: Text(
                      'Tidak ada barang untuk ditampilkan',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
                else {
                  return const Center(
                    child: Text(
                      'Sedang memperbarui daftar barang..',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
