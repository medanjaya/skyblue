import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:skyblue/api.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
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
      'key': 'BRAND',
      'name': 'MEREK',
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
    {
      'key': 'QUANTITY',
      'name': 'KUANTITAS',
      'controller': TextEditingController(),
    },
  ];

  List display = [];
  int rows = 10, current = 1;

  @override
  void initState() {
    super.initState();
    init();
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
        const Text('Data Stok'),
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
              const Text('Filter Data'),
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
              color: Theme.of(context).primaryColor,
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
                        )
                        .toList(),
                      ),
                    ),
                    const Text('entries'),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('ACTION'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('KODE'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('NAMA BARANG'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('KATEGORI'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('MEREK'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('HARGA'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('STATUS'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('KUANTITAS'),
                          ),
                        ],
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: getItemList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final items = snapshot.data!;
                            
                            if (items.isNotEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    final item = items[i];
                                
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
                                                  Icons.edit_note,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {}, //TODO informasi item
                                                icon: const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.blue,
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
                                          child: Text(item['brand'].toString()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item['price_info'].toString(),
                                            /* NumberFormat.decimalPattern('id_ID')
                                            .format(item['price_info'][0]['current_price'])
                                            .toString(), */
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(item['item_status']),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(item['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? ''),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, i) {
                                    return const Divider();
                                  },
                                  itemCount: pages.length,
                                ),
                              );
                            }

                            return const Expanded(
                              child: Center(
                                child: Text(
                                  'Tidak ada barang untuk ditampilkan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                          else {
                            return const Expanded(
                              child: Center(
                                child: Text(
                                  'Sedang memperbarui daftar barang..',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
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
        display = List.from( //FIXME
          display.where(
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

  void init() async {
    final items = await getItemList();

    setState(
      () {
        display = List.from(items);
      }
    );
  }
}
