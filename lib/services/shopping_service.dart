import 'dart:convert';
import 'dart:developer';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/shopping_item.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/services/firebase_service.dart';

class ShoppingService extends FirebaseService {
  ShoppingService([AuthToken? authToken]) : super(authToken);

  Future<List<ShoppingList>> fetchShoppingList() async{
    List<ShoppingList> list = [];
    try {
      final shoppingList = await httpFetch(
        '$databaseUrl/shopping/$userId.json?auth=$token',
        method: HttpMethod.get,
      ) as Map<String, dynamic>;

      final shoppingItem = await httpFetch(
        '$databaseUrl/shoppingItem/$userId.json?auth=$token',
        method: HttpMethod.get
      ) as Map<String, dynamic>;

      shoppingList.forEach((shoppingListId, value) {
        final items = shoppingItem[shoppingListId];
        List<ShoppingItem> itemList = []; //Lấy danh sách các mục của một danh sách cụ thể
        if (items!=null) {
          items.forEach((shoppingItemId, item) { 
            itemList.add(
              ShoppingItem.fromJson({
                'id': shoppingItemId,
                  ...item
              })
            );
          });
        }
        //Thêm từng danh sách với các thuộc tính đầy đủ vào trong full list
        list.add(
          ShoppingList.fromJson({
            'id': shoppingListId,
            ...value
          }).copyWith(items: itemList)
        );
      });
      return list;
    } catch(error) {
      log(error.toString());
      return list;
    }
  }

  //Hàm thêm danh sách vào cơ sở dữ liệu
  Future<ShoppingList?> addShoppingList(ShoppingList shopList) async {
    try {
      final newShoppingList = await httpFetch(
        '$databaseUrl/shopping/$userId.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          shopList.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        )
      ) as Map<String, dynamic>?;

      return shopList.copyWith(
        id: newShoppingList!['name'],
      );
    } catch(error) {
      print('Loi cho nay roi $error');
      return null;
    }
  }
  //Hàm thêm từng mục vào trong danh sách
  Future<ShoppingItem?> addShoppingItem(String shoppingListId, ShoppingItem item) async{
    try {
      final newItem = await httpFetch(
        '$databaseUrl/shoppingItem/$userId/$shoppingListId.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          item.toJson()
        )
      ) as Map<String, dynamic>;

      return item.copyWith(
        id: newItem['name']
      );
    } catch(error) {
      log(error.toString());
    }
  }

  //Hàm xóa một mục cụ thể trong danh sách
  Future<bool> removeShoppingItem(String shoppingListId, String shoppingItemId) async{
    try{
      await httpFetch(
        '$databaseUrl/shoppingItem/$userId/$shoppingListId/$shoppingItemId.json?auth=$token',
        method: HttpMethod.delete
      );
      return true;
    } catch(error) {
      log(error.toString());
      return false;
    }
  }

  //Hàm xóa một danh sách cụ thể
  Future<bool> removeShoppingList(String shoppingListId) async {
    try { 
      await httpFetch(
        '$databaseUrl/shopping/$userId/$shoppingListId.json?auth=$token',
        method: HttpMethod.delete
      );
      await httpFetch(
        '$databaseUrl/shoppingItem/$userId/$shoppingListId.json?auth=$token',
        method: HttpMethod.delete
      );
      return true;
    } catch(error) {
      log(error.toString());
      return false;
    }
  }

  //Hàm chuyển đổi trạng thái check
  Future<void> toggleCheckBox(String shoppingItemId, String shoppingListId, String changedState) async {
    try {
      await httpFetch(
        '$databaseUrl/shoppingItem/$userId/$shoppingListId/$shoppingItemId.json?auth=$token',
        method: HttpMethod.patch,
        body: json.encode({
          'isCheck': changedState
        })
      );
    } catch(error) {
      log(error.toString());
    }
  }
}