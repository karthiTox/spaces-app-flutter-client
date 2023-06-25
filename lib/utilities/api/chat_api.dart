import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spaces/data/chat.dart';
import 'package:spaces/data/message.dart';
import 'package:spaces/utilities/api/api_helper.dart';

class ChatApi extends ApiHelper {
  @protected
  final String baseUrl;

  ChatApi(this.baseUrl) : super(baseUrl);

  Future<Chat> createNewChat(
    String token,
    String chatId,
    List<String> members,
  ) async {
    final Map body = {
      "chatId": chatId,
      "members": members,
    };

    final response = await http.post(
      buildFullUrl("/chat/create"),
      body: encodeRequestBody(body),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return Chat.fromJson(decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }

  Future<Chat> fineOneChat(String token, String chatId) async {
    final response = await http.get(
      buildFullUrl("/chat/find/one/$chatId"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return Chat.fromJson(decodeResponseBody(response.body));
    } else {
      return throw Exception(response.body);
    }
  }

  Future<List<Chat>> findCurrentUserChat(String token) async {
    final response = await http.get(
      buildFullUrl("/chat/mine"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      List<dynamic> fetchedChatsInJson = decodeResponseBody(response.body);
      List<Chat> fetchedchats = [];

      for (var chatInJson in fetchedChatsInJson) {
        fetchedchats.add(Chat.fromJson(chatInJson));
      }
      return fetchedchats;
    } else {
      return throw Exception(response.statusCode);
    }
  }

  // message api

  Future<List<Message>> getAllMessages(String token, String parentId) async {
    try {
      
    
    final response = await http.get(
      buildFullUrl("/chat/find/messages/parentId/$parentId"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      print(response.body);
      List<dynamic> fetchedMessagesInJson = decodeResponseBody(response.body);
      print(fetchedMessagesInJson);
      List<Message> fetchedMessages = [];
      print(fetchedMessagesInJson.length);

      for (var messageInJson in fetchedMessagesInJson) {
        print(messageInJson);
        print("test");
        final mes = Message.fromJson(messageInJson);
        print(mes.referenceNumber);
        print("test");
        fetchedMessages.add(Message.fromJson(messageInJson));
      }

      print(fetchedMessages);
      return fetchedMessages;
    } else {
      
      return throw Exception(response.statusCode);
    }

    } catch (e) {
      print(e);
      return throw e;
    }
  }

  Future<List<Message>> getAllMessagesByChatId(String token, String chatId) async {    
    final response = await http.get(
      buildFullUrl("/chat/find/messages/chatId/$chatId"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      List<dynamic> fetchedMessagesInJson = decodeResponseBody(response.body);
      List<Message> fetchedMessages = [];

      for (var messageInJson in fetchedMessagesInJson) {
        final mes = Message.fromJson(messageInJson);
        fetchedMessages.add(Message.fromJson(messageInJson));
      }

      return fetchedMessages;
    } else {
      
      return throw Exception(response.statusCode);
    }

  }
}
