import 'dart:convert';

import 'package:hive/hive.dart';

// part 'user.g.dart';

@HiveType(typeId: 0)
class Chat extends HiveObject {
  @HiveField(0)
  final String chatId;
  @HiveField(1)
  @HiveField(2)
  final int totalMessages;
  final List<String> members;
  final String id;
  int v;

  Chat({
    required this.chatId,
    required this.members,
    required this.totalMessages,
    required this.id,
    this.v = 0,
  });

  @override
  String toString() {
    return """
    {
      chatId: $chatId,
      member: $members,
      totalMessages: $totalMessages
    }
    """;
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    final members = <String>[];

    if (json.containsKey("members")) {
      final membersJson = json["members"] as List<dynamic>;

      for (var element in membersJson) {
        if (element is String) {
          members.add(element);
        }
      }

    }

    return Chat(
      chatId: json["chatId"] ?? "",
      members: members,
      totalMessages: json["totalMessages"] ?? 0,
      id: json["_id"] ?? "",
      v: json["__v"] ?? 0,
    );
  }
}
