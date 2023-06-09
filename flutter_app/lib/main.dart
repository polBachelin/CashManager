import 'package:cash_manager/pages/NFC_Reader.dart';
import 'package:cash_manager/pages/QR_code.dart';
import 'package:cash_manager/pages/ValidationPage.dart';
import 'package:cash_manager/pages/buy_screen.dart';
import 'package:cash_manager/pages/register_screen.dart';
import 'package:cash_manager/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cash_manager/components/buy_page/cartStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cash_manager/pages/select_server.dart';
import 'package:cash_manager/services/manager.dart';


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
    return Manager(
        child: MaterialApp(
          
            title: 'Cash manager',
            // Start the app with the "/" named route. In this case, the app starts
            // on the RegisterScreen widget.
            initialRoute: prefs.getBool("isLogged")! ? '/buy' : '/',
            debugShowCheckedModeBanner: false,
            checkerboardOffscreenLayers: false,
            routes: {
          '/register': (context) => const RegisterScreen(),
          '/qrcode': (context) => const QRcodePage(),
          '/login': (context) => const LoginScreen(),
          '/': (context) => const ServerPage(),
          '/nfcreader': (context) => const NFCReaderPage(),
          '/buy': (context) => BuyScreen(storage: CartStorage()),
          // '/pay': (context) => const PayScreen(),
          // '/payment_infos': (context) => const PaymentInfosScreen(),
        }));
  }
}
