import 'package:flutter/material.dart';
import 'package:internship_coding_test/models/product.dart';
import 'package:internship_coding_test/providers/edit_product_provider.dart';
import 'package:internship_coding_test/providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;

  EditProductScreen({super.key, required this.product});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => EditProductProvider(
            productProvider: Provider.of<ProductProvider>(
              context,
              listen: false,
            ),
            product: product,
          ),
      child: Consumer<EditProductProvider>(
        builder: (context, editProvider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              title: const Text(
                'Edit Product',
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
                        initialValue: editProvider.name,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Enter name' : null,
                        onSaved: (value) => editProvider.name = value!,
                      ),
                      TextFormField(
                        initialValue: editProvider.price.toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final num = double.tryParse(value ?? '');
                          return (num == null || num <= 0)
                              ? 'Enter valid price'
                              : null;
                        },
                        onSaved:
                            (value) =>
                                editProvider.price = double.parse(value!),
                      ),
                      TextFormField(
                        initialValue: editProvider.stock.toString(),
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final num = int.tryParse(value ?? '');
                          return (num == null || num < 0)
                              ? 'Enter valid stock'
                              : null;
                        },
                        onSaved:
                            (value) => editProvider.stock = int.parse(value!),
                      ),
                      const SizedBox(height: 20),
                      editProvider.loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed:
                                () => editProvider.submit(_formKey, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff005cc8),
                            ),
                            child: const Text(
                              'Update Product',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
