
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';
import '../shared/scaffold_with_navbar.dart';

class FoodProcessingCategory extends StatelessWidget {
  const FoodProcessingCategory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục chế biến'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthManager>().logout();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: const CircularProgressIndicator(),);
          }
          return GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: <Widget>[
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/grill.png',width: 80,),
                        Text("Món nướng", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món nướng");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.grilling);
                            context.goNamed('food-category-list', extra: "Món nướng");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/cooking.png',width: 80,),
                        Text("Món xào", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món xào");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.stirFrying);
                            context.goNamed('food-category-list', extra: "Món xào");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/steam.png',width: 80,),
                        Text("Món hấp", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món hấp");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.steaming);
                            context.goNamed('food-category-list', extra: "Món hấp");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/boil.png',width: 80,),
                        Text("Món luộc", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món luộc");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.boiling);
                            context.goNamed('food-category-list', extra: "Món luộc");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/fish.png',width: 80,),
                        Text("Món sấy", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món sấy");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.drying);
                            context.goNamed('food-category-list', extra: "Món sấy");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/mixing.png',width: 80,),
                        Text("Món trộn", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món trộn");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.mixing);
                            context.goNamed('food-category-list', extra: "Món trộn");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/soup.png',width: 80,),
                        Text("Món nấu", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món nấu");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.cooking);
                            context.goNamed('food-category-list', extra: "Món nấu");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
              Card(
                elevation: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/images/plate.png',width: 80,),
                        Text("Món khác", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      ]
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onTap: () {
                            print("Chọn món khác");
                            context.read<FoodRecipesManager>().setFoodType(CookingType.other);
                            context.goNamed('food-category-list', extra: "Món khác");
                          },
                        ),
                      ),
                    )
                  ],
                )
              ),
            ],
          );
        }
      )
    );
  }
}