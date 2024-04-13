import 'package:ct484_project/models/food_recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HorizontalFoodRecipe extends StatelessWidget {
  const HorizontalFoodRecipe(this.foodRecipe, {super.key});

  final FoodRecipe foodRecipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(foodRecipe.imageUrl),
                        width: 150,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      ),
                ),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(foodRecipe.title, style: Theme.of(context).textTheme.bodyLarge,softWrap: true,textAlign: TextAlign.left,maxLines: 2,),
                ))
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => context.pushNamed('food-category-detail',extra: foodRecipe), //Sử dụng pushName thì extra không bị thay thế
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}