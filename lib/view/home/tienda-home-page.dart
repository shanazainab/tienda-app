import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/view/home/banner-bottom.dart';
import 'package:tienda/view/home/now-trending-block.dart';
import 'package:tienda/view/home/deals-block.dart';
import 'package:tienda/view/home/featured-brands.dart';
import 'package:tienda/view/home/featured-sellers-list.dart';
import 'package:tienda/view/home/new-arrivals-list.dart';
import 'package:tienda/view/home/recommended-list.dart';
import 'package:tienda/view/home/top-categories.dart';
import 'package:tienda/view/live-stream/video-stream-full-screen.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';
import 'package:tienda/view/widgets/network-state-wrapper.dart';

import '../../localization.dart';

class TiendaHomePage extends StatelessWidget {
   PageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(44.0), // here the desired height
          child: CustomAppBar(
            extend: true,
            title: "TIENDA",
            showWishList: true,
            showSearch: true,
            showCart: true,
            showNotification: true,
            showLogo: true,
          )),
      body: NetworkStateWrapper(
          networkState: (value) {},
          child: TiendaHomePageContents(controller: controller)),
    );
  }
}

class TiendaHomePageContents extends StatelessWidget {
  const TiendaHomePageContents({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            height: 400,
            child: PageIndicatorContainer(
              child: PageView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: RaisedButton(
                                onPressed: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.shop,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('shop-live'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                  ),
                  Container(
                    color: Colors.grey[200],
                  ),
                  Container(
                    color: Colors.grey[200],
                  )
                ],
                controller: controller,
              ),
              align: IndicatorAlign.bottom,
              length: 4,
              indicatorSpace: 20.0,
              padding: const EdgeInsets.all(10),
              indicatorColor: Colors.white,
              indicatorSelectorColor: Colors.blue,
              shape: IndicatorShape.circle(size: 8),
              // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
              // shape: IndicatorShape.oval(size: Size(12, 8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: NowTrendingBlock(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FeaturedSellersList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TopCategories(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: DealsBlock(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RecommendedList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: BannerBottom(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: NewArrivalList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FeaturedBrands(),
          )
        ],
      ),
    );
  }
}
