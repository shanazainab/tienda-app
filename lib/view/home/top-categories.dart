import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/product-list-page.dart';

class TopCategories extends StatelessWidget {
  final List<Category> topCategories;

  TopCategories(this.topCategories);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    List<Category> splitListOne = new List();
    List<Category> splitListTwo = new List();

    if (topCategories.length > 7) {
      int roundSplit = (topCategories.length / 2).round();
      for (int index = 0; index < topCategories.length; ++index) {
        if (index < roundSplit || index == roundSplit)
          splitListOne.add(topCategories[index]);
        else
          splitListTwo.add(topCategories[index]);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Now Trending",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<BottomNavBarBloc>(context)
                      .add(ChangeBottomNavBarState(1,true));
                },
                child: Text("See All".toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      color: Color(0xffc30045),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),

          splitListOne.isNotEmpty
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                              providers: [
                                                BlocProvider<FilterBloc>(
                                                  create:
                                                      (BuildContext context) =>
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
                                                                category:
                                                                    splitListOne[
                                                                            index]
                                                                        .id))),
                                                )
                                              ],
                                              child: ProductListPage(
                                                titleInEnglish:
                                                    splitListOne[index].nameEn,
                                                titleInArabic:
                                                    splitListOne[index].nameAr,
                                                query: 'get_category',
                                                searchBody: new SearchBody(
                                                    category:
                                                        splitListOne[index].id),
                                              ))));
                            },
                            child: Card(
                                elevation: 0,
                                color: Color(0xFFF2F3F5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(39)),
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
                                        splitListOne[index].nameEn,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          itemCount: splitListOne.length,
                        ),
                      ),
                      Container(
                        height: 45,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              Card(
                                  elevation: 0,
                                  color: Color(0xFFF2F3F5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(39)),
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
                                          splitListTwo[index].nameEn,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )),
                          itemCount: splitListTwo.length,
                        ),
                      )
                    ],
                  ),
                )
              : Wrap(
                  children: getWidgetList(),
                ),

          ///Gridview solution
          // SizedBox(
          //   height: 100,
          //   width: 500,
          //   child: StaggeredGridView.countBuilder(
          //     crossAxisCount: 2,
          //     itemCount: topCategories.length,
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (BuildContext context, int index) => Card(
          //         elevation: 0,
          //         color: Color(0xFFF2F3F5),
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(39)),
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //               left: 16.0, right: 16.0, top: 10, bottom: 10),
          //           child: Row(
          //             children: [
          //               SvgPicture.asset(
          //                 "assets/svg/chat.svg",
          //                 height: 12,
          //                 width: 12,
          //               ),
          //               SizedBox(
          //                 width: 6,
          //               ),
          //               Text(
          //                 topCategories[index].nameEn,
          //                 style: TextStyle(fontSize: 14),
          //               ),
          //             ],
          //           ),
          //         )),
          //     staggeredTileBuilder: (int index) =>
          //     new StaggeredTile.count(
          //         1, topCategories[index].nameEn.length > 6 ? topCategories[index].nameEn.length> 12?3.5:2.6 : 1.7),
          //     mainAxisSpacing: 4.0,
          //     crossAxisSpacing: 4.0,
          //   ),
          // ),
        ],
      ),
    );
  }

  getWidgetList() {
    List<Widget> widgets = new List();

    for (final category in topCategories) {
      widgets.add(Card(
          elevation: 0,
          color: Color(0xFFF2F3F5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(39)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                  category.nameEn,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          )));
    }

    return widgets;
  }
}
