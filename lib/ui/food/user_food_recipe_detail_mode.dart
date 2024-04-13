import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/shared/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserFoodRecipeDetailMode extends StatelessWidget {
  const UserFoodRecipeDetailMode(this.showFavorite, {super.key});

  final bool showFavorite;

  @override
  Widget build(BuildContext context) {

    return Consumer<FoodRecipesManager>(
      builder: (ctx, foodRecipesManager, child) {
        return !showFavorite ? (foodRecipesManager.items.length ==0 ? const Center(child: Text("Không tìm thấy công thức", style: TextStyle(fontSize: 20),),)
        : ListView.builder(
          itemCount: foodRecipesManager.items.length,
          itemBuilder: (context, index) {
            return UserFoodRecipeList(foodRecipesManager.items[index]);
          },
        )) 
        : (foodRecipesManager.favoriteItems.length == 0 ? const Center(child: Text('Chưa có sản phẩm yêu thích nào', style: TextStyle(fontSize: 20),),)
        : ListView.builder(
          itemCount: foodRecipesManager.favoriteItems.length,
          itemBuilder: (context, index) {
            return UserFoodRecipeList(foodRecipesManager.favoriteItems[index], isShowFavorite: true,);
          },
        ));
      }
    );
  }
}

class UserFoodRecipeList extends StatelessWidget {
  const UserFoodRecipeList(this.foodRecipe, {super.key, this.isShowFavorite = false});
  final FoodRecipe foodRecipe;
  final bool isShowFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: InkWell(
        splashColor: Theme.of(context).focusColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: ListTile(
          subtitle: Text(foodRecipe.ingredient, overflow: TextOverflow.ellipsis, maxLines: 2,),
          title: Text(foodRecipe.title),
          leading: Image(
            image: NetworkImage(foodRecipe.imageUrl),
            fit: BoxFit.fill,
            width: 100,
            height: 100,
          )
        ),
        onTap: () {
          print("Xem chi tiet");
          if(!isShowFavorite) {
            context.goNamed("user-food-detail",extra: foodRecipe);
          } else {
            context.goNamed("favorite-food-detail", extra: foodRecipe);
          }
        },
        onLongPress: () {
          print("Chinh sua hoac xoa");
          !isShowFavorite ? showDialog<String>(
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
          ) : '';
        },
      ),
    );
  }

}

