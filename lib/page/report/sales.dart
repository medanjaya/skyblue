import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'package:skyblue/api.dart';

// Helper function — taruh di class atau file utils
Color getOrderStatusColor(String status) {
  switch (status) {
    case 'COMPLETED':
      return const Color(0xFF3B6D11);
    case 'READY_TO_SHIP':
      return const Color(0xFF0F6E56);
    case 'PROCESSED':
      return const Color(0xFF185FA5);
    case 'TO_CONFIRM_RECEIVE':
      return const Color(0xFF185FA5);
    case 'SHIPPED':
      return const Color(0xFF534AB7);
    case 'UNPAID':
      return const Color(0xFFBA7517);
    case 'RETRY_SHIP':
      return const Color(0xFF854F0B);
    case 'TO_RETURN':
      return const Color(0xFF993556);
    case 'IN_CANCEL':
      return const Color(0xFFA32D2D);
    case 'CANCELLED':
      return const Color(0xFFA32D2D);
    default:
      return const Color(0xFF888780);
  }
}

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
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
    
    return StreamBuilder(
      stream: getOrderList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List sellers = snapshot.data!;
          
          for (final Map e in sellers) {
            e.addEntries(
              {'source': 'shopee'}.entries
            );
          }

          return StreamBuilder(
            stream: sb
            .from('order')
            .stream(
              primaryKey: ['id'],
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                display = sellers + snapshot.data!;

                final
                total = display.length,
                first = (current - 1) * rows,
                last = (first + rows > total) ? total : first + rows,
                pages = display.sublist(first, last);
                            
                if (display.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16.0,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Laporan Penjualan', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
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
                          Text(
                            'Review Penjualan dari ${
                              DateFormat('dd MMM yyyy').format(
                                DateTime.now().subtract(
                                  const Duration(days: 30),
                                ),
                              )
                            } - ${
                              DateFormat('dd MMM yyyy').format(
                                DateTime.now()
                              )
                            }',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 212.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16.0,
                          children: [
                            Column(
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Sales'),
                                        SizedBox(height: 8.0),
                                        Text('Rp 12.345.678', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 16),
                                            SizedBox(width: 4.0),
                                            Text('34% Dibanding bulan lalu'),
                                          ],//TODO icon dan warna harus bisa berubah dan persenan
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Order'),
                                        SizedBox(height: 8),
                                        Text('15.201', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.arrow_downward, color: Colors.redAccent, size: 16),
                                            SizedBox(width: 8),
                                            Text('5% Dibanding bulan lalu'),
                                          ],//TODO icon dan warna harus bisa berubah dan persenan
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kinerja', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          spacing: 8.0,
                                          children: [
                                            Icon(Icons.store_mall_directory_outlined),
                                            Text('Local'),
                                          ],
                                        ),
                                        Row(
                                          spacing: 8.0,
                                          children: [
                                            Text('561'),
                                            Icon(Icons.arrow_downward),
                                          ],
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      value: 0.08,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          spacing: 8.0,
                                          children: [
                                            Icon(Icons.shopping_bag_outlined),
                                            Text('Shopee'),
                                          ],
                                        ),
                                        Row(
                                          spacing: 8.0,
                                          children: [
                                            Text('1284'),
                                            Icon(Icons.arrow_upward),
                                          ],
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      value: 0.34,
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
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Tren Penjualan', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
                                        Row(
                                          spacing: 8.0,
                                          children: [
                                            Text('Local'),
                                            Text('Shopee'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text('Grafik disini'),
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
                          child: display.isNotEmpty
                          ? Column(
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
                                      items: [1, 2, 10, 25, 50].map(
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
                                          flex: 1,
                                          child: Text(
                                            'TANGGAL',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'CUSTOMER',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'SUMBER',
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
                                            'NOMINAL',
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
                                          final order = pages[i];
                                      
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(order['order_sn']),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  DateFormat('dd MMM yyyy  hh:mm:ss').format(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                      order['create_time'] * Duration.millisecondsPerSecond,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(order['buyer_username']),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(order['source']),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: List.generate(
                                                    order['item_list'].length,
                                                    (i) {
                                                      final item = order['item_list'][i];
                                      
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
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: getOrderStatusColor(order['order_status']).withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      spacing: 8,
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          size: 10,
                                                          color: getOrderStatusColor(order['order_status']),
                                                        ),
                                                        Text(
                                                          order['order_status'],
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: getOrderStatusColor(order['order_status'])
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  order['total_amount'] != 0
                                                  ? 'Rp. ${
                                                    NumberFormat.decimalPattern('id_ID')
                                                    .format(order['total_amount'])
                                                    .toString()
                                                  }'
                                                  : '-',
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
                          )
                          : const Center(
                            child: Text(
                              'Tidak ada riwayat transaksi untuk ditampilkan',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text(
                    'Tidak ada riwayat transaksi untuk ditampilkan',
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
                    'Sedang memperbarui riwayat transaksi fisik..',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }
            },
          );
        }
        else {
          return const Center(
            child: Text(
              'Sedang memperbarui riwayat transaksi marketplace..',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
      },
    );
  }
}
