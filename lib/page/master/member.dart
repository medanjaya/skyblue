import 'dart:math';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  final TextEditingController name = TextEditingController();

  List display = [];
  int rows = 5, current = 1;

  int totalPages() {
    return (display.length / rows).ceil();
  }


  List<int> paginationList() {

    final pages = totalPages();

    if (pages <= 5) {
      return List.generate(
        pages,
        (i) => i + 1,
      );
    }


    if (current <= 3) {
      return [
        1,
        2,
        3,
        -1,
        pages,
      ];
    }


    if (current >= pages - 2) {
      return [
        1,
        -1,
        pages - 2,
        pages - 1,
        pages,
      ];
    }


    return [
      1,
      -1,
      current,
      -1,
      pages,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Data User', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)
            ),),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              onPressed: () {
                //TODO tambah user, cek versi sebelumnya
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Baru'),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder(
              stream: sb
              .from('user')
              .stream(
                primaryKey: ['id'],
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List users = snapshot.data!;

                  display = List.from(
                    users.where(
                      (e) {
                        return e['name'].toLowerCase().contains(
                          name.text.toLowerCase(),
                        );
                      },
                    ),
                  );

                  final
                  total = display.length,
                  first = (current - 1) * rows,
                  last = (first + rows > total) ? total : first + rows,
                  pages = display.sublist(first, last);
                  
                  if (users.isNotEmpty) {
                    return Column(
                      spacing: 16.0,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      color: Colors.black54,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
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
                                    items: [5, 10, 20].map(
                                      (e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e.toString()),
                                        );  
                                      },
                                    )
                                    .toList(),
                                  ),
                                ),
                                const Text('entries'),
                              ],
                            ),
                            SizedBox(
                              width: 256.0,
                              child: TextField(
                                onChanged: (v) {
                                  setState(() {});
                                },
                                controller: name,
                                decoration: const InputDecoration(
                                  hintText: 'Cari berdasarkan nama..',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 8.0,
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text('AKSI'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('NAMA'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('EMAIL'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('ROLE'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('STATUS'),
                                ),
                              ],
                            ),
                            const Divider(),
                            display.isNotEmpty
                            ? ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                final user = pages[i];
                            
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: () {}, //TODO edit item
                                        icon: const Icon(
                                          Icons.edit_note,
                                          color: Colors.red,
                                        ), 
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(user['name']),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(user['email']),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(user['role'].join(', ')),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: user['is_active']
                                            ? const Color.fromARGB(120, 0, 128, 0).withOpacity(0.1)
                                            : const Color.fromARGB(120, 255, 0, 0).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8.0,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color:
                                                user['is_active'] == true
                                                ? Colors.green
                                                : Colors.red,
                                                size: 10,
                                              ),
                                              Text(user['is_active'] == true ? 'Active' : 'Inactive', style: TextStyle(
                                                color:
                                                user['is_active'] == true
                                                ? Colors.green
                                                : Colors.red,
                                              ),
                                              ),
                                            ],  
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, i) {
                                return const Divider();
                              },
                              itemCount: pages.length,
                            )
                            : const Expanded(
                              child: Center(
                                child: Text(
                                  'Tidak ada riwayat untuk ditampilkan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Showing ${total == 0 ? 0 : first + 1} to $last from $total entries'),
                            Row(
                              spacing: 4,
                              children: [
                                // tombol previous
                                InkWell(
                                  onTap: current > 1
                                  ? () {
                                    setState(() {
                                      current = current - 1;
                                    });
                                  }
                                  : null,

                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 20,
                                    ),
                                  ),
                                ),

                                ...paginationList().map(
                                  (page) {

                                    if(page == -1){
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('...'),
                                      );
                                    }

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          current = page;
                                        });
                                      },

                                      child: Container(
                                        width: 32,
                                        height: 32,

                                        margin: const EdgeInsets.only(
                                          left: 4,
                                        ),

                                        alignment: Alignment.center,

                                        decoration: BoxDecoration(
                                          color: current == page
                                          ? const Color(0xFF007BFF)
                                          : Colors.transparent,

                                          borderRadius:
                                            BorderRadius.circular(6),
                                        ),

                                        child: Text(
                                          '$page',

                                          style: TextStyle(
                                            color: current == page
                                            ? Colors.white
                                            : Colors.black87,

                                            fontWeight:
                                            current == page
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),


                                InkWell(
                                  onTap: current < (total / rows).ceil()
                                  ? () {
                                      setState(() {
                                        current = current + 1;
                                      });
                                    }
                                  : null,

                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: Text(
                      'Tidak ada user untuk ditampilkan',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
                else {
                  return const Center(
                    child: Text(
                      'Sedang memperbarui daftar user..',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}