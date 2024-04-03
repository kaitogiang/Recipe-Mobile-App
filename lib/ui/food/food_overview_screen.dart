
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'food_processing_category.dart';

class FoodOverviewScreen extends StatelessWidget {
  const FoodOverviewScreen({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
      ),
      body: Center(
        child: const Text("Trang chủ"),
      ),
    );
  }
}