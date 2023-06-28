import 'package:dbestblog/common/routes/names.dart';
import 'package:dbestblog/common/values/constants.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/application/application.dart';
import 'package:dbestblog/pages/application/bloc/application_bloc.dart';
import 'package:dbestblog/pages/authorization/authorization_page.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_bloc.dart';
import 'package:dbestblog/pages/chat/bloc/chats_bloc.dart';
import 'package:dbestblog/pages/chat/chats_page.dart';
import 'package:dbestblog/pages/chat/current_chat/bloc/current_chat_bloc.dart';
import 'package:dbestblog/pages/home/bloc/home_bloc.dart';
import 'package:dbestblog/pages/home/home_page.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_bloc.dart';
import 'package:dbestblog/pages/home/view_post/view_post_page.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_bloc.dart';
import 'package:dbestblog/pages/new_post/new_post_page.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:dbestblog/pages/profile/edit_profile/edit_profile_page.dart';
import 'package:dbestblog/pages/profile/profile_page.dart';
import 'package:dbestblog/pages/registration/bloc/registration_bloc.dart';
import 'package:dbestblog/pages/registration/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages/another_user_profile/another_user_profile.dart';
import '../../pages/another_user_profile/bloc/another_user_profile_bloc.dart';
import '../../pages/chat/current_chat/current_chat_page.dart';

class AppPagesComplect {
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppPageNames.AUTHORIZATION_PAGE,
        page: const AuthorizationPage(),
        bloc: BlocProvider(create: (_) => AuthorizationBloc()),
      ),
      PageEntity(
        route: AppPageNames.REGISTRATION_PAGE,
        page: const RegistrationPage(),
        bloc: BlocProvider(create: (_) => RegistrationBloc()),
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
      PageEntity(
        route: AppPageNames.NEW_POST,
        page: const NewPostPage(),
        bloc: BlocProvider(create: (_) => NewPostBloc()),
      ),
      PageEntity(
        route: AppPageNames.PROFILE,
        page: const ProfilePage(),
        bloc: BlocProvider(create: (_) => ProfileBloc()),
      ),
      PageEntity(
        route: AppPageNames.EDIT_PROFILE,
        page: const EditProfilePage(),
        bloc: BlocProvider(create: (_) => EditProfileBloc()),
      ),
      PageEntity(
        route: AppPageNames.ANOTHER_USER_PROFILE,
        page: const AnotherUserProfilePage(),
        bloc: BlocProvider(create: (_) => AnotherUserProfileBloc()),
      ),
      PageEntity(
        route: AppPageNames.VIEW_POST,
        page: const ViewPostPage(),
        bloc: BlocProvider(create: (_) => ViewPostBloc()),
      ),
      PageEntity(
        route: AppPageNames.ALL_CHATS,
        page: const AllChatsPage(),
        bloc: BlocProvider(create: (_) => ChatsBloc()),
      ),
      PageEntity(
        route: AppPageNames.CURRENT_CHAT,
        page: const ChattingPage(),
        bloc: BlocProvider(create: (_) => CurrentChatBloc()),
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
    if (Global.storageServices
        .getStringFromKey(AppConstants().USER_INFO)
        .isNotEmpty) {
      return MaterialPageRoute(
          builder: (_) => const ApplicationPage(), settings: settings);
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
