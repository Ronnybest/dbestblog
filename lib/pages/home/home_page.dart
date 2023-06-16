import 'package:dbestblog/pages/home/bloc/home_states.dart';
import 'package:dbestblog/pages/home/home_controller.dart';
import 'package:dbestblog/pages/home/widgets/home_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../registration/widgets/registration_widgets.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(context: context);
    _homeController.init();
  }

  Future<void> _refreshPage() async {
    _homeController.init(); // Перезагрузка страницы
  }

  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'DBestBlog',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Kalam',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeStates>(
          builder: (context, state) => RefreshIndicator(
            onRefresh: _refreshPage,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            padding: EdgeInsets.all(4),
                            child: postGrid(state.posts[index]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
