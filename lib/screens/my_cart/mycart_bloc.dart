import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_exception.dart';
import '../../common/convertor.dart';
import '../../model/product_list_model.dart';
import '../shopping_dashboard/shopping_repository.dart';

part 'mycart_event.dart';

part 'mycart_state.dart';

class MyCartBloc extends Bloc<MyCartEvent, MyCartState> {
  List<ProductListModelData> products = [];
  int grandTotal = 0;

  MyCartBloc() : super(MyCartInitial()) {
    final ShoppingRepository _shoppingRepository = ShoppingRepository();
    on<GetMyProductList>((event, emit) async {
      try {
        emit(MyCartLoading());
        var data = await _shoppingRepository.dbHelper.queryAllRows();
        for (var element in data) {
          var productData = convertJsonToData(element);
          grandTotal += productData.price ?? 0;
          products.add(productData);
        }
        emit(MyProductLoaded(products));
      } catch (e, stackTrace) {
        CustomException().onException(e.toString(), stackTrace);
      }
    });
    on<DeleteMyProductList>((event, emit) async {
      try {
        emit(MyCartLoading());
        var id = await _shoppingRepository.dbHelper.delete(event.id ?? 0);
        if (id != 0) {
          var data = await _shoppingRepository.dbHelper.queryAllRows();
          products.clear();
          grandTotal = 0;
          if (data.isEmpty) {
            emit(EmptyCart());
          } else {
            for (var element in data) {
              var productData = convertJsonToData(element);
              grandTotal += productData.price ?? 0;
              products.add(productData);
            }
            emit(MyProductLoaded(products));
          }
        }
      } catch (e, stackTrace) {
        CustomException().onException(e.toString(), stackTrace);
      }
    });
  }
}
