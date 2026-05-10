class AuthRepository {

  Future<Map<String, dynamic>> login(String email, String password) async {
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
