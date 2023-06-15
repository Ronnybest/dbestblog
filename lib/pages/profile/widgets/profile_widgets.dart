import 'package:dbestblog/common/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../common/values/constants.dart';
import '../../../global.dart';

void removeUserData(BuildContext context) {
  Global.storageServices.removeFromKey(AppConstants().USER_INFO);
  Navigator.of(context).pushNamedAndRemoveUntil(
      AppPageNames.AUTHORIZATION_PAGE, (route) => false);
}

Widget buildCard(BuildContext context, String img) {
  return Container(
    height: 645,
    width: 500,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer),
    child: Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(children: [
        Container(
          width: 180,
          height: 180,
          child: CircleAvatar(
            minRadius: 10,
            maxRadius: 200,
            foregroundImage: NetworkImage(img),
            backgroundColor: Colors.transparent,
          ),
        ),
        GestureDetector(
          onTap: () => removeUserData(context),
          child: Container(
            decoration: BoxDecoration(color: Colors.amber),
            child: Text('LogOut'),
          ),
        ),
      ]),
    ),
  );
}
