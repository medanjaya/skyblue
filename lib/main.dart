import 'package:flutter/material.dart';

import 'package:skyblue/menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UD Skyblue 1.0 (uks)',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 135, 206, 235),
        ),
      ),

      home: const Menu(),
    );
  }
}