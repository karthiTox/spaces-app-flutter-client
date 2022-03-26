import 'package:hive/hive.dart';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/shared_storage.dart';

class AuthDB {
  final usersCol = "users";

  // this methods are used to save and fetch the current user's auth information.
  // the token is saved seperately

  final SharedStorage sharedStorage;

  AuthDB({required this.sharedStorage});

  Future<void> setCurrentUser(User user) async {
    final box = await Hive.openBox(usersCol);
    await box.put("currentUser", user);
    sharedStorage.setString("currentUserToken", user.token);
    await box.put("currentUserToken", user.token);
  }

  Future<User?> getCurrentUser() async {
    final box = await Hive.openBox(usersCol);
    final user = box.get("currentUser", defaultValue: null) as User?;
    user?.token = box.get("currentUserToken", defaultValue: "") as String;
    return user;
  }

  Future<void> delCurrentUser() async {
    final box = await Hive.openBox(usersCol);
    await box.delete("currentUser");
    await box.delete("currentUserToken");
    sharedStorage.delString("currentUserToken");
  }
}
