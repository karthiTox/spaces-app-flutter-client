import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage {
  final SharedPreferences prefs;
  SharedStorage({required this.prefs});

  Future<SharedStorage> getInstance() async {
    return SharedStorage(prefs: await SharedPreferences.getInstance());
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  void setString(String key, String value) {
    prefs.setString(key, value);
  }
}
