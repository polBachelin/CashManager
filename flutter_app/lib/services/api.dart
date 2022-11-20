import 'package:area/models/services.dart';
import 'package:area/services/discord_api.dart';
import 'package:area/services/google_api.dart';
import 'package:area/services/notion_api.dart';
import 'package:area/utils/server_requests.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class Server {
  Server({required this.url});
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String url;

  var notion = NotionAPI(prefs: SharedPreferences.getInstance());
  var discord = DiscordAPI(prefs: SharedPreferences.getInstance());
  var google = GoogleAPI(prefs: SharedPreferences.getInstance());
  String? accessToken;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer "
  };

  void updateToken() {
    changeUrl(url);
    prefs.then((SharedPreferences p) {
      p.reload();
      if (p.getString("access_token") != null) {
        accessToken = p.getString("access_token");
        headers["Authorization"] = "Bearer " + p.getString("access_token")!;
      }
      notion.headers = headers;
      discord.headers = headers;
      google.headers = headers;
      //print("TOKEN UPDATED ==> " + p.getString("access_token")!);
    });
  }

  void changeUrl(newUrl) {
    url = newUrl;
    notion.url = newUrl;
    discord.url = newUrl;
    google.url = newUrl;
  }

  Future<bool> register(dynamic data) async {
    final response =
        await ServerRequest.postRequest(url, '/auth/register', data, headers);
    if (response.statusCode >= 300) {
      print(response.body.toString());
      return false;
    }
    prefs.then((SharedPreferences p) {
      p.setString(
          "username", json.decode(response.body.toString())['user']['email']);
      p.setString("access_token",
          json.decode(response.body.toString())['token']['access_token']);
      p.setBool("isLogged", true);
    });
    return true;
  }

  Future<bool> login(dynamic data) async {
    updateToken();
    final response =
        await ServerRequest.postRequest(url, '/auth/login', data, headers);
    if (response.statusCode >= 300) {
      print("CODE ERROR==> " + response.body.toString());
      return false;
    }
    prefs.then((SharedPreferences p) {
      p.setString(
          "username", json.decode(response.body.toString())['user']['email']);
      p.setString("access_token",
          json.decode(response.body.toString())['token']['access_token']);
      p.setBool("isLogged", true);
    });
    return true;
  }

  Future<bool> postIntraRequestLogin(dynamic data, bool login) async {
    final SharedPreferences p = await prefs;

    if (login == true) {
      final token = p.getString("access_token");
      if (token == null) {
        return false;
      }
      final response = await ServerRequest.postRequest(
          url, '/intra/token?state=' + token, {"link": data}, headers);
      if (response.statusCode >= 300) {
        final error = json.decode(response.body.toString())['message'];
        return false;
      }
    }
    return true;
  }

  Future<bool> postIntraRequest(dynamic data, bool login) async {
    updateToken();
    if (login == true) return postIntraRequestLogin(data, login);
    final response = await ServerRequest.postRequest(
        url, '/intra/token', {"link": data}, headers);
    if (response.statusCode >= 300) {
      final error = json.decode(response.body.toString())['message'];
      return false;
    }
    prefs.then((SharedPreferences p) {
      p.setString("username", json.decode(response.body.toString())['email']);
      p.setString("access_token",
          json.decode(response.body.toString())['token']['access_token']);
    });
    return true;
  }

  Future<Tuple3<String, String, bool>> oauthGetToken(
      dynamic code, String serviceName, bool login) async {
    updateToken();
    final routeEnd = login
        ? '/auth_mobile?code=$code&state=$accessToken'
        : '/auth_mobile?code=$code';
    final response = await ServerRequest.getRequest(
        url, '/' + serviceName + routeEnd, headers);
    print("REPONSE API ==>" + response.body + response.statusCode.toString());
    var ret = const Tuple3<String, String, bool>("", "", false);

    if (response.statusCode >= 300) {
      print(response.body.toString());
      final error = json.decode(response.body.toString())['error'];
      return ret;
    }
    if (response.statusCode == 200 && !login) {
      print("Body ==> " + response.body);
      final uri = Uri.parse(json.decode(response.body.toString())['url']);
      ret = ret.withItem1(uri.queryParameters["email"]!);
      ret = ret.withItem2(uri.queryParameters["token"]!);
    }
    ret = ret.withItem3(true);
    return ret;
  }

  Future<List<Service>> getServices() async {
    updateToken();
    final response = await ServerRequest.getRequest(url, '/services', headers);
    final loggedServices =
        await ServerRequest.getRequest(url, "/services/logged", headers);
    var joe = List<String>.from(json.decode(loggedServices.body));

    if (response.statusCode == 200) {
      final List services = json.decode(response.body);

      return services.map((json) => Service.fromJson(json)).where((service) {
        final nameService = service.name.toLowerCase();
        if (joe.contains(nameService)) {
          service.connected = true;
        }
        return true;
      }).toList();
    } else {
      print("FAIS CHIERR");
      throw Exception();
    }
  }

  Future<List> getAreas() async {
    updateToken();
    final myAreas = await ServerRequest.getRequest(url, '/area', headers);
    final List jsonBody = json.decode(myAreas.body);
    return jsonBody;
  }

  void enableArea(String name) async {
    updateToken();
    final res = await ServerRequest.getRequest(
        url, '/area/' + name + '/enable', headers);
  }

  void disableArea(String name) async {
    updateToken();
    final res = await ServerRequest.getRequest(
        url, '/area/' + name + '/disable', headers);
  }

  Future<bool> getStatus(String name) async {
    updateToken();
    final res = await ServerRequest.getRequest(
        url, '/area/' + name + '/isEnabled', headers);
    final joe = json.decode(res.body);
    return joe;
  }

  Future<List<List>> getAreasData() async {
    final List areas = await getAreas();
    final List<bool> status = List<bool>.empty(growable: true);

    for (int i = 0; i < areas.length; i++) {
      final bool s = await getStatus(areas[i]["name"]);
      status.add(s);
    }
    final List<List> obj = [areas, status];
    return obj;
  }

  void deleteArea(String name) async {
    updateToken();
    final res =
        await ServerRequest.deleteRequest(url, '/area/' + name, {}, headers);
  }
}
