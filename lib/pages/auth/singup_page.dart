import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spaces/pages/auth/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isLoading = false;
  String errorMessage = "";

  Future<void> onSignupBtnPressed() async {
    setState(() => {isLoading = true, errorMessage = ""});

    try {
      await Provider.of<AuthProvider>(context, listen: false).register();
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/auth/userId', (Route<dynamic> route) => false);
    } catch (error) {
      setState(() => errorMessage = error.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void onLoginBtnPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up", style: Theme.of(context).textTheme.headline1),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Create an account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: spacing),

              // _Email_ input field.
              TextField(
                decoration: const InputDecoration(hintText: "Email"),
                style: Theme.of(context).textTheme.headline6,
                onChanged: Provider.of<AuthProvider>(context).setEmail,
              ),
              const SizedBox(height: spacing * 0.5),

              // _Password_ input field.
              TextField(
                decoration: const InputDecoration(hintText: "Password"),
                style: Theme.of(context).textTheme.headline6,
                onChanged: Provider.of<AuthProvider>(context).setPassword,
              ),
              const SizedBox(height: spacing * 0.5),

              // _Retype password_ input field.
              TextField(
                decoration: const InputDecoration(hintText: "Retype password"),
                style: Theme.of(context).textTheme.headline6,
                onChanged: Provider.of<AuthProvider>(context).setRetypePassword,
              ),
              const SizedBox(height: spacing),

              if (errorMessage != "")
                Text(errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Theme.of(context).colorScheme.error)),

              if (errorMessage != "") const SizedBox(height: spacing),

              if (!isLoading)
                ElevatedButton(
                    child: Text(
                      "Continue",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: onSignupBtnPressed)

              else
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: null,
                ),                
              const SizedBox(height: spacing),

              GestureDetector(
                onTap: onLoginBtnPressed,
                child: Text(
                  "Already have an account?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }
}
