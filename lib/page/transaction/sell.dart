import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.0,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              const Text('Transaksi Penjualan', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Cari Nama/Kode Barang',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ), //TODO gunakan dropdown ketika input kode/nama barang
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 8.0,
                  children: List.generate( //TODO filter by ini itu seperti di tokped
                    16,
                    (i) {
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(40, 135, 206, 235),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Text('Filter by'), //TODO ganti dengan ChoiceChip
                      );
                    },
                  ),
                ),
              ),
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
                        50,
                        (i) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              children: [
                                const ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: ColoredBox(
                                      color: Colors.grey,
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
                                        const Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold),),
                                        const Text('Kode Barang', style: TextStyle(color: Colors.grey),),
                                        const Text('Harga', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF007BFF), fontSize: 18),),
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
                                          child: const Text('Sisa Stok')),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      const Icon(Icons.calendar_month_outlined),
                      Text( DateFormat('dd MMM yyyy').format(DateTime.now())),
                    ],
                  ),
                  Row(
                    spacing: 8.0,
                    children: [
                      const Icon(Icons.access_time_outlined),
                      Text( DateFormat('HH:mm:ss').format(DateTime.now())),
                    ],
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rincian'),
                  Text('Kode Transaksi'),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, i) {
                    return Row(
                      spacing: 16.0,
                      children: [
                        Container(
                          color: Colors.grey,
                          width: 80.0,
                          height: 80.0,
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nama Barang'),
                              Text('Harga x Jumlah'),
                              Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.add),
                        ),
                        const Text('0'),
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.delete_outline, color: Colors.red,),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(
                      height: 8.0,
                    );
                  },
                  itemCount: 16,
                ),
              ),
              const Divider(),
              const Text('Subtotal'),
              const Text('Total'),
              ElevatedButton(
                onPressed: () {
                  //TODO
                },
                child: const Text('Selesaikan Pesanan'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  //TODO
                },
                child: const Text('Hapus Semua'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
