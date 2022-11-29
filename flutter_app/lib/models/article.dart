  
import 'dart:convert';

List<Article> articlesListFromJson(String str) =>
  List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

class Article {
  final String name;
  final int nb;
  final int price;

  Article({
    required this.name,
    required this.nb,
    required this.price,
  });



  factory Article.fromJson(Map<String, dynamic> json) => Article(
        name: json['name'],
        nb: json['nb'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'nb': nb,
        'price': price,
      };

  int computeTotalPrice() {
    return nb * price;
  }
}
