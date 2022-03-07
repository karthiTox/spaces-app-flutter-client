import 'dart:convert';
import 'dart:developer';

class ApiHelper {
  late final String _baseUrl;

  final Map<String, String> defaultHeaders = {
    "Content-type": "application/json",
  };

  ApiHelper(String baseUrl) {
    _baseUrl = baseUrl;
  }

  String encodeRequestBody<T>(T requestBody) {
    return jsonEncode(requestBody);
  }

  dynamic decodeResponseBody(String responseBody) {
    return jsonDecode(responseBody);
  }

  bool isResponseSuccessful(int responseStatusCode) {
    return (responseStatusCode >= 200 && responseStatusCode < 300);
  }

  Uri buildFullUrl(String path) {
    log("$_baseUrl$path");
    return Uri.parse("$_baseUrl$path");
  }

  Map<String, String> addDefaultHeaders(Map<String, String> headers) {
    return headers..addAll({"Content-type": "application/json"});
  }

  Map<String, String> addTokenInHeader(Map<String, String> headers, String token) {
    return headers..addAll({"x-access-token": token});
  }
}
