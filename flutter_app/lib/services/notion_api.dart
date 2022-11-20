import 'dart:convert';
import 'package:area/utils/server_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotionAPI {
  NotionAPI({required this.prefs});
  Future<SharedPreferences> prefs;
  String? url;
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer "
  };

  void updateUrl() async {
    updateHeaders();
    final p = await SharedPreferences.getInstance();
    //p.reload();
    url = p.getString('server_url');
    print("URL updated + headers " + url! + headers.toString());
  }

  void updateHeaders() async {
    prefs.then((p) => p.reload().then((value) =>
        headers["Authorization"] = "Bearer " + p.getString('access_token')!));
  }

  Future<List> getDatabases() async {
    updateUrl();

    print("URL ==>" + url!);
    final response =
        await ServerRequest.getRequest(url!, '/notion/databases', headers);

    final List dbs = json.decode(response.body)["results"];
    print(dbs.toString());

    return dbs;
  }
}
