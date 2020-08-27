import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';
import 'package:transparent_image/transparent_image.dart';

class FeaturedProductGridView extends StatelessWidget {
  final List<Product> products;

  FeaturedProductGridView({this.products});

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Column(
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
        GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.width / 2) / 220,
            ),
            itemCount: products.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext cxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        SellerProductVideoPage()),
//                              );
                        },
                        child: FadeInImage.memoryNetwork(
                          image: "${products[index].thumbnail}",
                          height: 160,
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          products[index].nameEn,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("AED ${products[index].price}"),
                      )
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }
}
