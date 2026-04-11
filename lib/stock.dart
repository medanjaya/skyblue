import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class Item {
  String code, name, brand, type, status, quantity, keterangan;
  int qty;
  Item(this.code, this.name, this.brand, this.type, this.status, this.qty, this.quantity, {this.keterangan = ''});
}

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final List debugItems = [
    Item('SKB-001', 'Kaos Polos Blue', 'Skyblue', 'Atasan', 'Tersedia', 100, 'Pcs'),
    Item('SKB-002', 'Hoodie Navy', 'Skyblue', 'Jaket', 'Habis', 0, 'Pcs'),
  ];

  List displayItems = [];
  
  int _rowsPerPage = 10;
  int current = 1;
  
  final filterNamaCtrl = TextEditingController();
  final filterTipeCtrl = TextEditingController();
  final filterMerekCtrl = TextEditingController();
  final filterStatusCtrl = TextEditingController();
  final filterKodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayItems = List.from(debugItems);
  }

  void _filterData() {
    setState(
      () {
        displayItems = debugItems.where(
          (item) { //FIXME persingkat
            final matchNama = filterNamaCtrl.text.isEmpty || item.name.toLowerCase().contains(filterNamaCtrl.text.toLowerCase());
            final matchTipe = filterTipeCtrl.text.isEmpty || item.type.toLowerCase().contains(filterTipeCtrl.text.toLowerCase());
            final matchMerek = filterMerekCtrl.text.isEmpty || item.brand.toLowerCase().contains(filterMerekCtrl.text.toLowerCase());
            final matchStatus = filterStatusCtrl.text.isEmpty || item.status.toLowerCase().contains(filterStatusCtrl.text.toLowerCase());
            final matchKode = filterKodeCtrl.text.isEmpty || item.code.toLowerCase().contains(filterKodeCtrl.text.toLowerCase());
            return matchNama && matchTipe && matchMerek && matchStatus && matchKode;
          },
        ).toList();
      },
    );
  }

  // DIALOG KONFIRMASI HAPUS
  void _showConfirmDelete(Item item) {
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
                        debugItems.remove(item);
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
  void _showItemDialog({Item? barang}) {
    final isEdit = barang != null;
    final nameCtrl = TextEditingController(text: isEdit ? barang.name : '');
    final typeCtrl = TextEditingController(text: isEdit ? barang.type : '');
    final qtyCtrl = TextEditingController(text: isEdit ? barang.qty.toString() : '');
    final ketCtrl = TextEditingController(text: isEdit ? barang.keterangan : '');
    final statusCtrl = TextEditingController(text: isEdit ? barang.status : '');
    final brandCtrl = TextEditingController(text: isEdit ? barang.brand : '');
    final codeCtrl = TextEditingController(text: isEdit ? barang.code : '');

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
                  _buildDialogInput('TIPE', typeCtrl, width: 220),
                  _buildDialogInput('STATUS', statusCtrl, width: 220),
                  _buildDialogInput('MEREK', brandCtrl, width: 220),
                  _buildDialogInput('QTY BARANG', qtyCtrl, width: 220, isNumber: true),
                  _buildDialogInput('KODE BARANG', codeCtrl, width: 220),
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
                          barang.name = nameCtrl.text;
                          barang.type = typeCtrl.text;
                          barang.status = statusCtrl.text;
                          barang.brand = brandCtrl.text;
                          barang.qty = int.tryParse(qtyCtrl.text) ?? 0;
                          barang.code = codeCtrl.text;
                          barang.keterangan = ketCtrl.text;
                        } else {
                          debugItems.add(Item(codeCtrl.text, nameCtrl.text, brandCtrl.text, typeCtrl.text, statusCtrl.text, int.tryParse(qtyCtrl.text) ?? 0, 'Pcs', keterangan: ketCtrl.text));
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
    // Logika Pagination Sederhana
    final totalData = debugItems.length;
    final firstIndex = (current - 1) * _rowsPerPage;
    final lastIndex = (firstIndex + _rowsPerPage > totalData) ? totalData : firstIndex + _rowsPerPage;
    final pagedData = debugItems.sublist(firstIndex, lastIndex);

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
        spacing: 20.0,
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
                child: const Text('Tambah Stok'),
              ),
            ],
          ),
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
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400), //FIXME
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16.0,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      const Text('Show'),
                      Container(
                        height: 32.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, //FIXME
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton(
                          onChanged: (v) {
                            setState(
                              () {
                                _rowsPerPage = v!;
                                current = 1;
                              },
                            );
                          },
                          value: _rowsPerPage,
                          underline: const SizedBox(),
                          items: [10, 25, 50].map(
                            (e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.toString()),
                              );  
                            },
                          ).toList(),
                        ),
                      ),
                      const Text('entries'),
                    ],
                  ),
                  DataTable(
                    columns: [
                      'ACTION',
                      'KODE BARANG',
                      'NAMA BARANG',
                      'MEREK',
                      'TIPE',
                      'STATUS',
                      'QTY',
                      'SATUAN',
                    ].map(
                      (e) {
                        return DataColumn(
                          label: Text(e),
                        );
                      }
                    ).toList(),
                    rows: pagedData.map(
                      (e) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _showItemDialog(
                                      barang: e,
                                    ),
                                    icon: const Icon(
                                      Icons.edit_note,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _showConfirmDelete(e),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ), 
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(e.code)),
                            DataCell(Text(e.name)),
                            DataCell(Text(e.brand)),
                            DataCell(Text(e.type)),
                            DataCell(
                              Text(
                                e.status,
                                style: TextStyle(
                                  color: e.status.toLowerCase() == 'habis'
                                  ? Colors.red
                                  : Colors.green,
                                ),
                              ),
                            ),
                            DataCell(Text(e.qty.toString())),
                            DataCell(Text(e.quantity)),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Showing ${totalData == 0 ? 0 : firstIndex + 1} to $lastIndex from $totalData entries'),
                      _buildPaginationButtons(totalData),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButtons(int total) {
    final totalPages = (total / _rowsPerPage).ceil();
    return Row(
      children: List.generate(totalPages, (i) {
        final page = i + 1;
        return InkWell(
          onTap: () => setState(() => current = page),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: current == page ? const Color(0xFF90CAF9) : Colors.grey[200],
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(page.toString()),
          ),
        );
      }),
    );
  }
}