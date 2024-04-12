import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/food/staggered_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class StaggeredGridView extends StatelessWidget {
  const StaggeredGridView(this.type, this.foodByTypeList, {super.key});

  final String type;
  final List<FoodRecipe> foodByTypeList;

  @override
  Widget build(BuildContext context) {
    CookingType selectedType = CookingType.other;
                          switch(type) {
                            case "Món nướng": selectedType = CookingType.grilling; break;
                            case "Món xào": selectedType = CookingType.stirFrying; break;
                            case "Món hấp": selectedType = CookingType.steaming; break;
                            case "Món luộc": selectedType = CookingType.boiling; break;
                            case "Món trộn": selectedType = CookingType.drying; break;
                            case "Món trộn": selectedType = CookingType.mixing; break;
                            case "Món nấu": selectedType = CookingType.cooking; break;
                          }
    final BoxDecoration _boxDecorationStyle = BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3) //Vị trí bóng
                              )
                            ]
                          );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: type.compareTo("Gợi ý hôm này")!=0 ? const EdgeInsets.all(0.0) : const EdgeInsets.symmetric(vertical: 8),
              child: Text(type, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            if (type.compareTo("Gợi ý hôm này")!=0)
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0
                        )
                      )
                    ),
                    child: Text(
                      "Xem tất cả", 
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, 
                      ),
                    ),
                  ),
                  Icon(Icons.navigate_next, color: Theme.of(context).iconTheme.color,)
                ],
              ),
              onPressed: () {
                context.read<FoodRecipesManager>().setFoodType(selectedType);
                context.goNamed('food-category-list',extra: type);
              },
            )
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: type.compareTo("Gợi ý hôm này")!=0 ? foodByTypeList.length+1 : foodByTypeList.length,
            itemBuilder: (context, index) => index==foodByTypeList.length 
            ? IconButton(onPressed: () {
              context.read<FoodRecipesManager>().setFoodType(selectedType);
              context.goNamed('food-category-list',extra: type);
            }, 
              icon: Container(
                child: CircleAvatar(child: Icon(Icons.navigate_next),backgroundColor: Theme.of(context).indicatorColor,),
                decoration: _boxDecorationStyle,
              )
            ) 
            : StaggeredGridTile(foodByTypeList[index]),
          ),
        ),
      ],
    );
  }
}