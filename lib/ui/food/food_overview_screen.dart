
import 'dart:math';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:ct484_project/ui/shared/user_popup_menu.dart';
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'food_processing_category.dart';

class FoodOverviewScreen extends StatelessWidget {
  const FoodOverviewScreen({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        // actions: [
        //   PopupMenuButton<String>(
        //     useRootNavigator: true,
        //     icon: Icon(Icons.person),
        //     onSelected: (String result) {
        //       print(result);
        //     },
        //     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //       const PopupMenuItem<String>(
        //         value: 'Option 1',
        //         child: Text('Option 1'),
        //       ),
        //       const PopupMenuItem<String>(
        //         value: 'Option 2',
        //         child: Text('Option 2'),
        //       ),
        //     ],

        //   ),
        // ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Trang chủ"),
            TextButton(
              onPressed: () {
                AuthToken authToken = context.read<AuthManager>().authToken!;
                print("Email la: ${authToken.email}");
              },
              child: const Text("OKMan"),
            )
          ],
        ),
      ),
      
    );
  }
}