import 'package:flutter/material.dart';

class Barang {
  String kode, nama, merek, tipe, status, satuan, keterangan;
  int qty;
  Barang(this.kode, this.nama, this.merek, this.tipe, this.status, this.qty, this.satuan, {this.keterangan = ""});
}

class StokScreen extends StatefulWidget {
  const StokScreen({super.key});

  @override
  State<StokScreen> createState() => _StokScreenState();
}

class _StokScreenState extends State<StokScreen> {
  final List<Barang> _semuaBarang = [
    Barang("SKB-001", "Kaos Polos Blue", "Skyblue", "Atasan", "Tersedia", 100, "Pcs"),
    Barang("SKB-002", "Hoodie Navy", "Skyblue", "Jaket", "Habis", 0, "Pcs"),
  ];

  List<Barang> _dataTampil = [];
  String? filterNama, filterTipe, filterMerek, filterStatus, filterKode;

  @override
  void initState() {
    super.initState();
    _dataTampil = List.from(_semuaBarang);
  }

  void _filterData() {
    setState(() {
      _dataTampil = _semuaBarang.where((item) {
        var matchNama = filterNama == null || item.nama == filterNama;
        var matchTipe = filterTipe == null || item.tipe == filterTipe;
        var matchMerek = filterMerek == null || item.merek == filterMerek;
        var matchStatus = filterStatus == null || item.status == filterStatus;
        var matchKode = filterKode == null || item.kode == filterKode;
        return matchNama && matchTipe && matchMerek && matchStatus && matchKode;
      }).toList();
    });
  }

