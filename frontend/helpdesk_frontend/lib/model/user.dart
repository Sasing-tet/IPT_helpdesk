class User {
  String userId;
  String username;
  String password;
  String firstName;
  String lastName;
  String role;
  bool is_superuser;

  User(
      {required this.userId,
      required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.is_superuser,
      this.role = 'user'});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'is_superuser': is_superuser,
      };

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      username: map['username'],
      password: map['password'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      role: map['role'],
      is_superuser: map['is_superuser'],
    );
  }

  @override
  bool operator ==(covariant User other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
