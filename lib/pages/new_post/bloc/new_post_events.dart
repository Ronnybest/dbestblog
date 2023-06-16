import 'dart:io';

abstract class NewPostEvents {
  const NewPostEvents();
}

class ImageNewPost extends NewPostEvents {
  const ImageNewPost(this.image);
  final File image;
}

class DescriptionNewPost extends NewPostEvents {
  const DescriptionNewPost(this.description);
  final String description;
}
