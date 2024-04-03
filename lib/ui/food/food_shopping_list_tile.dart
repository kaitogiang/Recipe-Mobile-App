
import 'package:ct484_project/models/shopping_item.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FoodShoppingListTile extends StatelessWidget {
  final ShoppingList list;

  const FoodShoppingListTile(
    this.list, {
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(list.name, style: Theme.of(context).textTheme.bodyLarge),
      leading: Icon(Icons.list),
      trailing: Text('${list.checkedItemNumber}/${list.itemsSize}', style: Theme.of(context).textTheme.bodyLarge),
      onTap: () {
        print('Đã tap vao phan tu ${list.name} voi ${list.checkedItemNumber} đã tích');
        context.goNamed('detail',pathParameters: {'shoppingListId': list.id!});
      },
    );
  }
}