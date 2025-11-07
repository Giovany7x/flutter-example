import 'dart:io';

import 'package:easy_travel/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_travel/features/auth/domain/user.dart';

class AuthService {

  Future<User> login(String email, String password) async {
    final Uri uri = Uri.parse(
      ApiConstants.baseUrl,
    ).replace(path: ApiConstants.loginEndpoint);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    }

    return Future.error('Failed to login: email: $email password: $password');
  }
}
