import 'dart:collection';

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
import 'package:tienda/view/home/home-page.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  PreferenceBloc preferenceBloc = new PreferenceBloc();

  String message = "Category Preference";

  Map<Category, bool> categoryPreferences = new HashMap();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferenceBloc.add(FetchCategoryList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreferenceBloc>(
        create: (context) => preferenceBloc,
        child: BlocListener<PreferenceBloc, PreferenceStates>(
            listener: (context, state) {
              if (state is LoadCategoryListSuccess) {
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
                  if (state is LoadCategoryListSuccess)
                    return Zoom(
                        opacityScrollBars: 0.0,
                        backgroundColor: Colors.white,
                        canvasColor: Colors.white,
                        centerOnScale: true,
                        enableScroll: true,
                        doubleTapZoom: true,
                        zoomSensibility: 2.3,
                        initZoom: 0.0,
                        width: 1000,
                        height: 1800,
                        child: Center(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(top: 500.0, bottom: 300),
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 6,
                            itemCount: state.categories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              onTap: () {
                                print("CHOOSEN");
                                categoryPreferences.update(
                                    state.categories[index],
                                    (value) => !categoryPreferences[
                                        state.categories[index]]);
                                setState(() {
                                  int count = 0;
                                  categoryPreferences.forEach((key, value) {
                                    if (value) ++count;
                                  });

                                  if (count == 5) {
                                   handleNext(context);
                                  }
                                  message = "Choose ${5 - count} more";
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    maxRadius: 120,
                                    backgroundColor: categoryPreferences[
                                                    state.categories[index]] !=
                                                null &&
                                            categoryPreferences[
                                                state.categories[index]]
                                        ? Colors.lightBlue
                                        : Colors.grey[200],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: new Text(
                                      state.categories[index].nameEnglish,
                                      style: TextStyle(
                                        fontSize: 36,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            staggeredTileBuilder: (int index) =>
                                new StaggeredTile.count(
                                    2, index.isEven ? 2 : 3),
                            mainAxisSpacing: 50.0,
                            crossAxisSpacing: 50.0,
                          ),
                        )));
                  else
                    return Container(
                      height: 0,
                    );
                }),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Text(
                        message,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ))));
  }

  void handleNext(context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/categorySelectionPage"));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
