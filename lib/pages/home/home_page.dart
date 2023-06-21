import 'package:dbestblog/pages/home/bloc/home_states.dart';
import 'package:dbestblog/pages/home/home_controller.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_bloc.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_events.dart';
import 'package:dbestblog/pages/home/widgets/home_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'DBestBlog',
            style: TextStyle(
              fontSize: 32.sp,
              fontFamily: 'Kalam',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeStates>(
          builder: (context, state) => RefreshIndicator(
            onRefresh: _refreshPage,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Задаем количество столбцов
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio:
                      1.1.h, // Отношение ширины к высоте каждого элемента
                ),
                itemCount: state.posts!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context
                          .read<ViewPostBloc>()
                          .add(LoadComments(postObj: state.posts![index]));
                      Navigator.of(context).pushNamed('/view_post');
                    },
                    child:
                        postGrid(item: state.posts![index], context: context),
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
