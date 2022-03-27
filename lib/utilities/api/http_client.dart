import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:spaces/utilities/shared_storage.dart';

class HttpClient extends http.BaseClient {
  final Client _client = Client();

  final String baseUrl;
  final SharedStorage sharedStorage;

  HttpClient({required this.baseUrl, required this.sharedStorage});

  String endpoint(String url) {
    return "$baseUrl$url";
  }

  void _log(String url) {
    log(url, name: "info:httpClient");
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Cache-Control'] = 'no-cache';
    request.headers['x-access-token'] =
        sharedStorage.getString("currentUserToken") ?? "";

    return _client.send(request);
  }

  @override
  Future<http.Response> get(url, {Map<String, String>? headers}) {
    _log(endpoint(url.toString()));
    return super.get(Uri.parse(endpoint(url.toString())), headers: headers);
  }

  @override
  Future<http.Response> post(
    url, {
    Map<String, String>? headers,
    body,
    Encoding? encoding,
  }) {
    _log(endpoint(url.toString()));
    _log("body: $body");
    return super.post(
      Uri.parse(endpoint(url.toString())),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  // helper methods
  String encodeRequestBody<T>(T requestBody) {
    return jsonEncode(requestBody);
  }

  dynamic decodeResponseBody(String responseBody) {
    return jsonDecode(responseBody);
  }

  bool isResponseSuccessful(int responseStatusCode) {
    return (responseStatusCode >= 200 && responseStatusCode < 300);
  }
}
