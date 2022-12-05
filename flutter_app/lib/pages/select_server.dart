import 'package:cash_manager/components/animations/toast.dart';
import 'package:cash_manager/components/widgets/fields/ip_field.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
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
  double _elementsOpacity = 1;
  final TextEditingController ipController = TextEditingController();
  String _ip = "";

  bool _printLatestValue() {
    print('Value: $_ip');
    return true;
  }

  void updateIPServer(String server) {
    setState(() {
      _prefs.then((SharedPreferences prefs) {
        prefs.setString('server_url', "http://$server:8080");
        Manager.of(context).api.updateUrl(prefs.getString('server_url')!);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('server_url') ??
          prefs.setString('server_url', 'http://0.0.0.0:8080');
    });
    _elementsOpacity = 0;
  }

  void _getIp(String ip) {
    setState(() {
      _ip = ip;
    });
  }

  Future<bool> _connectServer(BuildContext context, String ipAdress) async {
    ipAdress = "http://$ipAdress:8080";

    final response = await Manager.of(context).api.pingServer(ipAdress);
    if (response) {
      final SharedPreferences prefs = await _prefs;
      Manager.of(context).api.updateUrl(prefs.getString('server_url'));
      Navigator.pushReplacementNamed(context, '/register');
      return true;
    }
    return false;
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
            const Text("Select a server"),
            IPField(
                fadeIP: _elementsOpacity == 1,
                ipController: ipController,
                action: _getIp),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
            ),
            ClassicButton(
                text: "Connect",
                icon: Icons.arrow_forward_rounded,
                onTap: () {
                  print("IP ADRESS: $_ip");
                  _connectServer(context, _ip).then((ret) {
                    if (!ret) {
                      toast(context,
                          "La connexion au serveur a échoué. Réessayez !");
                    }
                  });
                },
                elementsOpacity: 1)
          ]),
        ))));
  }
}
