
import 'package:flutter/material.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm công thức nấu'),
      ),
      body: Center(
        child: const Text('Danh sách công thức nấu ăn'),
      ),
    );
  }
}