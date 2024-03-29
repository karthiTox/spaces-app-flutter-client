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
  final AnalyticInterface _mixPanelInterface;

  AuthProvider(this._authRepository, this._userRepository, this._mixPanelInterface);

  @override
  void dispose() {  
    _authRepository.dispose();
    super.dispose();
  }

  String _email = "";
  String _userId = "";
  String _password = "";
  String _retypePassword = "";

  String get email => _email;
  String get userId => _userId;
  String get password => _password;
  String get retypePassword => _retypePassword;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setUserId(String value) {
    _userId = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setRetypePassword(String value) {
    _retypePassword = value;
    notifyListeners();
  }

  Future<bool> Function() get isAuth => _authRepository.isAuth;

  Stream<User?> get authState => _authRepository.authState;

  Future<User> login() async {
    _validateEmail(_email);
    _validatePassword(_password);

    final user = await _authRepository.login(_email, _password);
    _mixPanelInterface.initUser(user);
    return user;
  }

  Future<User> register() async {
    _validateEmail(_email);
    _validatePassword(_password);
    if (_retypePassword != _password) {
      throw Exception("passwords are not matching");
    }

    final user = await _authRepository.register(_email, _password);
    _mixPanelInterface.initUser(user);
    return user;
  }

  Timer? handler;
  int waitingTime = 2;

  String _userIdSearchMessage = "";
  String get userIdSearchMessage => _userIdSearchMessage;

  void checkUserId(String userId) async {
    _userIdSearchMessage = "searching...";
    notifyListeners();
    handler?.cancel();
    handler = Timer(Duration(seconds: waitingTime), _handle);
  }

  void _handle() {
    if (_userId == userId) {
      _userRepository
          .findOneByUserId(userId)
          .then((user) => {
                if (user.uid == "")
                  _userIdSearchMessage = "$userId is available"
                else
                  _userIdSearchMessage = "$userId is not available"
              })
          .onError((error, stackTrace) => {
                // if(error.toString().length < 20) _userIdSearchMessage = error.toString()
              })
          .whenComplete(() => {notifyListeners()});
    }
  }

  Future<User> setId() =>
      _userRepository.changeUserId( _userId);

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
    _mixPanelInterface.updateInitialData();
  }
}
