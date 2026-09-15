import 'package:dio/dio.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static String getMessage(Object error) {
    if (error is DioException) {
      return _fromDioException(error);
    }
    return 'Something went wrong. Please try again.';
  }

  static String _fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'A secure connection could not be established.';
      case DioExceptionType.badResponse:
        return _fromResponse(error);
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static String _fromResponse(DioException error) {
    final message = _extractMessage(error.response?.data);
    if (message != null && message.isNotEmpty) return message;

    switch (error.response?.statusCode) {
      case 400:
        return 'Please check your information and try again.';
      case 401:
        return 'Incorrect email or password.';
      case 404:
        return 'Requested resource was not found.';
      case 409:
        return 'This account already exists.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is String && data.trim().isNotEmpty) return data.trim();

    if (data is Map) {
      final errors = data['errors'];

      if (errors is Map) {
        final messages = errors.values
            .expand((value) => value is List ? value : [value])
            .map((value) => value.toString())
            .where((value) => value.trim().isNotEmpty)
            .toList();
        if (messages.isNotEmpty) return messages.join('\n');
      }

      if (errors is List && errors.isNotEmpty) {
        return errors.map((value) => value.toString()).join('\n');
      }

      for (final key in ['message', 'title', 'detail', 'error']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
    }

    return null;
  }
}
