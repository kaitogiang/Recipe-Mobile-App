import 'package:ct484_project/ui/food/food_recipes_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodSearchField extends StatefulWidget {
  const FoodSearchField({super.key});

  @override
  State<FoodSearchField> createState() => _FoodSearchFieldState();
}

class _FoodSearchFieldState extends State<FoodSearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();

     });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    super.dispose();
  }

  String removeVietnameseAccent(String origin) {
  Map<String, List<String>> template = {
  'a': ['á', 'à', 'ã', 'ạ', 'â', 'ấ', 'ầ', 'ẫ', 'ậ', 'ă', 'ắ', 'ằ', 'ẵ', 'ặ'],
  'e': ['é', 'è', 'ẽ', 'ẹ', 'ê', 'ế', 'ề', 'ễ', 'ệ', 'ẻ'],
  'i': ['í', 'ì', 'ĩ', 'ị'],
  'o': ['ó', 'ò', 'õ', 'ọ', 'ô', 'ố', 'ồ', 'ỗ', 'ộ', 'ơ', 'ớ', 'ờ', 'ỡ', 'ợ'],
  'u': ['ú', 'ù', 'ũ', 'ụ', 'ư', 'ứ', 'ừ', 'ữ', 'ự'],
  'y': ['ý', 'ỳ', 'ỹ', 'ỵ'],
  };

 
  String newString = origin.toLowerCase();
  
  template.forEach((basic, list) {
    for(int i=0; i<newString.length; i++) {
      if (list.contains(newString[i])) {
        newString = newString.replaceAll(newString[i], basic);
      }
    }
    });
  return newString;
 }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: false,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: "Nhập công thức cần tìm",
        prefixIcon: Icon(Icons.search),
        constraints: BoxConstraints(maxHeight: 70),
        suffixIcon: IconButton(icon: Icon(Icons.close),onPressed: () {
          _controller.text = '';
          _focusNode.unfocus();
          context.read<FoodRecipesManager>().setSearchText('');
        },)
      ),
      onFieldSubmitted: (value) {
        String searchText = removeVietnameseAccent(value);
        print("Gia tri da nhap la: $searchText");
        context.read<FoodRecipesManager>().setSearchText(searchText);
      },
      onChanged: (value) {
        if (value.isEmpty) {
          context.read<FoodRecipesManager>().setSearchText('');
        }
      },
    );
  }
}