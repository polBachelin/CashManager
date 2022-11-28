import 'package:cash_manager/pages/NFC_Reader.dart';
import 'package:cash_manager/pages/QR_code.dart';
import 'package:cash_manager/pages/login_screen.dart';
import 'package:cash_manager/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cash_manager/pages/select_server.dart';
import 'package:cash_manager/services/manager.dart';
import 'package:cash_manager/pages/NFC_Reader.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  SharedPreferences prefs;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //FlutterNativeSplash.remove();
    return Manager(
        child: MaterialApp(
            title: 'Cash manager',
            // Start the app with the "/" named route. In this case, the app starts
            // on the RegisterScreen widget.
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            checkerboardOffscreenLayers: false,
            routes: {
          '/': (context) => NFCReaderPage(),
          // '/login': (context) => const LoginScreen(),
          // '/register': (context) => const RegisterScreen(),
          // '/buy': (context) => const BuyScreen(),
          // '/pay': (context) => const PayScreen(),
          // '/payment_infos': (context) => const PaymentInfosScreen(),
        }));
  }
}
