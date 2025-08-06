import 'package:flutter/material.dart';
import 'package:internship_coding_test/providers/product_provider.dart';
import 'package:internship_coding_test/screens/add_product_screen.dart';
import 'package:internship_coding_test/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
    // context.read<ProductProvider>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ProductProvider>(context);
    final provider = context.watch<ProductProvider>();
    final products = provider.searchProducts.reversed.toList();

    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search product...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10),
                  //   borderSide: BorderSide(color: Colors.blue, width: 2),
                  // ),
                ),
                onChanged: (value) {
                  setState(() {
                    provider.setSearchQuery(value);
                  });
                },
              ),
            ),
          ),
          Expanded(
            child:
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: () => provider.fetchProducts(),
                      color: Color(0xff005cc8),
                      backgroundColor: Colors.white,
                      child:
                          products.isEmpty
                              ? const Center(child: Text('No products found.'))
                              : ListView.builder(
                                itemCount: products.length + 1,
                                itemBuilder: (ctx, i) {
                                  if (i == products.length) {
                                    return SizedBox(height: 80);
                                  }

                                  final p = products[i];

                                  return Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                      top: 10,
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        p.productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Price: \$${p.price} | Stock: ${p.stock}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            color: Color(0xff005cc8),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => EditProductScreen(
                                                        product: p,
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Color(0xffc10d0d),
                                            ),
                                            onPressed:
                                                () => _confirmDelete(
                                                  context,
                                                  p.productId,
                                                  provider,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff005cc8),
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, ProductProvider provider) {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this product?",
            ),
            actions: [
              TextButton(
                onPressed: () => navigator.pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xff005cc8)),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await provider.deleteProduct(id);
                  if (navigator.canPop()) navigator.pop();
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Color(0xffc10d0d)),
                ),
              ),
            ],
          ),
    );
  }
}
