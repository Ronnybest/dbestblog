import 'package:dbestblog/pages/home/bloc/home_states.dart';
import 'package:dbestblog/pages/home/home_controller.dart';
import 'package:dbestblog/pages/home/widgets/home_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/models/post.dart';
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
          title: const Text(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Задаем количество столбцов
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio:
                      1, // Отношение ширины к высоте каждого элемента
                ),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: postGrid(item: state.posts[index], context: context),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
