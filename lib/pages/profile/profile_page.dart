import 'package:dbestblog/pages/profile/profie_controller.dart';
import 'package:dbestblog/pages/profile/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';

import '../registration/widgets/registration_widgets.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController profileController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController = ProfileController();
  }

  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
  itemBuilder: (context) => [
    PopupMenuItem<String>(
      value: 'Settings',
      child: Text('Settings'),
    ),
    PopupMenuItem<String>(
      value: 'Logout',
      child: Text('Log out'),
    ),
  ],
  onSelected: (value) {
    switch(value){
      case 'Logout':
            removeUserData(context);       
      case 'Settings':
            print(Text('Settings'));
    }
}
          )
        ],
        centerTitle: true,
        title: Text('Profile',
         style: TextStyle(
          fontWeight: FontWeight.bold,
),
),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
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
                          child: buildAvatar(
                              context, profileController.UserObj!.avatarLink!),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        //name
                        Container(
                          //color: Colors.greenAccent,
                          child: buildText(profileController.UserObj!.name!,
                              'ABeeZee', 20, FontWeight.normal),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        //email
                        Container(
                          //color: Colors.blueAccent,
                          child: buildText(profileController.UserObj!.email!,
                              'ABeeZee', 12, FontWeight.normal),
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        //bio
                        Container(
                          height: 320,
                          //color: Colors.yellowAccent,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: buildText(profileController.UserObj!.bio!,
                                'ABeeZee', 16, FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        //log out button
                      ]),
                ),
              ),
            ],
          )),
    ));
  }
}
