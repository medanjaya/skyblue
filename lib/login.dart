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
  email = TextEditingController(),
  pass = TextEditingController();

  bool
  isAble = true,
  isHide = true,
  isCheck = false;
  
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
              color: const Color.fromARGB(225, 135, 206, 235), 
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
              spacing: 16.0,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 84.0,
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    isDense: true,
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  enabled: isAble,
                ),
                TextField(
                  controller: pass,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    isDense: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () {
                            isHide = !isHide;
                          },
                        );
                      },
                      icon: Icon(
                        isHide
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: isHide,
                  enabled: isAble,
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    Checkbox(
                      onChanged: (v) {
                        setState(
                          () {
                            isCheck = v!;
                          },
                        );
                      },
                      value: isCheck,
                    ),
                    const Text('Remember Me?'),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: isAble //TODO DELETE fitur remember me cuman bisa di pro plan
                    ? () async {
                        setState(
                          () {
                            isAble = false;
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        );
                        try {
                          await Supabase.instance.client.auth.signInWithPassword(
                            email: email.text,
                            password: pass.text,
                          )
                          .then(
                            (r) async {
                              if (r.user != null) {
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Selamat datang kembali, ${
                                        await Supabase.instance.client
                                        .from('user')
                                        .select()
                                        .eq('id', r.user!.id)
                                        .then(
                                          (r) {
                                            return r.first['name'];
                                          }
                                        )
                                      }.',
                                    ),
                                    duration: const Duration(
                                      seconds: 3,
                                    ),
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
                              'invalid_credentials' => 'Email atau Password salah!',
                              'validation_failed' => 'Masukkan Email dan Password terlebih dahulu!',
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
                      backgroundColor: Colors.white,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: isAble
                    ? const Text(
                      'MASUK', 
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
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
      },
    );
    ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(
        content: Text(label),
        duration: const Duration(
          seconds: 3,
        ),
      ),
    );
  }
}