//TODO yapiter lagi kerjain ini

import 'package:flutter/material.dart';

class Adjust extends StatefulWidget {
  const Adjust({super.key});

  @override
  State<Adjust> createState() => _AdjustState();
}

class _AdjustState extends State<Adjust> {
  
  String? selectedProductId;
  String? selectedProductName;

  final TextEditingController searchController = 
  TextEditingController();  

  List<Map<String, dynamic>> produk = [
    {
      'id': '1',
      'nama_produk': 'Produk A',
      'Stok': 10,
    },
    {
      'id': '2',
      'nama_produk': 'Produk B',
      'Stok': 20,
    }
  ];

  List<Map<String, dynamic>> riwayatTerbaru = [
    {
      'id': '1',
      'nama_produk': 'Produk A',
      'tipe_penyesuaian': 'Penambahan',
      'jumlah_penyesuaian': 5,
      'tanggal': "20 Januari 2024",
    },
    {
      'id': '2',
      'nama_produk': 'Produk B',
      'tipe_penyesuaian': 'Pengurangan',
      'jumlah_penyesuaian': 3,
      'tanggal': "21 Januari 2024",
    }
  ];

  List<Map<String, dynamic>> riwayatProduk = [];
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = produk;
  }

  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = [];
      } else {
        filteredProducts = produk.where((product) =>
                product['nama_produk'].toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      });
    }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FB),
      body: SingleChildScrollView(
        child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),  
        child:  Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Penyesuaian Stok',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007BFF),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KIRI
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Produk',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007BFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: searchController,
                          onChanged: searchProducts,
                          decoration: InputDecoration(
                            hintText: 'Cari produk...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: filteredProducts.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Tidak ada produk ditemukan',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(product['nama_produk']),
                                          subtitle: Text('Stok: ${product['Stok']}',
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedProductId = product['id'];
                                              selectedProductName = product['nama_produk'];

                                              riwayatProduk = riwayatTerbaru
                                                  .where((riwayat) =>
                                                      riwayat['nama_produk'] ==
                                                      selectedProductName)
                                                  .toList();
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // KANAN
                Expanded(
                  flex: 4,
                  child:   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail Penyesuaian',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF007BFF),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pilih produk untuk melihat detail penyesuaian stok.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                                
                                
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownMenu(
                                    width: 430,
                                    label: const Text("Tipe Penyesuaian"),
                                    inputDecorationTheme: InputDecorationTheme(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      isDense: true,
                                    ),
                                    dropdownMenuEntries: const[
                                      DropdownMenuEntry(
                                        value: 'penambahan',
                                        label: 'Penambahan',
                                      ),
                                      DropdownMenuEntry(
                                        value: 'pengurangan',
                                        label: 'Pengurangan',
                                      ),
                                    ],
                                    onSelected: (value) {},
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                //Jumlah Penyesuaian
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Jumlah Penyesuaian',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Prediksi Jumlah Stok',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF007BFF),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '10',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              
                                  const SizedBox(width: 16),
                              
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Keterangan',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF007BFF),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 240,
                                          child: TextField(
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Masukkan keterangan (opsional)',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              isDense: true,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  ),
                                  child: const Text('Batal'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF007BFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  ),
                                  child: const Text('Simpan'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Riwayat Penyesuaian Stok',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007BFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  riwayatProduk.isEmpty
                      ? Container(
                          height: 100,
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Tidak ada riwayat penyesuaian untuk produk ini.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: const Row(
                                  children:  [
                                    Expanded(flex: 2, child: Text('Tanggal & Waktu', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text('Tipe Penyesuaian', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 1, child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              const Divider(),
                              ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                          (_, __) => const Divider(
                          height: 1,
                          ),
                        itemBuilder: (context, index) {
                          final riwayat = riwayatProduk[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(riwayat['tanggal'])),
                                Expanded(flex: 2, child: Text(riwayat['nama_produk'])),
                                Expanded(flex: 2,
                                  child: Row(
                                    children: [
                                      Icon(
                                        riwayat['tipe_penyesuaian'] == 'Penambahan'
                                            ? Icons.add_circle
                                            : Icons.remove_circle,
                                        color:
                                            riwayat['tipe_penyesuaian'] == 'Penambahan'
                                                ? Colors.green
                                                : Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(riwayat['tipe_penyesuaian']),
                                    ],
                                  ) ),
                                Expanded(flex: 1, child: Text(riwayat['jumlah_penyesuaian'].toString())),
                              ],
                            ),
                          );
                        },  
                        itemCount: riwayatProduk.length,
                      ),
                    ]
                  )
                ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}