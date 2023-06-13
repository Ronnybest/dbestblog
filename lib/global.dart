import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Global {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    print('all good');
  }
}
