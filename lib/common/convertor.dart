
import 'package:shop_sqflite/shop_sqflite.dart';

import '../model/product_list_model.dart';

ProductListModelData convertJsonToData(Map<String, dynamic> json) {
  ProductListModelData product = ProductListModelData();
  product.id = json[DatabaseHelper.columnProductId];
  product.title = json[DatabaseHelper.columnProductName]?.toString();
  product.price = json[DatabaseHelper.columnProductPrice];
  product.featuredImage = json[DatabaseHelper.columnProductImage];

  return product;
}