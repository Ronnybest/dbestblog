import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/common/routes/routes.dart';
import 'package:dbestblog/pages/profile/bloc/profile_bloc.dart';
import 'package:dbestblog/pages/profile/bloc/profile_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/values/constants.dart';
import '../../../global.dart';

void removeUserData(BuildContext context) {
  Global.storageServices.removeFromKey(AppConstants().USER_INFO);
  context.read<ProfileBloc>().add(ResetProfile());
  Navigator.of(context).pushNamedAndRemoveUntil(
      AppPageNames.AUTHORIZATION_PAGE, (route) => false);
}

Widget buildAvatar(BuildContext context, String img) {
  return CircleAvatar(
    radius: 90.r,
    backgroundImage: CachedNetworkImageProvider(img, scale: 0.5),
    backgroundColor: Colors.transparent,
  );
}

Widget buildText(
    String text, String fontFamily, double fontSize, FontWeight fontWeight) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

Widget buildPostCard(PostObj post) {
  return CachedNetworkImage(
    imageUrl: post.image_link!,
    fit: BoxFit.cover,
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
