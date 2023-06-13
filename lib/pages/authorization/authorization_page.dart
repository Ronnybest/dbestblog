import 'package:dbestblog/pages/registration/registration_page.dart';
import 'package:flutter/material.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              OutlinedButton(
                child: Text('Login'),
                onPressed: () {
                  // Добавьте обработчик нажатия кнопки регистрации
                },
              ),
              OutlinedButton(
                child: Text('Registration'),
                onPressed: () {
                //Navigator.pushNamed(context, 'pages/registration/registration_page');     
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationPage(),));           
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
