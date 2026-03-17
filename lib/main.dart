import 'package:flutter/material.dart';
import 'package:skyblue/screens/splash_screen.dart';

void main() {
  runApp(const SkyblueApp());
}

class SkyblueApp extends StatelessWidget {
  const SkyblueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skyblue Inventory',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}