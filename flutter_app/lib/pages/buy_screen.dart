import 'package:cash_manager/components/animations/toast.dart';
import 'package:cash_manager/components/article_card.dart';
import 'package:cash_manager/components/buy_page/cartStorage.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/models/article.dart';
import 'package:flutter/material.dart';
import 'package:cash_manager/theme.dart' as theme;
import 'package:cash_manager/services/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selectPayment_screen.dart';

void clearSharedPrefs(SharedPreferences prefs) async {
  prefs.setBool('isLogged', false);
}

class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key, required this.storage}) : super(key: key);
  final CartStorage storage;

  @override
  BuyScreenState createState() => BuyScreenState();
}

class BuyScreenState extends State<BuyScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<int> _cart = [];
  double _bill = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCart().then((data) {
      setState(() {
        _cart = data!["cart"];
        _bill = data!["bill"];
        if (_bill < 0) _bill = 0;
      });
    });
  }

  int _incrementCart(int i, Article article) {
    setState(() {
      Manager.of(context).api.addArticle(article).then((value) {
        if (value) {
          _cart[i]++;
          _bill += article.price;
        }
      });
    });
    // Write the variable as a string to the file.
    widget.storage.writeCart(_cart, _bill);
    return _cart[i];
  }

  int _decrementCart(int i, Article article) {
    setState(() {
      if (_cart[i] >= 1) {
        Manager.of(context).api.removeArticle(article).then((value) {
          if (value) {
            _cart[i]--;
            _bill -= article.price;
            if (_bill < 0) _bill = 0;
          }
        });
      }
    });

    // Write the variable as a string to the file.
    widget.storage.writeCart(_cart, _bill);

    return _cart[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClassicButton(
                  text: "Logout",
                  onTap: () {
                    Manager.of(context).api.logout().then((value) {
                      if (value) {
                        Navigator.pushReplacementNamed(context, "/logout");
                      } else {
                        toast(context, "Le serveur est injoignable");
                      }
                    });
                  },
                  elementsOpacity: 1),
              Expanded(
                  child: FutureBuilder<List>(
                      future: Manager.of(context).api.getArticles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          if (_cart.isEmpty) {
                            _cart = List.filled(snapshot.data!.length, 0);
                          }
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              //shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                return ArticleCard(
                                    article: snapshot.data![i],
                                    incrementFunc: () =>
                                        _incrementCart(i, snapshot.data![i]),
                                    decrementFunc: () =>
                                        _decrementCart(i, snapshot.data![i]));
                              });
                        } else {
                          return const Center(
                              child: Text("No Articles availables",
                                  style: TextStyle(
                                      color: theme.blueColor,
                                      fontFamily: "Comic Sans MS",
                                      fontSize: 30)));
                        }
                      })),
              _bill != 0.0
                  ? ClassicButton(
                      text: "Pay now $_bill €",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SelectPayment(bill: _bill))),
                      elementsOpacity: 1)
                  : const SizedBox()
            ]));
  }
}
