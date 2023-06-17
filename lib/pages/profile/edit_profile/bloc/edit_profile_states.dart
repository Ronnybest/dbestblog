import 'dart:io';

class EditProfileStates {
  final File? avatar;
  final String? nickname;
  final String? bio;
  const EditProfileStates({this.avatar, this.nickname, this.bio});

  EditProfileStates copyWith({File? avatar, String? nickname, String? bio}) {
    return EditProfileStates(
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      bio: bio ?? this.bio,
    );
  }

  EditProfileStates reset({File? avatar, String? nickname, String? bio}) {
    return EditProfileStates(
      avatar: avatar,
      nickname: nickname,
      bio: bio,
    );
  }
}
