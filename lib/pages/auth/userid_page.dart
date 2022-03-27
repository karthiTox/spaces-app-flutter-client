import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spaces/pages/auth/auth_provider.dart';

class UserIdPage extends StatelessWidget {
  const UserIdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;

    return Scaffold(
      appBar: AppBar(
        title:
            Text("pick a userId", style: Theme.of(context).textTheme.headline1),
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
    final authProviderListener =
        Provider.of<AuthProvider>(context, listen: true);

    return ListView(
      children: [
        Text(
          "UserId",
          textAlign: TextAlign.start,
          style: theme.textTheme.headline6,
        ),

        const SizedBox(height: spacing * 0.5),

        // Email
        TextField(
          decoration: const InputDecoration(hintText: "user_name"),
          style: theme.textTheme.headline6,
          onChanged: (userId) {
            authProvider.userId = userId;
            authProvider.checkUserId(userId);
          },
        ),

        const SizedBox(height: spacing * 0.5),

        Text(
          authProviderListener.isSearchingUserId
              ? "searching..."
              : authProvider.userId != ""
                  ? authProviderListener.isUserIdAvailable
                      ? "${authProviderListener.userId} is available"
                      : "${authProviderListener.userId} is not available"
                  : "",
          textAlign: TextAlign.center,
          style: theme.textTheme.headline6?.copyWith(
            color: authProviderListener.isSearchingUserId
                ? Theme.of(context).colorScheme.onBackground
                : authProviderListener.isUserIdAvailable
                    ? Theme.of(context).colorScheme.onBackground
                    : Theme.of(context).colorScheme.error,
          ),
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Provider.of<AuthProvider>(context, listen: true).error,
          textAlign: TextAlign.center,
          style: theme.textTheme.headline6?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: spacing),
        ElevatedButton(
          child: Text(
            "Let's start",
            style: Theme.of(context).textTheme.headline6,
          ),
          onPressed: () {
            authProvider.error = "";
            authProvider.changeUserId().then((value) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/chats/main',
                (Route<dynamic> route) => false,
              );
            }).catchError((error) {
              authProvider.error = error.toString();
            });
          },
        ),
      ],
    );
  }
}
