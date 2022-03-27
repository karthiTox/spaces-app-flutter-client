import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:spaces/config.dart';
import 'package:spaces/repositories/auth_repository.dart';
import 'package:spaces/repositories/chat_repository.dart';
import 'package:spaces/repositories/user_repository.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/api/http_client.dart';
import 'package:spaces/utilities/authHandler.dart';
import 'package:spaces/utilities/db.dart';
import 'package:spaces/utilities/db/db.dart';
import 'package:spaces/utilities/shared_storage.dart';
import 'package:spaces/utilities/socket_io.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // utilities
  locator.registerSingleton(Config());

  locator.registerSingleton(
    SharedStorage(
      prefs: await SharedPreferences.getInstance(),
    ),
  );

  locator.registerSingleton(
    HttpClient(
      baseUrl: locator.get<Config>().BASE_URL,
      sharedStorage: locator.get(),
    ),
  );

  locator.registerSingleton(
    Api(
      baseUrl: locator.get<Config>().BASE_URL,
      client: locator.get(),
    ),
  );

  locator.registerSingleton(await DB.getInstance());

  locator.registerSingleton(
      await DBInterface.getInstance(sharedStorage: locator.get()));

  locator.registerSingleton(AuthHandler(api: locator.get(), db: locator.get()));

  locator.registerSingleton(SocketIO(baseUrl: locator.get<Config>().BASE_URL));

  // locator.registerSingleton(AnalyticInterface(
  //   mixpanel: await Mixpanel.init("0485a4695abda664bf852316745b4c76"),
  // ));

  // Repositories
  locator.registerSingleton(
    AuthRepository(
      api: locator.get(),
      db: locator.get<DBInterface>(),
    ),
  );
  locator.registerSingleton(
    UserRepository(
      api: locator.get(),
      db: locator.get<DBInterface>(),
    ),
  );
  locator.registerSingleton(
    ChatRepository(
      db: locator.get(),
      authHandler: locator.get(),
      api: locator.get<Api>(),
      sio: locator.get(),
    ),
  );
}
