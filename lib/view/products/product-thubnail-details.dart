import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/wishlist.dart';

class ProductThumbnailDetails extends StatelessWidget {
  final Product product;

  ProductThumbnailDetails({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4, left: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Brand"),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "product.nameEnglish",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(product.price.toString()),
                )
              ],
            ),
            BlocBuilder<WishListBloc, WishListStates>(
                builder: (context, state) {
              if (state is AddToWishList) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<WishListBloc>(context).add(
                        DeleteWishListItem(
                            wishListItem: new WishListItem(
                                product: product, size: null, color: null)));
                  },
                  child: Icon(
                    Icons.bookmark,
                    size: 18,
                    color: Colors.pink,
                  ),
                );
              } else
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<WishListBloc>(context).add(AddToWishList(
                        wishListItem: new WishListItem(
                            product: product, size: null, color: null)));
                  },
                  child: Icon(
                    Icons.bookmark,
                    size: 18,
                  ),
                );
            })
          ],
        ),
      ),
    );
  }
}
