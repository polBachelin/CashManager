import 'package:flutter/material.dart';
import 'package:cash_manager/theme.dart';
import 'package:cash_manager/services/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({Key? key}) : super(key: key);

  @override
  ServerPageState createState() => ServerPageState();
}

class ServerPageState extends State<ServerPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _getNewServer(String server) {
    setState(() {
      _prefs.then((SharedPreferences prefs) {
        print("Base IP : ${prefs.getString('server_url')!}");
        prefs.setString('server_url', "http://$server:8080");
        Manager.of(context).api.changeUrl(prefs.getString('server_url')!);
        print("Update IP : ${prefs.getString('server_url')!}");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('server_url') ??
          prefs.setString('server_url', 'http://192.168.43.15:8080');
    });
  }

  void _connectServer(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    Manager.of(context).api.changeUrl(prefs.getString('server_url'));
    print("Connect to server IP : ${Manager.of(context).api.url}");
    Navigator.pushReplacementNamed(context, '/authentification');
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        backgroundColor: ColorBackground,
        body: Center(
            child: Container(
          margin: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
          ),
          child: ListView(shrinkWrap: true, children: <Widget>[
            const Text("Select an AREA server"),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
            ),
          ]),
        ))));
  }
}
