class UserColumns {
  // Heleper Attributes for inserting column names
  static const String username = 'usernameColumn';
  static const String email = 'emailColumn';
  static const String password = 'passwordColumn';
  static final List<String> allUserColumns = [username, email, password];
}

class User {
  static const String userTable = 'users';
  // This will be our database columns
  final String userName;
  final String userEmail;
  final String userPassword;

  User({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  });

  // Convert our data model to a map
  // that is suitable for sfqlite
  Map<String, dynamic> toMap() {
    return {
      UserColumns.username: userName,
      UserColumns.email: userEmail,
      UserColumns.password: userPassword,
    };
  }

  // Returns a user model
  static User getUser(Map<String, dynamic> map) => User(
        userName: map[UserColumns.username] as String,
        userEmail: map[UserColumns.email] as String,
        userPassword: map[UserColumns.password] as String,
      );
}
