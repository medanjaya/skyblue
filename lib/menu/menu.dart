// TIDAK TERPAKAI

/* import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool hover = false;

  List menu = [
    {
      'icon': Icons.home,
      'label': 'DASHBOARD',
    },
    {
      'icon': Icons.book,
      'label': 'MASTER',
    },
    {
      'icon': Icons.shopping_cart,
      'label': 'TRANSAKSI',
    },
    {
      'icon': Icons.file_copy,
      'label': 'LAPORAN',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              //TODO
            },
            icon: const Icon(Icons.dark_mode),
          ),
          const SizedBox(width: 8.0),
          const Center(
            child: Text('Administrator'),
          ),
          const SizedBox(width: 24.0),
        ],
      ),
      body: Row(
        children: [
          InkWell(
            onTap: () {},
            onHover: (v) {
              setState(
                () {
                  hover = !hover;
                }
              );
            },
            child: Container(
              width: 256.0,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView.separated(
                  itemBuilder: (context, i) {
                    return Row(
                      spacing: 8.0,
                      children: [
                        Icon(menu[i]['icon']),
                        Text(menu[i]['label']),
                      ],
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 16.0);
                  },
                  itemCount: menu.length,
                ),
              ),
            ),
          ),
          const Column(),
        ],
      ),
    );
  }
} */