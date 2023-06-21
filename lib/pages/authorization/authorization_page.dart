import 'package:dbestblog/pages/authorization/authorization_controller.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_bloc.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_events.dart';
import 'package:dbestblog/pages/authorization/bloc/authorization_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../registration/widgets/registration_widgets.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  @override
  Widget build(BuildContext context) {
    RegistrationWidgets widgets = RegistrationWidgets(context: context);
    return BlocBuilder<AuthorizationBloc, AuthorizationStates>(
        builder: (context, state) {
      return Container(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 50.h),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: EdgeInsets.only(top: 60.h),
                child: Text(
                  'DBestBlog',
                  style: TextStyle(
                    fontSize: 62.sp,
                    fontFamily: 'Kalam',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    widgets.buildTextFields(
                        hintText: 'Email',
                        type: 'input',
                        func: (value) => context
                            .read<AuthorizationBloc>()
                            .add(EmailEvent(email: value!))),
                    SizedBox(
                      height: 20.h,
                    ),
                    widgets.buildTextFields(
                        hintText: 'Password',
                        type: 'pass',
                        func: (value) => context
                            .read<AuthorizationBloc>()
                            .add(PasswordEvent(password: value!))),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.r),
                child: Column(
                  children: [
                    widgets.buildButton(
                        text: 'Login', type: 'confirm', func: auth),
                    SizedBox(
                      height: 10.h,
                    ),
                    widgets.buildButton(
                        text: 'Registration', type: '', func: gotoReg),
                  ],
                ),
              )
            ]),
          ),
        ),
      );
    });
  }

  void auth() {
    AuthorizationController(context: context).authorizationEmailPass();
  }

  void gotoReg() {
    Navigator.of(context).pushNamed("/registration");
  }
}
