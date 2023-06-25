import 'package:get_it/get_it.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:spaces/config.dart';
import 'package:spaces/repositories/auth_repository.dart';
import 'package:spaces/repositories/chat_repository.dart';
import 'package:spaces/repositories/user_repository.dart';
import 'package:spaces/utilities/api/api.dart';
import 'package:spaces/utilities/authHandler.dart';
import 'package:spaces/utilities/db.dart';
import 'package:spaces/utilities/mix_panel.dart';
import 'package:spaces/utilities/socket_io.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton(Config());

  locator.registerSingleton<ApiInterface>(
    ApiInterface(locator.get<Config>().BASE_URL),
  );
  locator.registerSingleton<DB>(
    await DB.getInstance(),
  );
  locator.registerSingleton(AuthHandler(
    api: locator.get(),
    db: locator.get(),
  ));
  locator.registerSingleton(SocketIO(
    baseUrl: locator.get<Config>().BASE_URL,
  ));
  locator.registerSingleton(AnalyticInterface(
    mixpanel: await Mixpanel.init("0485a4695abda664bf852316745b4c76"),
  ));

  locator.registerSingleton(
      AuthRepository(authHandler: locator.get<AuthHandler>()));
  locator.registerSingleton(
      UserRepository(authHandler: locator.get(), api: locator.get()));
  locator.registerSingleton(ChatRepository(
    db: locator.get(),
    authHandler: locator.get(),
    api: locator.get<ApiInterface>(),
    sio: locator.get(),
  ));
}
