import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';
import 'package:transparent_image/transparent_image.dart';

class RelatedBrandProducts extends StatelessWidget {
  final List<Product> products;

  final String brandName;

  RelatedBrandProducts(this.brandName, this.products);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("All about $brandName",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(
              height: 6,
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        (MediaQuery.of(context).size.width / 2 - 16) / 220),
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width / 2,
                                alignment: Alignment.center,
                                child: FadeInImage.memoryNetwork(
                                  image: products[index].thumbnail,
                                  height: 140,
                                  width: MediaQuery.of(context).size.width / 2,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              products[index].nameEn,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,

                                )
                            ),
                            Text("${AppLocalizations.of(context).translate('aed')} ${products[index].price}",
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,

                                )
                            )

                          ],
                        ),
                      ),
                )),
          ],
        ),
      ),
    );
  }
}
