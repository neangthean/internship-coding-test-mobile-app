// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int status;
  String message;
  List<Product> products;

  ProductModel({
    required this.status,
    required this.message,
    required this.products,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    status: json["status"],
    message: json["message"],
    products: List<Product>.from(
      json["products"].map((x) => Product.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  int productId;
  String productName;
  double price;
  int stock;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    productName: json["product_name"],
    price: json["price"]?.toDouble(),
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "price": price,
    "stock": stock,
  };
}
