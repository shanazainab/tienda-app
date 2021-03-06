import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/bloc/events/home-events.dart';
import 'package:tienda/bloc/home-bloc.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/home-states.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/view/home/widget/featured-live.dart';
import 'package:tienda/view/home/widget/popular-presenters-list.dart';
import 'package:tienda/view/home/widget/top-categories.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

import '../../widgets/loading-widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  HomeBloc homeBloc = new HomeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeBloc.add(FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<HomeBloc, HomeStates>(
        cubit: homeBloc,
        builder: (context, state) {
          if (state is LoadDataSuccess)
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: CustomAppBar(
                  showSearch: true,
                  showLogo: true,
                  title: '',
                  showCart: false,
                  extend: true,
                  showNotification: false,
                  showWishList: false,
                ),
              ),
              body: Container(
                child: ListView(
                  cacheExtent: 1000,
                  padding: EdgeInsets.only(bottom: 100),
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageIndicatorContainer(
                        child: PageView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Color(0xFFFFDC98),
                            );
                          },
                        ),
                        align: IndicatorAlign.bottom,
                        length: state.homeScreenResponse.liveStreams.length,
                        padding: const EdgeInsets.all(10),
                        indicatorColor: Colors.white,
                        indicatorSelectorColor: Colors.blue,
                        shape: IndicatorShape.circle(size: 0),
                      ),
                    ),
                    BlocBuilder<PresenterBloc, PresenterStates>(
                        builder: (context, state) {
                      if (state is LoadPopularPresentersSuccess &&
                          state.presenters != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: PopularPresentersList(state.presenters),
                        );
                      } else
                        return Container();
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child:
                          TopCategories(state.homeScreenResponse.topCategories),
                    ),
                    BlocBuilder<LiveContentsBloc, LiveStates>(
                        builder: (context, state) {
                      if (state is LoadCurrentLiveVideoListSuccess &&
                          state.featuredLiveContent != null) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 16, right: 16),
                          child: FeaturedLive(state.featuredLiveContent),
                        );
                      } else
                        return Container();
                    })
                  ],
                ),
              ),
            );
          else
            return spinKit;
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
