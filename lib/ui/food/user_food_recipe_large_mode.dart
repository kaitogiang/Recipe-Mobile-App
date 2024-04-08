import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFoodRecipeLargeMode extends StatelessWidget {
  const UserFoodRecipeLargeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodRecipesManager>(
      builder: (ctx, foodRecipesManager, child) {
        return ListView.builder(
          itemCount: foodRecipesManager.itemCount,
          itemBuilder: (context, index) {
            return UserFoodRecipeLargList(foodRecipesManager.items[index]);
          },
        );
      },
    );
  }
}

class UserFoodRecipeLargList extends StatelessWidget {
  const UserFoodRecipeLargList(this.foodRecipe, {super.key});

  final FoodRecipe foodRecipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: InkWell(
        splashColor: Theme.of(context).focusColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15,),
            ClipRRect(
              child: Image.network(foodRecipe.imageUrl, width: 360,),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            const SizedBox(height: 12,),
            Text(foodRecipe.title, style: Theme.of(context).textTheme.titleLarge,softWrap: true,textAlign: TextAlign.center,),
            Text(foodRecipe.ingredient, style: Theme.of(context).textTheme.titleSmall,),
            const SizedBox(height: 12,)
          ],
        ),
        onTap: () {
          print("Chinh sua large");
        },
      ),
    );
  }
}