import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/view/products/single-product-page.dart';

import '../../app-language.dart';
import '../../localization.dart';

class RecommendedList extends StatelessWidget {
  final List<Product> recommendedProducts;

  RecommendedList(this.recommendedProducts);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Padding(
      padding: const EdgeInsets.only(left:12,right:12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).translate('recommended-for-you'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(
            height:appLanguage.appLocal == Locale('en')?190:240,
            child: ListView.builder(
                itemCount: recommendedProducts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){

                        FirebaseAnalytics()
                            .logEvent(name: "HOME_PAGE_CLICK", parameters: {
                          'section_name': 'recommendation',
                          'item_type': 'product',
                          'item_id':  recommendedProducts[index].nameEn,
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleProductPage(
                                      recommendedProducts[index].id),
                            ));
                        // OverlayService().addVideoTitleOverlay(context,ProductReviewPage(
                        //     recommendedProducts[index].id),false);

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
                                height: 120,
                                width: 120,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  recommendedProducts[index].thumbnail,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                //  placeholder: kTransparentImage,

                                ),
                              ),
                            ),
                            Text(recommendedProducts[index].nameEn,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,),
                            Text("${AppLocalizations.of(context).translate('aed')} ${recommendedProducts[index].price}")
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
