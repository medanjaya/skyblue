import 'package:flutter/material.dart';

import 'package:skyblue/api.dart';

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  @override
  void initState() {
    super.initState();
    authPartner();
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sandbox'),
      ),
    );
  }
}