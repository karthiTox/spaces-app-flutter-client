import 'package:spaces/utilities/api/auth_api.dart';
import 'package:spaces/utilities/api/http_client.dart';
import 'package:spaces/utilities/api/chat_api.dart';
import 'package:spaces/utilities/api/user_api.dart';

class Api {
  final String baseUrl;
  final HttpClient client;

  late final AuthApi authApi;
  late final UserApi userApi;
  late final ChatApi chatApi;

  Api({required this.baseUrl, required this.client}) {
    authApi = AuthApi(client);
    userApi = UserApi(client);
    chatApi = ChatApi(baseUrl);
  }
}
