class UserModel {
  String? email;
  String? wrole;
  String? uid;

// receiving data
  UserModel({this.uid, this.email, this.wrole});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      wrole: map['wrole'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'wrole': wrole,
    };
  }
}
