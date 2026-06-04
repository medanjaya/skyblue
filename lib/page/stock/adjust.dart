import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:skyblue/api.dart';

class Adjust extends StatefulWidget {
  const Adjust({super.key});

  @override
  State<Adjust> createState() => _AdjustState();
}

class _AdjustState extends State<Adjust> {
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
        const Text('Penyesuaian Stok'),
        SizedBox(
          height: 288.0,
          child: Row(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8.0,
                    children: [
                      Text('Pilih Produk'),
                      SizedBox(height: 64.0, child: TextField()),
                      Expanded(
                        child: Center(
                          child: Text(
                            'pilih produk untuk melihat informasi',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
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
                  child: Column(
                    spacing: 8.0,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Detail Penyesuaian'),
                          Text(
                            'Pilih produk untuk penyesuaian stok',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 16.0,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 64.0, child: TextField()),
                                  Text('Prediksi Jumlah Stok'),
                                  Text('-'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 64.0, child: TextField()),
                                  Text('Keterangan'),
                                  SizedBox(height: 64.0, child: TextField()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
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
                                          child: Text(item['brand']['original_brand_name']),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            NumberFormat.decimalPattern('id_ID')
                                            .format(item['price_info']?[0]['current_price'] ?? 0)
                                            .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(item['item_status']),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(item['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? '?'),
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
  
  void init() async {
    final items = await getItemList();

    setState(
      () {
        display = List.from(items);
      }
    );
  }
}