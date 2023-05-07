class UserModel {
  String? email;
  String? wrole;
  String? uid;
  String? name;
  String? image;

// receiving data
  UserModel({
    this.uid,
    this.email,
    this.wrole,
    this.name,
    this.image,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      wrole: map['wrole'],
      name: map['name'],
      image: map['image'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'wrole': wrole,
      'name': name,
      'image': image,
    };
  }
}
