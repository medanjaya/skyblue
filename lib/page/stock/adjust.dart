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
    return const Placeholder();
  }
}