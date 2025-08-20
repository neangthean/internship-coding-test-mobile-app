import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductProvider extends ChangeNotifier {
  final ProductProvider productProvider;

  AddProductProvider({required this.productProvider});

  bool loading = false;
  bool nameError = false;
  bool priceError = false;
  bool stockError = false;

  String name = '';
  double price = 0;
  int stock = 0;

  Future<void> submit(
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    formKey.currentState!.save();
    loading = true;
    notifyListeners();

    final newProduct = Product(
      productId: 0,
      productName: name,
      price: price,
      stock: stock,
    );

    await productProvider.addProduct(newProduct);

    loading = false;
    notifyListeners();

    if (context.mounted) Navigator.pop(context);
  }

  void setNameError(bool val) {
    nameError = val;
    notifyListeners();
  }

  void setPriceError(bool val) {
    priceError = val;
    notifyListeners();
  }

  void setStockError(bool val) {
    stockError = val;
    notifyListeners();
  }
}
