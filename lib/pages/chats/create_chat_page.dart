import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaces/pages/chats/chats_provider.dart';
import 'package:spaces/pages/widgets/user_widget.dart';

class CreateChatPage extends StatelessWidget {
  const CreateChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select user",
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: const Body(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          if(Provider.of<ChatsProvider>(context, listen: false).isSelectedUserNotEmpty())
            Navigator.pushNamed(context, "/chats/create/confirm")
          else 
            Navigator.pop(context)
        },
        icon: Icon(Icons.navigate_next),
        focusColor: Colors.grey,
        foregroundColor: Colors.white,
        label: Text('next'),
        elevation: 10,
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.start,
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        filled: false,
        hintText: "Search userId...",
      ),
      onChanged: Provider.of<ChatsProvider>(context).searchUserId,
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsProvider = Provider.of<ChatsProvider>(context);

    return Column(
      children: [
        SearchBar(),
        const SizedBox(height: 5),
        if (chatsProvider.selectedUsers.isNotEmpty)
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chatsProvider.selectedUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: UserWidget(
                      centerWidget: Text(
                        chatsProvider.selectedUsers[index].userId,
                      ),
                      endWidget: const Icon(Icons.close),
                    ),
                  ),
                  onTap: () => {
                    chatsProvider
                        .unSelectUser(chatsProvider.selectedUsers[index].uid)
                  },
                );
              },
            ),
          ),
          
        if (chatsProvider.selectedUsers.isNotEmpty) const SizedBox(height: 5),

        Expanded(
          child: ListView.builder(
            itemCount: chatsProvider.users.length,
            itemBuilder: (BuildContext context, int index) {
              final uid = chatsProvider.users[index].uid;
              return UserWidget(
                wrap: false,
                centerWidget: Text(
                  chatsProvider.users[index].userId,
                ),
                endWidget: Checkbox(
                  value: chatsProvider.isSelected(uid),
                  onChanged: (value) => {
                    if (value == true)
                      {chatsProvider.selectUser(uid)}
                    else
                      {chatsProvider.unSelectUser(uid)}
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
