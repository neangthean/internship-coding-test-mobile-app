import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0;
  int _stock = 0;
  bool _loading = false;
  bool _nameError = false;
  bool _priceError = false;
  bool _stockError = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    setState(() => _loading = true);

    final newProduct = Product(
      productId: 0,
      productName: _name,
      price: _price,
      stock: _stock,
    );
    await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).addProduct(newProduct);

    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text('Add Product')),
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
                  cursorColor: Color(0xff005cc8),
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    // labelStyle: TextStyle(color: Colors.grey),
                    floatingLabelStyle: TextStyle(
                      // color: Color(0xff005cc8),
                      color: _nameError ? Color(0xffb00020) : Color(0xff005cc8),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff005cc8),
                        width: 2,
                      ),
                    ),
                  ),
                  // validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() => _nameError = true);
                    } else {
                      setState(() => _nameError = false);
                    }
                    return value.isEmpty ? 'Enter name' : null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  cursorColor: Color(0xff005cc8),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    floatingLabelStyle: TextStyle(
                      // color: Color(0xff005cc8),
                      color:
                          _priceError ? Color(0xffb00020) : Color(0xff005cc8),
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
                      setState(() => _priceError = true);
                    } else {
                      setState(() => _priceError = false);
                    }
                    return (num == null || num <= 0)
                        ? 'Enter valid price'
                        : null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                TextFormField(
                  cursorColor: Color(0xff005cc8),
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    floatingLabelStyle: TextStyle(
                      // color: Color(0xff005cc8),
                      color:
                          _stockError ? Color(0xffb00020) : Color(0xff005cc8),
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
                      setState(() => _stockError = true);
                    } else {
                      setState(() => _stockError = false);
                    }
                    return (num == null || num < 0)
                        ? 'Enter valid stock'
                        : null;
                  },
                  onSaved: (value) => _stock = int.parse(value!),
                ),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff005cc8),
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
