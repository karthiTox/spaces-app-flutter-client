import 'dart:async';
import 'dart:developer';

// // import 'package:/.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:spaces/config.dart';
import 'package:spaces/data/message.dart';
import 'package:spaces/data/user.dart';
import 'package:spaces/data/chat.dart';
import 'package:spaces/utilities/injector.dart';
import 'package:spaces/utilities/mix_panel.dart';
import 'package:spaces/utilities/socket_io.dart';
import 'package:spaces/repositories/auth_repository.dart';
import 'package:spaces/repositories/chat_repository.dart';
import 'package:spaces/repositories/user_repository.dart';

class ChatsProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  // final AnalyticInterface _mixPanelInterface;

  ChatsProvider(
    this._authRepository,
    this._userRepository,
    this._chatRepository,
    // this._mixPanelInterface,
  ) {
    // _authRepository.authState.listen((event) {
    //   log(event.toString());
    //   if (event != null) {
    //     //     final socket = SocketIO(baseUrl: "http://192.168.5.247:3000/api");
    //     // socket.startConnection(event.token);
    //     // socket.joinSocketRoom(["6210adbd27879a63d5a3c1f9"]);
    //     // socket.getMessageResponse.listen((event) {
    //     //   log(event.toString());
    //     // });
    //     // socket.sendMessage(Message(
    //     //   chatId: "6210adbd27879a63d5a3c1f9",
    //     //   parentId: "6210adbd27879a63d5a3c1f9",
    //     //   referenceNumber: 0,
    //     //   type: "",
    //     //   data: "parent",
    //     //   createdAt: 0,
    //     //   createdBy: "",
    //     // ));
    //     // socket.leaveSocketRoom(["6210adbd27879a63d5a3c1f9"]);
    //     // socket.disconnect();
    //   }
    // });
  }

  // chat page

  Future<void> signout() async {
    final chats = await _chatRepository.findCurrentUserChat();
    for (var chat in chats) {
      log("unsubscribeFromTopic: " + chat.id);
      // FirebaseMessaging.instance.unsubscribeFromTopic(chat.id);
    }
    await _authRepository.logout();
  }

  Future<bool> isNewChat(Chat chat) async {
    return chat.totalMessages >
        await _chatRepository.getRefernceNumber(chat.chatId);
  }

  Future<bool> isNewMessage(Message msg) async {
    return msg.referenceNumber >
        await _chatRepository.getRefernceNumber(msg.chatId);
  }

  void setLastSceenReferenceNumber(String? chatId, int? refNum) {
    if (chatId != null) _chatRepository.setRefernceNumber(chatId, refNum ?? 0);
  }

  // create_chats_page methods

  Timer? handler;
  int waitingTime = 2;

  String _userId = "";
  String get userId => _userId;

  final List<User> _users = [];
  List<User> get users => _users;

  final List<User> _selectedUsers = [];
  List<User> get selectedUsers => _selectedUsers;

  bool isSelectedUserNotEmpty() => _selectedUsers.isNotEmpty;

  void selectUser(String uid) {
    final index = _selectedUsers.indexWhere((element) => element.uid == uid);
    if (index != -1) return;
    _selectedUsers
        .add(users[users.indexWhere((element) => element.uid == uid)]);
    notifyListeners();
  }

  void unSelectUser(String uid) {
    final index = _selectedUsers.indexWhere((element) => element.uid == uid);
    if (index == -1) return;
    _selectedUsers.removeAt(index);
    notifyListeners();
  }

  bool isSelected(String uid) {
    return _selectedUsers.indexWhere((element) => element.uid == uid) != -1;
  }

  void searchUserId(String userId) async {
    _userId = userId;
    notifyListeners();
    handler?.cancel();
    handler = Timer(Duration(seconds: waitingTime), _handle);
  }

  void _handle() {
    if (_userId == userId) {
      _userRepository
          .findManyByUserId(
            userId,
          )
          .then((users) => {
                _users.clear(),
                _users.addAll(users.where((element) =>
                    element.uid != _authRepository.currentUser?.uid)),
                log(users.toString()),
              })
          .onError((error, stackTrace) => {
                log(error.toString()),
              })
          .whenComplete(notifyListeners);
    }
  }

  // confirm_page methods

  String _chatId = "";
  String get chatId => _chatId;

  String _chatMessage = "";
  String get chatMessage => _chatMessage;

  void searchChatId(String chatId) async {
    _chatMessage = "searching...";
    _chatId = chatId;
    notifyListeners();
    handler?.cancel();
    handler = Timer(Duration(seconds: waitingTime), () => _handle2(chatId));
  }

  void _handle2(String chatId) {
    if (_chatId == chatId) {
      _chatMessage = "";

      _chatRepository
          .fineOneChat(
            _chatId,
          )
          .then((chat) => {
                if (chat.id == "")
                  _chatMessage = "$chatId is avaliable"
                else
                  _chatMessage = "$chatId is not avaliable",
              })
          .whenComplete(() => {
                notifyListeners(),
              });
    }
  }

  Future<void> create() async {
    await _chatRepository.createNewChat(
      chatId,
      selectedUsers.map((e) => e.uid).toList()
        ..add(_authRepository.currentUser!.uid),
    );
  }

  // chats_page methods

  Future<List<Chat>> fetchMine() async {
    final chats = await _chatRepository.findCurrentUserChat();
    for (var chat in chats) {
      log(chat.id);
      // FirebaseMessaging.instance.subscribeToTopic(chat.id);
    }
    return chats;
  }

  // chat_cards_page methods

  String currentChatId = "";
  String _currentParentId = "";
  String get currentParentId => _currentParentId;

  Map<String, List<Message>> _messageTree = {};
  Map<String, List<Message>> get getMessageTree => _messageTree;

  Future<String> getName(String uid) async {
    final user = await _userRepository.findOneByUid(uid);
    log(user.userId);
    return user.userId;
  }

  String get getCurrentUserid => _authRepository.currentUser?.userId ?? "";

  void setChatId(String newChatId) {
    _messageTree = {};

    if (newChatId == "") {
      stopListeningIn(currentChatId);
    } else {
      startListeningIn(newChatId);
    }
    currentChatId = newChatId;
    _chatRepository.getAllMessagesByChatId(newChatId).then(addMessageInTree);
    _currentParentId = newChatId;

    // _mixPanelInterface.trackOpenedChat(newChatId);
  }

  void setParentId(String newParentId) {
    _chatRepository.getAllMessages(newParentId).then(addMessageInTree);
    setLastSceenReferenceNumber(_messageTree[newParentId]?[0].chatId,
        _messageTree[newParentId]?.length);
    _currentParentId = newParentId;
  }

  String _messageText = "";
  String get getmessageText => _messageText;

  void setMessageText(String messageText) {
    _messageText = messageText;
    notifyListeners();
  }

  StreamSubscription<Message>? _listener;

  void startListeningIn(String roomId) {
    _listener ??= _chatRepository.getMessageResponse.listen((message) {
      addMessageInTree([message]);
      notifyListeners();
    });

    _chatRepository.joinSocketRoom([roomId]);
  }

  void stopListeningIn(String roomId) {
    _listener?.cancel();
    _listener = null;

    _chatRepository.leaveSocketRoom([roomId]);
  }

  addMessageInTree(List<Message> messages) async {
    for (Message message in messages) {
      // replace createdBy(uid) with userId
      message.createdBy = await getName(message.createdBy);

      if (message.parentId == message.chatId) {
        _messageTree[message.messageId] = [message];
      } else {
        _messageTree[message.parentId] ??= [];
        final indexIfExist = _messageTree[message.parentId]?.indexWhere(
            (storedMessage) => storedMessage.messageId == message.messageId);
        if (indexIfExist == -1) {
          _messageTree[message.parentId]?.add(message);
        }
      }
    }

    notifyListeners();
  }

  Future<void> sendMessage() async {
    final message = await _chatRepository.sendMessage(Message(
      chatId: currentChatId,
      parentId: _currentParentId != "" ? _currentParentId : currentChatId,
      type: "message",
      data: _messageText,
    ));

    if (_currentParentId == "") {
      // _mixPanelInterface.trackCreatedSpace(message.chatId);
      setParentId(message.messageId);
    } else {
      final bool isMine = _messageTree[_currentParentId]?[0].createdBy ==
          _authRepository.currentUser?.userId;
      // _mixPanelInterface.trackReplied(currentChatId, isMine);
    }
  }

  void flushAllTrackedEvents() {
    // _mixPanelInterface.flushAll();
  }
}
