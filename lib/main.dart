import 'package:dbestblog/pages/authorization/authorization_page.dart';
import 'package:dbestblog/pages/registration/registration_page.dart';
import 'package:flutter/material.dart';

import 'global.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthorizationPage(),
    );
  }
}
