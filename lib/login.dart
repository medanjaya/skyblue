import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:skyblue/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController
  user = TextEditingController(),
  pass = TextEditingController();

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
                Image.asset(
                  'assets/logo.png',
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
                  enabled: isAble,
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
                  enabled: isAble,
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
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          }
                        );
                        try {
                          await Supabase.instance.client.auth.signInWithPassword(
                            email: user.text,
                            password: pass.text,
                          )
                          .then(
                            (r) {
                              if (r.user != null) {
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Selamat datang kembali, ${r.user!.email}.'
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
                                        builder: (context) => const Home(),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }
                        on AuthApiException catch (e) {
                          showExceptionSnackBar(
                            switch (e.code as String) {
                              'invalid_credentials' => 'Username atau Password salah!',
                              'validation_failed' => 'Masukkan Username dan Password terlebih dahulu!',
                              String() => 'Ada yang salah, mohon coba beberapa saat lagi.',
                            },
                          );
                        }
                        on AuthRetryableFetchException {
                          showExceptionSnackBar('Tidak terhubung ke internet saat ini!');
                        }
                        catch (e) {
                          showExceptionSnackBar('Ada yang salah, mohon hubungi pengembang.');
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
                    child: isAble
                    ? const Text(
                      'Login', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    )
                    : const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(),
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

  void showExceptionSnackBar(String label) {
    setState(
      () {
        isAble = true;
      }
    );
    ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(
        content: Text(label),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}