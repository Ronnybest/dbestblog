import 'package:flutter/material.dart';

class RegistrationWidgets {
  final BuildContext context;
  RegistrationWidgets({required this.context});
  AppBar buildAppBar({required String titleText}) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        titleText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
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
        ? FilledButton(onPressed: func, child: Text(text))
        : OutlinedButton(onPressed: func, child: Text(text));
  }
}

void buildSnackBar({required String msg, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
