
import 'package:ct484_project/ui/food/foods_processing_category.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomCurveNavigationBar extends StatefulWidget {
  const BottomCurveNavigationBar(
    {super.key});
  @override
  State<BottomCurveNavigationBar> createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<BottomCurveNavigationBar> {
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {

      return CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        index: _selectedIndex,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.search, color: Colors.white,),
            label: 'Tìm kiếm',
            labelStyle: TextStyle(color: Colors.white)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.favorite, color: Colors.white),
            label: 'Yêu thích',
            labelStyle: TextStyle(color: Colors.white)

          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.home),
            label: 'Trang chủ',
            labelStyle: TextStyle(color: Colors.white)

          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.restaurant_menu),
            label: 'Danh mục',
            labelStyle: TextStyle(color: Colors.white)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.list_alt),
            label: 'Kế hoạch',
            labelStyle: TextStyle(color: Colors.white)
          )
        ],
        onTap: (index) {
          setState(() {
            print(index);
          });
        },
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 200),
      );
  }
}