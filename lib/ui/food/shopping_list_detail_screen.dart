import 'dart:math';

import 'package:ct484_project/models/shopping_item.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/ui/food/shopping_list_manager.dart';
import 'package:ct484_project/ui/shared/dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  const ShoppingListDetailScreen({required this.shoppingListId, super.key});

  final String shoppingListId;

  @override
  State<ShoppingListDetailScreen> createState() => _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {

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
  //TÌm kiếm danh sách tương thích dựa vào Id đã nhận được
  final shoppingListManager = context.watch<ShoppingListManager>().items;
  final items = shoppingListManager.firstWhere((e) => e.id!.compareTo(widget.shoppingListId)==0,);
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text(items.name),
      ),
      body: items.itemsSize == 0 ? Center(
        child: Text('Danh sách rỗng, hãy tạo danh sách nguyên liệu cần mua', 
        style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
      ) : ListView.builder(
        itemCount: items.items.length,
        itemBuilder: (ctx, i) => Column(
          children: [
            ShoppingItemListTile(items.items[i], items.id!)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Thêm mục mới ${items.checkedItemNumber}');
          _showDialogForm(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).indicatorColor,
      ),
    )
    );
  }

  void _showDialogForm(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nguyên liệu'),
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
                      print('Thêm nguyên liệu mới ${_controller.text}');
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
        prefixIcon: Icon(Icons.fastfood),
        border: UnderlineInputBorder(),
        labelText: 'Tên nguyên liệu',
        filled: true
      ),
      focusNode: myFocusNode,
      autofocus: true,
      controller: _controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Hãy nhập vào tên nguyên liệu';
        }
        return null;
      },
      onSaved: (newValue) {
        ShoppingItem newItem = ShoppingItem(
          id: '${DateTime.now()}${Random().nextInt(1000)}',
          name: newValue!
        );
        context.read<ShoppingListManager>().addAnShoppingItem(widget.shoppingListId, newItem);
      },
      
    );
  }

}

class ShoppingItemListTile extends StatelessWidget {
  final ShoppingItem listItem; //Đây là một mục cần mua
  final String shoppingListId;
  const ShoppingItemListTile(
    this.listItem, this.shoppingListId, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(listItem.itemName),
        leading: ValueListenableBuilder(
          valueListenable:listItem.isCheckListenable,
          builder: (context, value, child) {
            return Checkbox(
              checkColor: Colors.white,
              value: listItem.isCheck,
              onChanged: (value) {
                context.read<ShoppingListManager>().toggleCheckBox(listItem, shoppingListId);
              },
            );
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            print('Xóa phần tử ${listItem.itemName}');
            context.read<ShoppingListManager>().removeAnShoppingItem(listItem);
            //Hiển thị hộp thoải thông báo thành công
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Đã xóa thành công')));
          },
        ),
        onTap: () {
          print('Đánh dấu hoàn thành cho ${listItem.itemName}');
          context.read<ShoppingListManager>().toggleCheckBox(listItem, shoppingListId);
        },
      );
  }
}