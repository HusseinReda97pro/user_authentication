import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:user_authentication/src/models/custom_response.dart';
import 'package:user_authentication/src/network_services/status_codes.dart';

class NetworkServices {
  bool debugging = true;
  Map<String, String> headers = HashMap();
  static final NetworkServices _instance =
      NetworkServices._privateConstructor();
  NetworkServices._privateConstructor() {
    _dio = Dio(baseOptions);
// customization
    if (debugging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  late Dio _dio;
  var baseOptions = BaseOptions(
    // baseUrl: ApiUrls.BASE_URL,
    receiveDataWhenStatusError: true,
    receiveTimeout: 20 * 1000,
    connectTimeout: 20 * 1000,
    followRedirects: false,
    validateStatus: (status) {
      return status != null ? status < 500 : true;
    },
  );
  static NetworkServices get instance => _instance;

  void _setJsonHeader() {
    headers.putIfAbsent('Accept', () => 'application/json charset=utf-8');
  }

  Future<CustomResponse<dynamic>> get(
      {required String url, Map<String, dynamic>? queryParameters}) async {
    _setJsonHeader();
    Response response;

    response = await _dio.get(url,
        queryParameters: queryParameters, options: Options(headers: headers));
    // ignore: prefer_typing_uninitialized_variables
    var data;
    String? errorMessage, successMessage;
    if (response.statusCode == StatusCode.success) {
      data = response.data;
    } else {
      errorMessage = response.data['message'];
    }
    // successMessage = response.data['success_message'] ?? null;
    return CustomResponse(
      data: data,
      statusCode: response.statusCode,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  Future<CustomResponse<dynamic>> post({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headersForRequest,
    body,
  }) async {
    _setJsonHeader();
    Response? response;
    try {
      if (headersForRequest != null) {
        headersForRequest.forEach((key, value) {
          headers.putIfAbsent(key, () => value);
        });
      }
      response = await _dio.post(
        url,
        queryParameters: queryParameters,
        data: body != null ? json.encode(body) : null,
        options: Options(
          headers: headers,
        ),
      );
      // ignore: prefer_typing_uninitialized_variables
      var data;
      String? errorMessage, successMessage;
      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created) {
        data = response.data;
      } else {
        errorMessage = response.data['message'];
      }
      // successMessage = response.data['success_message'] ?? null;
      return CustomResponse(
        data: data,
        statusCode: response.statusCode,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );
    } catch (e) {
      return CustomResponse(
        statusCode: response?.statusCode,
        errorMessage: "Something Went Wrong",
      );
    }
  }

  Future<CustomResponse<dynamic>> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headersForRequest,
    body,
  }) async {
    _setJsonHeader();
    Response? response;
    try {
      if (headersForRequest != null) {
        headersForRequest.forEach((key, value) {
          headers.putIfAbsent(key, () => value);
        });
      }
      response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: body != null ? json.encode(body) : null,
        options: Options(
          headers: headers,
        ),
      );
      // ignore: prefer_typing_uninitialized_variables
      var data;
      String? errorMessage, successMessage;
      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created) {
        data = response.data;
      } else {
        errorMessage = response.data['message'];
      }
      // successMessage = response.data['success_message'] ?? null;
      return CustomResponse(
        data: data,
        statusCode: response.statusCode,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );
    } catch (e) {
      return CustomResponse(
        statusCode: response?.statusCode,
        errorMessage: "Something Went Wrong",
      );
    }
  }
}
