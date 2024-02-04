import '../../models/product.dart';

class CartState{}

class CartLoading extends CartState{}

class CartError extends CartState{
  String error;
  CartError(this.error);
}

class CartLoaded extends CartState{
  List<CartModel> products;
  CartLoaded(this.products);
}