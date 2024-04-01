
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Yêu thích'
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Trang chủ'
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Danh mục'
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Kế hoạch'
          )
        ],
        //currentIndex ở đây là index của branch đang được active,
        //tức là đang được chọn
        //navigationshell 
        //navigationShell là một hub trung tâm để kiểm soát và tương tác
        //với toàn bộ các route con bên trong mỗi nhánh, tức là mỗi tab
        //Nó giữ nguyên trạng thái của các route con bên trong, cho phép
        //Người dùng có thể trở về trạng thái trước đó
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
      ),
    );
  }
  //Hàm dùng để chuyển hướng tới một nhánh
  void _onTap(BuildContext context, int index) {
    //Hàm goBranch dùng để chuyển hướng tới một nhánh nào đó đã định nghĩa
    //theo chỉ số. Thứ tự các nhánh bắt đầu từ 0. Nhánh đầu tiên là 0,
    //thứ hai là 1, vv..vv
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex
    );
  }
}