import 'package:dio/dio.dart';
import 'package:flutter_bug_logger/flutter_logger.dart';
import 'package:user_authentication/src/common.dart';

class InterceptorLogs extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    Logger.i(options.path);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    xlogger.d(
      'RESPONSE Status[${response.requestOptions}] => PATH: ${response.requestOptions.extra}',
    );
    xlogger.d(
      'RESPONSE Object[${response.data}] => PATH: ${response.requestOptions.path}',
    );
    Logger.json('${response}');

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    xlogger.d(
      'ERROR[${err.response?.statusMessage}] => PATH: ${err.requestOptions.data}',
    );
    Logger.e('${err.response?.data}');
    // showToast('Something wrong!!!', false);
    // if (err.response?.statusMessage == 'Unauthorized') {
    //  PreferencesManager.removeToken();
    // }
    // if (err.response?.data != null) showToast("${err.response?.data}", false);

    xlogger.d(
      'ERROR object[${err.response?.data}] => PATH: ${err.requestOptions.path}',
    );

    return super.onError(err, handler);
  }
}
