import 'package:flutter/material.dart';
import 'package:pagination_app/core/tools/get_it_locator.dart';
import 'package:pagination_app/view/main_page.dart';

void main() {
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}
