import 'package:ct484_project/models/food_recipe.dart';
import 'package:flutter/material.dart';

class FoodRecipeDetailScreen extends StatelessWidget {
  const FoodRecipeDetailScreen(this.foodRecipe, {super.key});

  final FoodRecipe foodRecipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công thức nấu ăn'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 5,
                    child: ClipRRect(
                      child: Image.network(foodRecipe.imageUrl, fit: BoxFit.cover, height: 450,),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(foodRecipe.title.toUpperCase(), style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold), softWrap: true,)),
                      IconButton(icon: Icon(Icons.favorite_border),onPressed: () => print("Yêu thích"),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.food_bank, color: Theme.of(context).primaryColor ,size: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Nguyên liệu:', softWrap: true, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(foodRecipe.ingredient, style: Theme.of(context).textTheme.bodyLarge,),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.food_bank_outlined, color: Theme.of(context).primaryColor, size: 25,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Cách chế biến:', softWrap: true, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(foodRecipe.processing, style: Theme.of(context).textTheme.bodyLarge,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}