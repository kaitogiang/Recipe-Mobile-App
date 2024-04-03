import 'package:ct484_project/models/shopping_item.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:flutter/material.dart';

class ShoppingListManager extends ChangeNotifier{
  List<ShoppingList> _items = [
    ShoppingList(
      id: 's1',
      name: 'Buổi ăn chiều',
      items: [
        ShoppingItem(
          id: 'o1',
          name: 'Cà rốt',
        )
      ]
    ),

    ShoppingList(
      id: 's2',
      name: 'Buổi ăn tối',
      items: [
        ShoppingItem(
          id: 'o1',
          name: 'Mua 2 củ cà rốt',
        ),
        ShoppingItem(
          id: 'o1',
          name: 'Mua nữa ký giá',
        ),
        ShoppingItem(
          id: 'o1',
          name: 'Mua 2 ngàn hàng lá ở cửa hàng tạp hóa Phương Mỹ Chi Khánh Tận Nam Mỹ Quới',
        )
      ]
    )
  ];

  List<ShoppingList> get items {
    return [..._items];
  }

  int get itemCount => _items.length;

  void addShoppingList(ShoppingList list) {
    _items.add(list);
    notifyListeners();
  }

  void removeShoppingList(String id) {
    _items.removeWhere((element) => id.compareTo(element.id!)==0);
    notifyListeners();
  }
  //Hàm thay đổi trạng thái của một mục bên trong một danh sách con
  void toggleCheckBox(ShoppingItem shopItem) {
    final savedState = shopItem.isCheck;
    shopItem.isCheck = !savedState;
    notifyListeners();
  }

  //Hàm xóa một mục bên trong một danh sách con
  void removeAnShoppingItem(ShoppingItem item) {
    final shoppingList = _items.firstWhere((element) => element.items.contains(item));
    shoppingList.removeItem(item);
    notifyListeners();
  }

  //Hàm thêm một mục vào danh sách con
  void addAnShoppingItem(String shoppingListId, ShoppingItem newItem) {
    final shoppingList = _items.firstWhere((element) => element.id!.compareTo(shoppingListId)==0);
    shoppingList.addListItem(newItem);
    notifyListeners();
  }
}