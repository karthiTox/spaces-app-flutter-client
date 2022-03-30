import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:spaces/data/user.dart';

class DB {
  final usersCol = "users";
  final chatsCol = "chats";

  static Future<DB> getInstance() async {
    await Hive.initFlutter();

    // adapters
    Hive.registerAdapter(UserAdapter());

    Hive.openBox("users");

    return DB();
  }

  Future<void> setUser(User user) async {
    final box = Hive.box(usersCol);
    await box.put(user.uid, user);
  }

  Future<User> getUser(String uid) async {
    final box = Hive.box(usersCol);
    final user = await box.get(uid) as User;
    return user;
  }

  // chats reference number saver
  Future<void> setRefernceNumber(String chatId, int refNum) async {
    final box = Hive.box(chatsCol);
    await box.put(chatId, refNum);
  }

  Future<int> getRefernceNumber(String chatId) async {
    final box = Hive.box(chatsCol);
    return await box.get(chatId, defaultValue: 0) as int;
  }

  // this methods are used to save and fetch the current user's auth information.
  // the token is saved seperately
  Future<void> setCurrentUser(User user) async {
    final box = Hive.box(usersCol);
    await box.put("currentUser", user);
    await box.put("currentUserToken", user.token);
  }

  Future<User?> getCurrentUser() async {
    final box = Hive.box(usersCol);
    final user = box.get("currentUser", defaultValue: null) as User?;
    user?.token = box.get("currentUserToken", defaultValue: "") as String;
    return user;
  }

  Future<void> delCurrentUser() async {
    final box = Hive.box(usersCol);
    box.delete("currentUser");
    box.delete("currentUserToken");
  }
}
