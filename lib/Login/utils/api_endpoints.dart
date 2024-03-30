class ApiEndpoints {
  static const String baseurl = 'http://10.0.2.2:3000/';
  static AuthEndpoints authEndpoints = AuthEndpoints();
}

class AuthEndpoints {
  final String signup = 'signup';
  final String login = 'login';
  final String branch = 'v1/api/branch/add-branch';
  final String getbranch = 'v1/api/branch/get-users-branch';
  final String adduser = 'v1/api/branch/add-user';
}
