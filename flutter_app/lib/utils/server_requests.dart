import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ServerRequest {
  static Future<http.Response> getRequest(
      String url, String route, Map<String, String> headers) async {
    if (kDebugMode) {
      print("GET - $url$route - $headers");
    }
    final response = await http.get(Uri.parse(url + route), headers: headers);
    print("GET "+ response.statusCode.toString() + " - " + response.body);
    //updateCookie(response, headers);
    return response;
  }

  static Future<http.Response> postRequest(String url, String route,
      dynamic data, Map<String, String> headers) async {
    if (kDebugMode) {
      print("POST - $url$route");
      print("Payload : $data");
    }
    final response = await http.post(Uri.parse(url + route),
        headers: headers, body: json.encode(data));
    if (kDebugMode) {
      print("Response payload : ${response.body}");
    }
    headers = updateCookie(response, headers);
    return response;
  }

  static Future<http.Response> putRequest(String url, String route,
      dynamic data, Map<String, String> headers) async {
    print("PUT - $route");
    print("Payload : $data");
    final response = await http.put(Uri.dataFromString(url + route),
        headers: headers, body: json.encode(data));
    print("Response payload : ${response.body}");
    headers = updateCookie(response, headers);
    return response;
  }

  static Future<http.Response> deleteRequest(String url, String route,
      dynamic data, Map<String, String> headers) async {
    print("DELETE - $route");
    print("Payload : $data");
    final response =
        await http.delete(Uri.parse(url + route), headers: headers);
    headers = updateCookie(response, headers);
    return response;
  }

  static Map<String, String> updateCookie(
      http.Response response, Map<String, String> headers) {
    if (kDebugMode) {
      print(response.headers);
    }
    String? rawCookie = response.headers['set-cookie'];

    if (rawCookie == null) return headers;
    int index = rawCookie.indexOf(';');
    headers['cookie'] =
        (index == -1) ? rawCookie : rawCookie.substring(0, index);
    return headers;
  }
}
