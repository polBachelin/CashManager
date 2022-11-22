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
    throw Exception();
  }
}
