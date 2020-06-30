import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/view/home/banner-bottom.dart';
import 'package:tienda/view/home/category-block.dart';
import 'package:tienda/view/home/deals-block.dart';
import 'package:tienda/view/home/featured-brands.dart';
import 'package:tienda/view/home/featured-sellers-list.dart';
import 'package:tienda/view/home/home-top-app-bar.dart';
import 'package:tienda/view/home/new-arrivals-list.dart';
import 'package:tienda/view/home/recommended-list.dart';
import 'package:tienda/view/home/top-categories.dart';
import 'package:tienda/view/live-stream/video-stream-full-screen.dart';

class TiendaHomePage extends StatelessWidget {
  PageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height

          child: HomeTopAppBar()),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 400,
              child: PageIndicatorContainer(
                child: PageView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoStreamFullScreenView()),
                        );
                      },
                      child: Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Banner Title",
                                style:
                                    TextStyle(fontSize: 24, color: Colors.blue),
                              ),
                              Text(
                                "Lorem Epsum",
                                style:
                                    TextStyle(fontSize: 24, color: Colors.blue),
                              ),
                              Container(
                                width: 200,
                                child: RaisedButton(
                                  onPressed: () {},
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.shop),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("SHOP LIVE"),
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
                shape: IndicatorShape.circle(size: 12),
                // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
                // shape: IndicatorShape.oval(size: Size(12, 8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: CategoryBlock(),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: DealsBlock(),
            ),

            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: FeaturedSellersList(),
            ),

            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: RecommendedList(),
            ),

            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: BannerBottom(),
            ),

            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: NewArrivalList(),
            ),

            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: TopCategories(),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: FeaturedBrands(),
            )
          ],
        ),
      ),
    );
  }
}