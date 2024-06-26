
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/models/shopping_list.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:ct484_project/ui/auth/auth_screen.dart';
import 'package:ct484_project/ui/food/favorite_food_screen.dart';
import 'package:ct484_project/ui/food/food_overview_screen.dart';
import 'package:ct484_project/ui/food/food_processing_category.dart';
import 'package:ct484_project/ui/food/food_recipe_by_category.dart';
import 'package:ct484_project/ui/food/food_recipe_detail_screen.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/food/food_shopping_list_screen.dart';
import 'package:ct484_project/ui/food/horizontal_food_recipe.dart';
import 'package:ct484_project/ui/food/shopping_list_detail_screen.dart';
import 'package:ct484_project/ui/food/shopping_list_manager.dart';
import 'package:ct484_project/ui/food/user_food_recipe.dart';
import 'package:ct484_project/ui/food/user_food_recipe_form.dart';
import 'package:ct484_project/ui/shared/scaffold_with_navbar.dart';
import 'package:ct484_project/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
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
  WidgetsFlutterBinding.ensureInitialized(); //Khởi tạo Firebase để sử dụng được các dịch vụ khác như Storage
  await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: 'AIzaSyDwMeKYgOZLjRHwt4xIxWjD2wBXVmW98xo',
    appId: '1:823352233485:android:891f95732ace261ba54f44',
    messagingSenderId: '823352233485',
    projectId: 'cooking-app-8dd74',
    storageBucket: 'gs://cooking-app-8dd74.appspot.com',
  ),
  );
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider(siteKey)
  // );
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
                name: 'user-food',
                path: '/userfood',
                builder: (context, state) => const SafeArea(child: UserFoodRecipe()),
                routes: <RouteBase>[
                  GoRoute(
                    name: 'user-form',
                    path: 'userform',
                    builder: (context, state) =>  SafeArea(child: UserFoodRecipeForm(state.extra == null ? null: state.extra as FoodRecipe)),
                    pageBuilder: (context, state) => _createSlideTransition(context, state, UserFoodRecipeForm(state.extra == null ? null: state.extra as FoodRecipe)),
                  ),
                  GoRoute(
                    name: 'user-food-detail',
                    path: 'user-food-detail',
                    builder: (context, state) => SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe)),
                    pageBuilder: (context, state) => _createSlideTransition(context, state, SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe))),
                  )
                ]
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
                routes: <RouteBase>[
                  GoRoute(
                    name: 'favorite-food-detail',
                    path: 'favorite-food-detail',
                    builder: (context, state) => SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe)),
                    pageBuilder: (context, state) => _createSlideTransition(context, state, SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe))),
                  )
                ]
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
                routes: <RouteBase>[
                  GoRoute(
                    name: 'home-food-detail',
                    path: 'home-food-detail',
                    builder: (context, state) => SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe)),
                    pageBuilder: (context, state) => _createSlideTransition(context, state, SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe))),
                  )
                ]
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
                routes: <RouteBase>[
                  GoRoute(
                    name: 'food-category-list',
                    path: 'food-category-list',
                    builder: (context, state) => SafeArea(child: FoodRecipeByCategory(state.extra as String)),
                    pageBuilder: (context, state) => _createSlideTransition(context, state, SafeArea(child: FoodRecipeByCategory(state.extra as String))),
                    routes: <RouteBase>[
                      GoRoute(
                        name: 'food-category-detail',
                        path: 'food-category-detail',
                        builder: (context, state) => SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe)),
                        pageBuilder: (context, state) => _createSlideTransition(context, state, SafeArea(child: FoodRecipeDetailScreen(state.extra as FoodRecipe))),
                      )
                    ]
                  )
                ]
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
        ChangeNotifierProxyProvider<AuthManager, ShoppingListManager>(
          create: (ctx) => ShoppingListManager(),
          update: (ctx, authManager, shoppingListManager) {
            //Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            //cho ShoppingListManager
            shoppingListManager!.authToken = authManager.authToken;
            return shoppingListManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, FoodRecipesManager>(
          create: (ctx) => FoodRecipesManager(),
          update: (ctx, authManager, foodRecipesManager) {
            //Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            //cho foodRecipesManager
            foodRecipesManager!.authToken = authManager.authToken;
            return foodRecipesManager;
          },
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