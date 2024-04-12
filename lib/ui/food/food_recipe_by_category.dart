import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/food/horizontal_food_recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodRecipeByCategory extends StatelessWidget {
  const FoodRecipeByCategory(this.typeName, {super.key});

  final String typeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(typeName),
      ),
      body: FutureBuilder(
        future: context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return RefreshIndicator(
            onRefresh: () => context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
            child: Consumer<FoodRecipesManager>(
              builder: (ctx, foodRecipesManager, child) {
                return ListView.builder(
                  itemCount: foodRecipesManager.itemsByType.length,
                  itemBuilder: (context, index) => HorizontalFoodRecipe(foodRecipesManager.itemsByType[index]),
                );
              }
            ),
          );
        },
      ),
    );
  }
}
