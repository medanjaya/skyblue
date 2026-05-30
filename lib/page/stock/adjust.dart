import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Adjust extends StatefulWidget {
  const Adjust({super.key});

  @override
  State<Adjust> createState() => _AdjustState();
}

class _AdjustState extends State<Adjust> {
  
  String? selectedProductId;
  String? selectedProductName;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  String? tipePenyesuaian;
  final TextEditingController jumlahPenyesuaianController = TextEditingController();
  int prediksiStok = 0;

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
      'Keterangan': "Penyesuaian stok karena penerimaan barang dari supplier."
    },
    {
      'id': '2',
      'nama_produk': 'Produk B',
      'tipe_penyesuaian': 'Pengurangan',
      'jumlah_penyesuaian': 3,
      'tanggal': "21 Januari 2024",
      'Keterangan': "Penyesuaian stok karena kerusakan barang."
    }
  ];

  List<Map<String, dynamic>> riwayatProduk = [];
  List<Map<String, dynamic>> filteredProducts = [];

  void hitungPrediksiStok() {
    final currentProduct = produk.firstWhere((product) => product['id'] == selectedProductId);
    final currentStock = currentProduct['Stok'] as int;
    final adjustmentAmount = int.tryParse(jumlahPenyesuaianController.text) ?? 0;

    if (selectedProductId == null || tipePenyesuaian == null || jumlahPenyesuaianController.text.isEmpty) {
      prediksiStok = currentStock;
      return;
    }

    setState(() {
       if (tipePenyesuaian == 'penambahan') {
        prediksiStok = currentStock + adjustmentAmount;
      } else if (tipePenyesuaian == 'pengurangan') {
        prediksiStok = currentStock - adjustmentAmount;
      }
    });
  }

  void simpanPenyesuaian() {
    if (selectedProductId == null || tipePenyesuaian == null || jumlahPenyesuaianController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua informasi penyesuaian stok.')),
      );
      return;
    }

    final adjustmentAmount = int.tryParse(jumlahPenyesuaianController.text) ?? 0;
    if (adjustmentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah penyesuaian harus lebih dari 0.')),
      );
      return;
    }

    setState(() {
      final productIndex = produk.indexWhere((product) => product['id'] == selectedProductId);
      if (productIndex != -1) {
        produk[productIndex]['Stok'] = prediksiStok;

      final formatTipe = tipePenyesuaian == 'penambahan' ? 'Penambahan' : 'Pengurangan';
      riwayatTerbaru.insert(0, {
        'id': selectedProductId,
        'nama_produk': selectedProductName,
        'tipe_penyesuaian': formatTipe,
        'jumlah_penyesuaian': adjustmentAmount,
        'tanggal': DateFormat('dd MMMM yyyy HH:mm:ss').format(DateTime.now()),
        'Keterangan': keteranganController.text.isEmpty ? null : keteranganController.text,
      });

      riwayatProduk = riwayatTerbaru.where((riwayat) => riwayat['id'] == selectedProductId).toList();

      tipePenyesuaian = null;
      jumlahPenyesuaianController.clear();
      keteranganController.clear();
      prediksiStok = 0;
    }
  });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Penyesuaian stok berhasil disimpan.')),
    );
  }

  void batalPenyesuaian() {
    setState(() {
      selectedProductId = null;
      selectedProductName = null;
      tipePenyesuaian = null;
      jumlahPenyesuaianController.clear();
      keteranganController.clear();
      prediksiStok = 0;
      riwayatProduk = [];
    });
  }

  @override
  void initState() {
    super.initState();
    filteredProducts = [];
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
    jumlahPenyesuaianController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
        width: double.infinity,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Penyesuaian Stok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF),
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
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
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
                            const SizedBox(height: 16),

                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: selectedProductId == null 
                                    ? const Center(
                                        child: Text(
                                          'pilih produk untuk melihat info produk',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Icon(Icons.info_outline_rounded, color: Color(0xFF007BFF)),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Detail Info Produk",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF007BFF),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'ID Produk: $selectedProductId',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Nama Produk: $selectedProductName',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Stok Saat Ini: ${produk.firstWhere((product) => product['id'] == selectedProductId)['Stok']}',
                                              style: const TextStyle( fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                    ),
                              ),
                            ),
                          ],
                        ),

                        if (searchController.text.isNotEmpty)
                          Positioned(
                            top: 80,
                            left: 0,
                            right: 0,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 300),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: filteredProducts.isEmpty
                                  ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Tidak ada produk yang ditemukan.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredProducts.length,
                                      itemBuilder: (context, index) {
                                        final product = filteredProducts[index];
                                        return ListTile(
                                          dense: true,
                                          title: Text(product['nama_produk']),
                                          subtitle:
                                              Text('Stok: ${product['Stok']}'),
                                          onTap: () {
                                            setState(() {
                                              selectedProductId = product['id'];
                                              selectedProductName = product['nama_produk'];

                                              tipePenyesuaian = null;
                                              jumlahPenyesuaianController.clear();
                                              keteranganController.clear();

                                              riwayatProduk = riwayatTerbaru
                                                  .where((riwayat) =>
                                                      riwayat['id'] == selectedProductId)
                                                  .toList();                                         
                                              searchController.clear();
                                              hitungPrediksiStok();
                                            });
                                          },
                                        );
                                      },
                                    ),
                            ),
                          )
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
                          color: Theme.of(context).primaryColor,
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
                            selectedProductId == null
                                ? const Column(
                                    children: [
                                      Text(
                                        'Pilih produk untuk melihat detail penyesuaian stok.',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
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
                                    onSelected: (value) {
                                      tipePenyesuaian = value?.toString();
                                      hitungPrediksiStok();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                //Jumlah Penyesuaian
                                Expanded(
                                  child: TextField(
                                    controller: jumlahPenyesuaianController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      hitungPrediksiStok();
                                    },
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Prediksi Jumlah Stok',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF007BFF),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            selectedProductId == null ? '-' : prediksiStok.toString(),
                                            style: const TextStyle(
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
                                          width: 360,
                                          child: TextField(
                                            controller: keteranganController,
                                            maxLines: 4,
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
                                  onPressed: batalPenyesuaian,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  ),
                                  child: const Text('Batal'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: simpanPenyesuaian,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF007BFF),
                                    foregroundColor: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor,
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
                              'Tidak ada riwayat penyesuaian stok.',
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
                                    Expanded(flex: 1, child: Text('ID Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text('Tipe Penyesuaian', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 1, child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold)))
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
                                Expanded(flex: 1, child: Text(riwayat['id'])),
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
                                Expanded(flex: 3, child: Text(riwayat['Keterangan']?.toString() ?? '-')),
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