import 'package:flutter/material.dart';

import 'package:skyblue/api.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
        width: double.infinity,
        color: const Color(0xFFEAF3FB), // 🔥 background biru full
        padding: const EdgeInsets.all(16),  
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Penyesuaian Stok',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
        
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
                                decoration: InputDecoration(
                                  hintText: 'Cari produk...',
                                  prefixIcon: const Icon(Icons.search, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  isDense: true,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: produk.length,
                                  itemBuilder: (context, index) {
                                    final product = produk[index];
                                    return ListTile(
                                      title: Text(product['nama_produk'] as String),
                                      subtitle: Text('Stok: ${product['Stok']}'),
                                      onTap: () {
                                        setState(() {
                                          selectedProductName = product['nama_produk'] as String?;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child:   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
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
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF007BFF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                        ),
                                        child: const Text('Simpan Penyesuaian'),
                                      ),
                                    ],
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
              ]
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
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Riwayat penyesuaian stok akan muncul di sini',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
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