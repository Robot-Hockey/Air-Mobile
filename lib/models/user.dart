class User {
  String name;
  String email;
  String password;
  String authToken;
  String companyId;

  User({this.authToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      authToken: json['auth_token']
    );
  }
}