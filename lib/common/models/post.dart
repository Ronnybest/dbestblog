class PostObj {
  late String? author_id;
  late String? author_name;
  late String? image_link;
  late String? description;

  PostObj(
      {this.author_id, this.image_link, this.description, this.author_name});

  PostObj.fromMap(Map<String, dynamic> map) {
    this.author_id = map['author_id'];
    this.image_link = map['image_link'];
    this.description = map['description'];
    this.author_name = map['author_name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'author_id': this.author_id,
      'image_link': this.image_link,
      'description': this.description,
      'author_name': this.author_name,
    };
  }
}
