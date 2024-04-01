
import 'package:flutter/material.dart';

class FoodShoppingListScreen extends StatelessWidget {
  const FoodShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('kế hoạch mua nguyên liệu'),
      ),
      body: Center(
        child: const Text('Danh sách nguyên liệu nấu ăn'),
      ),
    );
  }
}