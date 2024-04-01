
import 'package:flutter/material.dart';

import '../shared/scaffold_with_navbar.dart';

class FoodProcessingCategory extends StatelessWidget {
  static const routeName = '/category';
  const FoodProcessingCategory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục chế biến'),
      ),
      body: Center(
        child: const Text('Danh mục chế biến', style: TextStyle(color: Colors.red),),
      ),
    );
  }
}