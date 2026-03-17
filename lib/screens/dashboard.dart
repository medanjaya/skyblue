import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            backgroundColor: Colors.grey[200],
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            labelType: NavigationRailLabelType.none,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Icon(Icons.menu),
            ),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.laptop_mac), label: Text('Device')),
              NavigationRailDestination(icon: Icon(Icons.shopping_cart_outlined), label: Text('Shop')),
              NavigationRailDestination(icon: Icon(Icons.description_outlined), label: Text('Report')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.dark_mode_outlined),
                      SizedBox(width: 10),
                      Text("Administrator", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // Card Tabel
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text("DEVICE", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Type", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("LAST SIGNED IN", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}