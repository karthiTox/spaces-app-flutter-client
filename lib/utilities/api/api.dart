import 'package:spaces/utilities/api/auth_api.dart';
import 'package:spaces/utilities/api/chat_api.dart';
import 'package:spaces/utilities/api/user_api.dart';

class ApiInterface {
  final String baseUrl;

  late final AuthApi authApi;
  late final UserApi userApi;
  late final ChatApi chatApi;

  ApiInterface(this.baseUrl) {
    authApi = AuthApi(baseUrl);
    userApi = UserApi(baseUrl);
    chatApi = ChatApi(baseUrl);
  }
}
