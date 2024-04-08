import 'dart:io';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/shared/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
          imageUrl: '',
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
  final _imageUrlController = TextEditingController();
  late FoodRecipe _editFood;
  IconLabel? selectedIcon;
  String? imageUrl;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) && 
          (value.endsWith('.png') || value.endsWith('.jpg') || value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _editFood = widget.foodRecipe;
    _imageUrlController.text = _editFood.imageUrl;
    imageUrl = _editFood.imageUrl.isNotEmpty ? _editFood.imageUrl : null;
    selectedIcon = _editFood.isPublic ? IconLabel.public : IconLabel.private;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
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
              const SizedBox(height: 10,),
              _buildTitleFiel(),
              const SizedBox(height: 12,),
              _buildIngredientField(),
              const SizedBox(height: 12,),
              _buildProcessingField(),
              const SizedBox(height: 12,),
              _buildDropdownMenu(),
              const SizedBox(height: 12,),
              (imageUrl != null) 
              ? Image.network(
                imageUrl!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network('https://i.imgur.com/sUFH1Aq.png');
                },
              )
              : Image.network('https://i.imgur.com/sUFH1Aq.png'),
              const SizedBox(height: 12,),
              _buildImageField(),
              const SizedBox(height: 12),
              ElevatedButton(
                child: const Text('Lưu'),
                onPressed: () {
                  _saveForm();
                },
              )
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

  DropdownButtonFormField<IconLabel> _buildDropdownMenu() {
    return DropdownButtonFormField<IconLabel>(
      value: selectedIcon,
      decoration: const InputDecoration(
        labelText: 'Chế độ hiển thị',
        filled: true,
        contentPadding: EdgeInsets.only(left: 14, top: 10, bottom: 10),
        
      ),
      items: IconLabel.values.map<DropdownMenuItem<IconLabel>>(
        (IconLabel icon) {
          return DropdownMenuItem<IconLabel>(
            value: icon,
            child: Row(
              children: <Widget>[
                Icon(icon.icon),
                SizedBox(width: 10,),
                Text(icon.label),
              ],
            ),
          );
        }
      ).toList(),
      onChanged: (IconLabel? newValue) {
        setState(() {
          selectedIcon = newValue;
        });
      },
      validator: (IconLabel? value) {
        if (value == null) {
          return 'Vui lòng chọn chế độ';
        }
        return null;
      },
      onSaved: (value) {
        _editFood = _editFood.copyWith(isPublic: value == IconLabel.public);
      },
    );
  }

  TextFormField _buildImageField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Đường dẫn hình ảnh',border: OutlineInputBorder()),
      keyboardType: TextInputType.url,
      controller: _imageUrlController,
      onFieldSubmitted: (value) {
        setState(() {
          imageUrl = value.isEmpty ? null : value;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập địa chỉ hình ảnh';
        }
        if (!_isValidImageUrl(value)) {
          return 'Đường dẫn không hợp lệ';
        }
        return null;
      },
      onSaved: (newValue) {
        _editFood = _editFood.copyWith(imageUrl: newValue);
      },
    );
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    try {
      final foodRecipesManager = context.read<FoodRecipesManager>();
      if (_editFood.id != null) {
        await foodRecipesManager.updateFoodRecipe(_editFood);
      } else {
        await foodRecipesManager.addFoodRecipe(_editFood);
      }
    } catch(error) {
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}