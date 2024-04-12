import 'package:ct484_project/models/food_recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StaggeredGridTile extends StatelessWidget {
  const StaggeredGridTile(this.foodRecipe, {super.key});

  final FoodRecipe foodRecipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 120,
                  child: ClipRRect(
                    child: Image.network(foodRecipe.imageUrl,fit: BoxFit.cover, height: 130, width: 200,),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(foodRecipe.title, overflow: TextOverflow.ellipsis, maxLines: 2, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),),
                )
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).focusColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    print("Xem chi tiết ${foodRecipe.title}");
                    context.goNamed("home-food-detail",extra: foodRecipe);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}