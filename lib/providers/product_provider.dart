import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  // final String apiUrl = 'http://localhost:3000/products';
  final String apiUrl =
      'http://10.0.2.2:3000/products'; // ← for Android Emulator
  List<Product> _products = [];

  bool _isLoading = false;

  String _searchQuery = '';

  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;

  List<Product> get products => _products;

  List<Product> get searchProducts {
    if (_searchQuery.trim().isEmpty) {
      // return a copy so UI can't mutate it accidentally
      return List<Product>.from(_products);
    }
    final q = _searchQuery.toLowerCase();
    return _products
        .where((p) => p.productName.toLowerCase().contains(q))
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    final res = await http.get(Uri.parse(apiUrl));
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final data = body['products'] ?? [];
      _isLoading = false;
      if (data is List) {
        _products = data.map((json) => Product.fromJson(json)).toList();
        notifyListeners();
      }
    }
  }

  Future<void> fetchProductById(int id) async {
    final res = await http.get(Uri.parse('$apiUrl?id=$id'));
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final product = Product.fromJson(body['product']);
      _products = [product];
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    final res = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (res.statusCode == 201) fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    final res = await http.put(
      Uri.parse('$apiUrl?id=${product.productId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (res.statusCode == 200) fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$apiUrl?id=$id'));
    if (res.statusCode == 200) fetchProducts();
  }

  Product? findById(int id) {
    try {
      return _products.firstWhere((p) => p.productId == id);
    } catch (e) {
      return null;
    }
  }
}
