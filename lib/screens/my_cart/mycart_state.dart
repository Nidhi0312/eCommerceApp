part of 'mycart_bloc.dart';
abstract class MyCartState {
  const MyCartState();

  List<Object?> get props => [];
}
class MyCartInitial extends MyCartState {}

class MyCartLoading extends MyCartState {}
class EmptyCart extends MyCartState {}
class MyProductLoaded extends MyCartState {
  List<ProductListModelData>? productListModel;

  MyProductLoaded(this.productListModel);
}