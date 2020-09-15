import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/single-product-page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../localization.dart';

class NewArrivalList extends StatelessWidget {
  final List<Product> newArrivals;

  NewArrivalList(this.newArrivals);
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
              child: Text(AppLocalizations.of(context).translate('new-arrival').toUpperCase(),
                  style: TextStyle(color: Colors.grey))),
          Container(
            height:appLanguage.appLocal == Locale('en')?210:240,
            child: ListView.builder(
                itemCount:newArrivals.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        OverlayService().addVideoTitleOverlay(context,SingleProductPage(
                            newArrivals[index].id),false);

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
                                child:FadeInImage.memoryNetwork(
                                  image:
                                  newArrivals[index].thumbnail,
                                  height: 152,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,

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
