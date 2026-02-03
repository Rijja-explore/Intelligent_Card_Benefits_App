class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
  static const String genaiEndpoint = '/genai';

  static String get genaiUrl => '$baseUrl$genaiEndpoint';

  // For production, you can change this to your deployed backend URL
  // static const String baseUrl = 'https://your-production-url.com';
}

class ApiResponse {
  final bool success;
  final String? data;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(String data) {
    return ApiResponse(
      success: true,
      data: data,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
}
