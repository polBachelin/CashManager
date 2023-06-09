import 'package:cash_manager/models/article.dart';
import 'package:flutter/material.dart';
import 'package:cash_manager/theme.dart' as theme;
import 'package:shared_preferences/shared_preferences.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  final Function ?incrementFunc;
  final Function ?decrementFunc;

  const ArticleCard({
    Key? key,
    required this.article,
    this.incrementFunc,
    this.decrementFunc,
  }) : super(key: key);

  @override
  ArticleCardState createState() => ArticleCardState();
}

class ArticleCardState extends State<ArticleCard> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _nb = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.network(widget.article.image),
              title: Text(widget.article.name),
              subtitle: Text("${widget.article.price}€"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () => _nb = widget.decrementFunc!(),
                  tooltip: 'Remove',
                  child: const Icon(Icons.minimize),
                ),
                const SizedBox(width: 8),
                Text("$_nb"),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _nb = widget.incrementFunc!(),
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
