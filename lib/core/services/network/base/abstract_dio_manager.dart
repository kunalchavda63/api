import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse<T>(data: data, success: true);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(message: message, success: false);
  }
}

class HttpMethod {
  static final HttpMethod _instance = HttpMethod._internal();

  factory HttpMethod() => _instance;

  HttpMethod._internal();

  final String baseUrl = 'https://jsonplaceholder.typicode.com/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<ApiResponse<T>> get<T>(
      String endpoint,
      T Function(dynamic json) fromJson,
      ) async {
    try {
      final response = await _dio.get(endpoint);
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        return ApiResponse.success(fromJson(response.data));
      } else {
        return ApiResponse.error('GET failed: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('GET exception: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
      String endpoint,
      dynamic body,
      T Function(dynamic json) fromJson,
      ) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(fromJson(response.data));
      } else {
        return ApiResponse.error('POST failed: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('POST exception: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
      String endpoint,
      dynamic body,
      T Function(dynamic json) fromJson,
      ) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      if (response.statusCode == 200) {
        return ApiResponse.success(fromJson(response.data));
      } else {
        return ApiResponse.error('PUT failed: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('PUT exception: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
      String endpoint,
      T Function(dynamic json) fromJson,
      ) async {
    try {
      final response = await _dio.delete(endpoint);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(fromJson(response.data));
      } else {
        return ApiResponse.error('DELETE failed: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('DELETE exception: $e');
    }
  }
}
