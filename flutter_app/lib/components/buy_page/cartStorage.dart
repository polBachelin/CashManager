import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CartStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/cart.txt');
  }

  Future<dynamic> readCart() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      return null;
    }
  }

  Future<File> writeCart(List<int> cart, double bill) async {
    final file = await _localFile;

    return file.writeAsString('{"cart": $cart, "bill": $bill}');
  }
}
