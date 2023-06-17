import 'dart:io';
import 'dart:ui';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_events.dart';
import 'package:dbestblog/pages/profile/edit_profile/bloc/edit_profile_states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/application', (route) => false);
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                        maxRadius: 85,
                        minRadius: 85,
                        child: ClipOval(
                          //clipBehavior: Clip.antiAlias,
                          child: state.avatar == null
                              ? TransitionToImage(
                                  image: AdvancedNetworkImage(
                                    _editProfilePage.userProfile!.avatarLink!,
                                    timeoutDuration:
                                        const Duration(seconds: 30),
                                    retryLimit: 1,
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: Container(
                                    color: Colors.transparent,
                                    child: const Icon(Icons.refresh),
                                  ),
                                  imageFilter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  enableRefresh: true,
                                  loadingWidgetBuilder: (
                                    context,
                                    progress,
                                    imageData,
                                  ) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        value:
                                            progress == 0.0 ? null : progress,
                                      ),
                                    );
                                  },
                                )
                              : Image(
                                  width: double.infinity,
                                  height: double.infinity,
                                  image: FileImage(state.avatar!),
                                  fit: BoxFit.fitWidth,
                                ),
                        )),
                    Positioned(
                      bottom: 5,
                      right: 15,
                      child: GestureDetector(
                        onTap: () => selectImage(),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                buildTextField(
                  _nicknameController,
                  (value) => context.read<EditProfileBloc>().add(
                        ChangeNickname(value),
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () => _editProfilePage.changeInfo().then(
                  (value) => buildSnackBar(
                      context: context, msg: 'User data changed successfully!'),
                ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, void Function(String value)? func) {
    return TextField(
      onChanged: func,
      controller: controller,
      decoration: InputDecoration(),
    );
  }

  Future<void> selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        File tempFile = File(file.path!);
        context.read<EditProfileBloc>().add(ChangeAvatar(tempFile));
      } else {}
    } catch (error) {
      print('Ошибка при выборе файла: $error');
    }
  }
}
