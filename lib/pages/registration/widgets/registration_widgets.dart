import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationWidgets {
  final BuildContext context;
  RegistrationWidgets({required this.context});
  AppBar buildAppBar({required String titleText}) {
    return AppBar(
      //systemOverlayStyle: SystemUiOverlayStyle.light,
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            //* height defines the thickness of the line
            height: .3,
          )),
      //backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        titleText,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 20.sp),
      ),
    );
  }

  Widget buildTextFields(
      {required String hintText,
      required String type,
      required void Function(String? value) func}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        obscureText: type == "pass" ? true : false,
        onChanged: (value) => func(value),
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.w),
          ),
          labelText: hintText,
        ),
      ),
    );
  }

  Widget buildButton(
      {required String text,
      required String type,
      required void Function() func}) {
    return type == 'confirm'
        ? FilledButton(
            onPressed: func,
            style: FilledButton.styleFrom(
              minimumSize: Size(370.w, 40.h),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        : OutlinedButton(
            onPressed: func,
            style: OutlinedButton.styleFrom(minimumSize: Size(370.w, 40.h)),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
              ),
            ),
          );
  }
}

void buildSnackBar({required String msg, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
