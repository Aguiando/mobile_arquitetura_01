import 'dart:convert';
import 'package:http/http.dart' as http;
 
class HttpHelper {
  static const String _baseUrl = 'https://dummyjson.com';
 
  static Map<String, String> headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
 
  static Uri uri(String path, {Map<String, String>? queryParams}) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: queryParams);
  }
 
  static Future<http.Response> get(String path, {String? token, Map<String, String>? queryParams}) {
    return http.get(uri(path, queryParams: queryParams), headers: headers(token: token));
  }
 
  static Future<http.Response> post(String path, {String? token, required Map<String, dynamic> body}) {
    return http.post(uri(path), headers: headers(token: token), body: jsonEncode(body));
  }
 
  static Future<http.Response> put(String path, {String? token, required Map<String, dynamic> body}) {
    return http.put(uri(path), headers: headers(token: token), body: jsonEncode(body));
  }
 
  static Future<http.Response> delete(String path, {String? token}) {
    return http.delete(uri(path), headers: headers(token: token));
  }
}