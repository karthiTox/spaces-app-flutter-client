import 'dart:async';
import 'dart:developer';

import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/authHandler.dart';
import 'package:spaces/utilities/db.dart';

import '../config.dart';
import '../data/message.dart';
import '../utilities/injector.dart';
import '../utilities/socket_io.dart';

class AuthRepository {
  late final AuthHandler _authHandler;

  late final Stream<User?> authState;
  User? get currentUser => _authHandler.currentUser;

  AuthRepository({required AuthHandler authHandler}) {
    _authHandler = authHandler;

    authState = _authHandler.getAuthState;


  }

  Future<bool> Function() get isAuth => _authHandler.isAuth;

  void dispose() {}

  Future<User> Function(String, String) get login => _authHandler.login;

  Future<User> Function(String, String) get register =>
      _authHandler.registerNewAccount;

  Future<void> Function() get signOut => _authHandler.signOut;
}
