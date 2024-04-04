
import 'package:flutter/material.dart';

class ShoppingItem {
  final String? id;
  final String name;
  final ValueNotifier<bool> _isCheck;

  ShoppingItem({
    this.id,
    required this.name,
    isCheck = false,
  }) : _isCheck = ValueNotifier<bool>(isCheck);

  set isCheck(bool newValue) {
    _isCheck.value = newValue;
  }
  bool get isCheck {
    return _isCheck.value;
  }

  ValueNotifier<bool> get isCheckListenable {
    return _isCheck;
  }

  String get itemName => name;

  ShoppingItem copyWith({
    String? id,
    String? name,
    bool? isCheck
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isCheck: isCheck ?? this.isCheck
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCheck': isCheck.toString()
    };
  }

  static ShoppingItem fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      isCheck: json['isCheck'].compareTo("true") == 0 ? true : false
    );
  }
}