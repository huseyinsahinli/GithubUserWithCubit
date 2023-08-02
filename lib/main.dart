import 'package:flutter/material.dart';

import 'products/user/view/user_view.dart';

void main() => runApp(
      const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Github User',
      debugShowCheckedModeBanner: false,
      home: UserView(),
    );
  }
}
