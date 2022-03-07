import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/api_helper.dart';

class UserApi extends ApiHelper {
  @protected
  final String baseUrl;

  UserApi(this.baseUrl) : super(baseUrl);

  Future<User> findOneByUserId(String token, String userId) async {
    final response = await http.get(
      buildFullUrl("/users/userId/one/$userId"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return User.fromJson(decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }

   Future<User> findOneByUid(String token, String uid) async {
    final response = await http.get(
      buildFullUrl("/users/uid/one/$uid"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return User.fromJson(decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }


  // it fetches all the users which starts with the given userId
  // search = userId%
  Future<List<User>> findManyByUserId(String token, String userId) async {
    final response = await http.get(
      buildFullUrl("/users/userId/many/$userId"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      List<dynamic> fetchedUsersInJson = decodeResponseBody(response.body);
      List<User> fetchedUsers = [];
      for (var jsonUser in fetchedUsersInJson) {
        fetchedUsers.add(User.fromJson(jsonUser));
      }
      return fetchedUsers;
    } else {
      return throw Exception(response.statusCode);
    }
  }

  Future<User> changeUserId(String token, String userId) async {
    final response = await http.get(
      buildFullUrl("/users/userId/set/$userId"),
      headers: addTokenInHeader(defaultHeaders, token),
    );

    if (isResponseSuccessful(response.statusCode)) {
      return User.fromJson(decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }
}
