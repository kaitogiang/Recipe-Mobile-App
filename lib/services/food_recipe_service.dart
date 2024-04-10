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

      final favoriteMap = await httpFetch(
        '$databaseUrl/favoriteFoodRecipe/$userId.json?auth=$token',
        method: HttpMethod.get
      ) as Map<String, dynamic>?;

      foodMap?.forEach((foodRecipeId, foodRecipe) { 
        final isFavorite = favoriteMap == null ? false : favoriteMap!.containsKey(foodRecipeId);
        food.add(
          FoodRecipe.fromJson({
            'id': foodRecipeId,
            ...foodRecipe,
          }).copyWith(isFavorite: isFavorite)
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

  Future<bool> updateFoodRecipe(FoodRecipe foodRecipe) async {
    try {
      await httpFetch(
        '$databaseUrl/foodRecipes/${foodRecipe.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(foodRecipe.toJson()),
      );
      return true;
    } catch(error) {
      log(error.toString());
      return false;
    }
  }

  //Hàm xóa một công thức nấu ăn
  Future<bool> removeFoodRecipe(String foodRecipeId) async {
    try {
      await httpFetch(
        '$databaseUrl/foodRecipes/$foodRecipeId.json?auth=$token',
        method: HttpMethod.delete
      );
      return true;

    } catch(error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> toggleFavoriteFoodRecipe(FoodRecipe foodRecipe) async {
    try {
      if (foodRecipe.isFavorite) {
        await httpFetch(
          '$databaseUrl/favoriteFoodRecipe/$userId/${foodRecipe.id}.json?auth=$token',
          method: HttpMethod.put,
          body: jsonEncode(foodRecipe.isFavorite)
        );
      } else {
        await httpFetch(
          '$databaseUrl/favoriteFoodRecipe/$userId/${foodRecipe.id}.json?auth=$token',
          method: HttpMethod.delete
        );
      }
      
      return true;
    } catch(error) {
      log(error.toString());
      return false;
    }
  }
}