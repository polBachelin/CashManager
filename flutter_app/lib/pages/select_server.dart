import 'package:cash_manager/components/animations/toast.dart';
import 'package:cash_manager/components/widgets/fields/custom_field.dart';
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

  bool isValidIP(String ip) {
    return RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$').hasMatch(ip);
  }

  void _getIp(String ip) {
    setState(() {
      _ip = ip;
    });
  }

  Future<bool> _connectServer(String ipAdress) async {
    String url = "http://$ipAdress:8080";

    final response = await Manager.of(context).api.pingServer(url);
    if (response) {
      // ignore: use_build_context_synchronously
      Manager.of(context).api.updateUrl(url);
      // ignore: use_build_context_synchronously
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
            CustomField(
                hintText: "Enter an Ip Adress",
                fade: _elementsOpacity == 1,
                actionOnChanged: _getIp,
                validatorFunc: isValidIP,
                ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
            ),
            ClassicButton(
                text: "Connect",
                onTap: () {
                  _connectServer(_ip).then((ret) {
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
