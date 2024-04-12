
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/food/food_search_field.dart';
import 'package:ct484_project/ui/food/user_food_recipe_detail_mode.dart';
import 'package:ct484_project/ui/food/user_food_recipe_large_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserFoodRecipe extends StatefulWidget {
  const UserFoodRecipe(
    {super.key}
  );

  @override
  State<UserFoodRecipe> createState() => _UserFoodRecipeState();
}

class _UserFoodRecipeState extends State<UserFoodRecipe> {

  ValueNotifier<bool> _isDetailView = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công thức nấu ăn của tôi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FoodSearchField(onSubmit: (searchText) => context.read<FoodRecipesManager>().setSearchText(searchText),),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Chế độ hiển thị', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),),
                  ToggleViewMode(_isDetailView)
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: context.read<FoodRecipesManager>().fetchUserFoodRecipe(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<FoodRecipesManager>().fetchUserFoodRecipe(),
                  child: ValueListenableBuilder(
                    valueListenable: _isDetailView,
                    builder: (context, value, child) {
                      if (value) {
                        return const UserFoodRecipeDetailMode(false);
                      } else {
                        return const UserFoodRecipeLargeMode();
                      }
                    },
                  ),
                );
              }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('user-form');
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).indicatorColor,
      ),
    );
  }
}

class ToggleViewMode extends StatefulWidget {
  const ToggleViewMode(this.isDetail,{super.key});

  final ValueNotifier isDetail;

  @override
  State<ToggleViewMode> createState() => _ToggleViewModeState();
}

class _ToggleViewModeState extends State<ToggleViewMode> {
  final List<bool> _selectedView = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ToggleButtons(

      direction: Axis.horizontal,
      onPressed: (index) {
        setState(() {
          for(int i = 0; i< _selectedView.length; i++) {
            _selectedView[i] = i == index;
            if (index == 0 ) {
              widget.isDetail.value = true;
            } else {
              widget.isDetail.value = false;
            }
          }
        });
      },
      selectedBorderColor: theme.primaryColor,
      selectedColor: theme.indicatorColor,
      fillColor: theme.primaryColor,
      color: theme.primaryColor,
      isSelected: _selectedView,
      children: [
        Icon(Icons.list),
        Icon(Icons.view_agenda)
      ],
    );
  }
}