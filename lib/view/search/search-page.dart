import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/search-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/search-bloc.dart';
import 'package:tienda/bloc/states/search-states.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/product-list-page.dart';
import 'package:tienda/view/search/search-autocomplete.dart';
import 'package:tienda/view/search/search-home-container.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode searchFocus = new FocusNode();

  SearchBloc searchBloc = new SearchBloc();

  TextEditingController searchTextController = new TextEditingController();

  PanelController panelController = new PanelController();

  PreferenceBloc preferenceBloc = new PreferenceBloc();

  LiveContentsBloc liveContentsBloc = new LiveContentsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    preferenceBloc.add(FetchPreferredCategoryList());
    searchTextController.addListener(() {
      print("TEXT INPUT:${searchTextController.text}");
      if (searchTextController.text.length > 1)
        searchBloc..add(ProductSearchAutocomplete(searchTextController.text));
      if (searchTextController.text.length < 1)
        searchBloc..add(StopSuggestions());
    });
    liveContentsBloc.add(LoadLiveVideoList());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: TextField(
              focusNode: searchFocus,
              controller: searchTextController,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                print(value);
                handleProductSearch(value);
              },
              decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                    child: SvgPicture.asset(
                      "assets/svg/search.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                  // prefix:SvgPicture.asset(
                  //   "assets/svg/search.svg",
                  //   height: 20,
                  //   width: 20,
                  // ) ,

                  prefixIconConstraints: BoxConstraints(
                    minHeight: 20,
                    minWidth: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(color: Color(0xffeef2f3))),
                  isDense: true,
                  fillColor: Color(0xffeef2f3),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(color: Color(0xffeef2f3))),
                  focusColor: Color(0xffeef2f3),
                  hintText: 'Presenters, Products, Categories',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xff010d10),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
        body: BlocListener<SearchBloc, SearchStates>(
          cubit: searchBloc,
          listener: (context, state) {
            if (state is ProductSearchAutoCompleteSuccess) {
              panelController.open();
            } else
              panelController.close();
          },
          child: Stack(
            children: <Widget>[
              SearchHomeContainer(
                preferenceBloc,
                liveContentsBloc,
                onScroll: (status) {
                  print("CALLBACK RECEIVED");

                  if (status == "START") searchFocus.unfocus();
                },
              ),
              BlocBuilder<SearchBloc, SearchStates>(
                  cubit: searchBloc,
                  builder: (context, state) {
                    if (state is ProductSearchAutoCompleteSuccess)
                      return Align(
                        alignment: Alignment.topCenter,
                        child: SlidingUpPanel(
                          controller: panelController,
                          minHeight: 0,
                          maxHeight: 250,
                          slideDirection: SlideDirection.DOWN,
                          panel: SearchAutoComplete(state.suggestions, (value) {
                            if (true) {
                              panelController.close();
                              searchTextController.clear();
                              searchFocus.unfocus();
                            }
                          }),
                        ),
                      );
                    else
                      return Align(
                        alignment: Alignment.topCenter,
                        child: SlidingUpPanel(
                          controller: panelController,
                          minHeight: 0,
                          maxHeight: MediaQuery.of(context).size.height,
                          slideDirection: SlideDirection.DOWN,
                          panel: SearchAutoComplete(new List(), (value) {
                            if (true) {
                              panelController.close();
                              searchTextController.clear();
                              searchFocus.unfocus();
                            }
                          }),
                        ),
                      );
                  }),
            ],
          ),
        ));
  }

  void handleImageSearchQuery(File image) {
    //new MLController().createImageLabels(image);
  }

  void handleProductSearch(String text) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<FilterBloc>(
                      create: (BuildContext context) => FilterBloc(),
                    ),
                    BlocProvider(
                      create: (BuildContext context) =>
                          ProductBloc()..add(FetchProductList(query: text)),
                    )
                  ],
                  child: ProductListPage(
                    titleInEnglish: text,
                    query: text,
                    searchBody: new SearchBody(),
                  ),
                )));
  }
}
