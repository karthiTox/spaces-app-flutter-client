import 'dart:async';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api.dart';

import 'package:spaces/utilities/db/db.dart';

class AuthRepository {
  final Api api;
  final DBInterface db;
  User? currentUser;

  final _authState = StreamController<User?>.broadcast();
  void Function(User? event) get _changeAuthState => _authState.sink.add;
  Stream<User?> get authState => _authState.stream;

  AuthRepository({required this.api, required this.db});

  Future<User> login(String email, String password) async {
    final user = await api.authApi.login(email, password);
    await db.authDB.setCurrentUser(user);
    _changeAuthState(user);
    return user;
  }

  Future<User> register(String email, String password) async {
    final newUser = await api.authApi.registerNewAccount(email, password);
    await db.authDB.setCurrentUser(newUser);
    _changeAuthState(newUser);
    return newUser;
  }

  Future<void> logout() async {
    await db.authDB.delCurrentUser();
    _changeAuthState(null);
  }

  bool isAuth() => db.authDB.getToken() != "";
}
