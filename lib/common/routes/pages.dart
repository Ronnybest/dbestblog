import 'package:dbestblog/common/routes/names.dart';
import 'package:dbestblog/pages/registration/bloc/registration_bloc.dart';
import 'package:dbestblog/pages/registration/registration_page.dart';
import 'package:flutter/material.dart';

class AppPagesComplect {
  static List<PageEntity> Routes() {
    return [
      PageEntity(
        route: AppPageNames.REGISTRATION_PAGE,
        page: RegistrationPage(),
        bloc: RegistrationBloc,
      ),
    ];
  }
}

class PageEntity {
  String route;
  Widget page;
  dynamic bloc;

  PageEntity({required this.route, required this.page, this.bloc});
}
