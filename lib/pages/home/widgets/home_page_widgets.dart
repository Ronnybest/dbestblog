import 'dart:ui';
import 'package:dbestblog/common/models/post.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_bloc.dart';
import 'package:dbestblog/pages/another_user_profile/bloc/another_user_profile_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget postGrid({required PostObj item, required BuildContext context}) {
  return IntrinsicHeight(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: EdgeInsets.fromLTRB(
          10.w, 10.h, 10.w, 0.h), // Добавление отступа 20px снизу
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<AnotherUserProfileBloc>()
                  .add(LoadProfileAndPosts(null, null, item.author_id!));
              Navigator.of(context).pushNamed('/another_user_profile');
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.w,
                  foregroundImage: NetworkImage(item.auhtor_avatar!),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 8.w),
                Text(
                  item.author_name!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          if (item.image_link != '')
            SizedBox(
              height: 200.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0.w),
                child: TransitionToImage(
                  image: AdvancedNetworkImage(
                    item.image_link!,
                    timeoutDuration: const Duration(seconds: 30),
                    retryLimit: 1,
                  ),
                  fit: BoxFit.cover,
                  placeholder: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                    child: const Icon(Icons.refresh),
                  ),
                  imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  width: double.infinity,
                  height: double.infinity,
                  enableRefresh: true,
                  loadingWidgetBuilder: (
                    context,
                    progress,
                    imageData,
                  ) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: progress == 0.0 ? null : progress,
                      ),
                    );
                  },
                ),
              ),
            ),
          SizedBox(height: 10.h),
          Text(
            item.description!,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    ),
  );
}
