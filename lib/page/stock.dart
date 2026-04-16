import 'package:flutter/material.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final List<Map> filters = [
    {
      'name': 'KODE BARANG',
      'controller': TextEditingController(),
    },
    {
      'name': 'NAMA BARANG',
      'controller': TextEditingController(),
    },
    {
      'name': 'MEREK',
      'controller': TextEditingController(),
    },
    {
      'name': 'TIPE',
      'controller': TextEditingController(),
    },
    {
      'name': 'STATUS',
      'controller': TextEditingController(),
    },
  ];

  final List debugItems = List.generate(
    100,
    (i) {
      return i.isOdd
      ? {
        'code': 'SKB-001',
        'name': 'Kaos Polos Blue',
        'brand': 'Skyblue',
        'type': 'Atasan',
        'status': 'Tersedia',
        'quantity': 100,
        'unit': 'Pcs',
      }
      : {
        'code': 'SKB-002',
        'name': 'Hoodie Navy',
        'brand': 'Skyblue',
        'type': 'Jaket',
        'status': 'Habis',
        'quantity': 50,
        'unit': 'Pcs',
      };
    },
  ); //FIXME ganti ke api

  int rows = 10;
  int current = 1;

  @override
  Widget build(BuildContext context) {
    final total = debugItems.length;
    final first = (current - 1) * rows;
    final last = (first + rows > total) ? total : first + rows;
    final pages = debugItems.sublist(first, last);
    
    return Column(
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
                color: const Color.fromARGB(255, 135, 206, 235),
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
              onPressed: () {}, //TODO _showItemDialog()
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 135, 206, 235),
              ),
              child: const Text('Tambah Stok'),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
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
                  color: Colors.grey,
                ),
              ),
              Row(
                spacing: 16.0,
                children: List.generate(
                  filters.length,
                  (i) {
                    final filter = filters[i];
    
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.0,
                        children: [
                          Text(
                            filter['name'],
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                            ),
                          ),
                          TextField(
                            onChanged: (v) {}, //TODO
                            controller: filter['controller'],
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ); 
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {});
                  }, //TODO _filterData,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
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
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8.0,
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
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton(
                        onChanged: (v) {
                          setState(
                            () {
                              rows = v!;
                              current = 1;
                            },
                          );
                        },
                        value: rows,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
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
                      rows: pages.map(
                        (e) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {}, /* TODO _showItemDialog(
                                        barang: e,
                                      ), */
                                      icon: const Icon(
                                        Icons.edit_note,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {}, /* TODO _showConfirmDelete(e) */
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ), 
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(e['code'])), //FIXME perbaiki format kode
                              DataCell(Text(e['name'])),
                              DataCell(Text(e['brand'])),
                              DataCell(Text(e['type'])),
                              DataCell(
                                Text(
                                  e['status'],
                                  style: TextStyle(
                                    color: e['status'].toLowerCase() == 'habis'
                                    ? Colors.red
                                    : Colors.green,
                                  ),
                                ),
                              ),
                              DataCell(Text(e['quantity'].toString())),
                              DataCell(Text(e['unit'])),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Showing ${total == 0 ? 0 : first + 1} to $last from $total entries'),
                    Row(
                      children: List.generate(
                        (total / rows).ceil(),
                        (i) {
                          final page = i + 1;
            
                          return InkWell(
                            onTap: () {
                              setState(
                                () {
                                  current = page;
                                }
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(
                                left: 5,
                              ),
                              decoration: BoxDecoration(
                                color: current == page
                                ? const Color.fromARGB(255, 135, 206, 235)
                                : Colors.grey,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(page.toString()),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}