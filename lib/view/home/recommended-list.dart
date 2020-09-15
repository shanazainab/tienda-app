import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/single-product-page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../app-language.dart';
import '../../localization.dart';

class RecommendedList extends StatelessWidget {
  final List<Product> recommendedProducts;

  RecommendedList(this.recommendedProducts);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context).translate('recommended-for-you').toUpperCase(),
                  style: TextStyle(
                      color: Colors.grey,
                      ))),
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
                        OverlayService().addVideoTitleOverlay(context,SingleProductPage(
                            recommendedProducts[index].id),false);

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
                                child: FadeInImage.memoryNetwork(
                                  image:
                                  recommendedProducts[index].thumbnail,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,

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
