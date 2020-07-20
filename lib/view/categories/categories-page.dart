
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/category-bloc.dart';
import 'package:tienda/bloc/events/category-events.dart';
import 'package:tienda/bloc/states/category-states.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/view/products/product-list-page.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final selectedCategoryIndex = BehaviorSubject<int>();

  CategoryBlock categoryBlock = new CategoryBlock();

  bool tapActionPlaced = false;

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
        print("CONSUMER CALLED");
        categoryBlock.add(LoadCategories());
        return MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBlock>(
                  create: (BuildContext context) => categoryBlock),
            ],
            child: BlocBuilder<CategoryBlock, CategoryStates>(
                builder: (context, state) {
              if (state is LoadCategoriesSuccess)
                return Container(
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
                                  alignment: Alignment.center,
                                  color: Colors.grey[200],
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  width: MediaQuery.of(context).size.width / 4 +
                                      40,
                                  child: ListView.builder(
                                      itemCount: state.categories.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              tapActionPlaced = true;
                                              selectedCategoryIndex.add(index);

                                              itemScrollController
                                                  .scrollTo(
                                                      index: index,
                                                      duration:
                                                          Duration(seconds: 2),
                                                      curve:
                                                          Curves.easeInOutCubic)
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
                                                                color:
                                                                    Colors.blue,
                                                                width: 4))
                                                        : null),
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  appLanguage.appLocal ==
                                                          Locale('en')
                                                      ? state.categories[index]
                                                          .nameEn
                                                      : state.categories[index]
                                                          .nameAr,
                                                  style:
                                                      TextStyle(fontSize: 16),
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
                              selectedCategoryIndex.add(itemPositionsListener
                                  .itemPositions.value.last.index);
                              return true;
                            }

                            return false;
                          },
                          child: ScrollablePositionedList.builder(
                            padding: EdgeInsets.only(top: 50),
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) => Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
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

                                              child: ExpansionTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  radius: 20,
                                                ),
                                                backgroundColor: Colors.white,
                                                children: _buildSubSubCategory(
                                                    state
                                                        .categories[index]
                                                        .subCats[subIndex]
                                                        .thirdLevel),
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
                                                            .nameAr,style: TextStyle(
                                                  fontSize: 13
                                                ),),
                                              )
//                                          child: Row(
//                                            children: <Widget>[
//                                              CircleAvatar(
//                                                backgroundColor: Colors.grey[200],
//                                                radius: 30,
//                                              ),
//                                              Padding(
//                                                padding: const EdgeInsets.only(
//                                                    left: 8.0, right: 8.0),
//                                                child: Column(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment.center,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(appLanguage.appLocal ==
//                                                            Locale('en')
//                                                        ? state
//                                                            .categories[index]
//                                                            .nameEnglish
//                                                        : state
//                                                            .categories[index]
//                                                            .nameArabic),
//
//                                                  ],
//                                                ),
//                                              ),
//                                            ],
//                                          ),
                                              ),
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
                );
              else
                return Container();
            }));
      },
    );
  }

  _buildSubSubCategory(List<SubSubCat> thirdLevelCategory) {
    List<Widget> widgets = new List();
    for (int i = 0; i < thirdLevelCategory.length; ++i) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductListPage(
                        categoryId: thirdLevelCategory[i].id.toString(),
                      )),
            );
          },
          child: Card(
              elevation: 0,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  thirdLevelCategory[i].nameEn,
                  style: TextStyle(fontSize: 14),
                ),
              )),
        ),
      ));
    }
    return widgets;
  }
}
