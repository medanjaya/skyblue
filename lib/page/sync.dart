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
  final SupabaseClient sb = Supabase.instance.client;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        const Text('Sinkronisasi Shopee'),
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
                  Icon(Icons.key),
                  Text('Kunci API'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    'Partner ID',
                    style: TextStyle(
                      fontSize: 10.0,
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
                      fontSize: 10.0,
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
                    prefs.setString('secret', secret.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Kunci diperbaharui, mohon untuk tidak disebarkan.'),
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text('Perbaharui'),
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
                          child: Text('TANGGAL'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('TIPE EVENT'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('STATUS'),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('PESAN'),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder(
                  stream: sb
                  .from('act')
                  .select()
                  .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final acts = snapshot.data;
                      
                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          final act = acts[i];
                      
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  DateFormat('dd/MM/yyyy hh:mm:ss').format(
                                    DateTime.parse(act['created_at']),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(act['type']),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  spacing: 8.0,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color:
                                      act['status']
                                      ? Colors.green
                                      : Colors.red,
                                      size: 18,
                                    ),
                                    Text(
                                      act['status']
                                      ? 'Success'
                                      : 'Error',
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(act['log']),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, i) {
                          return const Divider();
                        },
                        itemCount: acts!.length,
                      );
                    }
                    else {
                      return const Expanded(
                        child: Center(
                          child: Text(
                            'Tidak ada aktivitas untuk ditampilkan.',
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

    partner.text = prefs.getString('partner') ?? '';
    secret.text = prefs.getString('secret') ?? '';
  }
}