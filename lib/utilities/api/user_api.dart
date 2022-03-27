import 'package:spaces/data/user.dart';
import 'package:spaces/utilities/api/http_client.dart';

class UserApi {
  final HttpClient client;

  UserApi(this.client);

  Future<User> findOneByUserId(String userId) async {
    final response = await client.get(
      Uri.parse("/users/userId/one/$userId"),
    );

    if (client.isResponseSuccessful(response.statusCode)) {
      return User.fromJson(client.decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }

  Future<User> findOneByUid(String uid) async {
    final response = await client.get(
      Uri.parse("/users/uid/one/$uid"),
    );

    if (client.isResponseSuccessful(response.statusCode)) {
      return User.fromJson(client.decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }

  // it fetches all the users which starts with the given userId
  // search = userId%
  Future<List<User>> findManyByUserId(String userId) async {
    final response = await client.get(
      Uri.parse("/users/userId/many/$userId"),
    );

    if (client.isResponseSuccessful(response.statusCode)) {
      List<dynamic> fetchedUsersInJson =
          client.decodeResponseBody(response.body);
      List<User> fetchedUsers = [];
      for (var jsonUser in fetchedUsersInJson) {
        fetchedUsers.add(User.fromJson(jsonUser));
      }
      return fetchedUsers;
    } else {
      return throw Exception(response.statusCode);
    }
  }

  Future<User> changeUserId(String userId) async {
    final response = await client.get(
      Uri.parse("/users/userId/set/$userId"),
    );

    if (client.isResponseSuccessful(response.statusCode)) {
      return User.fromJson(client.decodeResponseBody(response.body));
    } else {
      return throw Exception(response.statusCode);
    }
  }
}
