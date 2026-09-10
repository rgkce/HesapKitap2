import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Emülatörler için 10.0.2.2, normal cihazlar/web/simülatör için localhost
  static String baseUrl = 'http://localhost:3000'; 
  
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Backend ile JWT token doğrulaması/giriş işlemi yapma metodu
  Future<bool> attemptBackendLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['accessToken'];
        return true;
      }
    } catch (e) {
      // Backend kapalıysa veya hata oluştuysa sessizce logla ve false dön
      print('Backend login attempt failed: $e');
    }
    return false;
  }

  // 1. /reports/requests-summary
  Future<Map<String, dynamic>?> fetchRequestSummary() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reports/requests-summary'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Failed to fetch request summary: $e');
    }
    return null;
  }

  // 2. /reports/monthly-spending
  Future<List<dynamic>?> fetchMonthlySpending() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reports/monthly-spending'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
    } catch (e) {
      print('Failed to fetch monthly spending: $e');
    }
    return null;
  }

  // 3. /reports/supplier-performance
  Future<List<dynamic>?> fetchSupplierPerformance() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reports/supplier-performance'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
    } catch (e) {
      print('Failed to fetch supplier performance: $e');
    }
    return null;
  }

  // 4. /reports/approval-duration
  Future<Map<String, dynamic>?> fetchApprovalDuration() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reports/approval-duration'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Failed to fetch approval duration: $e');
    }
    return null;
  }
}
