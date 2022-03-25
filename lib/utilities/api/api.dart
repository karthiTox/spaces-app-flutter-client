import 'package:spaces/utilities/api/auth_api.dart';
import 'package:spaces/utilities/api/chat_api.dart';
import 'package:spaces/utilities/api/user_api.dart';

class Api {
  final String baseUrl;

  late final AuthApi authApi;
  late final UserApi userApi;
  late final ChatApi chatApi;

  Api(this.baseUrl) {
    authApi = AuthApi(baseUrl);
    userApi = UserApi(baseUrl);
    chatApi = ChatApi(baseUrl);
  }
}
