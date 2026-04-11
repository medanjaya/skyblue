import 'package:flutter/material.dart';

class Item {
  String id, nama, noHP, alamat;
  Item(this.id, this.nama, this.noHP, this.alamat);
}

class Vendor extends StatefulWidget {
  const Vendor({super.key});

  @override
  State<Vendor> createState() => _VendorState();
}

class _VendorState extends State<Vendor> {
  // Data dummy awal
  final List<Item> debugItems = [
    Item('VND-001', 'Supplier Kain Utama', '08123456789', 'Jl. Merdeka No. 10'),
    Item('VND-002', 'Percetakan Sky', '08776655443', 'Jl. Serayu No. 5'),
  ];

  int _rowsPerPage = 10;
  int current = 1;

  // ============================================================
  // FUNGSI UNTUK MENAMPILKAN DIALOG (TAMBAH & EDIT)
  // ============================================================
  void _showItemDialog({Item? vendor}) {
    final isEdit = vendor != null;
    
    // Controller untuk mengambil input teks
    final idCtrl = TextEditingController(text: isEdit ? vendor.id : '');
    final namaCtrl = TextEditingController(text: isEdit ? vendor.nama : '');
    final hpCtrl = TextEditingController(text: isEdit ? vendor.noHP : '');
    final alamatCtrl = TextEditingController(text: isEdit ? vendor.alamat : '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(isEdit ? 'EDIT VENDOR INFO' : 'TAMBAH VENDOR BARU', 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel_outlined, color: Colors.grey, size: 30)),
                ],
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 30, runSpacing: 25,
                children: [
                  _buildDialogInput('ID VENDOR', idCtrl, width: 340),
                  _buildDialogInput('NAMA VENDOR', namaCtrl, width: 340),
                  _buildDialogInput('NO HP', hpCtrl, width: 340),
                  _buildDialogInput('ALAMAT', alamatCtrl, width: 340),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isEdit) {
                          // Logika Update
                          vendor.id = idCtrl.text;
                          vendor.nama = namaCtrl.text;
                          vendor.noHP = hpCtrl.text;
                          vendor.alamat = alamatCtrl.text;
                        } else {
                          // Logika Tambah Baru
                          debugItems.add(Item(idCtrl.text, namaCtrl.text, hpCtrl.text, alamatCtrl.text));
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], 
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18)
                    ),
                    child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18)),
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
                child: IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.cancel_outlined)
                ),
              ),
              const Text('HAPUS VENDOR?', 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
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
                      });
                      Navigator.pop(context);
                      // Opsional: Panggil _showSuccessPopup jika ingin ada notif sukses
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700], 
                      fixedSize: const Size(120, 40)
                    ),
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

  @override
  Widget build(BuildContext context) {
    // Logika Pagination Sederhana
    final totalData = debugItems.length;
    final firstIndex = (current - 1) * _rowsPerPage;
    final lastIndex = (firstIndex + _rowsPerPage > totalData) ? totalData : firstIndex + _rowsPerPage;
    final pagedData = debugItems.sublist(firstIndex, lastIndex);

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
                  'Data Vendor',
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
                child: const Text('Tambah Vendor'),
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
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: [
                      const DataColumn(
                        label: Text('ACTION'),
                      ),
                      _buildSortColumn('ID VENDOR'),
                      _buildSortColumn('NAMA VENDOR'),
                      _buildSortColumn('No HP'),
                      _buildSortColumn('Alamat'),
                    ],
                    rows: pagedData.map(
                      (e) {
                        return DataRow(
                          cells: [
                            // 1. Kolom ACTION
                            DataCell(
                              Row(
                                children: [
                                  // IKON EDIT
                                  IconButton(
                                    icon: const Icon(Icons.edit_note, color: Colors.blue),
                                    onPressed: () => _showItemDialog(vendor: e),
                                  ),
                                  // IKON HAPUS
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _showConfirmDelete(e),
                                  ),
                                ],
                              ),
                            ),
                            // 2. Kolom DATA
                            DataCell(Text(e.id)),
                            DataCell(Text(e.nama)),
                            DataCell(Text(e.noHP)),
                            DataCell(Text(e.alamat)),
                          ],
                        );
                      }
                    ).toList(),
                  ),
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
        ],
      ),
    );
  }

  // WIDGET HELPER
  Widget _buildDialogInput(String label, TextEditingController ctrl, {double width = 200}) {
    return SizedBox(width: width, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      TextField(controller: ctrl, decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(15), border: OutlineInputBorder())),
    ]));
  }

  DataColumn _buildSortColumn(String label) {
    return DataColumn(label: Row(children: [Text(label), const SizedBox(width: 5), const Icon(Icons.unfold_more, size: 16, color: Colors.grey)]));
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