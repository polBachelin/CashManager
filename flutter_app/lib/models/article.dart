import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

List<Article> articlesListFromJson(String str) =>
  List<Article>.from(json.decode(str)["articles"].map((x) => Article.fromJson(x)));

class Article {
  final String name;
  final double price;
  final String image;

  Article({
    required this.name,
    required this.price,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        name: json['name'],
        price: json['price'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'image': image,
      };

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Article && other.name == name;
  
  
}
