import 'dart:ui';

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
    return Container();}




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
