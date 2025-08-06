import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _stock;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.product.productName;
    _price = widget.product.price;
    _stock = widget.product.stock;
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    setState(() => _loading = true);

    final updatedProduct = Product(
      productId: widget.product.productId,
      productName: _name,
      price: _price,
      stock: _stock,
    );
    await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).updateProduct(updatedProduct);

    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text('Edit Product')),
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
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final num = double.tryParse(value ?? '');
                    return (num == null || num <= 0)
                        ? 'Enter valid price'
                        : null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                TextFormField(
                  initialValue: _stock.toString(),
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final num = int.tryParse(value ?? '');
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
  }
}
