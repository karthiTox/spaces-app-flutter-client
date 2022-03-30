import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:spaces/data/user.dart';

class UserDB {
  final String usersCol;

  UserDB({required this.usersCol}) {
    _init();
  }

  void _init() async {
    final box = Hive.box(usersCol);
    log("start printing UserDB", name: "info:UserDB");
    for (var user in box.values) {
      log(user.toString(), name: "info:UserDB");
    }
    log("end printing UserDB", name: "info:UserDB");
  }

  Future<void> saveUser(User user) async {
    final box = Hive.box(usersCol);
    await box.put(user.uid, user);
  }

  Future<User?> getUserByUserId(String userId) async {
    try {
      final box = Hive.box<User>(usersCol);
      final user = box.values.firstWhere(
        (user) => user.userId == userId,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<List<User>?> getManyByUserId(String userId) async {
    final box = Hive.box<User>(usersCol);
    final users =
        box.values.where((user) => user.userId.contains(userId, 0)).toList();
    return users;
  }

  Future<User?> getUserByUid(String uid) async {
    final box = Hive.box(usersCol);
    final user = box.get(uid, defaultValue: null) as User?;
    return user;
  }

  Future<void> delUserByUid(String uid) async {
    final box = Hive.box(usersCol);
    await box.delete(uid);
  }
}
