import 'dart:developer';
import 'dart:io';
import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/services/storage_service.dart';
import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:ct484_project/ui/shared/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum IconLabel {
  public('Công khai',Icons.public),
  private('Riêng tư',Icons.lock);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

enum IconType {
  grilling('Món nướng', Icons.outdoor_grill_outlined),
  stirFrying('Món xào', Icons.outdoor_grill_outlined),
  steaming('Món hấp', Icons.outdoor_grill_outlined),
  boiling('Món luộc', Icons.outdoor_grill_outlined),
  drying('Món sấy', Icons.outdoor_grill_outlined),
  mixing('Món trộn', Icons.outdoor_grill_outlined),
  cooking('Món nấu', Icons.outdoor_grill_outlined),
  other('khác', Icons.outdoor_grill_outlined);

  const IconType(this.label, this.icon);
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _processingController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late FoodRecipe _editFood;
  IconLabel? selectedIcon;
  IconType? selectedType;
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
    switch(_editFood.type) {
      case CookingType.grilling: selectedType = IconType.grilling; break;
      case CookingType.stirFrying: selectedType = IconType.stirFrying; break;
      case CookingType.steaming: selectedType = IconType.steaming; break;
      case CookingType.boiling: selectedType = IconType.boiling; break;
      case CookingType.drying: selectedType = IconType.drying; break;
      case CookingType.mixing: selectedType = IconType.mixing; break;
      case CookingType.cooking: selectedType = IconType.cooking; break;
      default: selectedType = IconType.other; break;
    };
    _titleController.text = _editFood.title;
    _ingredientController.text = _editFood.ingredient;
    _processingController.text = _editFood.processing;

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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                _buildTitleField(),
                const SizedBox(height: 12,),
                _buildIngredientField(),
                const SizedBox(height: 12,),
                _buildProcessingField(),
                const SizedBox(height: 12,),
                _buildDropdownType(),
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
                  child: _editFood.id == null ? const Text('Thêm công thức mới') : const Text('Lưu thay đổi'),
                  onPressed: () {
                    _saveForm();
                  },
                ),
                ElevatedButton(
                  child: const Text('Chọn hình'),
                  onPressed: _pickAndUpLoadImage,
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  TextFormField _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(labelText: 'Tiêu đề',border: OutlineInputBorder()),
      // autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
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
      controller: _ingredientController,
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
      controller: _processingController,
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

  DropdownButtonFormField<IconType> _buildDropdownType() {
    return DropdownButtonFormField<IconType>(
      value: selectedType,
      decoration: const InputDecoration(
        labelText: 'Loại chế biến món ăn',
        filled: true,
        contentPadding: EdgeInsets.only(left: 14, top: 10, bottom: 10),
      ),
      items: IconType.values.map<DropdownMenuItem<IconType>>(
        (IconType icon) {
          return DropdownMenuItem<IconType>(
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
      onChanged: (IconType? newValue) {
        setState(() {
          selectedType = newValue;
          print("Da chon $newValue");
        });
      },
      validator: (IconType? value) {
        if (value == null) {
          return 'Vui lòng chọn loại chế biến món ăn';
        }
        return null;
      },
      onSaved: (value) {
        CookingType selectedvalue;
        switch(value) {
          case IconType.grilling: selectedvalue = CookingType.grilling; break;
          case IconType.stirFrying: selectedvalue = CookingType.stirFrying; break;
          case IconType.steaming: selectedvalue = CookingType.steaming; break;
          case IconType.boiling: selectedvalue = CookingType.boiling; break;
          case IconType.drying: selectedvalue = CookingType.drying; break;
          case IconType.mixing: selectedvalue = CookingType.mixing; break;
          case IconType.cooking: selectedvalue = CookingType.cooking; break;
          default: selectedvalue = CookingType.other; break;
        };
        _editFood = _editFood.copyWith(type: selectedvalue);
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

  Future<String?> _pickAndUpLoadImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile!=null) {
      final imagePath = imageFile.path;
      final storageService = StorageService();
      final imageUrl = await storageService.uploadImage(imagePath);
      //user the imageUrl for further processing
      log(imageUrl);
      return imageUrl;
    }
    return null;
  }
}