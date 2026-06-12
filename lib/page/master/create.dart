import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

import 'package:skyblue/api.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController filter = TextEditingController();
  final ImagePicker picker = ImagePicker();
  
  List<XFile>? media;
  
  Map
  adds = {
    'original_price': null,
    'description': null,
    'weight': null,
    'item_name': null,
    'item_status': 'NORMAL',
    'logistic_info': [],
    'attribute_list': [],
    'category_id': null,
    'image': {
      'image_id_list': [],
    },
    'brand': {
      'brand_id': 0,
      'original_brand_name': 'NoBrand',
    },
    'seller_stock': [
      {
        'stock': 0,
      },
    ],
    'minimum': null,
  },
  
  vars = {
    //FIXME
  };

  @override
  void initState() {
    super.initState();
    filter.addListener(
      () {
        setState(() {});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tambah Barang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF),
              ),
            ),
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
                setState(
                  () {
                    IsCreate(false).dispatch(context);
                  },
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 36.0,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Informasi Barang',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 16.0,
                            children: [
                              labeledField(
                                onChanged: (v) {
                                  setState(
                                    () {
                                      adds['item_name'] = v;
                                    }
                                  );
                                },
                                label: 'Nama Barang',
                                hint: 'Masukkan Nama Barang',
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 8.0,
                                children: [
                                  const Text('Kategori*'),
                                  FutureBuilder(
                                    future: fetchCategoryList(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final hierarchy = Hierarchy(snapshot.data!),

                                        parents = snapshot.data!
                                        .map(
                                          (e) {
                                            return e['parent_category_id'];
                                          }
                                        )
                                        .where(
                                          (e) {
                                            return e != null && (false || e != 0);
                                          },
                                        )
                                        .toSet(),
                                  
                                        categories = List.from(
                                          snapshot.data!.where(
                                            (e) {
                                              return e['display_category_name'].toLowerCase().startsWith(
                                                filter.text.toLowerCase(),
                                              )
                                              as bool;
                                            },
                                          ),
                                        )
                                        .where(
                                          (e) {
                                            return !parents.contains(
                                              e['category_id'],
                                            );
                                          },
                                        )
                                        .toList();
                                        
                                        return DropdownMenu(
                                          onSelected: (v) {
                                            setState(
                                              () {
                                                adds['category_id'] = v;
                                              }
                                            );
                                          },
                                          controller: filter,
                                          menuHeight: 256.0,
                                          hintText: 'Masukkan Kategori Barang',
                                          textStyle: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          inputDecorationTheme: InputDecorationThemeData(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              vertical: 12.0,
                                              horizontal: 8.0,
                                            ),
                                            border: const OutlineInputBorder(),
                                            constraints: BoxConstraints.tight(
                                              const Size.fromHeight(40.0),
                                            ),
                                          ),
                                          expandedInsets: EdgeInsets.zero,
                                          dropdownMenuEntries: List.generate(
                                            categories.length.clamp(0, 8),
                                            (i) {
                                              final category = categories[i];
                                  
                                              return DropdownMenuEntry(
                                                value: category['category_id'],
                                                label: category['display_category_name'],
                                                labelWidget: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(category['display_category_name']),
                                                    Text(
                                                      hierarchy.get(category['category_id']),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      else {
                                        return const Text(
                                          'Memuat..',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (adds['category_id'] != null) Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 8.0,
                                children: [
                                  const Text('Atribut'), //TODO atribut belum implementasi
                                  FutureBuilder(
                                    future: fetchAttributeTree(adds['category_id']),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final attributes = snapshot.data!;
                                        
                                        return Wrap(
                                          spacing: 16.0,
                                          runSpacing: 16.0,
                                          children: List.generate(
                                            attributes.length,
                                            (i) {
                                              final
                                              attribute = attributes[i],
                                              values = attribute['attribute_value_list'] ?? [];

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                spacing: 8.0,
                                                children: [
                                                  Text(
                                                    '${
                                                      attribute['multi_lang'][0]['value']
                                                    }${
                                                      attribute['mandatory'] ? '*' : ''
                                                    }',
                                                  ),
                                                  DropdownMenu(
                                                    onSelected: (v) {
                                                      setState(
                                                        () {
                                                          //TODO
                                                        }
                                                      );
                                                    },
                                                    menuHeight: 256.0,
                                                    hintText: 'Masukkan ${attribute['multi_lang'][0]['value']}',
                                                    textStyle: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                    inputDecorationTheme: InputDecorationThemeData(
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        vertical: 12.0,
                                                        horizontal: 8.0,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      constraints: BoxConstraints.tight(
                                                        const Size.fromHeight(40.0),
                                                      ),
                                                    ),
                                                    expandedInsets: EdgeInsets.zero,
                                                    dropdownMenuEntries: List.generate(
                                                      values.length,
                                                      (j) {
                                                        final value = values[j];
                                            
                                                        return DropdownMenuEntry(
                                                          value: value['value_id'],
                                                          label: value['multi_lang'][0]['value'],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      else {
                                        return const Text(
                                          'Memuat..',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              //TODO variasi
                              labeledField(
                                onChanged: (v) {
                                  setState(
                                    () {
                                      adds['original_price'] = double.parse(v);
                                    }
                                  );
                                },
                                label: 'Harga',
                                hint: 'Masukkan Harga',
                                numeric: true,
                              ),
                              labeledField(
                                onChanged: (v) {
                                  setState(
                                    () {
                                      adds['minimum'] = int.parse(v);
                                    }
                                  );
                                },
                                label: 'Stok Minimum',
                                hint: 'Masukkan Stok Minimum',
                                numeric: true,
                              ),
                              labeledField(
                                onChanged: (v) {
                                  setState(
                                    () {
                                      adds['weight'] = double.parse(v) / 100;
                                    }
                                  );
                                },
                                label: 'Berat (gr)',
                                hint: 'Masukkan Berat Barang',
                                numeric: true,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 8.0,
                                children: [
                                  const Text('Jasa Pengiriman*'),
                                  FutureBuilder(
                                    future: fetchChannelList(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final List logistics = snapshot.data!;

                                        logistics.sort(
                                          (a, b) {
                                            return a['logistics_channel_name'].toLowerCase().compareTo(
                                              b['logistics_channel_name'].toLowerCase(),
                                            );
                                          },
                                        );

                                        adds['logistic_info'] = List.generate(
                                          logistics.length,
                                          (i) {
                                            return {
                                              'logistic_id': logistics[i]['logistics_channel_id'],
                                              'enabled': adds['logistic_info'].isNotEmpty
                                              ? adds['logistic_info'][i]['enabled']
                                              : true,
                                            };
                                          },
                                        );

                                        return Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: List.generate(
                                            logistics.length,
                                            (i) {
                                              final
                                              logistic = logistics[i],
                                              
                                              index = adds['logistic_info'].indexWhere(
                                                (f) => logistic['logistics_channel_id'] == f['logistic_id'],
                                              );
                                              
                                              return FilterChip(
                                                onSelected: (v) {
                                                  setState(
                                                    () {
                                                      adds['logistic_info'][index]['enabled'] = v;
                                                    },
                                                  );
                                                },
                                                label: Text(logistic['logistics_channel_name']),
                                                selected: adds['logistic_info'][index]['enabled'],
                                              );
                                            }
                                          )
                                        );
                                      }
                                      else {
                                        return const Text(
                                          'Memuat..',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        );
                                      }
                                    }
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
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 22.0,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16.0,
                          children: [
                            const Text(
                              'Deskripsi*',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (v) {
                                  setState(
                                    () {
                                      adds['description'] = v;
                                    }
                                  );
                                },
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(16.0),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16.0,
                        children: [
                          const Text(
                            'Gambar Barang*',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Catatan : ',
                                  style: TextStyle(
                                    color: Color(0xFF007BFF),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Format JPG, JPEG, atau PNG (Ukuran maksimal 10MB)',
                                ),
                              ],
                            ),
                          ),
                          Row(
                            spacing: 16.0,
                            children: List.generate(
                              5,
                              (i) {
                                return Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          final files = await picker.pickMultiImage();

                                          setState(
                                            () {
                                              media = files;
                                              
                                              uploadImage(media!)
                                              .then(
                                                (r) {
                                                  adds['image']['image_id_list'] = List.generate(
                                                    r.length,
                                                    (i) {
                                                      return r[i]['image_id'];
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        }
                                        catch (e) {
                                          setState(
                                            () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text('$e'), //FIXME
                                                  ),
                                                  duration: const Duration(seconds: 3),
                                                ),
                                              );
                                            }
                                          );
                                        }
                                      },
                                      child: media?.asMap().containsKey(i) ?? false
                                      ? Image.file(
                                        File(media![i].path),
                                        errorBuilder: (context, e, stackTrace) {
                                          return const Center(
                                            child: Icon(Icons.warning_amber),
                                          );
                                        },
                                      )
                                      : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFF6A6A6A),
                                          ),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          spacing: 8.0,
                                          children: [
                                            const Icon(
                                              Icons.image_outlined,
                                              color: Color(0xFF007BFF),
                                              size: 28.0,
                                            ),
                                            Text(
                                              'Gambar ${i + 1}',
                                              style: const TextStyle(
                                                color: Color(0xFF6A6A6A),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 8.0,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BFF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              //TODO reset
                            },
                            child: const Text('Reset'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BFF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              addItem(adds)
                              .then(
                                (r) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text('Barang berhasil ditambahkan.'),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  )
                                  .closed
                                  .then(
                                    (r) {
                                      IsCreate(false).dispatch(context);
                                    }
                                  );
                                }
                              );
                            },
                            child: const Text('Simpan Barang'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }
}

Widget labeledField(
  {
    Function(String)? onChanged,
    required String label,
    required String hint,
    bool numeric = false
  }
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8.0,
    children: [
      Text('$label*'),
      TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          border: const OutlineInputBorder(),
        ),
        keyboardType: numeric
        ? TextInputType.number
        : null,
        inputFormatters: numeric
        ? [FilteringTextInputFormatter.digitsOnly]
        : null,
      ),
    ],
  );
}

class Hierarchy {
  final Map maps;

  Hierarchy(List categories): maps = {
    for (final e in categories) e['category_id']: e,
  };

  String get(int id) {
    final path = [];
    int? current = id;

    while (current != null && maps.containsKey(current)) {
      final category = maps[current]!;
      path.add(category['display_category_name']);

      final parent = category['parent_category_id'];
      if (parent == 0) break;

      current = parent;
    }

    return path.reversed.join(' > ');
  }
}

class IsCreate extends Notification {
  final bool v;
  IsCreate(this.v);
}