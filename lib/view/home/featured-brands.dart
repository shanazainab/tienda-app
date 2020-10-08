import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/model/home-screen-data-response.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/product-list-page.dart';

import '../../localization.dart';

class FeaturedBrands extends StatelessWidget {
  List<FeaturedBrand> featuredBrand;

  FeaturedBrands(this.featuredBrand);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).translate('featured-brands'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: featuredBrand.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        FirebaseAnalytics()
                            .logEvent(name: "HOME_PAGE_CLICK", parameters: {
                          'section_name': 'top_brands',
                          'item_type': 'brand',
                          'item_id': featuredBrand[index].brand,
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider<FilterBloc>(
                                          create: (BuildContext context) =>
                                              FilterBloc(),
                                        ),
                                        BlocProvider(
                                          create: (BuildContext context) =>
                                              ProductBloc()
                                                ..add(FetchProductList(
                                                    query: featuredBrand[index]
                                                        .brand)),
                                        )
                                      ],
                                      child: ProductListPage(
                                        titleInEnglish:
                                            featuredBrand[index].brand,
                                        query: featuredBrand[index].brand,
                                        searchBody: new SearchBody(),
                                      ),
                                    )));
                      },
                      child: CircleAvatar(
                          radius: 50,
                          backgroundColor: index / 2 == 0
                              ? Color(0xFFE7F3FC)
                              : Color(0xFFEFE8FB),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              featuredBrand[index].brand,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ))),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
