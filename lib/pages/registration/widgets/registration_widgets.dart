import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          fontFamily: 'ABeeZee',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTextFields(
      {required String hintText,
      required String type,
      required void Function(String? value) func}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        obscureText: type == "pass" ? true : false,
        onChanged: (value) => func(value),
        style: TextStyle(
          fontFamily: 'ABeeZee',
          fontWeight: FontWeight.normal,
          ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
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
        ? FilledButton(onPressed: func, child: Text(text, style: TextStyle(fontFamily: 'ABeeZee', fontWeight: FontWeight.normal,),), style:  FilledButton.styleFrom(minimumSize: Size( 370, 40),)  //////// HERE
, )
        : OutlinedButton(onPressed: func, child: Text(text, style: TextStyle(fontFamily: 'ABeeZee', fontWeight: FontWeight.normal,),), style: OutlinedButton.styleFrom(minimumSize: Size( 370, 40)));
  }
}

void buildSnackBar({required String msg, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
