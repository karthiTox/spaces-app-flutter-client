import 'package:hive_flutter/hive_flutter.dart';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/db/auth_db.dart';
import 'package:spaces/utilities/db/user_db.dart';
import 'package:spaces/utilities/shared_storage.dart';

class DBInterface {
  final AuthDB authDB;
  final UserDB userDB;

  DBInterface({
    required this.authDB,
    required this.userDB,
  });

  static Future<DBInterface> getInstance({
    required SharedStorage sharedStorage,
  }) async {
    await Hive.initFlutter();

    const usersCol = "users";

    // adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }

    // opening boxes
    if (!Hive.isBoxOpen(usersCol)) await Hive.openBox(usersCol);

    return DBInterface(
      authDB: AuthDB(sharedStorage: sharedStorage, usersCol: usersCol),
      userDB: UserDB(usersCol: usersCol),
    );
  }
}
