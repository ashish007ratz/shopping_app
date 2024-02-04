import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/product/bloc.dart';
import 'package:shopping_app/models/product.dart';
import '../../../bloc/cart/bloc.dart';
import '../../../bloc/cart/states.dart';
import '../../../bloc/liked/bloc.dart';
import '../../../bloc/liked/states.dart';
import '../../../bloc/product/states.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late CartBloc cartBloc;
  late FavBloc favBloc;

  @override
  void initState() {
    var productBloc  = context.read<ProductBloc>();
    cartBloc = context.read<CartBloc>();
    favBloc = context.read<FavBloc>();
    productBloc.fetchProduct(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Product Detail',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400), // Customize text color
        ),
      ),
      body: SafeArea(child: body()),
    );
  }

  Widget body() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        /// loading state
        if (state is ProductLoading) {
          return _buildLoadingScreen();

          /// error state
        } else if (state is ProductError) {
          return _buildErrorScreen(state.error);
          /// show Products
        } else if (state is ProductLoaded) {
          var product = state.product;
          return _buildProductDetailsScreen(product);
        } else {
          return Container();
        }
      },
    );}

  /// loading page
  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  /// error screen
  Widget _buildErrorScreen(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Internal Server Error While loading data",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16.0),
          Text(errorMessage),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              var productBloc  = context.read<ProductBloc>();
              productBloc.fetchProduct(widget.productId);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// product data
  Widget _buildProductDetailsScreen(ProductModel product) {
    bool addedToCart = cartBloc.hasItem(product);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:  MultiBlocListener(
          listeners: [
            BlocListener (
              bloc: cartBloc,
              listener: (context, state) {
                if(state is CartLoaded){
                  setState(() {});
                }
              },
            ),
            BlocListener (
              bloc: favBloc,
              listener: (context, state) {
                if(state is FavLoaded){
                  setState(() {});
                }
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        // color: Colors.grey.withOpacity(0.4)
                        ),
                    height: 320,
                    child: Center(
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: Image.network(product.image),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // RatingBar.builder(
                          //     initialRating: 3,
                          //     itemSize: 20,
                          //     allowHalfRating: true,
                          //     itemCount: 5,
                          //     onRatingUpdate: (double) {},
                          //     itemBuilder: (context, index) => Icon(
                          //           Icons.star,
                          //           color: Colors.amber,
                          //           size: 4,
                          //         )),
                          IconButton(
                            icon: Icon(
                              favBloc.isFav(product)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: true ? Colors.red : null,
                            ),
                            onPressed: () {
                              favBloc.toggleFav(product);
                            },
                          ),

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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(margin: const EdgeInsets.only(bottom: 15)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Price        :  ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      Text('\$${product.price}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Category :  ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      Text(product.category,
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text('About',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Text(product.description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
