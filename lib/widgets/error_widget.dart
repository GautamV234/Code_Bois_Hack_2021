import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Object? errorMessage;

  const CustomErrorWidget({Key? key, this.errorMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Something Went Wrong, Please Try Again Later'),
          if (errorMessage != null) SizedBox(height: 12),
          if (errorMessage != null) Text(errorMessage.toString()),
        ],
      ),
    );
  }
}
