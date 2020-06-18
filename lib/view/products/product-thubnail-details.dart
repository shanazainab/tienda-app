import 'package:flutter/material.dart';
import 'package:tienda/model/product.dart';

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
            GestureDetector(
              onTap: () {
                handleAddToWishList();
              },
              child: Icon(
                Icons.bookmark,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleAddToWishList() {

  }
}
