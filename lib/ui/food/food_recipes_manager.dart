import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/services/food_recipe_service.dart';
import 'package:flutter/material.dart';

class FoodRecipesManager extends ChangeNotifier {
  List<FoodRecipe> _items = [];

  final FoodRecipeService _foodRecipeService;

  FoodRecipesManager([AuthToken? authToken])
  : _foodRecipeService = FoodRecipeService(authToken);

  set authToken(AuthToken? authToken) {
    _foodRecipeService.authToken = authToken;
  }

  List<FoodRecipe> get items {
    return [..._items];
  }

  int get itemCount => _items.length;

  Future<void> fetchUserFoodRecipe() async {
    _items = await _foodRecipeService.fetchFoodRecipe(
      filteredByUser: true
    );
    notifyListeners();
  }

  Future<void> addFoodRecipe(FoodRecipe food) async {
    final newFood = await _foodRecipeService.addFoodRecipe(food);
    if (newFood != null) {
      _items.add(newFood);
    }

    notifyListeners();
  }

}