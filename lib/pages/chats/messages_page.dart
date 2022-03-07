import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaces/data/chat.dart';
import 'package:spaces/data/message.dart';

import 'package:spaces/pages/chats/chats_provider.dart';
import 'package:spaces/pages/widgets/chat_card_widget.dart';
import 'package:spaces/pages/widgets/user_widget.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    final caller = Provider.of<ChatsProvider>(context, listen: true);
    final totMsgs =
        (caller.getMessageTree[caller.currentParentId]?.length ?? 0);
    return Scaffold(
      appBar: AppBar(title: Text("messages")),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            reverse: true,
            itemCount: totMsgs > 0 ? totMsgs + 2 : 0,
            itemBuilder: (BuildContext context, int index) {
              final items =
                  caller.getMessageTree[caller.currentParentId]!.toList();
              if (index == 0) {
                return const SizedBox(
                  height: 80,
                );
              }

              if (index == items.length) {
                return const SizedBox(
                  width: double.infinity,
                  child: Center(child: Text("---- replies ----")),
                );
              }

              index -= index < items.length ? 1 : 2;

              items.sort((a, b) {
                if (a.referenceNumber > b.referenceNumber) {
                  return -1;
                } else {
                  return 1;
                }
              });
              final item = items[index];
              return ChatBubble(
                userId: item.createdBy,
                text: item.data,
                isCurrentUser: (caller.getCurrentUserid == item.createdBy),
              );
            },
          ),

          // bottom bar
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              color: Color.fromARGB(131, 0, 0, 0),
              height: 70,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        filled: false,
                        hintText: 'message...',
                      ),
                      onChanged:(value){
                          Provider.of<ChatsProvider>(context, listen: false)
                              .setMessageText(value); _controller.text = value;},
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      Provider.of<ChatsProvider>(context, listen: false)
                          .sendMessage(),
                      _controller.text = ""
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: const Color.fromARGB(255, 154, 70, 202),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class Body extends StatelessWidget {
//   const Body({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final caller = Provider.of<ChatsProvider>(context, listen: true);
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             itemCount:
//                 caller.getMessageTree[caller.currentParentId]?.length ?? 0,
//             itemBuilder: (BuildContext context, int index) {
//               final item =
//                   caller.getMessageTree[caller.currentParentId]![index];
//               return Container(
//                   margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
//                   child: ChatCardWidget(
//                       messageTitle: Text(item.createdBy),
//                       messageBody: Text(item.data),
//                       messageComments: 30,
//                       onPressedCommentsButton: () {},
//                       onPressedSaveButton: () {}));
//             },
//           ),
//         ),
//         Expanded(
//           child: Row(
//             children: [
//               TextField(
//                 decoration: const InputDecoration(hintText: "Message.."),
//                 style: Theme.of(context).textTheme.headline6,
//                 onChanged: (value) =>
//                     Provider.of<ChatsProvider>(context, listen: false)
//                         .setMessageText(value),
//               ),
//               IconButton(
//                 onPressed: () => {
//                   Provider.of<ChatsProvider>(context, listen: false)
//                       .sendMessage(),
//                 },
//                 icon: const Icon(Icons.send),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.userId,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);

  final String userId;
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // add some padding
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Color.fromARGB(255, 162, 69, 255)
                : Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "$userId\n$text",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: isCurrentUser ? Colors.white : Colors.white),
              textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}
