import 'package:dbestblog/common/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Global {
  static late StorageService storageServices;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    //print('all good');
    storageServices = await StorageService().init();
  }
}
