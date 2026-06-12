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
      'key': 'category_id', //FIXME
      'name': 'KATEGORI',
      'controller': TextEditingController(),
    },
    {
      'key': 'BRAND', //FIXME
      'name': 'MEREK',
      'controller': TextEditingController(),
    },
  ];

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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        const Text('Data Stok', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
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
              const Text('Filter Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
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
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Filter'),
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

                  items.sort(
                    (a, b) {
                      return a['item_name'].toLowerCase().compareTo(
                        b['item_name'].toLowerCase(),
                      );
                    },
                  );

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
                                    flex: 2,
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
                                      'MEREK',
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
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'KUANTITAS',
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
                                
                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                onPressed: () {}, //TODO informasi item
                                                alignment: Alignment.centerLeft,
                                                icon: const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.blue,
                                                ),
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
                                              flex: 2,
                                              child: FutureBuilder(
                                                future: fetchCategoryList(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final List categories = snapshot.data!;
                                                    
                                                    return Text(
                                                      categories[
                                                        categories.indexWhere(
                                                          (e) => e['category_id'] == item['category_id'],
                                                        )
                                                      ]
                                                      ['display_category_name'],
                                                    );
                                                  }
                                                  else {
                                                    return const Text(
                                                      'Memuat..',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(item['brand']['original_brand_name'].toString()),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                item['price_info']?[0]['current_price'] != null
                                                ? 'Rp. ${
                                                  NumberFormat.decimalPattern('id_ID')
                                                  .format(item['price_info']?[0]['current_price'] ?? 0)
                                                  .toString()
                                                }'
                                                : 'Variatif',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: (item['item_status'] == 'NORMAL')
                                                    ? const Color.fromARGB(120, 0, 128, 0).withValues(alpha: 0.1)
                                                    : (item['item_status'] == 'HABIS')
                                                    ? const Color.fromARGB(120, 255, 0, 0).withValues(alpha: 0.1)
                                                    : (item['item_status'] == 'MENIPIS')
                                                    ? const Color.fromARGB(120, 255, 165, 0).withValues(alpha: 0.1)
                                                    : const Color.fromARGB(120, 128, 128, 128).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        color: item['item_status'] == 'NORMAL'
                                                        ? Colors.green
                                                        : (item['item_status'] == 'HABIS')
                                                        ? Colors.red
                                                        : (item['item_status'] == 'MENIPIS')
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                        size: 10,
                                                      ),
                                                      const SizedBox(width: 4.0,),
                                                      Text(item['item_status'], style: TextStyle(
                                                        color: item['item_status'] == 'NORMAL'
                                                        ? Colors.green
                                                        : (item['item_status'] == 'HABIS')
                                                        ? Colors.red
                                                        : (item['item_status'] == 'MENIPIS')
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                        fontWeight: FontWeight.w600,),  
                                                      ),
                                                    ],
                                                  )
                                                ) 
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(item['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? ''),
                                            ),
                                          ],
                                        ),
                                        if (item['has_model']) StreamBuilder(
                                          stream: getModelList(item['item_id']),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final models = snapshot.data!;

                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemBuilder: (context, j) {
                                                  final model = models[j];
                                                  
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Expanded(
                                                          flex: 1,
                                                          child: SizedBox(),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(model['model_id'].toString()),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(model['model_name']),
                                                        ),
                                                        const Expanded(
                                                          flex: 3,
                                                          child: SizedBox(),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            model['price_info']?[0]['current_price'] != null
                                                            ? NumberFormat.decimalPattern('id_ID')
                                                            .format(model['price_info']?[0]['current_price'] ?? 0)
                                                            .toString()
                                                            : '',
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          flex: 1,
                                                          child: SizedBox(),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(model['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? ''),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                itemCount: models.length,
                                              );
                                            }
                                            else {
                                              return const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                ),
                                                child: Text(
                                                  'Memuat..',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
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
