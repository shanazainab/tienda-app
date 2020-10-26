import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/category-bloc.dart';
import 'package:tienda/bloc/events/category-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/category-states.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/search-result/product-list-page.dart';
import 'package:tienda/view/widgets/loading-widget.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin<CategoriesPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final selectedCategoryIndex = BehaviorSubject<int>();

  CategoryBlock categoryBlock = new CategoryBlock();

  bool tapActionPlaced = false;

  ScrollController mainCategoryScroll = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryBlock.add(LoadCategories());

    selectedCategoryIndex.add(0);
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    print("CATEGORY BUILD");
    return Consumer<AppLanguage>(
      builder: (context, cart, child) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBlock>(
                  create: (BuildContext context) => categoryBlock),
            ],
            child: BlocBuilder<CategoryBlock, CategoryStates>(
                builder: (context, state) {
              if (state is LoadCategoriesSuccess)
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        StreamBuilder<int>(
                            stream: selectedCategoryIndex,
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                  child: Container(
                                    color: Colors.grey[200],
                                    width:
                                        MediaQuery.of(context).size.width / 4 +
                                            40,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: mainCategoryScroll,
                                        itemCount: state.categories.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                tapActionPlaced = true;
                                                selectedCategoryIndex
                                                    .add(index);

                                                itemScrollController
                                                    .scrollTo(
                                                        index: index,
                                                        duration: Duration(
                                                            seconds: 2),
                                                        curve: Curves
                                                            .easeInOutCubic)
                                                    .then((value) {
                                                  tapActionPlaced = false;
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: snapshot.data ==
                                                              index
                                                          ? Border(
                                                              right: BorderSide(
                                                                  color: Color(0xffff2e63),
                                                                  width: 4))
                                                          : null),
                                                  height: 50,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16,
                                                            left: 16.0,
                                                            right: 16),
                                                    child: Text(
                                                      appLanguage.appLocal ==
                                                              Locale('en')
                                                          ? state
                                                              .categories[index]
                                                              .nameEn
                                                          : state
                                                              .categories[index]
                                                              .nameAr,
                                                    ),
                                                  )),
                                            ),
                                          );
                                        }),
                                  ));
                            }),
                        Container(
                          width: 3 * MediaQuery.of(context).size.width / 4 - 40,
                          child: NotificationListener(
                            onNotification: (value) {
                              if (value is ScrollUpdateNotification &&
                                  !tapActionPlaced) {
                                if (itemPositionsListener
                                        .itemPositions.value.last.index >
                                    5)
                                  mainCategoryScroll.animateTo(
                                    mainCategoryScroll.position.maxScrollExtent,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 300),
                                  );

                                selectedCategoryIndex.add(itemPositionsListener
                                    .itemPositions.value.last.index);
                                return true;
                              }

                              return false;
                            },
                            child: ScrollablePositionedList.builder(
                              padding: EdgeInsets.only(top: 20),
                              itemCount: state.categories.length,
                              itemBuilder: (context, index) => Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 16),
                                        child: Text(
                                          appLanguage.appLocal == Locale('en')
                                              ? state.categories[index].nameEn
                                              : state.categories[index].nameAr,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.all(0),
                                        itemCount: state
                                            .categories[index].subCats.length,
                                        itemBuilder: (BuildContext context,
                                                int subIndex) =>
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),

                                                ///DEVELOPER NOTE: expansion_tile.dart has been
                                                /// edited to fit the requirement
                                                ///Keep track on version update
                                                ///hide border and wrap elements

                                                child: ExpansionTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(state
                                                            .categories[index]
                                                            .thumbnail),
                                                    radius: 20,
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  children:
                                                      _buildSubSubCategory(
                                                          state
                                                              .categories[index]
                                                              .subCats[subIndex]
                                                              .thirdLevel,
                                                          appLanguage),
                                                  title: Text(
                                                    appLanguage.appLocal ==
                                                            Locale('en')
                                                        ? state
                                                            .categories[index]
                                                            .subCats[subIndex]
                                                            .nameEn
                                                        : state
                                                            .categories[index]
                                                            .subCats[subIndex]
                                                            .nameAr,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                )),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              else
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: spinKit
                  ),
                );
            }));
      },
    );
  }

  _buildSubSubCategory(List<SubSubCat> thirdLevelCategory, appLanguage) {
    List<Widget> widgets = new List();
    for (int i = 0; i < thirdLevelCategory.length; ++i) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<FilterBloc>(
                              create: (BuildContext context) => FilterBloc(),
                            ),
                            BlocProvider(
                              create: (BuildContext context) => ProductBloc()
                                ..add(FetchProductList(
                                    query: 'get_category',
                                    searchBody: SearchBody(
                                      categoryType: 'third',
                                        category: thirdLevelCategory[i].id))),
                            )
                          ],
                          child: ProductListPage(
                            titleInEnglish: thirdLevelCategory[i].nameEn,
                            titleInArabic: thirdLevelCategory[i].nameAr,
                            query: 'get_category',
                            searchBody: new SearchBody(
                              categoryType: 'third',
                                category: thirdLevelCategory[i].id),
                          ),
                        )));
          },
          child: Card(
              elevation: 0,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  appLanguage.appLocal == Locale('en')
                      ? thirdLevelCategory[i].nameEn
                      : thirdLevelCategory[i].nameAr,
                  style: TextStyle(fontSize: 14),
                ),
              )),
        ),
      ));
    }

    return widgets;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
