
import '../../models/product.dart';

// product
abstract class ProductState{
}

class ProductLoading extends ProductState{}

class ProductError extends ProductState{
  String error;
  ProductError(this.error);
}

class ProductLoaded extends ProductState{
  ProductModel product;
  ProductLoaded(this.product);
}

/// products state
abstract class ProductsState{
}

class ProductsLoading extends ProductsState{}

class ProductsError extends ProductsState{
  String error;
  ProductsError(this.error);
}

class ProductsLoaded extends ProductsState{
  List<ProductModel> products;
  ProductsLoaded(this.products);
}