import 'package:flutter/material.dart';

import '../model/user.dart';
import '../pages/login_page.dart';

class UserInfoDialog extends StatelessWidget {
  final User user;
  const UserInfoDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('User Info'),
      content: SingleChildScrollView(
        child: ListBody(children: [
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 10),
              Text(user.login),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.key),
              const SizedBox(width: 10),
              Text(user.password),
            ],
          ),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.green),
            )),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (context) => const LoginPage()),
                ModalRoute.withName('/'),
              );
            },
            child: const Text(
              'Sign out',
              style: TextStyle(color: Colors.green),
            )),
      ],
    );
  }
}
