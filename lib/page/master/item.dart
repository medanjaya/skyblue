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
  ];

  List display = [];
  int rows = 10, current = 1;

  bool isAdd = false;

  @override
  Widget build(BuildContext context) {
    return isAdd
    ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tambah Barang',
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
                setState(
                  () {
                    isAdd = false;
                  },
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 36.0,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Informasi Produk',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 16.0,
                            children: [
                              labeledField(
                                label: 'Nama Barang',
                                hint: 'Masukkan Nama Barang',
                              ),
                              labeledField(
                                label: 'Kategori',
                                hint: 'Masukkan Kategori Barang',
                              ),
                              DropdownMenu(
                                onSelected: (v) {
                                  setState(
                                    () {
                                      //TODO
                                    }
                                  );
                                },
                                hintText: 'Tipe Penyesuaian',
                                inputDecorationTheme: InputDecorationThemeData(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 8.0,
                                  ),
                                  border: const OutlineInputBorder(),
                                  constraints: BoxConstraints.tight(
                                    const Size.fromHeight(37.0), //FIXME magic numbe
                                  ),
                                ),
                                expandedInsets: EdgeInsets.zero,
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(
                                    value: true,
                                    label: 'Penambahan',
                                  ),
                                  DropdownMenuEntry(
                                    value: false,
                                    label: 'Pengurangan',
                                  ),
                                ],
                              ),
                              /* Row( //TODO atribut
                                spacing: 16.0,
                                children: [
                                  Expanded(
                                    child: labeledField(
                                      label: 'Berat',
                                      hint: 'Masukkan Berat',
                                    ),
                                  ),
                                  Expanded(
                                    child: labeledField(
                                      label: 'Warna',
                                      hint: 'Warna',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 16.0,
                                children: [
                                  Expanded(
                                    child: labeledField(
                                      label: 'Kategori',
                                      hint: 'pilih category barang',
                                      suffixIcon: Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                  Expanded(
                                    child: labeledField(
                                      label: 'Brand',
                                      hint: 'pilih brand',
                                      suffixIcon: Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                ],
                              ), */
                              //FIXME variasi
                              labeledField(
                                label: 'Harga',
                                hint: 'Masukkan Harga',
                              ),
                              labeledField(
                                label: 'Minimum Pembelian',
                                hint: 'Masukkan minimum pembelian',
                              ),
                              labeledField(
                                label: 'Berat',
                                hint: 'Masukkan berat barang',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 22.0,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Deskripsi Barang',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            const Text(
                              'Deskripsi Produk',
                              style: TextStyle(
                                color: Color(0xFF007BFF),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            Expanded(
                              child: TextField(
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(14.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD8D8D8),
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF007BFF),
                                      width: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Image Product',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Note : ',
                                  style: TextStyle(
                                    color: Color(0xFF007BFF),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Format photos SVG, PNG, or JPG (Max size 4mb)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(fontSize: 13.0),
                          ),
                          const SizedBox(height: 18.0),
                          Row(
                            spacing: 16.0,
                            children: List.generate(
                              5,
                              (i) {
                                return Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.18,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 10.0,
                                      children: [
                                        const Icon(
                                          Icons.image_outlined,
                                          color: Color(0xFF007BFF),
                                          size: 28.0,
                                        ),
                                        Text(
                                          'Photo ${i + 1}',
                                          style: const TextStyle(
                                            color: Color(0xFF6A6A6A),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 148.0,
                        height: 48.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Save Product'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]
    )
    : Column(
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
                setState(
                  () {
                    isAdd = true;
                  },
                );
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
                          child: SelectionArea(
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
                                  
                                      return Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        //TODO edit item
                                                        setState(
                                                          () {
                                                            isAdd = true;
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        //TODO informasi item
                                                        setState(
                                                          () {
                                                            isAdd = true;
                                                          },
                                                        );
                                                      },
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
                                                child: Text(
                                                  item['price_info']?[0]['current_price'] != null
                                                  ? NumberFormat.decimalPattern('id_ID')
                                                  .format(item['price_info']?[0]['current_price'] ?? 0)
                                                  .toString()
                                                  : '',
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 16.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: item['item_status'] == 'NORMAL'
                                                      ? const Color.fromARGB(120, 0, 128, 0).withValues(alpha: 0.1)
                                                      : item['item_status'] == 'BANNED'
                                                      ? const Color.fromARGB(120, 255, 0, 0).withValues(alpha: 0.1)
                                                      : item['item_status'] == 'UNLIST'
                                                      ? const Color.fromARGB(120, 255, 165, 0).withValues(alpha: 0.1)
                                                      : item['item_status'] == 'REVIEWING'
                                                      ? const Color.fromARGB(120, 255, 255, 0).withValues(alpha: 0.1)
                                                      : const Color.fromARGB(120, 128, 128, 128).withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      spacing: 8,
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color: item['item_status'] == 'NORMAL'
                                                          ? Colors.green
                                                          : item['item_status'] == 'BANNED'
                                                          ? Colors.red
                                                          : item['item_status'] == 'UNLIST'
                                                          ? Colors.orange
                                                          : item['item_status'] == 'REVIEWING'
                                                          ? Colors.yellow
                                                          : Colors.grey,
                                                          size: 10,
                                                        ),
                                                        Text(
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                                                            flex: 2,
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

Widget labeledField({required String label, required String hint, IconData? suffixIcon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8.0,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(
        height: 52.0,
        child: TextField(
          readOnly: suffixIcon != null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: suffixIcon == null
            ? null
            : Icon(
              suffixIcon,
              color: const Color(0xFFA7A7A7),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFFD8D8D8),
                width: 1.4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF007BFF),
                width: 1.4,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}