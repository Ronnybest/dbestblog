import 'dart:io';

abstract class EditProfileEvents {
  const EditProfileEvents();
}

class ChangeAvatar extends EditProfileEvents {
  const ChangeAvatar(this.avatar);
  final File avatar;
}

class ChangeNickname extends EditProfileEvents {
  const ChangeNickname(this.nickname);
  final String nickname;
}

class ChangeBio extends EditProfileEvents {
  const ChangeBio(this.bio);
  final String bio;
}

class ResetBloc extends EditProfileEvents {
  const ResetBloc();
}
