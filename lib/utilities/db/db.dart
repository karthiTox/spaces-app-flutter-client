import 'package:hive_flutter/hive_flutter.dart';
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/db/auth_DB.dart';

class DBInterface {
  final AuthDB authDB = AuthDB();

  static Future<DBInterface> getInstance() async {
    await Hive.initFlutter();

    // adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }

    return DBInterface();
  }
}
