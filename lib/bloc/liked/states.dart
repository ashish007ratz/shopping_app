import '../../models/product.dart';

class FavouriteState {}

class FavLoading extends FavouriteState {}

class FavError extends FavouriteState {
  String error;
  FavError(this.error);
}

// can also use it for updated state
class FavLoaded extends FavouriteState {
  List<ProductModel> products;

  FavLoaded(this.products);
}