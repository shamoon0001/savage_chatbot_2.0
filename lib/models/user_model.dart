// lib/models/user_model.dart

class User {
  final int id;
  final String username;
  final String? email; // Email might be optional

  User({
    required this.id,
    required this.username,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? json['id'], // Accommodate different key names from backend
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
