import 'package:flutter/foundation.dart';

class PopupState extends ChangeNotifier{
  late ValueNotifier<bool> _order = ValueNotifier<bool>(false);
  
  ValueNotifier<bool> get order => _order;

  void changeStage() {
    order.value = !order.value;
  }
}