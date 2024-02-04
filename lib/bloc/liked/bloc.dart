import 'package:bloc/bloc.dart';
import 'package:shopping_app/bloc/liked/states.dart';
import '../../models/product.dart';


/// list of liked items
class FavBloc extends Cubit<FavouriteState> {
  List<ProductModel> _products = [];// making it private so that no one could make any changes from outside
  List<ProductModel> get products => _products;

  // initially getting the fav items when ever we initialize the bloc
  FavBloc() : super(FavLoading()) {
    fetchFav();
  }

  /// some external objects with actions
  Set<int> get _favKeys => _products.map((e) => e.id).toSet();
  // checks that the item is marked as fav or not
  bool isFav(ProductModel item) => _favKeys.contains(item.id);

  // get the fav list from the server hence there is no server in there so its dummy
  fetchFav() {
    emit(FavLoading());
    try {
      emit(FavLoaded(_products));
    } catch (e) {
      emit(FavError(e.toString()));
    }
  }

  // handle item fav add/remove from list
  void toggleFav(ProductModel item){
    if(isFav(item)){
      _removeFav(item);
    }
    else{
      _addFav(item);
    }
  }

  /// add as fav
  void _addFav(ProductModel item) {
    _products.add(item);
    emit(FavLoaded(_products));
    }
  /// remove as fav
  void _removeFav(ProductModel item){
    _products.removeWhere((i) => i.id == item.id);
    emit(FavLoaded(_products));
  }
}
