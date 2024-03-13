class ApiEndpoints {
  static final String baseurl = 'http://127.0.0.1:3000/';
  static AuthEndpoints authEndpoints = AuthEndpoints();
}

class AuthEndpoints {
  final String signup = 'signup';
  final String login = 'login';
}
