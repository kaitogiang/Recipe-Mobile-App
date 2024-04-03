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
  
}