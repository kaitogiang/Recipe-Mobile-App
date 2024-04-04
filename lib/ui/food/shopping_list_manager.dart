import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/shopping_item.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/services/shopping_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class ShoppingListManager extends ChangeNotifier{
  List<ShoppingList> _items = [
    // ShoppingList(
    //   id: 's1',
    //   name: 'Buổi ăn chiều',
    //   items: [
    //     ShoppingItem(
    //       id: 'o1',
    //       name: 'Cà rốt',
    //     )
    //   ]
    // ),

    // ShoppingList(
    //   id: 's2',
    //   name: 'Buổi ăn tối',
    //   items: [
    //     ShoppingItem(
    //       id: 'o1',
    //       name: 'Mua 2 củ cà rốt',
    //     ),
    //     ShoppingItem(
    //       id: 'o1',
    //       name: 'Mua nữa ký giá',
    //     ),
    //     ShoppingItem(
    //       id: 'o1',
    //       name: 'Mua 2 ngàn hàng lá ở cửa hàng tạp hóa Phương Mỹ Chi Khánh Tận Nam Mỹ Quới',
    //     )
    //   ]
    // )
  ];

  final ShoppingService _shoppingService;

  ShoppingListManager([AuthToken? authToken])
  : _shoppingService = ShoppingService(authToken);

  set authToken(AuthToken? authToken) {
    _shoppingService.authToken = authToken;
  }

  List<ShoppingList> get items {
    return [..._items];
  }

  int get itemCount => _items.length;

  Future<void> fetchShoppingList() async {
    _items = await _shoppingService.fetchShoppingList();
    notifyListeners();
  }

  Future<void> addShoppingList(ShoppingList list) async{
    print('Thuc hien ham tao shopping list');
    final newShopping = await _shoppingService.addShoppingList(list);
    if (newShopping!=null) {
      _items.add(newShopping);
    }
    // _items.add(list);
    notifyListeners();
  }
  //Hàm xóa một danh sách cụ thể
  Future<void> removeShoppingList(String id) async{
    if (await _shoppingService.removeShoppingList(id)) {
      _items.removeWhere((element) => id.compareTo(element.id!)==0);
    }
    notifyListeners();
  }
  //Hàm thay đổi trạng thái của một mục bên trong một danh sách con
  Future<void> toggleCheckBox(ShoppingItem shopItem, String shoppingListId) async{
    final savedState = shopItem.isCheck;
    shopItem.isCheck = !savedState;
    await _shoppingService.toggleCheckBox(shopItem.id!, shoppingListId, (!savedState).toString());
    notifyListeners();
  }

  //Hàm xóa một mục bên trong một danh sách con
  Future<void> removeAnShoppingItem(ShoppingItem item) async{
    final shoppingList = _items.firstWhere((element) => element.items.contains(item));
    if (await _shoppingService.removeShoppingItem(shoppingList.id!, item.id!)) {
      shoppingList.removeItem(item);
    }
    notifyListeners();
  }

  //Hàm thêm một mục vào danh sách con
  Future<void> addAnShoppingItem(String shoppingListId, ShoppingItem newItem) async{
    final shoppingList = _items.firstWhere((element) => element.id!.compareTo(shoppingListId)==0);
    final item = await _shoppingService.addShoppingItem(shoppingListId, newItem);
    shoppingList.addListItem(item!);
    notifyListeners();
  }
}