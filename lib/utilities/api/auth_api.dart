import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api_helper.dart';
import 'package:spaces/utilities/shared_storage.dart';

class AuthApi extends ApiHelper {
  // handle the failed responses clearly.
  // currently it is returning the status code as an Exception message.
  // Don't return response body

  AuthApi(String baseUrl) : super(baseUrl);

  Future<User> login(String email, String password) async {
    final body = {
      "email": email,
      "password": password,
    };

    final response = await http.post(
      buildFullUrl("/auth/login"),
      headers: defaultHeaders,
      body: encodeRequestBody(body),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return User.fromJson(decodeResponseBody(response.body));
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

    final response = await http.post(
      buildFullUrl("/auth/register"),
      headers: defaultHeaders,
      body: encodeRequestBody(body),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return User.fromJson(decodeResponseBody(response.body));
    } else {
      // Don't return status code
      return throw Exception(response.statusCode);
    }
  }
}
