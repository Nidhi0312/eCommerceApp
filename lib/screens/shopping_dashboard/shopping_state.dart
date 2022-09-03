part of 'shopping_bloc.dart';

abstract class ShoppingState {
  const ShoppingState();

  List<Object?> get props => [];
}

class ShoppingInitial extends ShoppingState {}

class ShoppingLoading extends ShoppingState {}

class ProductLoaded extends ShoppingState {
  List<ProductListModelData>? productListModel;

  ProductLoaded(this.productListModel);
}

class ProductLoadMore extends ShoppingState {
  List<ProductListModelData>? productListModel;

  ProductLoadMore(this.productListModel);
}

class NoInternetAvailable extends ShoppingState {}
