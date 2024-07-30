import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/models/product_model.dart';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
      final Welcome welcome = Welcome.fromJson(data);
    return welcome.products;
  } else {
    throw Exception('Failed to load products');
  }
}
