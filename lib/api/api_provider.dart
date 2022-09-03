import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:product_cart/common/app_exception.dart';
import 'package:product_cart/model/paging_response.dart';
import 'package:product_cart/model/product_list_model.dart';

import 'dio_interceptor.dart';

class ApiProvider {
  late Dio _dio;
  final String _url =
      'http://205.134.254.135/~mobile/MtProject/public/api/product_list.php';

  ApiProvider._internal() {
    _createDio();
  }

  static final _singleton = ApiProvider._internal();

  factory ApiProvider() {
    return _singleton;
  }

  _createDio() {
    const int timeout = 40000;
    _dio = Dio(BaseOptions(
      connectTimeout: timeout,
      sendTimeout: timeout,
      receiveTimeout: timeout,
    ));
    _dio.interceptors.add(DioInterceptor(_dio));
  }

  Future<PagingResponse<ProductListModelData>?> fetchProductList(
      Map<String, dynamic> body) async {
    try {
      Response response = await _dio.post(_url, data: jsonEncode(body));
      Map<String, dynamic> result = jsonDecode(response.data);

      if (response.statusCode == 200) {
        return PagingResponse<ProductListModelData>.fromJson(result);
      }
      return null;
    } catch (error, stacktrace) {
      CustomException().onException(error.toString(), stacktrace);
      return null;
    }
  }
}
