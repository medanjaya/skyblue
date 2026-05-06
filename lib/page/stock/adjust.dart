import 'package:flutter/material.dart';

import 'package:skyblue/api.dart';

class Adjust extends StatefulWidget {
  const Adjust({super.key});

  @override
  State<Adjust> createState() => _AdjustState();
}

class _AdjustState extends State<Adjust> {
  @override
  void initState() {
    super.initState();
    authPartner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penyesuaian Stok'),
      ),
      
      body: const Center(
        child: Text('Fitur penyesuaian stok akan segera hadir!'),
      ),
    );
  }
}