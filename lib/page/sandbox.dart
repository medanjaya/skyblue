import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:skyblue/api.dart';

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  String
  token = '',
  refresh = '',
  shop = '',
  expiry = '';
  
  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('TOKEN: $token'),
        Text('REFRESH: $refresh'),
        Text('SHOP: $shop'),
        Text('EXPIRY: $expiry'),
        IconButton(
          onPressed: () async {
            authPartner();
            update();
          },
          icon: const Icon(Icons.login),
        ),
        IconButton(
          onPressed: () async {
            refreshToken();
            update();
          },
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () async {
            getItemList();
            update();
          },
          icon: const Icon(Icons.download),
        ),
        IconButton(
          onPressed: () async {
            getOrderList();
            update();
          },
          icon: const Icon(Icons.list_alt),
        ),
      ],
    );
  }

  void update() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(
      () {
        token = prefs.getString('token') ?? '';
        refresh = prefs.getString('refresh') ?? '';
        shop = prefs.getString('shop') ?? '';
        expiry = prefs.getString('expiry') ?? '';
      }
    );
  }
}