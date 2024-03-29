
import 'package:ct484_project/ui/shared/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

import 'foods_processing_category.dart';

class FoodsOverviewScreen extends StatelessWidget {
  const FoodsOverviewScreen({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trang chủ'),
        ),
        bottomNavigationBar: BottomCurveNavigationBar(),
        body: Center(
          child: const Text("Trang chủ"),
        ),
      );
  }
}