import 'package:ct484_project/models/shopping_item.dart';

class ShoppingList {
  final String? id;
  final String name;
  final List<ShoppingItem> _items;

  ShoppingList({
    this.id,
    required this.name,
    items
  }) : _items = items ?? [];

  int get itemsSize => _items.length;

  int get checkedItemNumber {
    int sum = 0;
    _items.forEach((element) { 
      if (element.isCheck) {
        sum = sum + 1;
      }
    });
    return sum;
  }

  List<ShoppingItem> get items => _items;

  void removeItem(ShoppingItem item) {
    _items.remove(item);
  }

  //Hàm thêm một mục vào _item
  void addListItem(ShoppingItem item) {
    _items.add(item);
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    List<ShoppingItem>? items
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items
    };
  }

  static ShoppingList fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      items: json['items']
    );
  }
}