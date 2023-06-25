import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaces/pages/chats/chats_provider.dart';
import 'package:spaces/pages/widgets/user_widget.dart';

class ConfirmChatPage extends StatelessWidget {
  const ConfirmChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pick a unique group id",
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(margin: EdgeInsets.fromLTRB(20, 0, 20, 0), child: const ChatIdSearchBar()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Provider.of<ChatsProvider>(context, listen: false)
              .create()
              .then((value) => {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/chats/main", (route) => false),
                  }),
        },                
        icon: Icon(Icons.create),
        focusColor: Colors.grey,
        foregroundColor: Colors.white,
        label: Text('create'),
        elevation: 10,
      ),
    );
  }
}

class ChatIdSearchBar extends StatelessWidget {
  const ChatIdSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.start,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          decoration: const InputDecoration(
            filled: false,
            hintText: 'unique group id',
            border: InputBorder.none,
          ),
          onChanged: Provider.of<ChatsProvider>(context).searchChatId,
        ),
        Text(Provider.of<ChatsProvider>(context).chatMessage),
      ],
    );
  }
}
