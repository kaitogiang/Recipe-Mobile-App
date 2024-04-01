
import 'package:ct484_project/ui/food/favorite_food_screen.dart';
import 'package:ct484_project/ui/food/food_overview_screen.dart';
import 'package:ct484_project/ui/food/food_processing_category.dart';
import 'package:ct484_project/ui/food/food_search_screen.dart';
import 'package:ct484_project/ui/food/food_shopping_list_screen.dart';
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorkey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _searchingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'searchNav');
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorkey,
    initialLocation: '/home',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          //Nơi sẽ hiển thị các nhánh
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        //Danh sách các tab cũng là các nhánh
        branches: <StatefulShellBranch>[
          //Nhánh thứ nhất, tab tìm kiếm trong bottom navigation bar
          StatefulShellBranch(
            navigatorKey: _searchingNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                name: 'search',
                path: '/search',
                builder: (context, state) => const SafeArea(child: FoodSearchScreen()),
              )
            ]
          ),

          //Nhánh thứ hai, tab yêu thích trong bottom navigation bar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: 'favorite',
                path: '/favorite',
                builder: (context, state) => const SafeArea(child: FavoriteFoddScreen()),
              )
            ]
          ),

          //Nhánh thứ ba, tab trang chủ trong bottom navigation bar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: 'home',
                path: '/home',
                builder: (context, state) => const SafeArea(child: FoodOverviewScreen()),
              )
            ]
          ),

          //Nhánh thứ tư, tab danh mục trong bottom navigation bar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: 'category',
                path: '/category',
                builder: (context, state) => const SafeArea(child: FoodProcessingCategory()),
              )
            ]
          ),

          //Nhánh thứ năm, tab kế hoạch trong bottom navigation bar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: 'shopping-list',
                path: '/shopping-list',
                builder: (context, state) => const SafeArea(child: FoodShoppingListScreen()),
              )
            ]
          )
        ]
      )
    ]
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      secondary: Colors.black,
      background: Colors.white,
      surface: Colors.white,
      surfaceTint: Colors.grey
    );
    return MaterialApp.router(
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
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold
                );
              }
              return TextStyle(color: Colors.grey);
            }),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(
                  color: Colors.teal,
                );
              }
              return const IconThemeData(
                color: Colors.grey
              );
            }),
            backgroundColor: colorScheme.background,
          )
        ),  
        routerConfig: _router,      
      );
  }
}