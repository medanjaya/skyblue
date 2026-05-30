import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:skyblue/api.dart';

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  String token =  '', refresh = '', shop = '';
  
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('TOKEN: $token'),
        Text('REFRESH: $refresh'),
        Text('SHOP: $shop'),
        IconButton(
          onPressed: () {
            authPartner();
          },
          icon: const Icon(Icons.login),
        ),
        IconButton(
          onPressed: () {
            refreshToken();
          },
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () {
            getItemList();
          },
          icon: const Icon(Icons.download),
        ),
        IconButton(
          onPressed: () {
            getOrderList();
          },
          icon: const Icon(Icons.list_alt),
        ),
      ],
    );
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(
      () {
        token = prefs.getString('token') ?? '';
        refresh = prefs.getString('refresh') ?? '';
        shop = prefs.getString('shop') ?? '';
      }
    );
  }
}