import 'dart:io';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:flutter/material.dart';

enum IconLabel {
  public('Công khai',Icons.public),
  private('Riêng tư',Icons.lock);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class UserFoodRecipeForm extends StatefulWidget {
  UserFoodRecipeForm(
    FoodRecipe? foodRecipe,
    {super.key}) {
      if (foodRecipe == null) {
        this.foodRecipe = FoodRecipe(
          id: null,
          title: '',
          ingredient: '',
          processing: '',
        );
      } else {
        this.foodRecipe = foodRecipe;
      }
    }

    late final FoodRecipe foodRecipe;

  @override
  State<UserFoodRecipeForm> createState() => _UserFoodRecipeFormState();
}

class _UserFoodRecipeFormState extends State<UserFoodRecipeForm> {

  final _editForm = GlobalKey<FormState>();
  final TextEditingController iconController = TextEditingController();
  late FoodRecipe _editFood;
  IconLabel? selectedIcon;
  String? imageUrl;

  @override
  void initState() {
    _editFood = widget.foodRecipe;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm công thức mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _editForm,
          child: ListView(
            children: <Widget>[
              _buildTitleFiel(),
              const SizedBox(height: 12,),
              _buildIngredientField(),
              const SizedBox(height: 12,),
              _buildProcessingField(),
              const SizedBox(height: 12,),
              _buildDropdownMenu(),
              (imageUrl != null) 
              ? Image.network(imageUrl!)
              : Image.network('https://i.imgur.com/sUFH1Aq.png')
            ],
          ),
        ),
      )
    );
  }

  TextFormField _buildTitleFiel() {
    return TextFormField(
      initialValue: _editFood.title,
      decoration: const InputDecoration(labelText: 'Tiêu đề',border: OutlineInputBorder()),
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập tiêu đề cho công thức';
        }
        return null;
      },
      onSaved: (newValue) {
        _editFood = _editFood.copyWith(title: newValue);
      },
    );
  }

  TextFormField _buildIngredientField() {
    return TextFormField(
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      initialValue: _editFood.ingredient,
      decoration: const InputDecoration(labelText: 'Nguyên liệu',border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập nguyên liệu';
        }
        return null;
      },
      onSaved: (newValue) {
        _editFood = _editFood.copyWith(ingredient: newValue);
      },
    );

  }

  TextFormField _buildProcessingField() {
    return TextFormField(
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      initialValue: _editFood.processing,
      decoration: const InputDecoration(labelText: 'Cách làm',border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập cách làm';
        }
        return null;
      },
      onSaved: (newValue) {
        _editFood = _editFood.copyWith(processing: newValue);
      },
    );
  }

  DropdownMenu<IconLabel> _buildDropdownMenu() {
    return DropdownMenu(
      controller: iconController,
      enableFilter: false,
      requestFocusOnTap: false,
      enableSearch: false,
      leadingIcon: const Icon(Icons.settings),
      label: const Text('Chế độ hiển thị'),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0)
      ),
      onSelected: (IconLabel? icon) {
        setState(() {
          selectedIcon = icon;
        });
        print(icon!);
      },
      dropdownMenuEntries: IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
        (IconLabel icon) {
          return DropdownMenuEntry<IconLabel>(
            value: icon,
            label: icon.label,
            leadingIcon: Icon(icon.icon),
          );
        }
      ).toList(),
    );
  }
}