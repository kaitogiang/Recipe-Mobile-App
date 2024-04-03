
import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:ct484_project/ui/auth/auth_screen.dart';
import 'package:ct484_project/ui/food/favorite_food_screen.dart';
import 'package:ct484_project/ui/food/food_overview_screen.dart';
import 'package:ct484_project/ui/food/food_processing_category.dart';
import 'package:ct484_project/ui/food/food_search_screen.dart';
import 'package:ct484_project/ui/food/food_shopping_list_screen.dart';
import 'package:ct484_project/ui/food/shopping_list_detail_screen.dart';
import 'package:ct484_project/ui/food/shopping_list_manager.dart';
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:ct484_project/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _rootNavigatorkey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _searchingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'searchNav');
bool isUserAuthenticated = true;

Future<void> main() async {
  //load the .env file
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  GoRouter router(authManager) {
    final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorkey,
    initialLocation: authManager.isAuth ? '/home' : '/login',
    routes: <RouteBase>[
      //Chuyển hướng tơi trang đăng nhập
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => FutureBuilder(
          future: authManager.tryAutoLogin(),
          builder: (ctx, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
              ? const SafeArea(child: SplashScreen())
              : const SafeArea(child: AuthScreen());
          },
        )
      ),
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
                //Con cua Shopping list, khi nhấp vào một phần tử thì chuyển sang trang chi tiết
                //Các thực phẩm cần mua
                routes: <RouteBase>[
                  GoRoute(
                    name: 'detail',
                    path: 'detail/:shoppingListId',
                    builder: (context, state) =>  ShoppingListDetailScreen(shoppingListId: state.pathParameters['shoppingListId']!),
                    pageBuilder: (context, state) {
                      return _createSlideTransition(context, state, ShoppingListDetailScreen(shoppingListId: state.pathParameters['shoppingListId']!));
                    },
                  )
                ]
              )
            ]
          )
        ]
      ),
    ],
   );
   return _router;
  }

  

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      secondary: Colors.black,
      background: Colors.white,
      surface: Colors.white,
      surfaceTint: Colors.grey
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        //Provider lưu trữ trạng thái ShoppingListManager
        ChangeNotifierProvider(
          create: (context) => ShoppingListManager(),
        )
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
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
                ),
              ),  
              routerConfig: router(authManager),
            );
        }
      ),
    );
  }
  
}
//Hàm tạo hiệu ứng slide cho các route con
  CustomTransitionPage _createSlideTransition(BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: Duration(milliseconds: 500),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
    );
  }