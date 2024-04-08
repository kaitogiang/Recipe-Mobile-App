import 'package:flutter/material.dart';

class FoodRecipe {
  final String? id;
  final String title;
  final String ingredient;
  final String processing;
  final String imageUrl;
  final ValueNotifier<bool> _isPublic;

  FoodRecipe({
    this.id,
    required this.title,
    required this.ingredient,
    required this.processing,
    required this.imageUrl,
    isPublic = false,
  }) : _isPublic = ValueNotifier(isPublic);

  set isPublic(bool newValue) {
    _isPublic.value = newValue;
  }

  bool get isPublic {
    return _isPublic.value;
  }

  ValueNotifier<bool> get isPublicListenable {
    return _isPublic;
  }

  FoodRecipe copyWith({
    String? id,
    String? title,
    String? ingredient,
    String? processing,
    String? imageUrl,
    bool? isPublic,
  }) {
    return FoodRecipe(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredient: ingredient ?? this.ingredient,
      processing: processing ?? this.processing,
      imageUrl: imageUrl ?? this.imageUrl,
      isPublic: isPublic ?? this.isPublic
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredient': ingredient,
      'processing': processing,
      'imageUrl': imageUrl,
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
      isPublic: json['isPublic'].compareTo("true")==0 ? true : false
    );
  }
}