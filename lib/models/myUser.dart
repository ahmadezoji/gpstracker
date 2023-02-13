import 'dart:convert';

class myUser {
  final String fullname;
  final String email;
  final String phone;
  final String birthday;
  final String pictureUrl;

  const myUser(
      {required this.fullname,
      required this.email,
      required this.phone,
      required this.birthday,
      required this.pictureUrl});

  factory myUser.fromJson(Map<String, dynamic> jsonData) {
    return myUser(
      fullname: jsonData['fullname'],
      email: jsonData['email'],
      phone: jsonData['phone'],
      birthday: jsonData["birthday"],
      pictureUrl: jsonData["pictureUrl"],
    );
  }

  @override
  String toString() {
    return 'name = $fullname,phone=$phone';
  }

  static Map<String, dynamic> toMap(myUser user) => {
        'fullname': user.fullname,
        'email': user.email,
        'phone': user.phone,
        'birthday': user.birthday,
        'pictureUrl': user.pictureUrl
      };

  static String encode(List<myUser> users) => json.encode(
        users.map<Map<String, dynamic>>((users) => myUser.toMap(users)).toList(),
      );

  static List<myUser> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<myUser>((item) => myUser.fromJson(item))
          .toList();
}
