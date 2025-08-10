import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for handling HTTP API requests
class ApiService {
  final Dio _dio;
  final Logger _logger;

  ApiService(this._dio, this._logger) {
    _setupInterceptors();
  }

  /// Setup Dio interceptors for logging, authentication, etc.
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          _logger.i('🌐 ${options.method} ${options.uri}');
          if (options.data != null) {
            _logger.d('📤 Request Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          _logger.i('✅ ${response.statusCode} ${response.requestOptions.uri}');
          _logger.d('📥 Response Data: ${response.data}');
          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          _logger.e('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
          _logger.e('Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  /// Check network connectivity
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await isConnected()) {
        return ApiResponse.error('No internet connection');
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = fromJson != null ? fromJson(response.data) : response.data as T;
        return ApiResponse.success(data);
      } else {
        return ApiResponse.error('Request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await isConnected()) {
        return ApiResponse.error('No internet connection');
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = fromJson != null ? fromJson(response.data) : response.data as T;
        return ApiResponse.success(responseData);
      } else {
        return ApiResponse.error('Request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await isConnected()) {
        return ApiResponse.error('No internet connection');
      }

      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final responseData = fromJson != null ? fromJson(response.data) : response.data as T;
        return ApiResponse.success(responseData);
      } else {
        return ApiResponse.error('Request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<bool>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      if (!await isConnected()) {
        return ApiResponse.error('No internet connection');
      }

      final response = await _dio.delete(
        endpoint,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    T Function(dynamic)? fromJson,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      if (!await isConnected()) {
        return ApiResponse.error('No internet connection');
      }

      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = fromJson != null ? fromJson(response.data) : response.data as T;
        return ApiResponse.success(responseData);
      } else {
        return ApiResponse.error('Upload failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Download file
  Future<ApiResponse<String>> downloadFile(
    String endpoint,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await isConnected()) {
        return ApiResponse.error('No internet connection');
      }

      await _dio.download(
        endpoint,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      return ApiResponse.success(savePath);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle Dio errors
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        return 'Network error. Please check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Get base URL
  String get baseUrl => _dio.options.baseUrl;

  /// Cancel all requests
  void cancelRequests() {
    _dio.close(force: true);
  }
}

/// API Response wrapper class
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  ApiResponse._(this.isSuccess, this.data, this.error);

  factory ApiResponse.success(T data) => ApiResponse._(true, data, null);

  factory ApiResponse.error(String error) => ApiResponse._(false, null, error);

  /// Check if response is successful
  bool get isError => !isSuccess;

  /// Get data or throw error
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    }
    throw Exception(error ?? 'Unknown error');
  }

  /// Map success data to different type
  ApiResponse<R> map<R>(R Function(T) mapper) {
    if (isSuccess && data != null) {
      return ApiResponse.success(mapper(data as T));
    }
    return ApiResponse.error(error ?? 'Unknown error');
  }

  /// Handle response with callbacks
  void when({
    required void Function(T data) onSuccess,
    required void Function(String error) onError,
  }) {
    if (isSuccess && data != null) {
      onSuccess(data as T);
    } else {
      onError(error ?? 'Unknown error');
    }
  }
}

/// API endpoints
class ApiEndpoints {
  static const String users = 'users';
  static const String posts = 'posts';
  static const String todos = 'todos';
  static const String comments = 'comments';
  static const String albums = 'albums';
  static const String photos = 'photos';
}

/// Extension for common API operations
extension ApiServiceExtension on ApiService {
  /// Get users
  Future<ApiResponse<List<Map<String, dynamic>>>> getUsers() async {
    return await get<List<Map<String, dynamic>>>(
      ApiEndpoints.users,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Get user by ID
  Future<ApiResponse<Map<String, dynamic>>> getUser(int id) async {
    return await get<Map<String, dynamic>>(
      '${ApiEndpoints.users}/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Get posts
  Future<ApiResponse<List<Map<String, dynamic>>>> getPosts() async {
    return await get<List<Map<String, dynamic>>>(
      ApiEndpoints.posts,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Get todos
  Future<ApiResponse<List<Map<String, dynamic>>>> getTodos() async {
    return await get<List<Map<String, dynamic>>>(
      ApiEndpoints.todos,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Create new todo
  Future<ApiResponse<Map<String, dynamic>>> createTodo(Map<String, dynamic> todo) async {
    return await post<Map<String, dynamic>>(
      ApiEndpoints.todos,
      data: todo,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Update todo
  Future<ApiResponse<Map<String, dynamic>>> updateTodo(int id, Map<String, dynamic> todo) async {
    return await put<Map<String, dynamic>>(
      '${ApiEndpoints.todos}/$id',
      data: todo,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Delete todo
  Future<ApiResponse<bool>> deleteTodo(int id) async {
    return await delete('${ApiEndpoints.todos}/$id');
  }
}