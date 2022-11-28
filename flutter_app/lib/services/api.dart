import 'dart:convert';

import 'package:cash_manager/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Server {
  Server({required this.url});

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String url;
  String? accessToken;
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer "
  };

  void updateToken() {
    prefs.then((SharedPreferences p) {
      p.reload();
      if (p.getString("access_token") != null) {
        accessToken = p.getString("access_token");
        headers["Authorization"] = "Bearer ${p.getString("access_token")!}";
      }
    });
  }

  void updateUrl(newUrl) {
    url = newUrl;
  }

  Future<bool> logout() async {
    return true;
  }

  Future<bool> login() async {
    return true;
  }

  Future<bool> register() async {
    return true;
  }

  Future<List<Article>> getArticles() async {

    String articlesString = '''[
    {
      "id": 1,
      "name": "Ryan Jordan 1",
      "price": 32
    },
    {
      "id": 2,
      "name": "Conversation",
      "price": 3,
    },
    {
      "id": 3,
      "name": "Will Smith",
      "price": 30
    },
]
    ''';

    final parsed = json.decode(articlesString).cast<Map<String, dynamic>>();
    print("TOTO");
    print(articlesListFromJson(articlesString));
    return parsed.map<Article>((json) => Article.fromJson(json)).toList();
  }
}
