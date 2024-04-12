import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/staggered_grid_tile.dart';
import 'package:ct484_project/ui/food/user_food_recipe_detail_mode.dart';
import 'package:flutter/material.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen(this.filterFoodRecipe, {super.key});
  final List<FoodRecipe> filterFoodRecipe;

  @override
  Widget build(BuildContext context) {
    return filterFoodRecipe.length == 0 ?  const Center(child: Text("Không tìm thấy công thức", style: TextStyle(fontSize: 20),),)
      : GridView.builder(
        padding: EdgeInsets.only(top: 13),
        itemCount: filterFoodRecipe.length,
        itemBuilder: (context, index) => StaggeredGridTile(filterFoodRecipe[index]),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 13,
          mainAxisExtent: 200
        ),
      );
  }
}

