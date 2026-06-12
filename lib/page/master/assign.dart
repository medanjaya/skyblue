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

class _AssignState extends State<Assign> {
  final TextEditingController
  name = TextEditingController(),
  email = TextEditingController(),
  pass = TextEditingController();

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
    final sb = Supabase.instance.client;
    final isEdit = widget.user != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEdit ? 'Atur User' : 'Tambah User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF),
              ),
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
        TextField(
          onChanged: (v) {
            email.text = v.isNotEmpty
            ? '${
              v.replaceAll(' ', '.').toLowerCase()
            }@skyblue.co.id'
            : '';
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
        ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8.0,
          children: [
            const Text('Role'),
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
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('User Aktif'),
          value: isActive,
          onChanged: (v) {
            setState(
              () {
                isActive = v;
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 16.0,
          children: [
            OutlinedButton(
              onPressed: () {
                name.clear();
                email.clear();
                setState(
                  () {
                    selectedRoles.clear();
                    isActive = true;
                  },
                );
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await sb.auth.admin
                .createUser(
                  AdminUserAttributes(
                    email: name.text,
                    password: pass.text,
                    emailConfirm: true,
                  ),
                )
                .then(
                  (r) {
                    sb.from('user').insert(
                      {
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
                );
              },
              child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
            ),
          ],
        ),
      ],
    );
  }
}

class IsAssign extends Notification {
  final bool v;
  IsAssign(this.v);
}