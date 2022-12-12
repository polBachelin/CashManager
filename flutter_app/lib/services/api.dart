import 'dart:convert';
import 'package:cash_manager/models/article.dart';
import 'package:cash_manager/utils/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class Server {
  Server({required this.url});

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String url;
  String? accessToken;
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer "
  };

  void updateUrl(newUrl) {
    url = newUrl;
  }

  void updateAccessToken(String token) {
    accessToken = token;
    prefs.then((SharedPreferences p) {
      p.setString("access_token", accessToken!);
      headers["Authorization"] = "Bearer ${p.getString("access_token")!}";
    });
  }

  Future<Tuple3<String, String, bool>> interceptTokenRegister(Server api,
      String oauthName, String code, SharedPreferences prefs) async {
    // var response = await api.register();

    // print("TUPLE returned ==> " + response.toString());
    // prefs.setString("username", response.item1);
    // prefs.setString("access_token", response.item2);
    // prefs.setBool("isLogged", response.item3);

    // api.updateToken();

    // return response;
    throw Exception();
  }

  Future<bool> pingServer(url) async {
    try {
      final response = await ServerRequest.getRequest(url, "", null);
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    return true;
  }

  Future<int> register(String username, String email, String password) async {
    try {
      print("$url/user");
      final response = await ServerRequest.postRequest(url, "/user",
          {"name": username, "email": email, "password": password}, headers);
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<int> login(String email, String password) async {
    try {
      final response = await ServerRequest.postRequest(
          url, "/auth", {"email": email, "password": password}, headers);
      if (response.statusCode == 200) {
        updateAccessToken(json.decode(response.body)["token"]);
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<List<Article>> getArticles() async {
    try {
      final response = await ServerRequest.getRequest(
          "http://10.19.246.178:8080", "/articles", headers);
      if (response.statusCode == 200) {
        print(articlesListFromJson(response.body));
        return articlesListFromJson(response.body);
      } else {
        return List<Article>.empty();
      }
    } catch (e) {
      print(e);
      return List<Article>.empty();
      // return null;
    }
  }
}
