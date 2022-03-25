import 'dart:async';

import 'package:spaces/data/chat.dart';
import 'package:spaces/data/message.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/authHandler.dart';
import 'package:spaces/utilities/db.dart';
import 'package:spaces/utilities/socket_io.dart';

import '../data/user.dart';

class ChatRepository {
  late final Api _api;
  late final AuthHandler _auth;
  late final DB _db;
  late final SocketIO _sio;

  late StreamSubscription<User?> _authState;

  ChatRepository({
    required AuthHandler authHandler,
    required Api api,
    required DB db,
    required SocketIO sio,
  }) {
    _api = api;
    _auth = authHandler;
    _db = db;
    _sio = sio;

    _authState = _auth.getAuthState.listen((currentUser) {
      if (currentUser != null) {
        sio.startConnection(currentUser.token);
        _authState.cancel();
      }
    });
  }

  // chats api calls
  // Add local db storage when fetch
  Future<Chat> createNewChat(String chatId, List<String> members) =>
      _api.chatApi.createNewChat(_auth.getToken(), chatId, members);

  Future<Chat> fineOneChat(String chatId) =>
      _api.chatApi.fineOneChat(_auth.getToken(), chatId);

  Future<List<Chat>> findCurrentUserChat() =>
      _api.chatApi.findCurrentUserChat(_auth.getToken());

  Future<List<Message>> getAllMessages(String parentId) async {
    if (parentId == "") return [];
    return _api.chatApi.getAllMessages(_auth.getToken(), parentId);
  }

  Future<List<Message>> getAllMessagesByChatId(String chatId) async {
    if (chatId == "") return [];
    return _api.chatApi.getAllMessagesByChatId(_auth.getToken(), chatId);
  }

  // db
  Future<void> Function(String, int) get setRefernceNumber =>
      _db.setRefernceNumber;
  Future<int> Function(String) get getRefernceNumber => _db.getRefernceNumber;

  Future<Message> sendMessage(Message message) => _sio.sendMessage(message);
  Stream<Message> get getMessageResponse => _sio.getMessageResponse;
  void Function(List<String>) get joinSocketRoom => _sio.joinSocketRoom;
  void Function(List<String>) get leaveSocketRoom => _sio.leaveSocketRoom;
}