  // ============================================================
  // DIALOG 1: KONFIRMASI HAPUS
  // ============================================================
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
              const Text("HAPUS ITEM?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)),
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
                        _semuaBarang.remove(item);
                        _filterData();
                      });
                      Navigator.pop(context);
                      _showSuccessPopup("ITEM BERHASIL DIHAPUS", Icons.delete_outline);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700], fixedSize: const Size(120, 40)),
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

  // ============================================================
  // DIALOG 2: NOTIFIKASI BERHASIL (SUCCESS POP-UP)
  // ============================================================
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
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIALOG 3: TAMBAH & EDIT (DENGAN NOTIFIKASI SUKSES)
  // ============================================================
  void _showItemDialog({Barang? barang}) {
    var isEdit = barang != null;
    final nameCtrl = TextEditingController(text: isEdit ? barang.nama : "");
    final tipeCtrl = TextEditingController(text: isEdit ? barang.tipe : "");
    final qtyCtrl = TextEditingController(text: isEdit ? barang.qty.toString() : "");
    final ketCtrl = TextEditingController(text: isEdit ? barang.keterangan : "");
    var statusVal = isEdit ? barang.status : null;
    var merekVal = isEdit ? barang.merek : null;
    var kodeVal = isEdit ? barang.kode : null;

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
                  Text(isEdit ? "EDIT ITEM INFO" : "TAMBAH ITEM BARU", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel_outlined, color: Colors.grey, size: 30)),
                ],
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 30, runSpacing: 20,
                children: [
                  _buildDialogInput("NAMA BARANG", nameCtrl, width: 220),
                  _buildDialogInput("TIPE", tipeCtrl, width: 220),
                  _buildDialogDropdown("STATUS", ["Tersedia", "Habis"], statusVal, (v) => statusVal = v, width: 220),
                  _buildDialogDropdown("MEREK", ["Skyblue", "Vendor A"], merekVal, (v) => merekVal = v, width: 220),
                  _buildDialogInput("QTY BARANG", qtyCtrl, width: 220, isNumber: true),
                  _buildDialogDropdown("KODE BARANG", ["SKB-001", "SKB-002", "SKB-003"], kodeVal, (v) => kodeVal = v, width: 220),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("KETERANGAN*", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
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
                          barang.qty = int.tryParse(qtyCtrl.text) ?? 0;
                          barang.status = statusVal ?? barang.status;
                        } else {
                          _semuaBarang.add(Barang(kodeVal ?? "NEW", nameCtrl.text, merekVal ?? "Skyblue", tipeCtrl.text, statusVal ?? "Tersedia", int.tryParse(qtyCtrl.text) ?? 0, "Pcs"));
                        }
                        _filterData();
                      });
                      Navigator.pop(context);
                      // TAMPILKAN PESAN SUKSES SESUAI FOTO
                      _showSuccessPopup(isEdit ? "ITEM BERHASIL DIPERBARUI" : "ITEM BERHASIL DITAMBAHKAN", Icons.check);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
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

  // Widget pendukung (Input & Dropdown) tetap sama...
  Widget _buildDialogInput(String label, TextEditingController ctrl, {double width = 200, bool isNumber = false}) {
    return SizedBox(width: width, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(controller: ctrl, keyboardType: isNumber ? TextInputType.number : TextInputType.text, decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(12), border: OutlineInputBorder())),
    ]));
  }

  Widget _buildDialogDropdown(String label, List<String> items, String? val, Function(String?) onChange, {double width = 200}) {
    return SizedBox(width: width, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(value: val, isDense: true, decoration: const InputDecoration(contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(), onChanged: onChange),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Data Stok & Tambah Stok)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF90CAF9), borderRadius: BorderRadius.circular(8)), child: const Text("Data Stok", style: TextStyle(fontWeight: FontWeight.bold))),
              ElevatedButton(onPressed: () => _showItemDialog(), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF90CAF9), foregroundColor: Colors.black), child: const Text("TAMBAH STOK")),
            ],
          ),
          const SizedBox(height: 20),

          // Filter Card (Design tetap seperti awal)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(15)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Filter Data", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 15),
              Wrap(spacing: 15, runSpacing: 15, children: [
                _buildFilterDropdown("NAMA BARANG", ["Kaos Polos Blue", "Hoodie Navy"], (v) => filterNama = v),
                _buildFilterDropdown("TIPE", ["Atasan", "Jaket"], (v) => filterTipe = v),
                _buildFilterDropdown("MEREK", ["Skyblue", "Vendor A"], (v) => filterMerek = v),
                _buildFilterDropdown("STATUS", ["Tersedia", "Habis"], (v) => filterStatus = v),
                _buildFilterDropdown("KODE BARANG", ["SKB-001", "SKB-002"], (v) => filterKode = v),
              ]),
              const SizedBox(height: 15),
              Align(alignment: Alignment.bottomRight, child: OutlinedButton(onPressed: _filterData, style: OutlinedButton.styleFrom(backgroundColor: Colors.grey[200]), child: const Text("CARI", style: TextStyle(color: Colors.black)))),
            ]),
          ),
          const SizedBox(height: 20),

          // Tabel Stok
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("ACTION")),
                  DataColumn(label: Text("KODE BARANG")),
                  DataColumn(label: Text("NAMA BARANG")),
                  DataColumn(label: Text("MEREK")),
                  DataColumn(label: Text("TIPE")),
                  DataColumn(label: Text("STATUS")),
                  DataColumn(label: Text("QTY")),
                  DataColumn(label: Text("SATUAN")),
                ],
                rows: _dataTampil.map((item) {
                  return DataRow(cells: [
                    DataCell(Row(
                      children: [
                        // IKON EDIT (PENA)
                        IconButton(icon: const Icon(Icons.edit_note, color: Colors.blue), onPressed: () => _showItemDialog(barang: item)),
                        // IKON HAPUS (SESUAI REQUEST)
                        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _showConfirmDelete(item)),
                      ],
                    )),
                    DataCell(Text(item.kode)),
                    DataCell(Text(item.nama)),
                    DataCell(Text(item.merek)),
                    DataCell(Text(item.tipe)),
                    DataCell(Text(item.status, style: TextStyle(color: item.status == "Habis" ? Colors.red : Colors.green))),
                    DataCell(Text(item.qty.toString())),
                    DataCell(Text(item.satuan)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, List<String> items, Function(String?) onChanged) {
    return SizedBox(width: 180, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      const SizedBox(height: 5),
      DropdownButtonFormField<String>(isExpanded: true, decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder()), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(), onChanged: onChanged),
    ]));
  }
}