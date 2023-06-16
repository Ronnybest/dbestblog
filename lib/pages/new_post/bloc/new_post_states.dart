import 'dart:io';

class NewPostStates {
  const NewPostStates({this.image, this.description = ''});
  final File? image;
  final String description;

  NewPostStates copyWith({File? image, String? description}) {
    return NewPostStates(
        image: image ?? this.image,
        description: description ?? this.description);
  }

  NewPostStates deleteImage({String? description}) {
    return NewPostStates(
      image: null,
      description: description ?? this.description,
    );
  }
}
