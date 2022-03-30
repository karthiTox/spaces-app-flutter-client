import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spaces/pages/auth/auth_provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;

    return Scaffold(
      body: Stack(
        children: const [
          Padding(
            padding: EdgeInsets.only(
                left: spacing, right: spacing, top: spacing * 0.5),
            child: Align(
              alignment: Alignment.topCenter,
              child: InputSection(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BottomSection(),
            ),
          )
        ],
      ),
    );
  }
}

class InputSection extends StatelessWidget {
  const InputSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    final theme = Theme.of(context);

    return ListView(
      children: [
        Text(
          "Spaces",
          style: theme.textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: spacing * 0.5),
        Text(
          "#Never misses the important messages!",
          textAlign: TextAlign.center,
          style: theme.textTheme.headline6,
        ),
      ],
    );
  }
}

class BottomSection extends StatelessWidget {
  const BottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: spacing * 0.5),
        ElevatedButton(
          key: const Key("login_btn"),
          child: Text("login", style: theme.textTheme.headline6),
          onPressed: () => onLoginButtonPressed(context),
        ),
        const SizedBox(height: spacing * 0.5),
        ElevatedButton(
          child: Text("register", style: theme.textTheme.headline6),
          style: theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(100, 100, 100, 100),
            ),
          ),
          onPressed: () => onRegisterButtonPressed(context),
        ),
      ],
    );
  }

  void onLoginButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/auth/login',
      (Route<dynamic> route) => true,
    );
  }

  void onRegisterButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/auth/signup',
      (Route<dynamic> route) => true,
    );
  }
}
