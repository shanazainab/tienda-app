import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/product-review-page.dart';

import '../../localization.dart';

class NewArrivalList extends StatelessWidget {
  final List<Product> newArrivals;

  NewArrivalList(this.newArrivals);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Padding(
      padding: const EdgeInsets.only(left:12,right:12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).translate('new-arrival'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Container(
            height: appLanguage.appLocal == Locale('en') ? 210 : 240,
            child: ListView.builder(
                itemCount: newArrivals.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        FirebaseAnalytics()
                            .logEvent(name: "HOME_PAGE_CLICK", parameters: {
                          'section_name': 'new_arrivals',
                          'item_type': 'product',
                          'item_id': newArrivals[index].nameEn,
                        });
                        OverlayService().addVideoTitleOverlay(
                            context,
                            ProductReviewPage(newArrivals[index].id),
                            false,
                            false);
                      },
                      child: Container(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 120,
                                child: CachedNetworkImage(
                                  imageUrl: newArrivals[index].thumbnail,
                                  height: 152,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              newArrivals[index].nameEn,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            Text(
                              '${AppLocalizations.of(context).translate('aed')} ${newArrivals[index].price}',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
