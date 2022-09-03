import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:product_cart/common/network_manager.dart';
import 'package:product_cart/screens/shopping_dashboard/shopping_repository.dart';

import '../../common/app_exception.dart';
import '../../common/convertor.dart';
import '../../model/product_list_model.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  List<ProductListModelData> selectedProducts = [];
  List<ProductListModelData> products = [];
  List<ProductListModelData> dbProducts = [];
  final ShoppingRepository _shoppingRepository = ShoppingRepository();

  ShoppingBloc() : super(ShoppingInitial()) {
    int page = 1;
    int perPage = 5;
    //This is for getting product list
    on<GetProductList>((event, emit) async {
      try {
        if (await NetworkManager.instance.isConnected()) {
          emit(ShoppingLoading());
          products.clear();
          products = await _shoppingRepository.fetchProductList(page, perPage);

          await _getProductsFromDB();
          await _updateSelectedFlag();
          page++;
          emit(ProductLoaded(products));
        } else {
          emit(NoInternetAvailable());
        }
      } catch (e, stackTrace) {
        CustomException().onException(e.toString(), stackTrace);
      }
    });

    //this is for save product list to cart
    on<LoadMoreProduct>((event, emit) async {
      try {
        products
            .addAll(await _shoppingRepository.fetchProductList(page, perPage));
        emit(ProductLoaded(products));
      } catch (e, stackTrace) {
        CustomException().onException(e.toString(), stackTrace);
      }
    });
    on<UpdateProductList>((event, emit) async {
      try {
        var existingCount = await _shoppingRepository.dbHelper
            .queryRowIdCount(event.data.id ?? 0);
        if (existingCount != 0) {
          await _shoppingRepository.dbHelper.delete(event.data.id ?? 0);
        } else {
          var id = await _shoppingRepository.insertData(event.data);
          if (id != 0) {}
        }
        products.removeAt(event.index);
        event.data.isSelected = !event.data.isSelected;
        products.insert(event.index, event.data);
        emit(ProductLoaded(products));
      } catch (e, stackTrace) {
        CustomException().onException(e.toString(), stackTrace);
      }
    });
  }

//this is for verifying that list is alreay selected before or available in cart or not
  _getProductsFromDB() async {
    var data = await _shoppingRepository.dbHelper.queryAllRows();
    dbProducts.clear();
    for (var element in data) {
      dbProducts.add(convertJsonToData(element));
    }
  }

  _updateSelectedFlag() async {
    for (var dbElement in dbProducts) {
      var d = products.firstWhere((element) => dbElement.id == element.id);
      d.isSelected = true;
    }
  }
}
