import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Assign extends StatefulWidget {
  const Assign(
    {
      super.key,
      this.user,
    }
  );

  final Map? user;

  @override
  State<Assign> createState() => _AssignState();
}
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }
}

class _AssignState extends State<Assign> {
  final TextEditingController
  name = TextEditingController(),
  email = TextEditingController(),
  pass = TextEditingController(),
  secret = TextEditingController();

  final List<String> roles = [
    'admin',
    'master',
    'stock',
    'transaction',
    'report',
  ];

  bool isHide = true;

  late Set<String> selectedRoles;
  late bool isActive;

  

  @override
  void initState() {
    super.initState();

    name.text = widget.user?['name'] ?? '';
    email.text = widget.user?['email'] ?? '';
    pass.text = widget.user != null ? 'kenapa kamu ngintip begitu, siapa yang suruh' : '';

    selectedRoles = Set<String>.from(widget.user?['role'] ?? []);
    isActive = widget.user?['is_active'] ?? true;
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Perbarui User' : 'Tambah User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007BFF),
                  ),
                ),
                Text(
                  isEdit
                    ? 'Ubah data yang ingin diperbarui'
                    : 'Isi data lengkap untuk menambah akun baru',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              onPressed: () {
                setState(
                  () {
                    IsAssign(false).dispatch(context);
                  },
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),

        Expanded(
          child: Center(
            
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    const _SectionLabel(label: 'INFORMASI AKUN'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (v) {
                                !isEdit
                                ? email.text = v.isNotEmpty
                                  ? '${
                                    v.replaceAll(' ', '.').toLowerCase()
                                  }@skyblue.co.id'
                                  : ''
                                : null;
                              },
                              controller: name,
                              decoration: const InputDecoration(
                                labelText: 'Nama',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: email,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              enabled: !isEdit,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: pass,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 8.0,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: !isEdit
                                  ? () {
                                    setState(
                                      () {
                                        isHide = !isHide;
                                      },
                                    );
                                  }
                                  : null,
                                  icon: Icon(
                                    isHide
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              obscureText: isHide,
                              enabled: !isEdit,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _SectionLabel(label: 'HAK AKSES'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 8.0,
                          children: [
                            const Text('Pilih satu atau lebih role'),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: roles.map(
                                (role) {
                                  return FilterChip(
                                    label: Text(role),
                                    selected: selectedRoles.contains(role),
                                    onSelected: (v) {
                                      setState(
                                        () {
                                          if (v) {
                                            selectedRoles.add(role);
                                          } else {
                                            selectedRoles.remove(role);
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const _SectionLabel(label: 'STATUS & OTORISASI'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'User Aktif',
                                style: TextStyle(
                                  color: Theme.of(context).primaryIconTheme.color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: isActive,
                              onChanged: (v) {
                                setState(
                                  () {
                                    isActive = v;
                                  },
                                );
                              },
                            ),
                            const Divider(height: 8),
                            const Text('Secret Key'),
                            const SizedBox(height: 8),
                            Row(
                              spacing: 16.0,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: secret,
                                    decoration: InputDecoration(
                                      hintText: 'Isi key untuk ${
                                        isEdit
                                        ? 'memperbarui'
                                        : 'menambahkan'
                                      } user',
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final sb = SupabaseClient(
                              'https://nodpqwqildvzjpnechui.supabase.co',
                              secret.text,
                            );
                            
                            !isEdit
                            ? await sb.auth.admin
                            .createUser(
                              AdminUserAttributes(
                                email: email.text,
                                password: pass.text,
                                emailConfirm: true,
                              ),
                            )
                            .then(
                              (r) {
                                sb.from('user').insert(
                                  {
                                    'id': r.user!.id,
                                    'name': name.text,
                                    'email': email.text,
                                    'role': selectedRoles.toList(),
                                    'is_active': isActive,
                                  },
                                )
                                .select()
                                .then(
                                  (r) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('User dengan nama ${r.first['name']} berhasil ditambahkan.'),
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    )
                                    .closed
                                    .then(
                                      (r) {
                                        IsAssign(false).dispatch(context);
                                      },
                                    );
                                  },
                                );
                              },
                            )
                            : await sb.from('user').update(
                              {
                                'name': name.text,
                                'role': selectedRoles.toList(),
                                'is_active': isActive,
                              },
                            )
                            .eq('id', widget.user!['id'])
                            .select()
                            .then(
                              (r) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'User dengan nama ${r.first['name']} berhasil diperbarui.',
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                )
                                .closed
                                .then(
                                  (r) {
                                    IsAssign(false).dispatch(context);
                                  },
                                );
                              },
                            );
                          },
                          child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        
        
        
        
        
      ],
    );
  }
}

class IsAssign extends Notification {
  final bool v;
  IsAssign(this.v);
}