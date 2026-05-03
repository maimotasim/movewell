import 'package:dio/dio.dart';
import 'package:movewell/core/network/api_client.dart';

class AuthRepository {
  // ignore: unused_field
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    // TODO: Remove when API is ready and uncomment el hta ely taht (roaa aw maryam)
    await Future.delayed(const Duration(seconds: 1));
    return {'token': 'dummy_mock_token_123'};
    
    /*
    try {
      final response = await _dio.post(
        '/api/v1/auth/login', // Backend Dev to update this route
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
    */
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    // TODO: Remove when API is ready and uncomment el hta ely taht (roaa aw maryam)
    await Future.delayed(const Duration(seconds: 1));
    return {'token': 'dummy_mock_token_123'};
    
    /*
    try {
      final response = await _dio.post(
        '/api/v1/auth/register', // Backend Dev to update this route
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
    */
  }
}
