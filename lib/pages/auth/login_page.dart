import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:spaces/data/user.dart';

import 'package:spaces/pages/auth/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {         
    return _Content();
  }
}

class _Content extends StatefulWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool isLoading = false;
  String errorMessage = "";


  Future<void> onLoginBtnPressed() async {
    setState(() => {isLoading = true, errorMessage = ""});

    try {
      await Provider.of<AuthProvider>(context, listen: false).login();
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/chats/main', (Route<dynamic> route) => false);
    } catch (error) {
      setState(() => errorMessage = error.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void onSignupBtnPressed() {
    Navigator.pushNamed(context, "/auth/signup");
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    final providerCaller = Provider.of<AuthProvider>(context, listen: false);

    // StreamSubscription<User?> ins;
    // final ins = providerCaller.authState.listen((event) {
    //   if (event != null) {
    //     Navigator.of(context).pushNamedAndRemoveUntil(
    //       '/chats/main',
    //       (route) => false,
    //     );
    //     ins.cancel();
    //   }
    // });

    return Scaffold(
      body: Center(
        child: SizedBox(
            width: 350,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Spaces",
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center),

                  const SizedBox(height: spacing * 0.5),

                  Text("#Differnet spaces different conversations",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),

                  const SizedBox(height: spacing),

                  // _Email_ input field.
                  TextField(
                      decoration: const InputDecoration(hintText: "Email"),
                      style: Theme.of(context).textTheme.headline6,
                      onChanged: (value) => providerCaller.setEmail(value)),

                  const SizedBox(height: spacing * 0.5),

                  // _Password_ input field.
                  TextField(
                      decoration: const InputDecoration(hintText: "Password"),
                      style: Theme.of(context).textTheme.headline6,
                      obscureText: true,
                      onChanged: (value) => providerCaller.setPassword(value)),

                  const SizedBox(height: spacing),

                  if (errorMessage != "")
                    Text(errorMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Theme.of(context).colorScheme.error)),

                  if (errorMessage != "") const SizedBox(height: spacing),

                  if (!isLoading)
                    ElevatedButton(
                        child: Text("Login",
                            style: Theme.of(context).textTheme.headline6),
                        onPressed: onLoginBtnPressed)
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
                    onTap: onSignupBtnPressed,
                    child: Text("Don't have an account?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
                  )
                ])),
      ),
    );
  }
}


// Container(
//             width: 350, 
//             child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "${
//                 Provider.of<LoginProvider>(context).counter
//             }",
//             style: Theme.of(context).textTheme.headline1,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: spacing * 0.5),

//           Text("#Differnet spaces different conversations",
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.headline6
//           ),
//           const SizedBox(height: spacing),

//           // _Email_ input field.
//           TextField(
//               decoration: const InputDecoration(hintText: "Email"),
//               style: Theme.of(context).textTheme.headline6,
//               onChanged: (value) => {
//                 // Provider.of<LoginProvider>(context).setEmail(value)
//               },
//           ),
//           const SizedBox(height: spacing * 0.5),

//           // _Password_ input field.
//           TextField(
//               decoration: const InputDecoration(hintText: "Password"),
//               style: Theme.of(context).textTheme.headline6),
//           const SizedBox(height: spacing),

//           ElevatedButton(
//               child: Text(
//                 "Login",
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//               onPressed: () => {
//                 Provider.of<LoginProvider>(context, listen: false).incC() 
//               }),

//           const SizedBox(height: spacing),
//           GestureDetector(
//             onTap: () {
//               // Navigator.push(context,
//               //     MaterialPageRoute(builder: (_) => const SignupPage()));
//             },
//             child: Text(
//               "Don't have an account?",
//               textAlign: TextAlign.center,
//               style: Theme.of(context)
//                   .textTheme
//                   .headline6
//                   ?.copyWith(color: Theme.of(context).colorScheme.secondary),
//             ),
//           )
//         ])
//           )
