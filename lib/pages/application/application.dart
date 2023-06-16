import 'package:dbestblog/pages/application/application_widgets.dart';
import 'package:dbestblog/pages/application/bloc/application_bloc.dart';
import 'package:dbestblog/pages/application/bloc/application_events.dart';
import 'package:dbestblog/pages/application/bloc/application_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBlocs, AppStates>(
      builder: (context, state) {
        return Container(
          child: SafeArea(
              child: Scaffold(
            body: buildPage(state.index),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(),
              child: NavigationBar(
                selectedIndex: state.index,
                onDestinationSelected: (value) {
                  context.read<AppBlocs>().add(TriggerAppEvent(value));
                },
                destinations: bottovNavBarTabs,
              ),
            ),
          )),
        );
      },
    );
  }
}
