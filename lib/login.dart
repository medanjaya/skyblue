import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  isHide = true;
  
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
                                final
                                info = await DeviceInfoPlugin().deviceInfo,
                                time = DateTime.now().toIso8601String();
                                
                                await Supabase.instance.client
                                .from('user')
                                .update(
                                  switch (info.runtimeType.toString()) {
                                    'AndroidDeviceInfo' => {
                                      'device': info.data['model'],
                                      'type': 'android',
                                      'last_signed_at': time,
                                    },
                                    'IosDeviceInfo' => {
                                      'device': info.data['modelName'],
                                      'type': 'ios',
                                      'last_signed_at': time,
                                    },
                                    'LinuxDeviceInfo' => {
                                      'device': info.data['prettyName'],
                                      'type': 'linux',
                                      'last_signed_at': time,
                                    },
                                    'MacOsDeviceInfo' => {
                                      'device': info.data['computerName'],
                                      'type': 'macos',
                                      'last_signed_at': time,
                                    },
                                    'WebBrowserInfo' => {
                                      'device': switch (info.data['browserName'] as BrowserName) {
                                        BrowserName.firefox => 'Mozilla Firefox',
                                        BrowserName.samsungInternet => 'Samsung Internet',
                                        BrowserName.opera => 'Opera Web',
                                        BrowserName.msie => 'Internet Explorer',
                                        BrowserName.edge => 'Microsoft Edge',
                                        BrowserName.chrome => 'Google Chrome',
                                        BrowserName.safari => 'Apple Safari',
                                        BrowserName.unknown => '',
                                      },
                                      'type': 'web',
                                      'last_signed_at': time,
                                    },
                                    'WindowsDeviceInfo' => {
                                      'device': info.data['computerName'],
                                      'type': 'windows',
                                      'last_signed_at': time,
                                    },
                                    String() => {
                                      'device': '',
                                      'type': '',
                                      'last_signed_at': time,
                                    },
                                  },
                                )
                                .eq('id', r.user!.id)
                                .then(
                                  (v) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
          ),
          child: Text(label),
        ),
        duration: const Duration(
          seconds: 3,
        ),
      ),
    );
  }
}