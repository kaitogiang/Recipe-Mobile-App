
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'food_processing_category.dart';

class FoodOverviewScreen extends StatelessWidget {
  const FoodOverviewScreen({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.goNamed('login');
              context.read<AuthManager>().logout();
            },
          )
        ],
      ),
      body: Center(
        child: const Text("Trang chủ"),
      ),
    );
  }
}