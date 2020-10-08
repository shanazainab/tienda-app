import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/home/popular-presenters-list.dart';
import 'package:tienda/view/live-stream/live-videos-list.dart';
import 'package:tienda/view/products/product-list-page.dart';
import 'package:tienda/view/search/recent-search-block.dart';

typedef ScrollCallBack = Function(String status);

class SearchHomeContainer extends StatelessWidget {
  final ScrollCallBack onScroll;
  final LiveContentsBloc liveContentsBloc;

  final PreferenceBloc preferenceBloc;

  int prevNumber;
  int currentNumber;

  SearchHomeContainer(this.preferenceBloc, this.liveContentsBloc,
      {this.onScroll});

  Random random = new Random();
  final List<Color> colorsList = [
    Color(0xffEFE8FB),
    Color(0xffE7F3FC),
    Color(0xffFCF2F2),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NotificationListener<ScrollNotification>(
        onNotification: (status) {
          if (status is ScrollNotification) {
            onScroll("START");
          }
          if (status is ScrollEndNotification) {
            onScroll("END");
          }

          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ///Category list
              SizedBox(
                height: 20,
              ),
              BlocBuilder<PreferenceBloc, PreferenceStates>(
                  cubit: preferenceBloc,
                  builder: (context, state) {
                    if (state is LoadPreferredCategoryListSuccess) {
                      return Container(
                        height: 45,
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MultiBlocProvider(
                                                  providers: [
                                                    BlocProvider<FilterBloc>(
                                                      create: (BuildContext
                                                              context) =>
                                                          FilterBloc(),
                                                    ),
                                                    BlocProvider(
                                                      create: (BuildContext
                                                              context) =>
                                                          ProductBloc()
                                                            ..add(FetchProductList(
                                                                query:
                                                                    'get_category',
                                                                searchBody: SearchBody(
                                                                    category: state
                                                                        .categories[
                                                                            index]
                                                                        .id))),
                                                    )
                                                  ],
                                                  child: ProductListPage(
                                                    titleInEnglish: state
                                                        .categories[index]
                                                        .nameEn,
                                                    titleInArabic: state
                                                        .categories[index]
                                                        .nameAr,
                                                    query: 'get_category',
                                                    searchBody: new SearchBody(
                                                        category: state
                                                            .categories[index]
                                                            .id),
                                                  ))));
                                },
                                child: Card(
                                    elevation: 0,
                                    color: colorsList[random.nextInt(3)],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(39)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 10,
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/chat.svg",
                                            height: 12,
                                            width: 12,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            state.categories[index].nameEn,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                            itemCount: state.categories.length),
                      );
                    } else
                      return Container();
                  }),
              SizedBox(
                height: 20,
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
              SizedBox(
                height: 20,
              ),
              RecentSearchBlock(),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 20, left: 16.0, right: 16),
                  child: BlocBuilder<LiveContentsBloc, LiveStates>(
                      cubit: liveContentsBloc,
                      builder: (context, state) {
                        if (state is LoadLiveVideoListSuccess &&
                            state.liveContents.isNotEmpty) {
                          return LiveVideoList(state.liveContents);
                        } else {
                          return Container();
                        }
                      })),
              //PopularSearchBlock()
            ],
          ),
        ),
      ),
    );
  }
}
