import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaces/pages/auth/auth_provider.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isAuth().then(
      (isLoggedIn) {
        if(isLoggedIn) Provider.of<AuthProvider>(context, listen: false).updateInitialTrackingData();

        Navigator.of(context).pushNamedAndRemoveUntil(
          isLoggedIn ? '/chats/main' : '/auth/login',
          (route) => false,
        );
      },
    );

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Welcome to the Spaces!"),
      ),
    );
  }
}
