import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/db/db.dart';

class UserRepository {
  late final Api _api;
  late final DBInterface _db;

  UserRepository({
    required Api api,
    required DBInterface db,
  }) {
    _api = api;
    _db = db;
  }

  // users api call
  Future<User?> changeUserId(String userId) async {
    print("test");
    print(await _api.userApi.changeUserId(userId));
    final currentUser = await _db.authDB.getCurrentUser();
    if (currentUser != null) {
      currentUser.userId = userId;
      await _db.authDB.setCurrentUser(currentUser);
    }
    return currentUser;
  }

  Future<User> findOneByUserId(String userId) async {
    final user = await _db.userDB.getUserByUserId(userId);
    if (user != null) return user;
    return await _api.userApi.findOneByUserId(userId);
  }

  Future<User> findOneByUid(String uid) async {
    final user = await _db.userDB.getUserByUid(uid);
    if (user != null) return user;
    return await _api.userApi.findOneByUid(uid);
  }

  Future<List<User>> findManyByUserId(String userId) async {
    final users = await _db.userDB.getManyByUserId(userId);
    if (users != null) return users;
    return _api.userApi.findManyByUserId(userId);
  }
}
