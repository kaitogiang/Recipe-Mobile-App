import 'package:flutter/material.dart';

enum CookingType {
  grilling, //Món nướng
  stirFrying, //Món xào
  steaming, //Món hấp
  boiling, //Món luộc
  drying, //Món sấy
  mixing, //Món trộn
  cooking, //Món nấu
  other
}

class FoodRecipe {
  final String? id;
  final String title;
  final String ingredient;
  final String processing;
  final String imageUrl;
  final CookingType type;
  final ValueNotifier<bool> _isPublic;
  final ValueNotifier<bool> _isFavorite;
  FoodRecipe({
    this.id,
    required this.title,
    required this.ingredient,
    required this.processing,
    required this.imageUrl,
    type = CookingType.other,
    isPublic = false,
    isFavorite = false,
  }) : _isPublic = ValueNotifier(isPublic),
       _isFavorite = ValueNotifier(isFavorite),
       this.type = type;

  set isPublic(bool newValue) {
    _isPublic.value = newValue;
  }

  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  bool get isPublic {
    return _isPublic.value;
  }

  bool get isFavorite {
    return _isFavorite.value;
  }

  @override
  String toString() {
    String typeString = "";
    switch(type) {
      case CookingType.grilling: typeString = "mon nuong"; break;
      case CookingType.stirFrying: typeString = "mon xao"; break;
      case CookingType.steaming: typeString = "mon hap"; break;
      case CookingType.boiling: typeString = "mon luoc"; break;
      case CookingType.drying: typeString = "mon say"; break;
      case CookingType.mixing: typeString = "mon tron"; break;
      case CookingType.cooking: typeString = "mon nau"; break;
      default: typeString = "mon khac"; break;
    }
    return title + " " + typeString;
  }

  ValueNotifier<bool> get isPublicListenable {
    return _isPublic;
  }

  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  FoodRecipe copyWith({
    String? id,
    String? title,
    String? ingredient,
    String? processing,
    String? imageUrl,
    CookingType? type,
    bool? isPublic,
    bool? isFavorite,
  }) {
    return FoodRecipe(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredient: ingredient ?? this.ingredient,
      processing: processing ?? this.processing,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      isPublic: isPublic ?? this.isPublic,
      isFavorite: isFavorite ?? this.isFavorite
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredient': ingredient,
      'processing': processing,
      'imageUrl': imageUrl,
      'type': type.toString(),
      'isPublic': isPublic.toString()
    };
  }

  static FoodRecipe fromJson(Map<String, dynamic> json) {
    return FoodRecipe(
      id: json['id'],
      title: json['title'],
      ingredient: json['ingredient'],
      processing: json['processing'],
      imageUrl: json['imageUrl'],
      type:  setCookingType(json['type']),
      isPublic: json['isPublic'].compareTo("true")==0 ? true : false
    );
  }

  static CookingType setCookingType(String type) {
    switch(type) {
      case "CookingType.grilling": return CookingType.grilling;
      case "CookingType.stirFrying": return CookingType.stirFrying;
      case "CookingType.steaming": return CookingType.steaming;
      case "CookingType.boiling": return CookingType.boiling;
      case "CookingType.drying": return CookingType.drying;
      case "CookingType.mixing": return CookingType.mixing;
      case "CookingType.cooking": return CookingType.cooking;
    }
    return CookingType.other;
  }
}