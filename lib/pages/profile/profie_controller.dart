import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/global.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileController {
  ProfileController({required this.context});
  final BuildContext context;

  UserObj init() {
    UserObj userObj = UserObj();
    final state = context.read<ProfileBloc>().state;
    if (state.userObj != null) {
      userObj.id = state.userObj!.id;
      userObj.name = state.userObj!.name;
      userObj.email = state.userObj!.email;
      userObj.avatarLink = state.userObj!.avatarLink;
      userObj.bio = state.userObj!.bio;
    } else {
      userObj = Global.storageServices.getUserProfile()!;
    }
    return userObj;
  }
}
