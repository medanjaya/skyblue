import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'package:skyblue/api.dart';

class Adjust extends StatefulWidget {
  const Adjust({super.key});

  @override
  State<Adjust> createState() => _AdjustState();
}

class _AdjustState extends State<Adjust> {
  final TextEditingController
  search = TextEditingController(),
  type = TextEditingController(),
  amount = TextEditingController(),
  note = TextEditingController();

  List display = [];
  int rows = 10, current = 1;

  int? value, operand, predict;
  bool? operator;
  
  Map select = {};
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        const Text('Penyesuaian Stok', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color : Color(0xFF007BFF)
        )),
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
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 8.0,
                        children: [
                          const Text(
                            'Pilih Barang',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color : Color(0xFF007BFF),
                            ),
                          ),
                          TextField(
                            onChanged: (v) {
                              setState(() {});
                            },
                            controller: search,
                            decoration: const InputDecoration(
                              hintText: 'Cari berdasarkan nama..',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Expanded(
                            child: select.isNotEmpty
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8.0,
                              children: [
                                const Row(
                                  spacing: 8.0,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: Color(0xFF007BFF),
                                    ),
                                    Text(
                                      'Detail Info Produk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF007BFF),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'ID Produk: ${select['item_id']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Nama Produk: ${select['item_name']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Stok Saat Ini: ${select['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? '?'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : const Center(
                              child: Text(
                                'Pilih barang untuk melihat informasi',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (search.text.isNotEmpty) Positioned(
                        top: 76.0, //FIXME magic numbe
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          constraints: const BoxConstraints(
                            maxHeight: 192.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: StreamBuilder(
                            stream: getItemList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final items = List.from(
                                  snapshot.data!.where(
                                    (e) {
                                      return e['item_name'].toString().toLowerCase().contains(
                                        search.text.toLowerCase(),
                                      );
                                    },
                                  ),
                                );

                                if (items.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      final item = items[i];
                                      
                                      return ListTile(
                                        onTap: () {
                                          setState(
                                            () {
                                              select = item;
                                              value = select['stock_info_v2']?['summary_info']['total_available_stock'];
                                              operate();
                                              
                                              search.clear();
                                            }
                                          );
                                        },
                                        dense: true,
                                        title: Text(item['item_name']),
                                        subtitle: Text('Stok: ${item['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? '?'}'),
                                      );
                                    },
                                    itemCount: items.length,
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
                          Text('Detail Penyesuaian', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20, color : Color(0xFF007BFF)
                          )),
                          Text(
                            'Pilih produk untuk penyesuaian stok',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16.0,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    spacing: 16.0,
                                    children: [
                                      TextField(
                                        onTap: () {
                                          setState(
                                            () {
                                              isExpand = true;   
                                            }
                                          );
                                        },
                                        controller: type,
                                        decoration: const InputDecoration(
                                          labelText: 'Tipe Penyesuaian',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 8.0,
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                        readOnly: true,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        spacing: 8.0,
                                        children: [
                                          const Text('Prediksi Jumlah Stok'),
                                          Text(
                                            predict != null
                                            ? predict.toString()
                                            : '-',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (isExpand) Positioned(
                                    top: 38.0, //FIXME also magic numbe
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      constraints: const BoxConstraints(
                                        maxWidth: 256.0,
                                        maxHeight: 192.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemBuilder: (context, i) {                                       
                                          final isEven = i.isEven;

                                          return ListTile(
                                            onTap: () {
                                              setState(
                                                () {
                                                  type.text = isEven
                                                  ? 'Penambahan'
                                                  : 'Pengurangan';
                                                  
                                                  operator = isEven;
                                                  operate();

                                                  isExpand = false;
                                                }
                                              );
                                            },
                                            dense: true,
                                            title: Text(
                                              isEven
                                              ? 'Penambahan'
                                              : 'Pengurangan',
                                            )
                                          );
                                        },
                                        itemCount: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 16.0,
                                children: [
                                  TextField(
                                    onChanged: (v) {
                                      setState(
                                        () {
                                          operand = int.tryParse(v);
                                          operate();
                                        },
                                      );
                                    },
                                    controller: amount,
                                    decoration: const InputDecoration(
                                      labelText: 'Jumlah',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 8.0,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    spacing: 8.0,
                                    children: [
                                      const Text('Keterangan'),
                                      TextField(
                                        onChanged: (v) {
                                          setState(() {});
                                        },
                                        controller: note,
                                        decoration: const InputDecoration(
                                          hintText: '(Opsional)',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 8.0,
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 3,
                                        minLines: 3,
                                      ),
                                    ],
                                  ),
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
                            onPressed: () {
                              clear();
                            },
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              updateStock(
                                select['item_id'],
                                predict!,
                              )
                              .then(
                                (r) {
                                  sb.from('adjust').insert(
                                    {
                                      'type': operator,
                                      'amount': operand,
                                      'note': note.text,
                                      'item': select['item_id'],
                                    },
                                  )
                                  .then(
                                    (r) {
                                      clear();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('Barang berhasil disesuaikan.'),
                                          ),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: const Text('Simpan'), //TODO konfirmasi
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
            child: StreamBuilder(
              stream: sb
              .from('adjust')
              .stream(
                primaryKey: ['id'],
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  display = snapshot.data!;

                  final
                  total = display.length,
                  first = (current - 1) * rows,
                  last = (first + rows > total) ? total : first + rows,
                  pages = display.sublist(first, last);
                  
                  if (display.isNotEmpty) {
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
                                      'ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'TANGGAL',
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
                                      'TIPE',
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
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'KETERANGAN',
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
                                    final adjust = pages[i];
                                
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(adjust['id'].toString()),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            DateFormat('dd/MM/yyyy hh:mm:ss').format(
                                              DateTime.parse(adjust['created_at']),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(adjust['item'].toString()),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            adjust['type']
                                            ? 'Pengurangan'
                                            : 'Penambahan',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(adjust['amount'].toString()),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(adjust['note']),
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
                      'Tidak ada penyesuaian untuk ditampilkan',
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
                      'Sedang memperbarui daftar penyesuaian..',
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

  void operate() {
    predict = value != null && operand != null && operator != null
    ? operator!
      ? value! + operand!
      : value! - operand!
    : null;
  }

  void clear() {
    setState(
      () {
        search.clear();
        type.clear();
        amount.clear();
        note.clear();

        select = {};
        value = null;
        operand = null;
        operator = null;
        predict = null;
      }
    );
  }
}