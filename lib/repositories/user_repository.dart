import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/authHandler.dart';

class UserRepository {
  late final Api _api;
  late final AuthHandler _auth;

  UserRepository({
    required AuthHandler authHandler,
    required Api api,
  }) {
    _api = api;
    _auth = authHandler;
  }

  // users api call
  Future<User> findOneByUserId(String userId) =>
      _api.userApi.findOneByUserId(_auth.getToken(), userId);

  Future<User> findOneByUid(String uid) =>
      _api.userApi.findOneByUid(_auth.getToken(), uid);

  Future<User> changeUserId(String userId) =>
      _api.userApi.changeUserId(_auth.getToken(), userId);

  Future<List<User>> findManyByUserId(String userId) =>
      _api.userApi.findManyByUserId(_auth.getToken(), userId);
}
