import 'dart:convert';

class User {
  final String fullname;
  final String email;
  final String phone;
  final String birthday;
  final String pictureUrl;

  const User(
      {required this.fullname,
      required this.email,
      required this.phone,
      required this.birthday,
      required this.pictureUrl});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
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

  static Map<String, dynamic> toMap(User user) => {
        'fullname': user.fullname,
        'email': user.email,
        'phone': user.phone,
        'birthday': user.birthday,
        'pictureUrl': user.pictureUrl
      };

  static String encode(List<User> users) => json.encode(
        users.map<Map<String, dynamic>>((users) => User.toMap(users)).toList(),
      );

  static List<User> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<User>((item) => User.fromJson(item))
          .toList();
}
