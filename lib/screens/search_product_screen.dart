import 'package:flutter/material.dart';
import 'package:internship_coding_test/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final allProducts = provider.products;

    // Filter products based on search query
    final filteredProducts = allProducts.where((product) {
      final name = product.productName.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          // 🔍 Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // 📋 List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.fetchProducts(),
              child: filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (ctx, i) {
                  final p = filteredProducts[i];
                  return ListTile(
                    title: Text(p.productName),
                    subtitle: Text('Price: \$${p.price} | Stock: ${p.stock}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
