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

    // adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }

    return DBInterface(
      authDB: AuthDB(sharedStorage: sharedStorage),
      userDB: UserDB(),
    );
  }
}
