import 'dart:convert';
import 'dart:developer';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/services/firebase_service.dart';

class FoodRecipeService extends FirebaseService {
  FoodRecipeService([AuthToken? authToken]) : super(authToken);

  //Hàm nạp danh sách các công thức nấu ăn
  Future<List<FoodRecipe>> fetchFoodRecipe({bool filteredByUser = false}) async {
    final List<FoodRecipe> food = [];

    try {
      final filters = filteredByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

      final foodMap = await httpFetch(
        '$databaseUrl/foodRecipes.json?auth=$token&$filters',
        method: HttpMethod.get
      ) as Map<String, dynamic>?;

      foodMap?.forEach((foodRecipeId, foodRecipe) { 
        food.add(
          FoodRecipe.fromJson({
            'id': foodRecipeId,
            ...foodRecipe,
          })
        );
      });
      return food;
    } catch(error) {
      print("Loi cho trong food recipe service");
      log(error.toString());
      return food;
    }
  }


  //Hàm thêm một công thức nấu ăn mới
  Future<FoodRecipe?> addFoodRecipe(FoodRecipe foodRecipe) async {
    try {
      final newFoodRecipe = await httpFetch(
        '$databaseUrl/foodRecipes.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          foodRecipe.toJson()
            ..addAll({
              'creatorId': userId,
            })
        )
      ) as Map<String, dynamic>?;

      return foodRecipe.copyWith(
        id: newFoodRecipe!['name'],
      );
    } catch(error) {
      log(error.toString());
      return null;
    }
  }
}