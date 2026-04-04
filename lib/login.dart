import 'package:flutter/material.dart';

import 'package:skyblue/dashboard.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final SupabaseClient sb = Supabase.instance.client;
  final TextEditingController user = TextEditingController(), pass = TextEditingController();

  bool isAble = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/back.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            width: 384.0,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85), 
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 8.0,
                  offset: Offset(0, 4.0),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //TODO cek lagi nanti, mungkin bisa diupdate sama yang png
                Image.asset(
                  'assets/logo_sk.png',
                  width: 60.0,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'LOGIN TO YOUR ACCOUNT', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24.0),
                TextField(
                  controller: user,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: pass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: isAble
                    ? () async {
                        setState(
                          () {
                            isAble = false;
                          }
                        );
                        try {
                          await sb.auth.signInWithPassword(
                            email: user.text,
                            password: pass.text,
                          )
                          .then(
                            (v) {
                              if (v.user != null) {
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Selamat datang kembali, ${v.user!.email}.'
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                )
                                .closed
                                .then(
                                  (r) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Dashboard(),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }
                        on AuthApiException catch (e) {
                          setState(
                            () {
                              isAble = true;
                            }
                          );
                          ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                switch (e.code as String) {
                                  'invalid_credentials' => 'Username atau Password salah!',
                                  'validation_failed' => 'Masukkan Username dan Password terlebih dahulu!',
                                  String() => 'Ada yang salah, coba beberapa saat lagi.',
                                },
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Login', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}