
import 'dart:async';
import 'dart:math';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/food/food_search_field.dart';
import 'package:ct484_project/ui/food/staggered_grid_view.dart';
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'food_processing_category.dart';

class FoodOverviewScreen extends StatefulWidget {
  const FoodOverviewScreen({super.key}); 

  @override
  State<FoodOverviewScreen> createState() => _FoodOverviewScreenState();
}

class _FoodOverviewScreenState extends State<FoodOverviewScreen> {

  late Future<void> _fetchFoodRecipe;
  @override
  void initState() {
     _fetchFoodRecipe = context.read<FoodRecipesManager>().fetchAllFoodRecipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthManager>().logout();
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const FoodSearchField(),
              Expanded(
                child: FutureBuilder(
                  future: _fetchFoodRecipe,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    return RefreshIndicator(
                      onRefresh: () => context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
                      child: Consumer<FoodRecipesManager>(
                        builder: (ctx, foodRecipesManager, child) {
                          return ListView.builder(
                            itemCount: foodRecipesManager.foodByTypeList.length,
                            itemBuilder: (context, index)  {
                              Map<String, List<FoodRecipe>> specificTypeList = foodRecipesManager.foodByTypeList[index];
                              String type = specificTypeList.keys.first;
                              List<FoodRecipe> typeRecipeList = specificTypeList.values.first;
                              return StaggeredGridView(type, typeRecipeList);
                            }
                          );
                        }
                      ),
                    );
                    // return StaggeredGridView(context.read<FoodRecipesManager>().items);
                    // return RefreshIndicator(
                    //   onRefresh: () => context.read<FoodRecipesManager>().fetchAllFoodRecipe(),
                    //   child: Consumer<FoodRecipesManager>(
                    //     builder: (ctx, foodRecipesManager, child) {
                    //       return ListView.builder(
                    //       itemCount: foodRecipesManager.allItems.length,
                    //       itemBuilder: (context, index) => Text(foodRecipesManager.allItems[index].title),
                    //                           );
                    //     }
                    //   ),
                    // );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}