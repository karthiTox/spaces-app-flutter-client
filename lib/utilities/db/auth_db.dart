import 'package:hive/hive.dart';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/shared_storage.dart';

class AuthDB {
  // this methods are used to save and fetch the current user's auth information.
  // the token is saved seperately

  final SharedStorage sharedStorage;
  final String usersCol;

  AuthDB({required this.sharedStorage, required this.usersCol});

  Future<void> setCurrentUser(User user) async {
    final box = Hive.box(usersCol);
    await box.put("currentUser", user);
    sharedStorage.setString("currentUserToken", user.token);
    await box.put("currentUserToken", user.token);
  }

  Future<User?> getCurrentUser() async {
    final box = Hive.box(usersCol);
    final user = box.get("currentUser", defaultValue: null) as User?;
    user?.token = box.get("currentUserToken", defaultValue: "") as String;
    return user;
  }

  Future<void> delCurrentUser() async {
    final box = Hive.box(usersCol);
    await box.delete("currentUser");
    await box.delete("currentUserToken");
    sharedStorage.delString("currentUserToken");
  }

  String getToken() {
    return sharedStorage.getString("currentUserToken") ?? "";
  }
}
