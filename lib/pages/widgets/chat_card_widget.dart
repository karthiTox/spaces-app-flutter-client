import 'package:flutter/material.dart';

class ChatCardWidget extends StatelessWidget {
  final Widget messageTitle;
  final Widget messageBody;
  final int messageComments;
  final Function() onPressedCommentsButton;
  final Function() onPressedSaveButton;

  const ChatCardWidget({
    Key? key,
    required this.messageTitle,
    required this.messageBody,
    required this.messageComments,
    required this.onPressedCommentsButton,
    required this.onPressedSaveButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: messageTitle,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: messageBody,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextButton(
              child: Text("$messageComments comments"),
              onPressed: onPressedCommentsButton,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextButton(
              child: Text("save"),
              onPressed: onPressedSaveButton,
            ),
          ),
        ],
      ),
    );
  }
}
