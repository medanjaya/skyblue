import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Procure extends StatefulWidget {
  const Procure({super.key});


  @override
  State<Procure> createState() => _ProcureState();
}

class _ProcureState extends State<Procure> {
  List display = [];
  int rows = 10, current = 1, selectedPeriod = 7;

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
    final sb = Supabase.instance.client;

    return Column(
      spacing: 16.0,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Laporan Pembelian', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007BFF),
                  ),
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    Container(
                      height: 28.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedPeriod,
                          items: const [
                            DropdownMenuItem(
                              value: 7,
                              child: Text('Last 7 Days'),
                            ),
                            DropdownMenuItem(
                              value: 30,
                              child: Text('Last 1 month'),
                            ),
                            DropdownMenuItem(
                              value: 90,
                              child: Text('Last 3 months'),
                            ),
                            DropdownMenuItem(
                              value: 180,
                              child: Text('Last 6 months'),
                            ),
                            DropdownMenuItem(
                              value: 365,
                              child: Text('Last 1 year'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedPeriod = value;
                                current = 1;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        //TODO
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Export CSV'),
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'Review Pembelian dari 13 April 2026 - 13 Mei 2026',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Total Pembelian'),
              SizedBox(height: 8),
              Text('328'),
              SizedBox(height: 8),
              Text('12 Transaksi dalam Perjalanan'),
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
              .from('procure')
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
                      spacing: 16.0,
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
                        Column(
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'NO PO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
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
                                    'BARANG',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            display.isNotEmpty
                            ? ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                final procure = pages[i];
                            
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(procure['id'].toString()),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        DateFormat('dd MMM yyyy hh:mm:ss').format(
                                          DateTime.parse(procure['created_at']),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          procure['item_list'].length,
                                          (i) {
                                            final item = procure['item_list'][i];
                            
                                            return Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text('x${item['model_quantity_purchased']}'),
                                                ),
                                                Expanded(
                                                  flex: 8,
                                                  child: Text(item['item_name']),
                                                ),
                                              ],
                                            );
                                          }
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
                            )
                            : const Expanded(
                              child: Center(
                                child: Text(
                                  'Tidak ada riwayat pembelian untuk ditampilkan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Showing ${total == 0 ? 0 : first + 1} to $last from $total entries'),
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
                      'Tidak ada riwayat pembelian untuk ditampilkan',
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
                      'Sedang memperbarui riwayat pembelian..',
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
