import 'package:product_cart/model/paging_response.dart';
import 'package:product_cart/model/product_list_model.dart';
import 'package:shop_sqflite/shop_sqflite.dart';

import '../../api/api_provider.dart';

class ShoppingRepository {
  final _provider = ApiProvider();
  final dbHelper = DatabaseHelper.instance;

  Future<List<ProductListModelData>> fetchProductList(
      int pageNo, int perPage) async {
    PagingResponse<ProductListModelData>? response =
        await _provider.fetchProductList({"page": pageNo, "perPage": perPage});
    return response?.items ?? [];
  }

  Future<int> insertData(ProductListModelData data) async {
    var row = await _generateMap(data);
    final id = await dbHelper.insert(row);
    return id;
  }

  Future<Map<String, dynamic>> _generateMap(ProductListModelData data) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductId: data.id,
      DatabaseHelper.columnProductName: data.title,
      DatabaseHelper.columnProductImage: data.featuredImage,
      DatabaseHelper.columnProductPrice: data.price,
      DatabaseHelper.columnQuantity: 1,
    };
    return row;
  }
}
