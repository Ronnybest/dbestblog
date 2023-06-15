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
      appBar: widgets.buildAppBar(titleText: 'Profile'),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              buildCard(context, profileController.UserObj!.avatarLink!),
            ],
          )),
    ));
  }
}
