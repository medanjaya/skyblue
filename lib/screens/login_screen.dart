//telah merge ke login.dart

/* import 'package:flutter/material.dart';
import 'package:skyblue/screens/dashboard.dart';
// EDIT DI SINI: Pastikan import package projectmu benar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void _handleLogin() {
    // Logika login tetap sama
    if (userController.text == "jamesrusli123" && passController.text == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau Password Salah!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ==========================================
      // EDIT DI SINI: Background Gambar Toko
      // ==========================================
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background_store.jpg'), // Path gambar background
            fit: BoxFit.cover, // Gambar memenuhi layar
            // Menambahkan filter gelap agar kotak login lebih terbaca
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Gelapkan 50%
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 350,
            decoration: BoxDecoration(
              // Kotak putih transparan seperti di foto
              color: Colors.white.withOpacity(0.85), 
              borderRadius: BorderRadius.circular(20), // Sudut membulat
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==========================================
                // EDIT DI SINI: Logo Kecil di Atas Teks Login
                // ==========================================
                Image.asset(
                  'assets/logo_sk.png',
                  width: 60, // Ukuran kecil
                ),
                const SizedBox(height: 10),
                const Text(
                  "LOGIN TO YOUR ACCOUNT", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),

                // Input Username
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                    labelText: "Username",
                    border: OutlineInputBorder(), // Garis tepi kotak
                  ),
                ),
                const SizedBox(height: 15),

                // Input Password
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                    labelText: "Password",
                    border: OutlineInputBorder(), // Garis tepi kotak
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Warna abu-abu seperti foto
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Login", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
} */