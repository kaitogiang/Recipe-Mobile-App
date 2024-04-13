
import 'dart:math';

import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/ui/food/food_shopping_list_tile.dart';
import 'package:ct484_project/ui/food/shopping_list_manager.dart';
import 'package:ct484_project/ui/shared/confirm_dialog.dart';
import 'package:ct484_project/ui/shared/dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';

class FoodShoppingListScreen extends StatefulWidget {
  const FoodShoppingListScreen({super.key});

  @override
  State<FoodShoppingListScreen> createState() => _FoodShoppingListScreenState();
}

class _FoodShoppingListScreenState extends State<FoodShoppingListScreen> {
  
  late FocusNode myFocusNode;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _controller.text = '';
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final shoppingListManager = ShoppingListManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kế hoạch mua nguyên liệu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthManager>().logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: context.read<ShoppingListManager>().fetchShoppingList(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<ShoppingListManager>().fetchShoppingList(),
              child: Consumer<ShoppingListManager>(
                builder: (context, shoppingListManager, child) {
                  return ListView.builder(
                    itemCount: shoppingListManager.itemCount,
                    itemBuilder: (ctx, i) {
                      final item = shoppingListManager.items[i];
                      return Dismissible(
                        key: Key(item.id!),
                        onDismissed: (direction) {
                          //Xóa một danh sách dựa vào id của nó
                          shoppingListManager.removeShoppingList(item.id!);
                          //Hiển thị hộp thoải thông báo thành công
                          ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Đã xóa thành công')));
                        },
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showConfirmDialog(context, 'Bạn chắc chắn xóa danh sách này, hành động này sẽ không thể hoàn tác lại', 'Xóa danh sách mua sắm??');
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete, color: Theme.of(context).indicatorColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            InkWell(child: FoodShoppingListTile(shoppingListManager.items[i])),
                            const Divider()
                          ],
                        ),
                      );
                    },
                  );
                }
              ),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).indicatorColor,
        onPressed: () {
          myFocusNode.requestFocus();
          _showDialogForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDialogForm(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm danh sách mới'),
        content: Form(
          key: _formKey,
          child: _buildTextField(),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('Thoát', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 17
                ),),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                      print('Tạo danh sách mới ${_controller.text}');
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                      _controller.text = '';
                  }
                  
                },
                child: Text('Tạo',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 17
                ),),
              )
            ],
          )
        ],
      )
    );
  }

  TextFormField _buildTextField() {
    return  TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.list),
        border: UnderlineInputBorder(),
        labelText: 'Tên danh sách mới',
        filled: true
      ),
      focusNode: myFocusNode,
      autofocus: true,
      controller: _controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Hãy nhập vào tên danh sách';
        }
        return null;
      },
      onSaved: (newValue) {
        ShoppingList newList = ShoppingList(
          id: '${DateTime.now()}${new Random().nextInt(1000)}',
          name: newValue!
        );
        context.read<ShoppingListManager>().addShoppingList(newList);
      },
      
    );
  }
}