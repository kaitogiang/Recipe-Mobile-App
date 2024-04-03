import 'dart:convert';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/services/firebase_service.dart';

class ShoppingService extends FirebaseService {
  ShoppingService([AuthToken? authToken]) : super(authToken);


  //Hàm thêm danh sách vào cơ sở dữ liệu
  Future<ShoppingList?> addShoppingList(ShoppingList shopList) async {
    try {
      final newShoppingList = await httpFetch(
        '$databaseUrl/shopping.json?auth=$token',
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
      print(error);
      return null;
    }
  }
}