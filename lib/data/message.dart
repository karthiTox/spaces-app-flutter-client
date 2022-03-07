import 'dart:convert';

import 'package:hive/hive.dart';

// part 'user.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  final String chatId;
  final String parentId;
  final String messageId;
  final int referenceNumber;
  final String type;
  final String data;
  final int createdAt;
  String createdBy;

  Message({
    required this.chatId,
    required this.parentId,
    this.messageId = "",
    this.referenceNumber = 0,
    required this.type,
    required this.data,
    this.createdAt = 0,
    this.createdBy = "",
  });

  @override
  String toString() {
    return """
    {
      chatId: $chatId,
      parentId: $parentId,
      messageId: $messageId,
      referenceNumber: $referenceNumber,
      type: $type,
      data: $data,
      createdAt: $createdAt,
      createdBy: $createdBy,
    }
    """;
  }

  static Map toMap(Message self) {
    return {
      "chatId": self.chatId,
      "parentId": self.parentId,
      "referenceNumber": self.referenceNumber,
      "type": self.type,
      "data": self.data,
      "createdAt": self.createdAt,
      "createdBy": self.createdBy,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      chatId: json["chatId"] ?? "",
      parentId: json["parentId"] ?? "",
      messageId: json["_id"] ?? "",
      referenceNumber: json["referenceNumber"] ?? 0,
      type: json["type"] ?? "",
      data: json["data"] ?? "",
      createdAt: 1,
      createdBy: json["createdBy"] ?? "",
    );
  }
}
