class ApiEndpoints {
  static final String baseurl = 'http://10.0.2.2:3000/';
  static AuthEndpoints authEndpoints = AuthEndpoints();
}

class AuthEndpoints {
  final String signup = 'signup';
  final String login = 'login';
}
