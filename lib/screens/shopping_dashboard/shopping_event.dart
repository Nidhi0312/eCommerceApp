part of 'shopping_bloc.dart';

abstract class ShoppingEvent {
  const ShoppingEvent();

  List<Object> get props => [];
}

class GetProductList extends ShoppingEvent {
  GetProductList();
}

class LoadMoreProduct extends ShoppingEvent {}

class SaveProductList extends ShoppingEvent {
  ProductListModelData data;

  SaveProductList(this.data);
}

class UpdateProductList extends ShoppingEvent {
  ProductListModelData data;
  int index;
  BuildContext context;

  UpdateProductList(this.data, this.index, this.context);
}
