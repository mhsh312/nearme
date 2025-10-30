import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class UserTest extends StatelessWidget {
  UserTest({super.key});

  void signOut() {
    AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User")),
      body: Column(
        children: [
          SelectableText(AuthService().user?.uid ?? "user"),
          ElevatedButton(onPressed: signOut, child: Text("sign out")),
        ],
      ),
    );
  }
}
