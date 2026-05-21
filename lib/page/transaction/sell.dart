import 'package:flutter/material.dart';

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
              const Text('Transaksi Penjualan'),
              const TextField(), //TODO gunakan dropdown ketika input kode/nama barang
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
                        child: const Text('Filter by'),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
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
                        child: const Column(
                          children: [
                            ClipRRect(
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
                              padding: EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0
                              ),
                              child: Column(
                                children: [
                                  Text('Nama Barang'),
                                  Text('Kode Barang'),
                                  Text('Harga'),
                                  Text('Sisa Stok'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      Text('13 April 2026'),
                    ],
                  ),
                  Row(
                    spacing: 8.0,
                    children: [
                      Icon(Icons.access_time_outlined),
                      Text('23:59:59'),
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
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.add),
                        ),
                        const Text('Harga'),
                        IconButton(
                          onPressed: () {
                            //TODO
                          },
                          icon: const Icon(Icons.remove),
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
              ElevatedButton(
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