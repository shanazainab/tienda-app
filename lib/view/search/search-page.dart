import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/search-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/search-bloc.dart';
import 'package:tienda/bloc/states/search-states.dart';
import 'package:tienda/controller/ml-controller.dart';

import 'package:tienda/localization.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/product-list-page.dart';
import 'package:tienda/view/search/search-autocomplete.dart';
import 'package:tienda/view/widgets/image-option-dialogue.dart';

import 'package:tienda/view/search/search-home-container.dart';
import 'package:tienda/view/search/voice-search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode searchFocus = new FocusNode();

  SearchBloc searchBloc = new SearchBloc();

  TextEditingController searchTextController = new TextEditingController();

  PanelController panelController = new PanelController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchTextController.addListener(() {
      print("TEXT INPUT:${searchTextController.text}");
      if (searchTextController.text.length > 1)
        searchBloc..add(ProductSearchAutocomplete(searchTextController.text));
      if (searchTextController.text.length < 1)
        searchBloc..add(StopSuggestions());
    });
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
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                  contentPadding: EdgeInsets.all(8),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200])),
                  isDense: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200])),
                  focusColor: Colors.grey[200],
                  hintText: AppLocalizations.of(context)
                      .translate("search-for-brands-and-products"),
                  hintStyle: TextStyle(fontSize: 12),
                  border: InputBorder.none),
            ),
          ),
          actions: <Widget>[
            IconButton(
              constraints: BoxConstraints.tight(Size.square(40)),
              padding: EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                searchFocus.unfocus();
                // showModalBottomSheet(
                //     context: context,
                //     builder: (BuildContext bc) {
                //       return VoiceSearch(
                //         onVoiceInput: (input) {
                //           searchTextController.text = input;
                //         },
                //       );
                //     });
              },
              icon: Icon(
                Icons.keyboard_voice,
                size: 22,
              ),
            ),
            IconButton(
              constraints: BoxConstraints.tight(Size.square(40)),
              padding: EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                searchFocus.unfocus();
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return ImageOptionDialogue(
                        selectedImage: (image) {
                          handleImageSearchQuery(image);
                        },
                      );
                    });
              },
              icon: Icon(
                Icons.camera_alt,
                size: 22,
              ),
            ),
            SizedBox(
              width: 8,
            )
          ],
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
                          maxHeight: 250,
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
