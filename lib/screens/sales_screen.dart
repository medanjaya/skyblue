import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController dateCtrl = TextEditingController(text: "26/03/2026");
  final TextEditingController kodeCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();

  // List untuk menampung barang yang akan dijual (keranjang sementara)
  List<Map<String, dynamic>> cartItems = [];

  void _addItem() {
    if (kodeCtrl.text.isNotEmpty && qtyCtrl.text.isNotEmpty) {
      setState(() {
        cartItems.add({
          "kode": kodeCtrl.text,
          "qty": qtyCtrl.text,
          "nama": "Barang ${kodeCtrl.text}", // Simulasi nama barang
          "harga": 50000, // Simulasi harga
        });
        kodeCtrl.clear();
        qtyCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TRANSAKSI PENJUALAN",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
          const SizedBox(height: 20),
          
          // Row Tanggal
          const Text("Tanggal", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          SizedBox(
            width: 250,
            height: 40,
            child: TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          const SizedBox(height: 40),

          // KOTAK INPUT TENGAH (ABU-ABU)
          Center(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  _buildInputRow("Kode Barang", kodeCtrl),
                  const SizedBox(height: 20),
                  _buildInputRow("Qty", qtyCtrl),
                  const SizedBox(height: 30),
                  
                  // Tombol ADD
                  ElevatedButton.icon(
                    onPressed: _addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text("ADD", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // TABEL KERANJANG (Opsional: Agar user tahu apa yang sudah di-ADD)
          if (cartItems.isNotEmpty)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("KODE")),
                      DataColumn(label: Text("NAMA")),
                      DataColumn(label: Text("QTY")),
                      DataColumn(label: Text("ACTION")),
                    ],
                    rows: cartItems.map((item) => DataRow(cells: [
                      DataCell(Text(item['kode'])),
                      DataCell(Text(item['nama'])),
                      DataCell(Text(item['qty'])),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => cartItems.remove(item)),
                      )),
                    ])).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController ctrl) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}