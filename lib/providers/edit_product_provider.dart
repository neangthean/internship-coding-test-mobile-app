import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductProvider extends ChangeNotifier {
  final ProductProvider productProvider;
  final Product product;

  EditProductProvider({required this.productProvider, required this.product}) {
    // initialize form values from product
    name = product.productName;
    price = product.price;
    stock = product.stock;
  }

  String name = '';
  double price = 0;
  int stock = 0;
  bool loading = false;

  Future<void> submit(
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    formKey.currentState!.save();

    loading = true;
    notifyListeners();

    final updatedProduct = Product(
      productId: product.productId,
      productName: name,
      price: price,
      stock: stock,
    );

    await productProvider.updateProduct(updatedProduct);

    loading = false;
    notifyListeners();

    if (context.mounted) Navigator.pop(context);
  }
}
