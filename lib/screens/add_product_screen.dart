import 'package:flutter/material.dart';
import 'package:internship_coding_test/providers/add_product_provider.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addProduct = context.read<AddProductProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  cursorColor: const Color(0xff005cc8),
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    floatingLabelStyle: TextStyle(
                      color:
                          addProduct.nameError
                              ? const Color(0xffb00020)
                              : const Color(0xff005cc8),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff005cc8),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      addProduct.setNameError(true);
                    } else {
                      addProduct.setNameError(false);
                    }
                    return value.isEmpty ? 'Enter name' : null;
                  },
                  onSaved: (value) => addProduct.name = value!,
                ),
                TextFormField(
                  cursorColor: const Color(0xff005cc8),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    floatingLabelStyle: TextStyle(
                      color:
                          addProduct.priceError
                              ? const Color(0xffb00020)
                              : const Color(0xff005cc8),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff005cc8),
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final num = double.tryParse(value ?? '');
                    if (num == null || num <= 0) {
                      addProduct.setPriceError(true);
                    } else {
                      addProduct.setPriceError(false);
                    }
                    return (num == null || num <= 0)
                        ? 'Enter valid price'
                        : null;
                  },
                  onSaved: (value) => addProduct.price = double.parse(value!),
                ),
                TextFormField(
                  cursorColor: const Color(0xff005cc8),
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    floatingLabelStyle: TextStyle(
                      color:
                          addProduct.stockError
                              ? const Color(0xffb00020)
                              : const Color(0xff005cc8),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff005cc8),
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final num = int.tryParse(value ?? '');
                    if (num == null || num <= 0) {
                      addProduct.setStockError(true);
                    } else {
                      addProduct.setStockError(false);
                    }
                    return (num == null || num < 0)
                        ? 'Enter valid stock'
                        : null;
                  },
                  onSaved: (value) => addProduct.stock = int.parse(value!),
                ),
                const SizedBox(height: 20),
                addProduct.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () => addProduct.submit(_formKey, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff005cc8),
                      ),
                      child: const Text(
                        'Add Product',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
