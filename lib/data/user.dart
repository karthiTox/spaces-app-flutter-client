import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0) final String userId;
  @HiveField(1) final String email;
  final String password;
  @HiveField(2) final String uid;
  int v;
  
  String token;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.uid,
    this.v = 0,
    this.token = "",
  });

  @override
  String toString() => """
  {
    userId => $userId,
    email => $email,
    uid => $uid,
    v => $v,
    token => $token,
  }
  """;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json["userId"] ?? "",
        email: json["email"] ?? "",
        password: json["passwod"] ?? "",
        uid: json["_id"] ?? "",
        v: json["__v"] ?? 0,
        token: json["token"] ?? "");
  }
}
