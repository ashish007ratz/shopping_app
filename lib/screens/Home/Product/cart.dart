import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/cart/bloc.dart';
import '../../../bloc/cart/states.dart';
import '../../../models/product.dart';
import '../../common/empty_page.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc cartBloc;

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    if (!(cartBloc.state is CartLoaded)) {
      cartBloc.fetchCart();
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
          'Your Cart',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400), // Customize text color
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          /// loading state
          if (state is CartLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );

            /// error state
          } else if (state is CartError) {
            return Center(
              child: Icon(Icons.close),
            );

            /// show Products
          } else if (state is CartLoaded) {
            var products = state.products;
            if (products.length == 0)
              return EmptyItemsWidget(text: "No Items in Cart");
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
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, CartModel item) {
    var product = item.product;
    return Card(
      child: ListTile(
        minVerticalPadding: 10,
        contentPadding: EdgeInsets.only(left: 15, top: 7, bottom: 7, right: 5),
        onTap: () {},
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
        title: Text(product.title, maxLines: 1),
        subtitle: Text("${product.price} \$"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                cartBloc.toggleItem(product);
              }, // Implement this function
            ),
          ],
        ),
      ),
    );
  }
}
