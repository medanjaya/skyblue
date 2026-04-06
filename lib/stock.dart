import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class Barang {
  String kode, nama, merek, tipe, status, satuan, keterangan;
  int qty;
  Barang(this.kode, this.nama, this.merek, this.tipe, this.status, this.qty, this.satuan, {this.keterangan = ''});
}

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final List<Barang> _semuaBarang = [
    Barang('SKB-001', 'Kaos Polos Blue', 'Skyblue', 'Atasan', 'Tersedia', 100, 'Pcs'),
    Barang('SKB-002', 'Hoodie Navy', 'Skyblue', 'Jaket', 'Habis', 0, 'Pcs'),
  ];

  List<Barang> _dataTampil = [];
  
  // Controller untuk Filter
  final filterNamaCtrl = TextEditingController();
  final filterTipeCtrl = TextEditingController();
  final filterMerekCtrl = TextEditingController();
  final filterStatusCtrl = TextEditingController();
  final filterKodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataTampil = List.from(_semuaBarang);
  }

  void _filterData() {
    setState(() {
      _dataTampil = _semuaBarang.where((item) {
        var matchNama = filterNamaCtrl.text.isEmpty || item.nama.toLowerCase().contains(filterNamaCtrl.text.toLowerCase());
        var matchTipe = filterTipeCtrl.text.isEmpty || item.tipe.toLowerCase().contains(filterTipeCtrl.text.toLowerCase());
        var matchMerek = filterMerekCtrl.text.isEmpty || item.merek.toLowerCase().contains(filterMerekCtrl.text.toLowerCase());
        var matchStatus = filterStatusCtrl.text.isEmpty || item.status.toLowerCase().contains(filterStatusCtrl.text.toLowerCase());
        var matchKode = filterKodeCtrl.text.isEmpty || item.kode.toLowerCase().contains(filterKodeCtrl.text.toLowerCase());
        return matchNama && matchTipe && matchMerek && matchStatus && matchKode;
      }).toList();
    });
  }

  // DIALOG KONFIRMASI HAPUS
  void _showConfirmDelete(Barang item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel_outlined)),
              ),
              const Text('HAPUS ITEM?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(fixedSize: const Size(120, 40)),
                    child: const Text('No, cancel', style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _semuaBarang.remove(item);
                        _filterData();
                      });
                      Navigator.pop(context);
                      _showSuccessPopup('ITEM BERHASIL DIHAPUS', Icons.delete_outline);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700], fixedSize: const Size(120, 40)),
                    child: const Text('Yes, confirm', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // NOTIFIKASI BERHASIL
  void _showSuccessPopup(String message, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel_outlined)),
              ),
              Icon(icon == Icons.delete_outline ? Icons.delete_sweep : Icons.check, size: 50, color: Colors.black),
              const SizedBox(height: 20),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  // DIALOG TAMBAH & EDIT (SEMUA INPUT KETIK)
  void _showItemDialog({Barang? barang}) {
    var isEdit = barang != null;
    final nameCtrl = TextEditingController(text: isEdit ? barang.nama : '');
    final tipeCtrl = TextEditingController(text: isEdit ? barang.tipe : '');
    final qtyCtrl = TextEditingController(text: isEdit ? barang.qty.toString() : '');
    final ketCtrl = TextEditingController(text: isEdit ? barang.keterangan : '');
    final statusCtrl = TextEditingController(text: isEdit ? barang.status : '');
    final merekCtrl = TextEditingController(text: isEdit ? barang.merek : '');
    final kodeCtrl = TextEditingController(text: isEdit ? barang.kode : '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(isEdit ? 'EDIT ITEM INFO' : 'TAMBAH ITEM BARU', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel_outlined, color: Colors.grey, size: 30)),
                ],
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 30, runSpacing: 20,
                children: [
                  _buildDialogInput('NAMA BARANG', nameCtrl, width: 220),
                  _buildDialogInput('TIPE', tipeCtrl, width: 220),
                  _buildDialogInput('STATUS', statusCtrl, width: 220),
                  _buildDialogInput('MEREK', merekCtrl, width: 220),
                  _buildDialogInput('QTY BARANG', qtyCtrl, width: 220, isNumber: true),
                  _buildDialogInput('KODE BARANG', kodeCtrl, width: 220),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KETERANGAN*', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: ketCtrl, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder())),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isEdit) {
                          barang.nama = nameCtrl.text;
                          barang.tipe = tipeCtrl.text;
                          barang.status = statusCtrl.text;
                          barang.merek = merekCtrl.text;
                          barang.qty = int.tryParse(qtyCtrl.text) ?? 0;
                          barang.kode = kodeCtrl.text;
                          barang.keterangan = ketCtrl.text;
                        } else {
                          _semuaBarang.add(Barang(kodeCtrl.text, nameCtrl.text, merekCtrl.text, tipeCtrl.text, statusCtrl.text, int.tryParse(qtyCtrl.text) ?? 0, 'Pcs', keterangan: ketCtrl.text));
                        }
                        _filterData();
                      });
                      Navigator.pop(context);
                      _showSuccessPopup(isEdit ? 'ITEM BERHASIL DIPERBARUI' : 'ITEM BERHASIL DITAMBAHKAN', Icons.check);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    child: const Text('CANCEL', style: TextStyle(color: Colors.black)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogInput(String label, TextEditingController ctrl, {double width = 200, bool isNumber = false}) {
    return SizedBox(width: width, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(controller: ctrl, keyboardType: isNumber ? TextInputType.number : TextInputType.text, decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(12), border: OutlineInputBorder())),
    ]));
  }

  Widget _buildFilterInput(String label, TextEditingController ctrl) {
    return SizedBox(width: 180, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      const SizedBox(height: 5),
      TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 12),
        decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12), border: OutlineInputBorder()),
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    print('hasil waktu: ${DateTime.now().millisecondsSinceEpoch}');
    
    //NOTE cara membuat sign HMAC-SHA256 untuk API
    //1. gabung partner_id, api path, timestamp, access_token, dan shop_id menjadi base
    final
    partner = '1201347',
    path = '/api/v2/product/get_item_list',
    time = '${DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond}',
    token = '666164684d69686c5952727464485541',
    shop = '226708243',
    base = partner + path + time + token + shop;
    print('hasil base: $base');
    
    //2. hash base dengan HMAC-SHA256
    final hmac = Hmac(
      sha256,
      base64Decode('c2hwazU2NjI0NzQ5NzM3OTZmNTc3NDU0NDU1MTc4NmE2YTZkNDg2ODc0NTI1MzYyNzc2ZDY2NjI2MjQyNjc3NA=='),
    );
    final hash = hmac.convert(utf8.encode(base));
    print('hasil hash: $hash');
    
    http.get(
      Uri.parse('https://openplatform.sandbox.test-stable.shopee.sg/api/v2/product/get_item_list?partner_id=$partner&sign=$hash&timestamp=$time&shop_id=$shop&access_token=$token&offset=0&page_size=10&update_time_from=1423958400&update_time_to=$time&item_status=NORMAL')
    )
    .then(
      (v) {
        print('hasilnya: ${v.body}');
      }
    );
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF90CAF9), //FIXME
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'Data Stok',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _showItemDialog(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFF90CAF9),
                ),
                child: const Text('TAMBAH STOK'),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400, //FIXME
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                const Text(
                  'Filter Data',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey, //FIXME
                  ),
                ),
                Wrap( //FIXME
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    _buildFilterInput('NAMA BARANG', filterNamaCtrl),
                    _buildFilterInput('TIPE', filterTipeCtrl),
                    _buildFilterInput('MEREK', filterMerekCtrl),
                    _buildFilterInput('STATUS', filterStatusCtrl),
                    _buildFilterInput('KODE BARANG', filterKodeCtrl),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: _filterData,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey[200], //FIXME
                    ),
                    child: const Text(
                      'CARI',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400), //FIXME
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ACTION')),
                  DataColumn(label: Text('KODE BARANG')),
                  DataColumn(label: Text('NAMA BARANG')),
                  DataColumn(label: Text('MEREK')),
                  DataColumn(label: Text('TIPE')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('QTY')),
                  DataColumn(label: Text('SATUAN')),
                ],
                rows: _dataTampil.map(
                  (item) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _showItemDialog(
                                  barang: item,
                                ),
                                icon: const Icon(
                                  Icons.edit_note,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _showConfirmDelete(item),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ), 
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(item.kode)),
                        DataCell(Text(item.nama)),
                        DataCell(Text(item.merek)),
                        DataCell(Text(item.tipe)),
                        DataCell(
                          Text(
                            item.status,
                            style: TextStyle(
                              color: item.status.toLowerCase() == 'habis'
                              ? Colors.red
                              : Colors.green,
                            ),
                          ),
                        ),
                        DataCell(Text(item.qty.toString())),
                        DataCell(Text(item.satuan)),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}