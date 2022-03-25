import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaces/pages/auth/auth_provider.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/auth/login',
      (route) => false,
    );

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Welcome to the Spaces!\nchange this screen"),
      ),
    );
  }
}
