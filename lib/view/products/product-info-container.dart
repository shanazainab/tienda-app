import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';

class ProductInfoContainer extends StatelessWidget {
  final Product product;

  ProductInfoContainer(this.product);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              product.nameEn,
              style: TextStyle(
                fontSize: 16
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  Text(
                    '${AppLocalizations.of(context).translate('aed')} ${product.price}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  product.discount != 0?Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      '${AppLocalizations.of(context).translate('aed')} ${product.price/product.discount * 100}',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey),
                    ),
                  ):Container(),

                  ///org*dis = price , org = price/dis
                  product.discount != 0?Container(
                    color: Colors.pink.withOpacity(0.1),
                    child: Text(
                      '${product.discount}% OFF',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ):Container(),

                ],
              ),
            ),

            !product.isReturnable?Container(
              color: Colors.blue.withOpacity(0.1),
              child: Text(
                'NOT RETURNABLE',
                style: TextStyle(color: Colors.blue),
              ),
            ):Container()
          ],
        ),
      ),
    );
  }
}
