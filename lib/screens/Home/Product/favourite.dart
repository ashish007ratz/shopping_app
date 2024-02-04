import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/product.dart';
import '../../../bloc/cart/bloc.dart';
import '../../../bloc/cart/states.dart';
import '../../../bloc/liked/bloc.dart';
import '../../../bloc/liked/states.dart';
import '../../common/empty_page.dart';
import '../../common/view_image.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  late CartBloc cartBloc;
  @override
  void initState() {
    var favBloc = context.read<FavBloc>();
    cartBloc = context.read<CartBloc>();
    if (!(favBloc.state is FavLoaded)) {
      favBloc.fetchFav();
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
          'Your favourite',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400), // Customize text color
        ),
      ),
      body: BlocBuilder<FavBloc, FavouriteState>(
        builder: (context, state) {
          /// loading state
          if (state is FavLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );

            /// error state
          } else if (state is FavError) {
            return Center(
              child: Icon(Icons.close),
            );

            /// show Products
          } else if (state is FavLoaded) {
            var products = state.products;
            if (products.length == 0)
              return EmptyItemsWidget(text: "No Items in Favourite here!");
            else
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: GridView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(context, product);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 190),
                ),
              );
          } else {
            return Container();
          }
        },
      ),
      bottomSheet: Container(
        height: 50,
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    bool addedToCart = cartBloc.hasItem(product);

    return BlocListener(
      bloc: cartBloc,
      listener: (context, state) {
        if (state is CartLoaded) {
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2, // Blur radius
                blurRadius: 4, // Offset along X and Y axis
                offset: Offset(0, 2), // Shadow direction
              ),
            ],
            borderRadius: BorderRadius.circular(20), color: Colors.white),

        padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 100,
                      child: Image.network(
                        product.image,
                        // fit: BoxFit.fill,
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
                      ),
                    ),
                  ),
                  Positioned(
                      right: 5,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            var favBloc = context.read<FavBloc>();
                            favBloc.toggleFav(product);
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.grey,
                          )))
                ],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(product.price + " \$",
                                maxLines: 1, overflow: TextOverflow.ellipsis)),

                        /// item to Cart actions
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
