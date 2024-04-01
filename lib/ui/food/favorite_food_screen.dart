
import 'package:flutter/material.dart';

class FavoriteFoddScreen extends StatelessWidget {
  const FavoriteFoddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công thức nấu ăn yêu thích'),
      ),
      body: Center(
        child: const Text('Danh sach công thức nấu ăn yêu thích'),
      ),
    );
  }
}