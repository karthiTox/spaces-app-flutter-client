import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaces/data/chat.dart';

import 'package:spaces/pages/chats/chats_provider.dart';
import 'package:spaces/pages/widgets/user_widget.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Spaces",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              child: Text("sign out"),
              onPressed: () => {
                Provider.of<ChatsProvider>(context, listen: false).flushAllTrackedEvents(),

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Expanded(
                      child: AlertDialog(
                        title: Text('Sign out'),
                        content: Text('Are you sure ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<ChatsProvider>(context, listen: false)
                                  .signout()
                                  .then((value) => {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/auth/login',
                                                (Route<dynamic> route) => false)
                                      });
                            },
                            child: Text('confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
      body: Body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          "/chats/create",
        ),
        icon: Icon(Icons.person_add),
        focusColor: Colors.grey,
        foregroundColor: Colors.white,
        label: Text('new chat'),
        elevation: 10,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ChatsProvider>(context, listen: false).fetchMine(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("no data");
          final data = snapshot.data as List<Chat>;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: GestureDetector(
                  child: UserWidget(
                      wrap: false,
                      centerWidget: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          data[index].chatId,
                        ),
                      ),
                      endWidget: FutureBuilder(
                        future:
                            Provider.of<ChatsProvider>(context, listen: false)
                                .isNewChat(data[index]),
                        builder: (context, ss) {
                          if (!ss.hasData) {
                            return Text(data[index].totalMessages.toString());
                          } else {
                            return Container(
                              width: 10,
                              height: 10,
                              color: Color.fromARGB(255, 150, 71, 229),
                            );
                          }
                        },
                      )),
                  onTap: () => {
                    Provider.of<ChatsProvider>(context, listen: false)
                        .setChatId(data[index].id),
                    print("test"),
                    Navigator.of(context).pushNamed('/chats/cards')
                  },
                ),
              );
            },
          );
        });
  }
}
