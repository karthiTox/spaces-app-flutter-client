import 'package:http/http.dart' as http;
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/base_client.dart';

class AuthApi {
  // handle the failed responses clearly.
  // currently it is returning the status code as an Exception message.
  // Don't return response body

  final HttpClient client;

  AuthApi(this.client);

  Future<User> login(String email, String password) async {
    final body = {
      "email": email,
      "password": password,
    };

    final response = await client.post(
      Uri.parse("/auth/login"),
      body: client.encodeRequestBody(body),
    );

    if (client.isResponseSuccessful(response.statusCode)) {
      return User.fromJson(client.decodeResponseBody(response.body));
    } else {
      // Don't return status code
      return throw Exception(response.statusCode);
    }
  }

  Future<User> registerNewAccount(String email, String password) async {
    final Map body = {
      "email": email,
      "password": password,
    };

    final response = await client.post(
      Uri.parse("/auth/register"),
      body: client.encodeRequestBody(body),
    );

    if (client.isResponseSuccessful(response.statusCode)) {
      return User.fromJson(client.decodeResponseBody(response.body));
    } else {
      // Don't return status code
      return throw Exception(response.statusCode);
    }
  }
}
