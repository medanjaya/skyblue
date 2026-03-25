import 'package:flutter/material.dart';
import 'package:skyblue/menu/menu.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final SupabaseClient sb = Supabase.instance.client;
  final TextEditingController email = TextEditingController(), pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            'assets/back.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 3,
            height: MediaQuery.sizeOf(context).height / 3,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 48.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16.0,
                  children: [
                    const Text('LOGIN TO YOUR ACCOUNT'),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person_outlined)
                      ),
                      controller: email,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock_outlined)
                      ),
                      obscureText: true,
                      controller: pass,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Menu(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}