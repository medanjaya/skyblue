import 'dart:math';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Adjust extends StatefulWidget {
  const Adjust({super.key});

  @override
  State<Adjust> createState() => _AdjustState();
}

class _AdjustState extends State<Adjust> {
  List display = [];
  int rows = 10, current = 1;

  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8.0,
                    children: [
                      const Text('Pilih Produk'),
                      TextField(
                        onChanged: (v) {
                          setState(() {});
                        },
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
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Pilih produk untuk melihat informasi',
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
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 16.0,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8.0,
                                children: [
                                  TextField(
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Tipe Penyesuaian',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 8.0,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const Text('Prediksi Jumlah Stok'),
                                  const Text('-'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8.0,
                                children: [
                                  TextField(
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Jumlah',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 8.0,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const Text('Keterangan'),
                                  TextField(
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: '(Opsional)',
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
            child: StreamBuilder(
              stream: sb
              .from('adjust')
              .stream(
                primaryKey: ['id'],
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final display = snapshot.data!;

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
}