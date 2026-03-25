import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skyblue/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Berpindah ke LoginScreen setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90CAF9), // Warna biru muda sesuai foto
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ==========================================
            // EDIT DI SINI: Menggunakan Gambar Logo Asli
            // ==========================================
            Image.asset(
              'assets/images/logo_sk.png', // Path ke file logomu
              width: 180, // Sesuaikan ukuran agar pas
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika gambar gagal dimuat
                return const Icon(Icons.error_outline, size: 100, color: Colors.red);
              },
            ),
            const SizedBox(height: 10), // Jarak kecil seperti di foto

            // ==========================================
            // EDIT DI SINI: Teks Sesuai Foto
            // ==========================================
            const Text(
              "CREATIVITY BECOME A REALITY",
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, // Sedikit tebal
                color: Colors.white, // Teks putih agar kontras
              ),
            ),
          ],
        ),
      ),
    );
  }
}