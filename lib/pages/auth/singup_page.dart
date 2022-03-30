import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spaces/pages/auth/auth_provider.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Signin", style: Theme.of(context).textTheme.headline1),
      ),
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ListView(
      children: [
        // Text(
        //   "Spaces",
        //   style: theme.textTheme.headline1,
        //   textAlign: TextAlign.center,
        // ),

        // const SizedBox(height: spacing * 0.5),

        Text(
          "Email",
          textAlign: TextAlign.start,
          style: theme.textTheme.headline6,
        ),

        const SizedBox(height: spacing * 0.5),

        // Email
        TextField(
          decoration: const InputDecoration(hintText: "your@email.com"),
          style: theme.textTheme.headline6,
          onChanged: (value) => authProvider.email = value,
        ),

        const SizedBox(height: spacing * 0.5),

        Text(
          "Password",
          textAlign: TextAlign.start,
          style: theme.textTheme.headline6,
        ),

        const SizedBox(height: spacing * 0.5),

        // Password
        TextField(
          decoration: const InputDecoration(hintText: "****"),
          style: theme.textTheme.headline6,
          obscureText: true,
          onChanged: (value) => authProvider.password = value,
        ),

        const SizedBox(height: spacing * 0.5),

        Text(
          "Retype Password",
          textAlign: TextAlign.start,
          style: theme.textTheme.headline6,
        ),

        const SizedBox(height: spacing * 0.5),

        // Password
        TextField(
          decoration: const InputDecoration(hintText: "****"),
          style: theme.textTheme.headline6,
          obscureText: true,
          onChanged: (value) => authProvider.retypePassword = value,
        ),
      ],
    );
  }
}

class BottomSection extends StatefulWidget {
  const BottomSection({Key? key}) : super(key: key);

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool isLoading = false;

  void setLoading(bool value) => setState(() => isLoading = value);

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authProviderListener =
        Provider.of<AuthProvider>(context, listen: true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          authProviderListener.error,
          textAlign: TextAlign.center,
          style: theme.textTheme.headline6?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: spacing),
        ElevatedButton(
          child: Text("Next", style: Theme.of(context).textTheme.headline6),
          onPressed: isLoading
              ? null
              : () {
                  setLoading(true);
                  authProvider.error = "";
                  authProvider.register().then((value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/auth/userId',
                      (Route<dynamic> route) => true,
                    );
                  }).catchError((error) {
                    authProvider.error = error.toString();
                  }).whenComplete(() {
                    setLoading(false);
                  });
                },
        ),
      ],
    );
  }

  moveToStartScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/auth/login',
      (Route<dynamic> route) => false,
    );
  }
}
