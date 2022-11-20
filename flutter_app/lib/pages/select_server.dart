import 'package:flutter/material.dart';
import 'package:area/components/buttons/roundedFlatButton.dart';
import 'package:area/components/buttons/inputText.dart';
import 'package:area/theme.dart' as theme;
import 'package:area/services/manager.dart';
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
        print("Base IP : " + prefs.getString('server_url')!);
        prefs.setString('server_url', "http://" + server + ":8080");
        Manager.of(context).api.changeUrl(prefs.getString('server_url')!);
        print("Update IP : " + prefs.getString('server_url')!);
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
    print("Connect to server IP : " + Manager.of(context).api.url);
    Navigator.pushReplacementNamed(context, '/authentification');
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        backgroundColor: theme.background,
        body: Center(
            child: Container(
          margin: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
          ),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Text("Select an AREA server", style: theme.titleStyle),
            const SizedBox(height: 30),
            Input(
              inputName: 'newserver',
              inputIcon: Icons.dns,
              inputHintText: '0.0.0.0',
              inputType: TextInputType.text,
              inputHidden: false,
              getInputValue: _getNewServer,
              errorText: "",
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: RoundedFlatButton(
                buttonText: 'Connect to server',
                backgroundColor: theme.primaryColor,
                passedFunction: _connectServer,
                buttonIcon: Icons.connect_without_contact_outlined,
              ),
            ),
          ]),
        ))));
  }
}
