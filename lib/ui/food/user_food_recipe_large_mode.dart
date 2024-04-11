import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../shared/confirm_dialog.dart';

class UserFoodRecipeLargeMode extends StatelessWidget {
  const UserFoodRecipeLargeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodRecipesManager>(
      builder: (ctx, foodRecipesManager, child) {
        return foodRecipesManager.items.length ==0 ? const Center(child: Text("Không tìm thấy công thức", style: TextStyle(fontSize: 20),),)
        : ListView.builder(
          itemCount: foodRecipesManager.items.length,
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
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(foodRecipe.title, style: Theme.of(context).textTheme.titleLarge,softWrap: true,textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(foodRecipe.ingredient, 
                style: Theme.of(context).textTheme.titleSmall, 
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, maxLines: 2,
              ),
            ),
            const SizedBox(height: 12,)
          ],
        ),
        onTap: () {
          print("Xem chi tiet larg");
          context.goNamed("user-food-detail",extra: foodRecipe);
        },
        onLongPress: () {
          print("Chinh sua hoac xoa");
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Center(child: const Text("Tùy chọn")),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: Text("Hãy chọn một hành động", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () {
                              print("Chỉnh sửa");
                              Navigator.of(context).pop();
                              context.goNamed("user-form", extra: foodRecipe);
                            },
                            icon: Icon(Icons.edit),
                            label: const Text("Chỉnh sửa", style: TextStyle(fontSize: 20),),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              print("Xóa");
                              // context.read<FoodRecipesManager>().removeFoodRecipe(foodRecipe.id!);
                              showConfirmDialog(context, "Bạn chắc chắn xóa chứ, bạn sẽ không thể hoàn tác hành động này", "Xóa công thức này??").then((value) {
                                //Nếu value là true thì xác nhận xóa
                                if (value!) {
                                  print("Xoa thanh cong");
                                  context.read<FoodRecipesManager>().removeFoodRecipe(foodRecipe.id!);
                                  Navigator.of(context).pop();
                                } else {
                                  //Nếu value là false thì hủy hành động xóa
                                  print("Không muốn xóa dc chưa");
                                }
                              });
                            },
                            icon: Icon(Icons.delete),
                            label: const Text("Xóa",style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                  ],
                ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(child: const Text('Thoát',style: TextStyle(fontSize: 20))),
                )
              ],
            )
          );
        },
      ),
    );
  }
}