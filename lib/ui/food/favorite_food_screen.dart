
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/food/user_food_recipe_detail_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteFoddScreen extends StatelessWidget {
  const FavoriteFoddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công thức nấu ăn yêu thích'),
      ),
      body: FutureBuilder(
              future: context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 12,),
                      //Dùng consumer để quan sát sự thay đổi của danh sách favoriteItem 
                      Consumer<FoodRecipesManager>(
                        builder: (ctx, foodRecipesManager, child) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Số lượng yêu thích là: ${foodRecipesManager.favoriteItems.length}',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
                            ),
                          );
                        },
                      ),
                      Expanded(child: const UserFoodRecipeDetailMode(true))
                    ],
                  ),
                );
              },
            )
    );
  }
}