// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/product_provider.dart';
// import 'screens/product_list_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ProductProvider()..fetchProducts(),
//       child: MaterialApp(
//         title: 'Product CRUD',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: const ProductListScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:internship_coding_test/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
