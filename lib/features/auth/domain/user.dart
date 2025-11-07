class User {
  final String firstName;
  final String lastName;
  final String token;
  final String emaill;

  const User({
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.emaill,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      token: json['token'],
      emaill: json['email'],
    );
  }
}
