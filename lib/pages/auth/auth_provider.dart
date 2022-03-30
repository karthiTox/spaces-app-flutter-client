import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:spaces/data/user.dart';
import 'package:spaces/repositories/auth_repository.dart';
import 'package:spaces/repositories/user_repository.dart';
import 'package:spaces/utilities/mix_panel.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  // final AnalyticInterface _mixPanelInterface;

  AuthProvider(
    this._authRepository,
    this._userRepository,
    // this._mixPanelInterface
  );

  String _email = "";
  String _password = "";
  String _userId = "";
  String _retypePassword = "";
  String _error = "";
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String get userId => _userId;
  String get retypePassword => _retypePassword;
  String get error => _error;
  bool get isLoading => _isLoading;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set retypePassword(String value) {
    _retypePassword = value;
    notifyListeners();
  }

  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    email = "";
    password = "";
    userId = "";
    retypePassword = "";
    error = "";
    isLoading = false;
  }

  bool isAuth() => _authRepository.isAuth();

  Future<User> login() async {
    _validateEmail(_email);
    _validatePassword(_password);

    isLoading = true;

    try {
      final user = await _authRepository.login(_email, _password);
      // _mixPanelInterface.initUser(user);
      return user;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<User> register() async {
    _validateEmail(_email);
    _validatePassword(_password);
    if (_retypePassword != _password) {
      throw Exception("passwords are not matching");
    }

    isLoading = true;

    try {
      final user = await _authRepository.register(_email, _password);
      return user;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Timer? handler;
  int waitingTime = 2;

  bool _isSearchingUserId = false;
  bool _isUserIdAvailable = false;

  bool get isSearchingUserId => _isSearchingUserId;
  bool get isUserIdAvailable => _isUserIdAvailable;

  void checkUserId(String userId) async {
    handler?.cancel();
    _isUserIdAvailable = false;
    _isSearchingUserId = true;
    _isLoading = true;

    notifyListeners();

    handler = Timer(Duration(seconds: waitingTime), _waitAndcheckUserId);
  }

  void _waitAndcheckUserId() {
    if (userId != "") {
      _userRepository.findOneByUserId(userId).then((user) {
        _isUserIdAvailable = user.uid == "" ? true : false;
      }).catchError((error) {
        _error = error.toString();
      }).whenComplete(() {
        _isSearchingUserId = false;
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<User?> changeUserId() {
    if (isUserIdAvailable != true) throw Exception("$_userId is not available");
    final user = _userRepository.changeUserId(_userId);
    return user;
  }

  // input validators
  final _emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  void _validateEmail(String email) {
    if (!_emailRegEx.hasMatch(email)) {
      throw Exception("email is not valid");
    }
  }

  _validatePassword(String password) {
    if (password.length < 4) {
      throw Exception("password length should be greater than 6");
    }
  }

  // events

  updateInitialTrackingData() {
    // _mixPanelInterface.updateInitialData();
  }
}
