import 'package:flutter/material.dart';

class FoodRecipe {
  final String? id;
  final String title;
  final String ingredient;
  final String processing;
  final ValueNotifier<bool> _isPublic;

  FoodRecipe({
    this.id,
    required this.title,
    required this.ingredient,
    required this.processing,
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
    bool? isPublic,
  }) {
    return FoodRecipe(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredient: ingredient ?? this.ingredient,
      processing: processing ?? this.processing,
      isPublic: isPublic ?? this.isPublic
    );
  }
}