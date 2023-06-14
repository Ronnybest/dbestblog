import 'package:flutter/material.dart';

import '../registration/widgets/registration_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return Container(
      child: Scaffold(
        appBar: widgets.buildAppBar(titleText: 'Main page'),
        body: Container(
          child: Text('Test'),
        ),
      ),
    );
  }
}
