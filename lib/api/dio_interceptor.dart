import 'package:dio/dio.dart';

class DioInterceptor extends InterceptorsWrapper {
  DioInterceptor(Dio dio) ;

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    //get your token from shared preference
    var token =
        "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz";
    options.headers["Authorization"] = "Bearer " + token;
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    /**
     * Handle response if API return only status code not data.
     * When we pass to null data then handle response in Retrofit_client.dart which receive response optional
     */
    final data = response.data;

    if (data is String && data.isEmpty) {
      response.data = null;
    }

    super.onResponse(response, handler);
  }

  @override
  Future onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    //Refresh your token here
    if (err.response?.statusCode == 401) {}
    return super.onError(
      err,
      handler,
    );
  }
}
