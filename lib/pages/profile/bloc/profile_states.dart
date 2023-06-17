import 'package:dbestblog/common/models/user.dart';

class ProfileStates {
  final UserObj? userObj;
  const ProfileStates({this.userObj});

  ProfileStates copyWith({UserObj? newObj}) {
    return ProfileStates(
      userObj: newObj ?? this.userObj,
    );
  }

  ProfileStates reset({UserObj? userObj}) {
    return const ProfileStates(
      userObj: null,
    );
  }
}
