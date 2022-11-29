class User {
  final String username;
  final String email;
  final String password;

  User({
    required this.username,
    required this.password,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}