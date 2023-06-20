import 'package:dbestblog/common/models/user.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:dbestblog/pages/profile/bloc/profile_states.dart';
import 'package:dbestblog/pages/profile/profie_controller.dart';
import 'package:dbestblog/pages/profile/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserObj userObj;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userObj = ProfileController(context: context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileStates>(
      builder: (context, state) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                  itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'Edit profile',
                          child: Text('Edit profile',style:  TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
                ),
                ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Logout',
                          child: Text('Log out',style:  TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
                ),),
                        ),
                      ],
                  onSelected: (value) {
                    switch (value) {
                      case 'Logout':
                        removeUserData(context);
                      case 'Edit profile':
                        Navigator.of(context).pushNamed('/edit_profile');
                    }
                  })
            ],
            centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 645,
                  width: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondaryContainer),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //color: Colors.red,
                          width: 180,
                          height: 180,
                          child: buildAvatar(context, userObj.avatarLink!),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        //name
                        Container(
                          //color: Colors.greenAccent,
                          child: buildText(
                              userObj.name!, 'Nunito', 20, FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        //email
                        Container(
                          //color: Colors.blueAccent,
                          child: buildText(
                              userObj.email!, 'Nunito', 12, FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        //bio
                        Container(
                          height: 320,
                          //color: Colors.yellowAccent,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: buildText(
                                userObj.bio!, 'Nunito', 16, FontWeight.normal),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        //log out button
                      ],
                    ),
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
