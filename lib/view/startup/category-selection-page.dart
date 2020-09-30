import 'dart:collection';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/view/home/home-screen.dart';

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  PreferenceBloc preferenceBloc = new PreferenceBloc();

  String message = "Tell Us What You Are Looking for ";

  List<int> preferredCategoriesId = new List();
  List<String> preferredCategoriesNames = new List();

  Map<Category, bool> categoryPreferences = new HashMap();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferenceBloc.add(FetchPreferredCategoryList());
  }

  final transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreferenceBloc>(
        create: (context) => preferenceBloc,
        child: BlocListener<PreferenceBloc, PreferenceStates>(
            listener: (context, state) {
              if (state is LoadPreferredCategoryListSuccess) {
                for (final category in state.categories) {
                  categoryPreferences.putIfAbsent(category, () => false);
                }

                print(categoryPreferences);
              }
              setState(() {});
            },
            child: Scaffold(
                body: Stack(
              children: <Widget>[
                BlocBuilder<PreferenceBloc, PreferenceStates>(
                    builder: (context, state) {
                  if (state is LoadPreferredCategoryListSuccess)
                    return Center(
                      child: SizedBox(
                        height: 400,
                        child: InteractiveViewer(
                            boundaryMargin:
                                EdgeInsets.only(top: 100.0, bottom: 100),
                            transformationController: transformationController,

//                        minScale: 0.1,
//                        maxScale: 1.6,

                            // You can off zooming by setting scaleEnable to false
                            //scaleEnabled: false,
                            onInteractionStart: (_) =>
                                print("Interaction Started"),
                            onInteractionEnd: (details) {
                              setState(() {
                                transformationController.toScene(Offset.zero);
                              });
                            },
                            onInteractionUpdate: (_) =>
                                print("Interaction Updated"),
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              itemCount: state.categories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                onTap: () {
                                  ///add it to the list
                                  if (preferredCategoriesId
                                      .contains(state.categories[index].id)) {
                                    preferredCategoriesId.removeWhere(
                                        (element) =>
                                            element ==
                                            state.categories[index].id);
                                    preferredCategoriesNames.removeWhere(
                                        (element) =>
                                            element ==
                                            state.categories[index].nameEn);
                                  } else {
                                    preferredCategoriesNames
                                        .add(state.categories[index].nameEn);
                                    preferredCategoriesId
                                        .add(state.categories[index].id);
                                  }

                                  categoryPreferences.update(
                                      state.categories[index],
                                      (value) => !categoryPreferences[
                                          state.categories[index]]);
                                  int count = 0;
                                  setState(() {
                                    categoryPreferences.forEach((key, value) {
                                      if (value) ++count;
                                    });

                                    if (5 - count != 0)
                                      message = "${5 - count} more to go";
                                    else
                                      message = "";
                                  });
                                  if (count == 5) {
                                    handleNext(context);
                                  }
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Card(
                                        elevation: categoryPreferences[state
                                                        .categories[index]] !=
                                                    null &&
                                                categoryPreferences[
                                                    state.categories[index]]
                                            ? 8
                                            : 0,
                                        clipBehavior: Clip.antiAlias,
                                        child: CircleAvatar(
                                          maxRadius: 50.0,
                                          backgroundColor: Colors.grey[200],
                                          backgroundImage: NetworkImage(
                                            state.categories[index].thumbnail,
                                          ),
                                        ),
                                        shape: CircleBorder(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: new Text(
                                          state.categories[index].nameEn,
                                          style: TextStyle(
                                            color: categoryPreferences[
                                                            state.categories[
                                                                index]] !=
                                                        null &&
                                                    categoryPreferences[
                                                        state.categories[index]]
                                                ? Colors.lightBlue
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 2 : 1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            )),
                      ),
                    );
                  else
                    return Center(
                      child: SizedBox(
                        height: 400,
                        child: InteractiveViewer(
                            boundaryMargin:
                                EdgeInsets.only(top: 100.0, bottom: 100),
                            transformationController: transformationController,

//                        minScale: 0.1,
//                        maxScale: 1.6,

                            // You can off zooming by setting scaleEnable to false
                            //scaleEnabled: false,
                            onInteractionStart: (_) =>
                                print("Interaction Started"),
                            onInteractionEnd: (details) {
                              setState(() {
                                transformationController.toScene(Offset.zero);
                              });
                            },
                            onInteractionUpdate: (_) =>
                                print("Interaction Updated"),
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              itemCount: 8,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) =>
                                  Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Card(
                                      elevation: 0,
                                      clipBehavior: Clip.antiAlias,
                                      child: CircleAvatar(
                                        maxRadius: 50.0,
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      shape: CircleBorder(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: new Text(""),
                                    ),
                                  ],
                                ),
                              ),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 2 : 1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            )),
                      ),
                    );
                }),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 80.0, left: 16, right: 16),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )),
              ],
            ))));
  }

  void handleNext(context) async {
    ///log to firebase

    for (final categoryName in preferredCategoriesNames) {
      FirebaseAnalytics().logEvent(
          name: "CATEGORY_PREF", parameters: {'category_id': categoryName});
    }

    await Future.delayed(Duration(milliseconds: 500));
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/categorySelectionPage"));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}

class CustomBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
