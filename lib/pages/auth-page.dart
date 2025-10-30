import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth.dart';

void _signInWithGoogle() {
  AuthService().googleLogin();
}

void _signInWithPhone() {
  print('Navigate to Phone Sign-in Screen');
}

void _signInAnonymously() {
  AuthService().anonLogin();
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_AppLogo(), _AuthButtonGroup()],
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text("Near Me"), FaIcon(FontAwesomeIcons.locationArrow)],
    );
  }
}

class _AuthButtonGroup extends StatelessWidget {
  const _AuthButtonGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FractionallySizedBox(
            widthFactor: 0.7,
            child: _AuthButton(
              text: Text("Sign in with Google"),
              icon: FaIcon(FontAwesomeIcons.google),
              onPressed: _signInWithGoogle,
            ),
          ),
          SizedBox(height: 15),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: _AuthButton(
              text: Text("Sign in with Phone"),
              icon: FaIcon(FontAwesomeIcons.phone),
              onPressed: _signInWithPhone,
            ),
          ),
          SizedBox(height: 15),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: _AuthButton(
              text: Text("Sign in Anonymously"),
              icon: FaIcon(FontAwesomeIcons.user),
              onPressed: _signInAnonymously,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final Text text;
  final FaIcon icon;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(onPressed: onPressed, icon: icon, label: text);
  }
}

class PhoneAuthButton extends StatelessWidget {
  const PhoneAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _signInWithPhone,
      icon: FaIcon(FontAwesomeIcons.phone),
      label: Text("Sign in with phone"),
    );
  }
}

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _signInWithGoogle,
      icon: FaIcon(FontAwesomeIcons.google),
      label: Text("Sign in with Google"),
    );
  }
}

class AnonAuthButton extends StatelessWidget {
  const AnonAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _signInAnonymously,
      icon: FaIcon(FontAwesomeIcons.user),
      label: Text("anon signin"),
    );
  }
}
