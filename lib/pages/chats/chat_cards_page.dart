// import 'dart:ffi';
// it is showing error when import 'dart:fii';
// : Error: Not found: 'dart:ffi'
// lib/…/chats/chat_cards_page.dart:1
// import 'dart:ffi';
//        ^

// Failed to compile application.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spaces/pages/chats/chats_provider.dart';

class ChatCardsPage extends StatelessWidget {
  const ChatCardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cards")),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Body(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Provider.of<ChatsProvider>(context, listen: false).setParentId(""),
          Navigator.pushNamed(context, "/chats/messages"),
        },
        icon: Icon(Icons.group),
        focusColor: Colors.grey,
        foregroundColor: Colors.white,
        label: Text('new space'),
        elevation: 10,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totCards = Provider.of<ChatsProvider>(context, listen: true)
        .getMessageTree
        .keys
        .length;

    if (totCards == 0) return Text("loading...");

    return ListView.builder(
      itemCount: totCards,
      itemBuilder: (context, index) {
        final tree =
            Provider.of<ChatsProvider>(context, listen: false).getMessageTree;
        final treeKeys = tree.keys.toList();
        treeKeys.sort((a, b) {
          if (tree[a]![0].referenceNumber > tree[b]![0].referenceNumber) {
            return -1;
          } else {
            return 1;
          }
        });
        final parentId = treeKeys.elementAt(index);
        final item = Provider.of<ChatsProvider>(context, listen: false)
            .getMessageTree[parentId]![0];

        return FutureBuilder(
            future: Provider.of<ChatsProvider>(context, listen: false)
                .isNewMessage(item),
            builder: (context, sp) {
              return buildCard(context, sp.hasData ? sp.data as bool : false,
                  (item.createdBy), item.data, () {
                Provider.of<ChatsProvider>(context, listen: false)
                    .setParentId(item.messageId);
                Navigator.pushNamed(context, "/chats/messages");
              }, tree[parentId]?.length ?? 0);
            });
      },
    );
  }
}

Card buildCard(BuildContext context, bool isNew, String name, String data,
    void Function() onPressedCommentsBtn, int comments) {
  return Card(
      elevation: 4.0,
      color: Colors.black,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNew)
              Container(
                  width: 5,
                  height: 5,
                  color: Color.fromARGB(255, 144, 82, 243)),
            if (isNew)
              SizedBox(
                height: 5,
              ),
            Text(
              name,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                data,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: onPressedCommentsBtn,
              child: Text("${comments - 1} comment"),
              style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 43, 43, 43)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // ElevatedButton(
            //   onPressed: () => {},
            //   child: Text("Save"),
            //   style: ButtonStyle(
            //       minimumSize:
            //           MaterialStateProperty.all<Size>(Size.fromHeight(50)),
            //       backgroundColor: MaterialStateProperty.all<Color>(
            //           Color.fromARGB(255, 43, 43, 43)),
            //       foregroundColor:
            //           MaterialStateProperty.all<Color>(Colors.white)),
            // ),
          ],
        ),
      ));
}
