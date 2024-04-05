import 'package:flutter/material.dart';

enum SampleItem {itemOne, itemTwo, itemThree}

class UserPopUpMenu extends StatefulWidget {
  const UserPopUpMenu({super.key});

  @override
  State<UserPopUpMenu> createState() => _UserPopUpMenuState();
}

class _UserPopUpMenuState extends State<UserPopUpMenu> {

  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      
      initialValue: selectedItem,
      onSelected: (item) {
        setState(() {
          selectedItem = item;
          print(selectedItem);
        });
      },
      icon: Icon(Icons.verified_user),
      itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Công thức của tôi'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Đăng xuất'),
        ),
      ],
    );
  }
}