
import 'package:ct484_project/models/food_recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserFoodRecipe extends StatelessWidget {
  const UserFoodRecipe(
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công thức nấu ăn của tôi'),
      ),
      body: Center(
        child: const Text('Danh sách các công thức nấu ăn cá nhân'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('user-form');
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).indicatorColor,
      ),
    );
  }
}