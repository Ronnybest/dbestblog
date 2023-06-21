import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_events.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../registration/widgets/registration_widgets.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nicknameController;
  late TextEditingController _bioController;

  //=TextEditingController(text: editProfilePage.userProfile!.name!);
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  late EditProfileController _editProfilePage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editProfilePage = EditProfileController(context: context);
    _nicknameController =
        TextEditingController(text: _editProfilePage.userProfile!.name);
    _bioController =
        TextEditingController(text: _editProfilePage.userProfile!.bio);
    context
        .read<EditProfileBloc>()
        .add(ChangeNickname(_nicknameController.text));
    context.read<EditProfileBloc>().add(ChangeBio(_bioController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileStates>(
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          context.read<EditProfileBloc>().add(const ResetBloc());
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            //systemOverlayStyle: SystemUiOverlayStyle.light,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  //* height defines the thickness of the line
                  height: .3,
                )),
            //backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Edit profile',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 90.r,
                      foregroundImage: state.avatar != null &&
                              File(state.avatar!.absolute.path).existsSync()
                          ? FileImage(state.avatar!) as ImageProvider<Object>
                          : CachedNetworkImageProvider(
                              _editProfilePage.userProfile!.avatarLink!),
                    ),
                    Positioned(
                      bottom: 3.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () => selectImage(),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Nickname',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                buildTextField(
                  _nicknameController,
                  (value) => context.read<EditProfileBloc>().add(
                        ChangeNickname(value),
                      ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'About me',
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                buildTextField(
                  _bioController,
                  (value) => context.read<EditProfileBloc>().add(
                        ChangeBio(value),
                      ),
                ),
              ],
            ),
          ),
          floatingActionButton: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: Size(350.w, 40.h),
            ),
            onPressed: () {
              _editProfilePage.changeInfo().then((value) {
                buildSnackBar(
                    context: context,
                    msg: 'User data has changed successfully!');
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/profile_page',
                  (route) => false,
                );
              });
            },
            child: Text(
              'Save',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.normal,
                  fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, void Function(String value)? func) {
    return TextField(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.normal,
      ),
      onChanged: func,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? result =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (result != null) {
        File tempFile = File(result.path);
        context.read<EditProfileBloc>().add(ChangeAvatar(tempFile));
      } else {}
    } catch (error) {
      print('Ошибка при выборе файла: $error');
    }
  }
}
