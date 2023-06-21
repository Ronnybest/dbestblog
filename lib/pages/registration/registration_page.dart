import 'package:dbestblog/pages/registration/bloc/registration_bloc.dart';
import 'package:dbestblog/pages/registration/bloc/registration_events.dart';
import 'package:dbestblog/pages/registration/bloc/registration_states.dart';
import 'package:dbestblog/pages/registration/registration_controller.dart';
import 'package:dbestblog/pages/registration/widgets/registration_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return BlocBuilder<RegistrationBloc, RegistrationStates>(
        builder: (context, state) {
      return Scaffold(
        appBar: widgets.buildAppBar(titleText: 'Registration'),
        body: Container(
          margin: EdgeInsets.only(top: 50.h),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                widgets.buildTextFields(
                    hintText: 'Nickname',
                    type: 'input',
                    func: (value) => context
                        .read<RegistrationBloc>()
                        .add(UserNameEvent(username: value!))),
                SizedBox(
                  height: 20.h,
                ),
                widgets.buildTextFields(
                    hintText: 'Email',
                    type: 'input',
                    func: (value) => context
                        .read<RegistrationBloc>()
                        .add(EmailEvent(email: value!))),
                SizedBox(
                  height: 20.h,
                ),
                widgets.buildTextFields(
                    hintText: 'Password',
                    type: 'pass',
                    func: (value) => context
                        .read<RegistrationBloc>()
                        .add(PasswordEvent(password: value!))),
                SizedBox(
                  height: 20.h,
                ),
                widgets.buildTextFields(
                    hintText: 'Confirm password',
                    type: 'pass',
                    func: (value) => context
                        .read<RegistrationBloc>()
                        .add(RePasswordEvent(rePassword: value!))),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
              child: widgets.buildButton(
                  text: 'Registration', type: 'confirm', func: register),
            )
          ]),
        ),
      );
    });
  }

  void register() {
    RegistrationController(context).registerWithEmail();
  }
}
