part of 'mycart_bloc.dart';

abstract class MyCartEvent {
  const MyCartEvent();

  List<Object> get props => [];
}

class GetMyProductList extends MyCartEvent {}
class DeleteMyProductList extends MyCartEvent {
  int? id;
  DeleteMyProductList(this.id);
}
