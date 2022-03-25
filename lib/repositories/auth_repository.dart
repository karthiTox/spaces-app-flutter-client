import 'dart:async';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api.dart';

import 'package:spaces/utilities/db/db.dart';

class AuthRepository {
  final Api api;
  final DBInterface db;
  User? currentUser;

  AuthRepository({required this.api, required this.db});

  Future<User> login(String email, String password) async {
    final user = await api.authApi.login(email, password);
    await db.authDB.setCurrentUser(user);
    return user;
  }

  Future<User> register(String email, String password) async {
    final newUser = await api.authApi.registerNewAccount(email, password);
    await db.authDB.setCurrentUser(newUser);
    return newUser;
  }

  Future<void> logout() async {
    await db.authDB.delCurrentUser();
  }
}
