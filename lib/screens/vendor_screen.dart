import 'package:flutter/material.dart';

class Vendor {
  String id, nama, noHP, alamat;
  Vendor(this.id, this.nama, this.noHP, this.alamat);
}

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  // Data dummy awal
  final List<Vendor> _semuaVendor = [
    Vendor("VND-001", "Supplier Kain Utama", "08123456789", "Jl. Merdeka No. 10"),
    Vendor("VND-002", "Percetakan Sky", "08776655443", "Jl. Serayu No. 5"),
  ];

  int _rowsPerPage = 10;
  int _currentPage = 1;

  // ============================================================
  // FUNGSI UNTUK MENAMPILKAN DIALOG (TAMBAH & EDIT)
  // ============================================================
  void _showVendorDialog({Vendor? vendor}) {
    var isEdit = vendor != null;
    
    // Controller untuk mengambil input teks
    final idCtrl = TextEditingController(text: isEdit ? vendor.id : "");
    final namaCtrl = TextEditingController(text: isEdit ? vendor.nama : "");
    final hpCtrl = TextEditingController(text: isEdit ? vendor.noHP : "");
    final alamatCtrl = TextEditingController(text: isEdit ? vendor.alamat : "");

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
                  Text(isEdit ? "EDIT VENDOR INFO" : "TAMBAH VENDOR BARU", 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel_outlined, color: Colors.grey, size: 30)),
                ],
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 30, runSpacing: 25,
                children: [
                  _buildDialogInput("ID VENDOR", idCtrl, width: 340),
                  _buildDialogInput("NAMA VENDOR", namaCtrl, width: 340),
                  _buildDialogInput("NO HP", hpCtrl, width: 340),
                  _buildDialogInput("ALAMAT", alamatCtrl, width: 340),
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
                          _semuaVendor.add(Vendor(idCtrl.text, namaCtrl.text, hpCtrl.text, alamatCtrl.text));
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], 
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18)
                    ),
                    child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18)),
                    child: const Text("CANCEL", style: TextStyle(color: Colors.black)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDelete(Vendor item) {
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
              const Text("HAPUS VENDOR?", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(fixedSize: const Size(120, 40)),
                    child: const Text("No, cancel", style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _semuaVendor.remove(item);
                      });
                      Navigator.pop(context);
                      // Opsional: Panggil _showSuccessPopup jika ingin ada notif sukses
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700], 
                      fixedSize: const Size(120, 40)
                    ),
                    child: const Text("Yes, confirm", style: TextStyle(color: Colors.white)),
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
    var totalData = _semuaVendor.length;
    var firstIndex = (_currentPage - 1) * _rowsPerPage;
    var lastIndex = (firstIndex + _rowsPerPage > totalData) ? totalData : firstIndex + _rowsPerPage;
    var pagedData = _semuaVendor.sublist(firstIndex, lastIndex);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER & TOMBOL TAMBAH (BISA DITEKAN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFF90CAF9), borderRadius: BorderRadius.circular(8)),
                child: const Text("Data Vendor", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () => _showVendorDialog(), // <--- Aktifkan Tambah
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF90CAF9), foregroundColor: Colors.black),
                child: const Text("Tambah Vendor")
              ),
            ],
          ),
          const SizedBox(height: 20),

          // TABLE CONTAINER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                // SHOW ENTRIES
                Row(
                  children: [
                    const Text("Show "),
                    _buildEntriesDropdown(),
                    const Text(" entries"),
                  ],
                ),
                const SizedBox(height: 15),

                // DATATABLE
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: [
                      const DataColumn(label: Text("ACTION")),
                      _buildSortColumn("ID Vendor"),
                      _buildSortColumn("NAMA Vendor"),
                      _buildSortColumn("No HP"),
                      _buildSortColumn("Alamat"),
                    ],
                    rows: pagedData.map((v) {
                      return DataRow(
                        cells: [
                          // 1. Kolom ACTION
                          DataCell(
                            Row(
                              children: [
                                // IKON EDIT
                                IconButton(
                                  icon: const Icon(Icons.edit_note, color: Colors.blue),
                                  onPressed: () => _showVendorDialog(vendor: v),
                                ),
                                // IKON HAPUS
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _showConfirmDelete(v),
                                ),
                              ],
                            ),
                          ),
                          // 2. Kolom DATA
                          DataCell(Text(v.id)),
                          DataCell(Text(v.nama)),
                          DataCell(Text(v.noHP)),
                          DataCell(Text(v.alamat)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // FOOTER PAGINATION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Showing ${totalData == 0 ? 0 : firstIndex + 1} to $lastIndex from $totalData entries"),
                    _buildPaginationButtons(totalData),
                  ],
                )
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

  Widget _buildEntriesDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: DropdownButton<int>(
        value: _rowsPerPage,
        underline: const SizedBox(),
        items: [10, 25, 50].map((int v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
        onChanged: (v) => setState(() { _rowsPerPage = v!; _currentPage = 1; }),
      ),
    );
  }

  Widget _buildPaginationButtons(int total) {
    var totalPages = (total / _rowsPerPage).ceil();
    return Row(
      children: List.generate(totalPages, (i) {
        var page = i + 1;
        return InkWell(
          onTap: () => setState(() => _currentPage = page),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: _currentPage == page ? const Color(0xFF90CAF9) : Colors.grey[200],
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