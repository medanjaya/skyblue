//TODO https://gemini.google.com/share/7e099b69a6ec
// SPLASH -> LOGIN -> DAHSBOARD

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import 'package:skyblue/login.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://nodpqwqildvzjpnechui.supabase.co',
    anonKey: 'sb_publishable_AhZMwxayR5KdKMoAfJvmhQ_m5RWaUZX',
    authOptions: const FlutterAuthClientOptions(
      detectSessionInUri: false,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UD Skyblue Inventory 1.0 (uks)',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ),
      ),

      home: FlutterSplashScreen.fadeIn(
        backgroundColor: const Color.fromARGB(255, 135, 206, 235),
        childWidget: Image.asset('assets/logo.png'),
        nextScreen: const Login(),
      ),
    );
  }
}