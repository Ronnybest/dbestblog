import 'package:dbestblog/common/routes/names.dart';
import 'package:dbestblog/pages/application/application.dart';
import 'package:dbestblog/pages/application/bloc/application_bloc.dart';
import 'package:dbestblog/pages/authorization/authorization_page.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_bloc.dart';
import 'package:dbestblog/pages/home/bloc/home_bloc.dart';
import 'package:dbestblog/pages/home/home_page.dart';
import 'package:dbestblog/pages/registration/bloc/registration_bloc.dart';
import 'package:dbestblog/pages/registration/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPagesComplect {
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppPageNames.REGISTRATION_PAGE,
        page: const RegistrationPage(),
        bloc: BlocProvider(create: (_) => RegistrationBloc()),
      ),
      PageEntity(
        route: AppPageNames.REGISTRATION_PAGE,
        page: const AuthorizationPage(),
        bloc: BlocProvider(create: (_) => AuthorizationBloc()),
      ),
      PageEntity(
        route: AppPageNames.HOME_PAGE,
        page: const HomePage(),
        bloc: BlocProvider(create: (_) => HomeBloc()),
      ),
      PageEntity(
        route: AppPageNames.APPLICATION,
        page: const ApplicationPage(),
        bloc: BlocProvider(create: (_) => AppBlocs()),
      ),
    ];
  }

  static List<dynamic> allBlocsProvider(BuildContext context) {
    List<dynamic> appBlocs = [];
    for (var bloc in routes()) {
      appBlocs.add(bloc.bloc);
    }
    return appBlocs;
  }

  static MaterialPageRoute generateRoutes(RouteSettings settings) {
    if (settings.name != null) {
      var result = routes().where((element) => element.route == settings.name);
      if (result.isNotEmpty) {
        return MaterialPageRoute(
            builder: (_) => result.first.page, settings: settings);
      }
    }
    return MaterialPageRoute(
        builder: (_) => const AuthorizationPage(), settings: settings);
  }
}

class PageEntity {
  String route;
  Widget page;
  dynamic bloc;

  PageEntity({required this.route, required this.page, this.bloc});
}
