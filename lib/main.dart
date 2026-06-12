import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import 'package:skyblue/provider.dart';
import 'package:skyblue/home.dart';
import 'package:skyblue/login.dart';

/* FIXME agar user tidak bisa resize ukuran windows dsb.
1. flutter pub add window_manager
2. import 'package:window_manager/window_manager.dart';
3. di main() tambahkan await windowManager.ensureInitialized();
4. lalu await windowManager.setFullScreen(true); */

//FIXME ganti ke background biru kembali, cek commit sebelumnya

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://nodpqwqildvzjpnechui.supabase.co',
    publishableKey: 'sb_publishable_AhZMwxayR5KdKMoAfJvmhQ_m5RWaUZX',
    authOptions: const FlutterAuthClientOptions(
      detectSessionInUri: false,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'UD Skyblue Inventory 1.0 (uks)',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.white,
        textTheme: Typography.blackCupertino,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007BFF),
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          dense: true,
          visualDensity: VisualDensity.standard,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          tileColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 18,
          )
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: Typography.whiteCupertino,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007BFF),
          brightness: Brightness.dark,
          surface: Colors.black,        // ← warna background sidebar dark mode
        ),
        listTileTheme: const ListTileThemeData(
          dense: true,
          visualDensity: VisualDensity.standard,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          tileColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
          )
        ),
      ),

      themeMode: theme.mode,

      home: FlutterSplashScreen.fadeIn(
        backgroundColor: const Color.fromARGB(255, 135, 206, 235),
        childWidget: Image.asset('assets/splash.png'),
        nextScreen: Supabase.instance.client.auth.currentUser != null
        ? const Home()
        : const Login(),
      ),
    );
  }
}