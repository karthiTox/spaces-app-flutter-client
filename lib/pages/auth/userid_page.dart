import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spaces/pages/auth/auth_provider.dart';

class UserIdPage extends StatefulWidget {
  const UserIdPage({Key? key}) : super(key: key);

  @override
  State<UserIdPage> createState() => _UserIdPageState();
}

class _UserIdPageState extends State<UserIdPage> {
  bool isLoading = false;
  String errorMessage = "";

  Future<void> signUp() async {
    setState(() => {isLoading = true, errorMessage = ""});

    try {
      await Provider.of<AuthProvider>(context, listen: false).setId();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/chats/main', (Route<dynamic> route) => false);
    } catch (error) {
      setState(() => errorMessage = error.toString().substring(0, 20));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("UserId", style: Theme.of(context).textTheme.headline1),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Pick the userId",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: spacing),

              // _userId_ input field.
              TextField(
                decoration: const InputDecoration(hintText: "UserId"),
                style: Theme.of(context).textTheme.headline6,
                onChanged: (userId) => {
                  Provider.of<AuthProvider>(context, listen: false).checkUserId(userId),
                  Provider.of<AuthProvider>(context, listen: false).setUserId(userId)
                },
              ),
              const SizedBox(height: spacing * 0.5),

              Text(Provider.of<AuthProvider>(context, listen: true).userIdSearchMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: spacing * 0.5),

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
                    child: Text("signup",
                        style: Theme.of(context).textTheme.headline6),
                    onPressed: signUp)
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
            ],
          ),
        ),
      ),
    );
  }
}
