import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/services/food_recipe_service.dart';
import 'package:flutter/material.dart';

class FoodRecipesManager extends ChangeNotifier {
  List<FoodRecipe> _items = [];
  String _searchText = '';

  final FoodRecipeService _foodRecipeService;

  FoodRecipesManager([AuthToken? authToken])
  : _foodRecipeService = FoodRecipeService(authToken);

  set authToken(AuthToken? authToken) {
    _foodRecipeService.authToken = authToken;
  }

  List<FoodRecipe> get items {
    if (_searchText.isEmpty) {
      return [..._items];
    } else {
      return _items.where((foodRecipe) => removeVietnameseAccent(foodRecipe.title).contains(_searchText)).toList();
    }
  }

  List<FoodRecipe> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  String removeVietnameseAccent(String origin) {
    Map<String, List<String>> template = {
    'a': ['á', 'à', 'ã', 'ạ', 'â', 'ấ', 'ầ', 'ẫ', 'ậ', 'ă', 'ắ', 'ằ', 'ẵ', 'ặ'],
    'e': ['é', 'è', 'ẽ', 'ẹ', 'ê', 'ế', 'ề', 'ễ', 'ệ', 'ẻ'],
    'i': ['í', 'ì', 'ĩ', 'ị'],
    'o': ['ó', 'ò', 'õ', 'ọ', 'ô', 'ố', 'ồ', 'ỗ', 'ộ', 'ơ', 'ớ', 'ờ', 'ỡ', 'ợ'],
    'u': ['ú', 'ù', 'ũ', 'ụ', 'ư', 'ứ', 'ừ', 'ữ', 'ự'],
    'y': ['ý', 'ỳ', 'ỹ', 'ỵ'],
    };

  
    String newString = origin.toLowerCase();
    
    template.forEach((basic, list) {
      for(int i=0; i<newString.length; i++) {
        if (list.contains(newString[i])) {
          newString = newString.replaceAll(newString[i], basic);
        }
      }
      });
    return newString;
  }

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  int get itemCount => _items.length;

  Future<void> fetchAllFoodRecipe() async {
    _items = await _foodRecipeService.fetchFoodRecipe();
    notifyListeners();
  }


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

  Future<void> updateFoodRecipe(FoodRecipe food) async {
    final index = _items.indexWhere((item) => item.id == food.id);
    if (index >= 0) {
      if (await _foodRecipeService.updateFoodRecipe(food)) {
        _items[index] = food;
        notifyListeners();
      }
    }
  }

  Future<void> removeFoodRecipe(String foodId) async {
    if (await _foodRecipeService.removeFoodRecipe(foodId)) {
      _items.removeWhere((element) => element.id!.compareTo(foodId)==0);
    }
    notifyListeners();
  }

  Future<void> toggleFavoriteFoodRecipe(FoodRecipe foodRecipe) async {
    final savedState = foodRecipe.isFavorite;
    foodRecipe.isFavorite = !savedState;
    if(!await _foodRecipeService.toggleFavoriteFoodRecipe(foodRecipe)) {
      foodRecipe.isFavorite = savedState;
    }
    notifyListeners();
  }
}