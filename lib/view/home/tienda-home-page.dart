import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/bloc/events/home-events.dart';
import 'package:tienda/bloc/home-bloc.dart';
import 'package:tienda/bloc/states/home-states.dart';
import 'package:tienda/loading-widget.dart';
import 'package:tienda/view/home/live-stream-banner.dart';
import 'package:tienda/view/home/deals-block.dart';
import 'package:tienda/view/home/featured-brands.dart';
import 'package:tienda/view/home/featured-sellers-list.dart';
import 'package:tienda/view/home/new-arrivals-list.dart';
import 'package:tienda/view/home/recommended-list.dart';
import 'package:tienda/view/home/top-categories.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';
import 'package:tienda/view/widgets/network-state-wrapper.dart';

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

class TiendaHomePageContents extends StatefulWidget {
  const TiendaHomePageContents({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  _TiendaHomePageContentsState createState() => _TiendaHomePageContentsState();
}

class _TiendaHomePageContentsState extends State<TiendaHomePageContents>
    with AutomaticKeepAliveClientMixin<TiendaHomePageContents> {
  HomeBloc homeBloc = new HomeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeBloc.add(FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeBloc, HomeStates>(
        cubit: homeBloc,
        builder: (context, state) {
          if (state is LoadDataSuccess)
            return Container(
              child: ListView(
                cacheExtent: 1000,
                padding: EdgeInsets.only(bottom: 50),
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: PageIndicatorContainer(
                      child: PageView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return LiveStreamBanner(
                              state.homeScreenResponse.liveStreams[index]);
                        },
                        controller: widget.controller,
                      ),
                      align: IndicatorAlign.bottom,
                      length: state.homeScreenResponse.liveStreams.length,
                      padding: const EdgeInsets.all(10),
                      indicatorColor: Colors.white,
                      indicatorSelectorColor: Colors.blue,
                      shape: IndicatorShape.circle(size: 0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: FeaturedPresentersList(
                        state.homeScreenResponse.featuredPresenters),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:
                        TopCategories(state.homeScreenResponse.topCategories),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DealsBlock(state.homeScreenResponse.dealsOfTheDay),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RecommendedList(
                        state.homeScreenResponse.recommendedProducts),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: NewArrivalList(state.homeScreenResponse.newArrivals),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:
                        FeaturedBrands(state.homeScreenResponse.featuredBrands),
                  )
                ],
              ),
            );
          else
            return spinkit;
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
