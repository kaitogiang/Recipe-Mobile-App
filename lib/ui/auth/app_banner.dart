import 'dart:math';

import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          SizedBox(
            width: 200,
            child: Text(
                'Chào mừng',
                style: TextStyle(
                  color: Theme.of(context).indicatorColor,
                  fontSize: 35,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.bold,
                ),
            ),
          ),
          SizedBox(
            width: 300,
            child: Text(
                'Hãy đăng nhập vào và tận hưởng ứng dụng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.normal,
                ),
            ),
          ),
          SizedBox(height: 15,)
        ],
      ),
    );
  }
}
