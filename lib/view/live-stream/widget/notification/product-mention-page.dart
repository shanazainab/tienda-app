import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/product.dart';

import '../../../../localization.dart';

typedef OnProductTap = Function(int productIndex);

class ProductMentionPage extends StatelessWidget {
  final List<Product> liveProducts;

  final OnProductTap onProductTap;

  ///max height: 500
  ProductMentionPage(
      {@required this.liveProducts, @required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
        stream: new RealTimeController().mentionedProductStream,
        builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
          if (snapshot.hasData) {
            int currentIndex;
            for (int index = 0; index < liveProducts.length; ++index) {
              if (liveProducts[index].id == snapshot.data.id)
                currentIndex = index;
            }
            return GestureDetector(
              onTap: () {
                onProductTap(currentIndex);
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 10 * 500 / 100,
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("Tap to view product details",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xff555555),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            )),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data.thumbnail,
                            width: MediaQuery.of(context).size.width,
                            height: 50 * 500 / 100,
                            fit: BoxFit.contain,
                          ),
                          Container(
                            height: 20 * 500 / 100,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 200,
                                      child: Text(
                                        snapshot.data.nameEn,
                                        softWrap: true,
                                      )),
                                  Text(
                                      '${AppLocalizations.of(context).translate('aed')} ${snapshot.data.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 0,
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 20 * 500 / 100,
                      alignment: Alignment.center,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: liveProducts.length,
                          itemBuilder: (BuildContext context, int index) => Row(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 100,
                                    color: index < currentIndex ||
                                            index == currentIndex
                                        ? Color(0xfff15223)
                                        : Color(0xffEAEAEA),
                                  ),
                                  CircleAvatar(
                                      radius: 35,
                                      foregroundColor: index < currentIndex ||
                                              index == currentIndex
                                          ? Color(0xfff15223)
                                          : Color(0xffEAEAEA),
                                      backgroundColor: index < currentIndex ||
                                              index == currentIndex
                                          ? Color(0xfff15223)
                                          : Color(0xffEAEAEA),
                                      child: CircleAvatar(
                                        radius: 33,
                                        foregroundColor: Colors.white,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                liveProducts[index].thumbnail,
                                                scale: 0.2),
                                      ))
                                ],
                              )),
                    )
                  ],
                ),
              ),
            );
          } else
            return Container();
        });
  }
}
