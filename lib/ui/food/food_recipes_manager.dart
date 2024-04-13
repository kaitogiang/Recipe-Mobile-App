import 'dart:async';
import 'dart:math';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/services/food_recipe_service.dart';
import 'package:ct484_project/services/storage_service.dart';
import 'package:flutter/material.dart';
class FoodRecipesManager extends ChangeNotifier {
  List<FoodRecipe> _items = []; //Lưu trữ sản phẩm của người dùng cụ thể
  List<FoodRecipe> _allItems = []; //Lưu trữ tất cả sản phẩm

  String _searchText = '';

  String _seachHomeText = '';

  CookingType _foodType = CookingType.other;

  final FoodRecipeService _foodRecipeService;
  final StorageService _storageService;

  FoodRecipesManager([AuthToken? authToken])
  : _foodRecipeService = FoodRecipeService(authToken),
    _storageService = StorageService(authToken);

  set authToken(AuthToken? authToken) {
    _foodRecipeService.authToken = authToken;
    _storageService.authToken = authToken;
  }

  List<FoodRecipe> get items {
    if (_searchText.isEmpty) {
      return [..._items];
    } else {
      return _items.where((foodRecipe) => removeVietnameseAccent(foodRecipe.title).contains(_searchText)).toList();
    }
  }

  List<FoodRecipe> get allItems {
    if (_seachHomeText.isEmpty) {
      return [..._allItems];
    } else {
      return _allItems.where((foodRecipe) => removeVietnameseAccent(foodRecipe.title).contains(_seachHomeText)).toList();
    }
  }

  List<FoodRecipe> get itemsByType {
    return _allItems.where((foodRecipe)=>foodRecipe.type == _foodType).toList();
  }

  List<Map<String, List<FoodRecipe>>> get foodByTypeList {
    Map<CookingType, String> getCookingTypeString = {
      CookingType.grilling: "Món nướng",
      CookingType.stirFrying: "Món xào",
      CookingType.steaming: "Món hấp",
      CookingType.boiling: "Món luộc",
      CookingType.drying: "Món sấy",
      CookingType.mixing: "Món trộn",
      CookingType.cooking: "Món nấu",
      CookingType.other: "Món khác"
    };

    List<Map<String, List<FoodRecipe>>> typeList = [];
    Map<String, List<FoodRecipe>> map = {}; //Map dùng để lưu trữ loại và danh sách tương ứng
     //Tạo gợi ý hôm nay
    List<FoodRecipe> randomizedList = [..._allItems];
    var random = new Random();
    //Shuffle the list
    randomizedList.shuffle(random);
    //Lấy 5 phần tử đầu tiên
    List<FoodRecipe> recommendList = randomizedList.take(5).toList();
    map["Gợi ý hôm này"] = recommendList;

    typeList.add(map);

    for(CookingType type in CookingType.values) {
      Map<String, List<FoodRecipe>> map = {};
      List<FoodRecipe> sublist = [];
      String typeString = getCookingTypeString[type]!;
      _allItems.forEach((foodRecipe) { 
        if (type == foodRecipe.type && sublist.length < 5) {
          sublist.add(foodRecipe);
        }
      });
      map[typeString] = sublist;
      typeList.add(map);
    }

    return typeList;
  }

  List<FoodRecipe> get favoriteItems {
    return _allItems.where((item) => item.isFavorite).toList();
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

  bool get isEmptySearchHome {
    return _seachHomeText.isEmpty;
  }

  void setSearchHomeText(String value) {
    _seachHomeText = value;
    notifyListeners();
  }

  void setFoodType(CookingType type) {
    _foodType = type;
    notifyListeners();
  }

  int get itemCount => _items.length;

  Future<void> fetchAllFoodRecipe() async {
    _allItems = await _foodRecipeService.fetchFoodRecipe();
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
      _allItems.add(newFood);
    }

    notifyListeners();
  }

  Future<void> updateFoodRecipe(FoodRecipe food) async {
    final index = _items.indexWhere((item) => item.id == food.id);
    final indexInAll = _allItems.indexWhere((item) => item.id == food.id);
    if (index >= 0) {
      if (await _foodRecipeService.updateFoodRecipe(food)) {
        _items[index] = food;
        _allItems[indexInAll] = food;
        notifyListeners();
      }
    }
  }

  Future<void> removeFoodRecipe(String foodId) async {
    if (await _foodRecipeService.removeFoodRecipe(foodId)) {
      _items.removeWhere((element) => element.id!.compareTo(foodId)==0);
      _allItems.removeWhere((element) => element.id!.compareTo(foodId)==0);
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

  Future<String> uploadImage(String path) async {
    return await _storageService.uploadImage(path);
  }

  Future<String> getImageNameFromUrl(String downloadedUrl) async {
    return await _storageService.getImageNameFromUrl(downloadedUrl);
  }

  Future<void> removeImageFileFromStorage(String filename) async {
    return await _storageService.removeUploadedFile(filename);
  }

}