import 'package:cash_manager/models/article.dart';
import 'package:flutter/material.dart';
import 'package:cash_manager/theme.dart' as theme;
import 'package:shared_preferences/shared_preferences.dart';

class ArticleCard extends StatefulWidget {
  final Article article;

  const ArticleCard({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  ArticleCardState createState() => ArticleCardState();
}

class ArticleCardState extends State<ArticleCard> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _nb = 0;

  void _incrementCounter() {
    setState(() {
      _nb++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _nb--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading:
                  Icon(Icons.album), //TODO: remplacer par une image d'article
              title: Text(widget.article.name),
              subtitle: Text(article.price),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Remove',
                  child: const Icon(Icons.minimize),
                ),
                const SizedBox(width: 8),
                Text("$_nb"),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Add to buy list',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
