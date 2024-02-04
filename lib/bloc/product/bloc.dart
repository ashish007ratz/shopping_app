import 'package:bloc/bloc.dart';
import 'package:shopping_app/bloc/product/states.dart';
import '../../models/product.dart';

class ProductsBloc extends Cubit<ProductsState> {
  List<ProductModel> products = [];
  ProductsBloc() : super(ProductsLoading());
  
  void fetchProducts() async {
    emit(ProductsLoading());
    try {
     products = await ProductModel.fetchProducts();
     emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}


class ProductBloc extends Cubit<ProductState>{
  ProductModel? product;
  ProductBloc():super(ProductLoading());

  void fetchProduct(int id) async {
    emit(ProductLoading());
    try {
      product = await ProductModel.fetchProductById(id);
      emit(ProductLoaded(product!));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
