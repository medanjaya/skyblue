import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'package:skyblue/api.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  final TextEditingController
  search = TextEditingController(),
  name = TextEditingController();

  List orders = [];
  
  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;

    return StreamBuilder(
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
                    
          items.sort(
            (a, b) {
              return a['item_name'].toLowerCase().compareTo(
                b['item_name'].toLowerCase(),
              );
            },
          );

          return Row(
            spacing: 16.0,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    const Text('Transaksi Pembelian', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
                    TextField(
                      onChanged: (v) {
                        setState(() {});
                      },
                      controller: search,
                      decoration: const InputDecoration(
                        labelText: 'Cari Nama Barang',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    /* SingleChildScrollView( //TODO filter by ini itu seperti di tokped, ganti dengan ChoiceChip
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 8.0,
                        children: List.generate(
                          16,
                          (i) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(40, 135, 206, 235),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Text('Filter by'),
                            );
                          },
                        ),
                      ),
                    ), */
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final count = (width / 180.0).floor().clamp(1, 5).toInt();
          
                          return GridView.count(
                            crossAxisCount: count,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.625,
                            children: List.generate(
                              items.length,
                              (i) {
                                final item = items[i];

                                return InkWell(
                                  onTap: () {
                                    setState(
                                      () {
                                        orders.add(
                                          {
                                            'item': item,
                                            'model_quantity_purchased': 0,
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 1.0,
                                            child: Image.network(
                                              item['image']['image_url_list'][0],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 8.0
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['item_name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(item['item_id'].toString(), style: const TextStyle(color: Colors.grey),),
                                                Text(
                                                  item['price_info']?[0]['current_price'] != null
                                                  ? 'Rp. ${
                                                    NumberFormat.decimalPattern('id_ID')
                                                    .format(item['price_info']![0]['current_price'] ?? 0)
                                                    .toString()
                                                  }'
                                                  : '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF007BFF),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0,),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 8.0
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(120, 0, 128, 0).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  child: Text(
                                                    'Stok saat ini: ${
                                                      item['stock_info_v2']?['summary_info']['total_available_stock'].toString() ?? ''
                                                    }',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8.0,
                  children: [
                    const Text('Rincian Pengadaan'),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, i) {
                          final
                          order = orders[i],
                          detail = order['item'];

                          return Row(
                            spacing: 16.0,
                            children: [
                              SizedBox(
                                width: 80.0,
                                height: 80.0,
                                child: Image.network(
                                  detail['image']['image_url_list'][0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Text(detail['item_name']),
                              ),
                              IconButton(
                                onPressed: () {
                                  final quantity = order['model_quantity_purchased'];

                                  setState(
                                    () {
                                      orders[i]['model_quantity_purchased'] = quantity + 1;
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                              Text(
                                order['model_quantity_purchased'].toString(),
                              ),
                              IconButton(
                                onPressed: () {
                                  final quantity = orders[i]['model_quantity_purchased'];

                                  setState(
                                    () {
                                      orders[i]['model_quantity_purchased'] = quantity > 0
                                      ? quantity - 1
                                      : 0;
                                    },
                                  );
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      orders.removeAt(i);
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, i) {
                          return const SizedBox(
                            height: 8.0,
                          );
                        },
                        itemCount: orders.length,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Barang'),
                        Text(
                          orders.isNotEmpty
                            ? NumberFormat.decimalPattern('id_ID')
                            .format(
                              orders.fold<num>(
                                0,
                                (v, i) {
                                  return v + i['model_quantity_purchased'];
                                },
                              ),
                            )
                            .toString()
                            : '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        for (final e in orders) {
                          await updateStock(
                            e['item']['item_id'],
                            e['item']['stock_info_v2']?['summary_info']['total_available_stock'] +
                            e['model_quantity_purchased'],
                          );
                        }

                        sb.from('procure').insert(
                          {
                            'item_list': List.generate(
                              orders.length,
                              (i) {
                                final order = orders[i];

                                return {
                                  'item_name': order['item']['item_name'],
                                  'model_quantity_purchased': order['model_quantity_purchased'], 
                                };
                              }
                            ),
                          },
                        )
                        .select()
                        .then(
                          (r) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('Transaksi ${r.first['id']} berhasil dibuat.'),
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            )
                            .closed
                            .then(
                              (r) {
                                setState(
                                  () {
                                    orders.clear();
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Text('Selesaikan Pembelian'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            orders.clear();
                          },
                        );
                      },
                      child: const Text('Hapus Semua'),
                    ),
                  ],
                ),
              ),
            ],
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
      }
    );
  }
}
