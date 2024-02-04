import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/cart/states.dart';
import 'package:shopping_app/bloc/liked/bloc.dart';
import 'package:shopping_app/bloc/liked/states.dart';
import 'package:shopping_app/screens/Home/Product/detail.dart';
import '../../../bloc/cart/bloc.dart';
import '../../../bloc/product/bloc.dart';
import '../../../bloc/product/states.dart';
import '../../../models/product.dart';
import '../../common/empty_page.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late CartBloc cartBloc;
  late FavBloc favBloc;

  @override
  void initState() {
    var productsBloc = context.read<ProductsBloc>();
    cartBloc = context.read<CartBloc>();
    favBloc = context.read<FavBloc>();
    if (!(productsBloc.state is ProductsLoaded)) {
      productsBloc.fetchProducts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Product list',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400), // Customize text color
        ),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder:widgetBodyBuilder
      ),
    );
  }

  /// [widgetBodyBuilder] contains the body of the page according  to its state
 Widget widgetBodyBuilder(BuildContext context, ProductsState state) {
   /// loading state
   if (state is ProductsLoading) {
     return Center(
       child: CircularProgressIndicator(),
     );

     /// error state
   } else if (state is ProductsError) {
     return Center(
       child: Icon(Icons.close),
     );

     /// show Products
   } else if (state is ProductsLoaded) {
     var products = state.products;

     if (products.length == 0)
       return EmptyItemsWidget(text: "No Products here!");
     else
       return ListView.builder(
         itemCount: products.length,
         itemBuilder: (context, index) {
           final product = products[index];
           return _buildProductCard(context, product);
         },
       );
   } else {
     return Container();
   }
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return StatefulBuilder(builder: (context, setState) {
      bool addedToCart = cartBloc.hasItem(product);
      bool addedToFav = favBloc.isFav(product);
      return MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: cartBloc,
            listener: (context, state) {
              if (state is CartLoaded) {
                setState(() {});
              }
            },
          ),
          BlocListener(
            bloc: favBloc,
            listener: (context, state) {
              if (state is FavLoaded) {
                setState(() {});
              }
            },
          ),
        ],
        child: Card(
          child: ListTile(
            minVerticalPadding: 10,
            contentPadding:
                EdgeInsets.only(left: 15, top: 7, bottom: 7, right: 5),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          ProductDetailPage(productId: product.id)));
            },
            leading: CircleAvatar(
                radius: 25,
                child: Image.network(
                  product.image,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                        height: 15,
                        width: 15,
                        child: Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ))); // Replace with your preferred loading indicator
                  },
                )),
            title: Text(
              product.title,
              maxLines: 1,
            ),
            subtitle: Text("${product.price} \$"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Cart item
                IconButton(
                  icon: Icon(
                      addedToCart
                          ? Icons.shopping_cart
                          : Icons.add_shopping_cart,
                      color: !addedToCart
                          ? Colors.grey
                          : Colors.blueAccent.withOpacity(0.8)),
                  onPressed: () {
                    cartBloc.toggleItem(product);
                  }, // Implement this function
                ),

                /// Favourite
                IconButton(
                  icon: Icon(
                    addedToFav
                        ? Icons.favorite_outlined
                        : Icons.favorite_outline,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    favBloc.toggleFav(product);
                  }, // Implement this function
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
