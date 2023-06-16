import 'package:dbestblog/pages/home/bloc/home_states.dart';
import 'package:dbestblog/pages/home/home_controller.dart';
import 'package:dbestblog/pages/home/widgets/home_page_widgets.dart';
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
  late HomeController _homeController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeController = HomeController(context: context);
    _homeController.init();
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
              fontSize: 28,
              fontFamily: 'Kalam',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeStates>(
          builder: (context, state) => Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          padding: EdgeInsets.all(
                              4), // Добавляем отступы по 2 пикселя с каждой стороны
                          child: postGrid(state.posts[index]),
                        ),
                      );
                    },
                    childCount: state.posts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
