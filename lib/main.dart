
import 'package:ct484_project/ui/food/foods_overview_screen.dart';
import 'package:ct484_project/ui/food/foods_processing_category.dart';
import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      secondary: Colors.orange,
      background: Colors.white,
      surface: Colors.white
    );
    return MaterialApp(
        title: 'My Receipt',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: colorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 4,
            shadowColor: colorScheme.shadow
          ),    
          iconTheme: IconThemeData(color: Colors.white)
        ),
        home: const SafeArea(child: FoodsOverviewScreen()),
        routes: {
          FoodsProcessingCategory.routeName: (ctx) => const SafeArea(child: FoodsProcessingCategory() )
        },
      );
  }
}