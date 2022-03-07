import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  
  final bool wrap;
  final Widget centerWidget;
  final Widget? endWidget;

  const UserWidget({
    Key? key,
    this.wrap = true,
    required this.centerWidget,
    this.endWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: wrap ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        mainAxisSize: wrap ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: centerWidget,
            ),
          ),
          if (endWidget != null)
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: endWidget!,
              ),
            ),
        ],
      ),
    );
  }
}
