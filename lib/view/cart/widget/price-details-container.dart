import 'package:flutter/material.dart';
import 'package:tienda/model/cart.dart';

import '../../../localization.dart';

class PriceDetailsContainer extends StatelessWidget {
  const PriceDetailsContainer({
    Key key,
    @required this.summary,
  }) : super(key: key);

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).translate('price-details'),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('cart-total'),
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${summary.cartPrice}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('cart-discount'),
                ),
                Text("${AppLocalizations.of(context).translate('aed')} ${summary.discountPrice}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Coupon discount',
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${summary.couponDiscount}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('order-total'),
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${summary.totalPrice}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('delivery-charge'),
                ),
                Text(
                  AppLocalizations.of(context).translate('free'),
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Divider(),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('total'),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${summary.totalPrice}",
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
