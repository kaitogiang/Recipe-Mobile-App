
import 'package:flutter/material.dart';

import '../shared/bottom_navigation_bar.dart';

class FoodsProcessingCategory extends StatelessWidget {
  static const routeName = '/category';
  const FoodsProcessingCategory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục chế biến'),
      ),
      bottomNavigationBar: BottomCurveNavigationBar(),
      body: Center(
        child: const Text('Danh mục chế biến'),
      ),
    );
  }
}