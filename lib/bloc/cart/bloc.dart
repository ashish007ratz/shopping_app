import 'package:bloc/bloc.dart';
import 'package:shopping_app/bloc/cart/states.dart';
import '../../models/product.dart';

/// holds the carts items of the user
class CartBloc extends Cubit<CartState>{
  // all products added by the user
  List<CartModel> _products = [];
  List<CartModel> get products => _products;

  /// initially calling the fetchCart to get cart items
  CartBloc():super(CartLoading()){
    fetchCart();
  }

  /// objects and actions
  Set<int> get keys => _products.map((e) => e.itemKey).toSet();
  bool hasItem( ProductModel item) => keys.contains(item.id);
  double  get total {
    /// get product total
    double subTtl = 0;
    _products.forEach((p) {
      subTtl += double.parse(p.product.price) * p.itemCount;
    });
    return subTtl;
  }

  // functions
  fetchCart(){
    emit(CartLoading());
    try{
      emit(CartLoaded(_products));
    }catch(e) {
      emit(CartError(e.toString()));
    }
  }

  /// cart actions
  toggleItem(ProductModel item){
    if(hasItem(item)){
      _removeProduct(item);
    }
    else{
      _addProduct(item);
    }
  }

  void _addProduct(ProductModel item) {
    _products.add(CartModel(itemKey: item.id, itemCount: 1, product: item));
    emit(CartLoaded(_products));
  }

  void _removeProduct(ProductModel item) {
    _products.removeWhere((i) => i.itemKey == item.id);
    emit(CartLoaded(_products));
  }
}