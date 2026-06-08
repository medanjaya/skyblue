import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class Sync extends StatefulWidget {
  const Sync({super.key});

  @override
  State<Sync> createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  final TextEditingController
  partner = TextEditingController(),
  secret = TextEditingController();

  bool isHide = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final sb = Supabase.instance.client;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        const Text('Sinkronisasi Shopee', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            spacing: 12.0,
            children: [
              const Row(
                spacing: 8.0,
                children: [
                  Icon(Icons.key, color: Color(0xFF007BFF),),
                  Text('Kunci API', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    'Partner ID',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: partner,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
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
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    'Secret Key',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: secret,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.security),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    
                    prefs.setString('partner', partner.text);
                    prefs.setString('secret', base64Encode(utf8.encode(secret.text)));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Kunci diperbarui, mohon untuk tidak disebarkan.'),
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text('Perbarui'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                const Column(
                  spacing: 16.0,
                  children: [
                    Row(
                      spacing: 8.0,
                      children: [
                        Icon(Icons.history),
                        Text('Aktivitas Terbaru'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('TANGGAL', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('TIPE EVENT', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('PESAN', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder(
                  stream: sb
                  .from('action')
                  .stream(
                    primaryKey: ['id'],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List actions = snapshot.data!;
                      
                      if (actions.isNotEmpty) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            final action = actions[i];
                        
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat('dd MMM yyyy hh:mm:ss').format(
                                      DateTime.parse(action['created_at']),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(action['type']),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: action['status']
                                            ? const Color.fromARGB(120, 0, 128, 0).withValues(alpha: 0.1)
                                            : const Color.fromARGB(120, 255, 0, 0).withValues(alpha: 0.1),
                                          
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 8,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                               color:
                                              action['status']
                                                ? Colors.green
                                                : Colors.red,
                                              size: 10,
                                            ),
                                            Text(action['status'] ? 'Success' : 'Error', style: TextStyle(
                                              color:
                                                action['status']
                                                ? Colors.green
                                                : Colors.red,
                                            )
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  flex: 2,
                                  child: Text(action['log']),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider();
                          },
                          itemCount: actions.length,
                        );
                      }
                      return const Expanded(
                        child: Center(
                          child: Text(
                            'Tidak ada riwayat untuk ditampilkan',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }
                    else {
                      return const Expanded(
                        child: Center(
                          child: Text(
                            'Sedang memperbarui riwayat aktivitas..',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();

    setState(
      () {
        partner.text = prefs.getString('partner') ?? '';
        secret.text = prefs.getString('secret') ?? '';
      }
    );
  }
}