import 'package:dbestblog/pages/home/bloc/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../registration/widgets/registration_widgets.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return BlocBuilder<HomeBloc, HomeStates>(
      builder: (context, state) {
        return Container(
          child: Scaffold(
            appBar: widgets.buildAppBar(titleText: 'Main page'),
            body: Container(
              margin: EdgeInsets.only(top: 50),
              child: Text('Test'),
            ),
          ),
        );
      },
    );
  }
}
