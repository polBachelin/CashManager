import 'package:cash_manager/components/article_card.dart';
import 'package:flutter/material.dart';
import 'package:cash_manager/theme.dart' as theme;
import 'package:cash_manager/services/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillComponent extends StatefulWidget {
  const BillComponent({Key? key}) : super(key: key);

  @override
  BuyScreenState createState() => BuyScreenState();
}

class BuyScreenState extends State<BillComponent> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FutureBuilder<List>(
              future: Manager.of(context).api.getArticles(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return ArticleCard(article: snapshot.data![i]);
                      });
                } else {
                  return const Center(
                      child: Text("No Articles availables",
                          style: TextStyle(
                              color: theme.blueColor,
                              fontFamily: "Comic Sans MS",
                              fontSize: 30)));
                }
              }),
          const Text("COCO")
        ]));
  }
}
