import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/shared_storage.dart';

class UserDB {
  final usersCol = "users";

  // this methods are used to save and fetch the current user's auth information.
  // the token is saved seperately

  UserDB() {
    _init();
  }

  void _init() async {
    final box = await Hive.openBox<User>(usersCol);
    for (var user in box.values) {
      log(user.toString(), name: "info:UserDB");
    }
  }

  Future<void> saveUser(User user) async {
    final box = await Hive.openBox(usersCol);
    await box.put(user.uid, user);
  }

  Future<User?> getUserByUserId(String userId) async {
    try {
      final box = await Hive.openBox<User>(usersCol);
      final user = box.values.firstWhere(
        (user) => user.userId == userId,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<List<User>?> getManyByUserId(String userId) async {
    final box = await Hive.openBox<User>(usersCol);
    final users =
        box.values.where((user) => user.userId.contains(userId, 0)).toList();
    return users;
  }

  Future<User?> getUserByUid(String uid) async {
    final box = await Hive.openBox(usersCol);
    final user = box.get(uid, defaultValue: null) as User?;
    return user;
  }

  Future<void> delUserByUid(String uid) async {
    final box = await Hive.openBox(usersCol);
    await box.delete(uid);
  }
}
