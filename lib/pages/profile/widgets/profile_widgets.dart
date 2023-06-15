import 'package:dbestblog/common/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../common/values/constants.dart';
import '../../../global.dart';

void removeUserData(BuildContext context) {
  Global.storageServices.removeFromKey(AppConstants().USER_INFO);
  Navigator.of(context).pushNamedAndRemoveUntil(
      AppPageNames.AUTHORIZATION_PAGE, (route) => false);
}

Widget buildAvatar(BuildContext context, String img) {
  return CircleAvatar(
    minRadius: 10,
    maxRadius: 200,
    foregroundImage: NetworkImage(img),
    backgroundColor: Colors.transparent,
  );
}

Widget buildText(
    String text, String fontFamily, double fontSize, FontWeight fontWeight) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
