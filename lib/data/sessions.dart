// Session model

class Session {
  int id = 0;
  String date = '';
  String name = '';
  String email = '';
  String password = '';
  String jwtToken = '';

  Session(
      this.id, this.date, this.name, this.email, this.password, this.jwtToken);

  Session.fromJson(Map<String, dynamic> sessionMap) {
    id = sessionMap['id'] ?? 0;
    date = sessionMap['date'] ?? '';
    name = sessionMap['name'] ?? '';
    email = sessionMap['email'] ?? '';
    password = sessionMap['password'] ?? '';
    jwtToken = sessionMap['jwtToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'name': name,
      'email': email,
      'password': password,
      'jwtToken': jwtToken,
    };
  }
}
