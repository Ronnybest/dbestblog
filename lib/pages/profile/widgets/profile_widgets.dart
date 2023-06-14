import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

Widget buildCard(BuildContext context, String img) {
  return Container(
    height: 646,
    width: 500,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer),
    child: Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(children: [
        Container(
          width: 180,
          height: 180,
          child: CircleAvatar(
            minRadius: 10,
            maxRadius: 200,
            foregroundImage: FileImage(decodeBase64ToFile(img)),
            backgroundColor: Colors.red,
          ),
        ),
      ]),
    ),
  );
}

File decodeBase64ToFile(String img) {
  // Декодируем строку Base64 в байты
  List<int> bytes = base64Decode(img);

  // Создаем временный файл и записываем в него данные
  File decodedFile = File('${Directory.systemTemp.path}/decoded_image.jpg');
  decodedFile.writeAsBytesSync(bytes);

  return decodedFile;
}
