class UserObj {
  late String? id;
  late String? name;
  late String? email;
  late String? avatarLink;
  late String? bio;

  UserObj({this.name, this.email, this.avatarLink, this.bio, this.id});

  UserObj.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.email = map['email'];
    this.avatarLink = map['avatarLink'];
    this.bio = map['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'avatarLink': this.avatarLink,
      'bio': this.bio,
    };
  }
}
