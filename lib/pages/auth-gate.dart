import 'package:flutter/material.dart';
import 'package:nearme/pages/user-test.dart';
import 'package:nearme/pages/feed.dart';
import 'package:nearme/services/auth.dart';

import 'auth-page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("An error has occured."));
        } else if (snapshot.hasData) {
          return Center(child: Feed());
        } else {
          return AuthPage();
        }
      },
    );
  }
}
