import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/view/presenter-profile/seller-product-video-page.dart';

class FeaturedProductList extends StatelessWidget {
  final List<Product> products;

  FeaturedProductList({this.products});

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  AppLocalizations.of(context).translate("featured-products"),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          SizedBox(
            height: appLanguage.appLocal != Locale('en') ? 280 : 230,
            child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 160,
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SellerProductVideoPage()),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${GlobalConfiguration().getString("baseURL")}/${products[index].thumbnail}",
                              height: 160,
                              width: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  height: 160,
                                  width: 120,
                                  color: Color(0xfff2f2e4),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 160,
                                width: 120,
                                color: Color(0xfff2f2e4),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(products[index].nameEn,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("AED ${products[index].price}"),
                          )
                        ],
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
