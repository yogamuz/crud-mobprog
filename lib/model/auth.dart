class Auth {
  final String id;
  final String username;
  final String password;

  Auth({required this.id, required this.username, required this.password});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
