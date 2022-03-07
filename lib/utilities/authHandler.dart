import 'dart:async';

import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/db.dart';

class AuthHandler {
  late final ApiInterface _api;
  late final DB _db;

  final _authState = StreamController<User?>.broadcast();
  void Function(User? event) get changeAuthState => _authState.sink.add;
  Stream<User?> get getAuthState => _authState.stream;

  User? currentUser;

  AuthHandler({required ApiInterface api, required DB db}) {
    _api = api;
    _db = db;

    _db.getCurrentUser().then(_updateAuthState);
  }

  void dispose() {
    _authState.close();
  }

  Future<bool> isAuth() async {
    final currentUser = await _db.getCurrentUser();
    return currentUser != null;
  }

  void _updateAuthState(User? user) {
    currentUser = user;
    changeAuthState(user);
  }

  String getToken() {
    if (currentUser == null) {
      return throw Exception("not authorized, no auth token");
    }
    return currentUser!.token;
  }

  Future<User> login(String email, String password) async {
    final user = await _api.authApi.login(email, password);
    await _db.setCurrentUser(user);
    _updateAuthState(user);
    return user;
  }

  Future<User> registerNewAccount(String email, String password) async {
    final newUser = await _api.authApi.registerNewAccount(email, password);
    await _db.setCurrentUser(newUser);
    _updateAuthState(newUser);
    return newUser;
  }

  Future<void> signOut() async {
    await _db.delCurrentUser();
    _updateAuthState(null);    
  }
}
