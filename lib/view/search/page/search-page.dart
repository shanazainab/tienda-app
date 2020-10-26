
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/search/search-bloc.dart';
import 'package:tienda/bloc/search/search-events.dart';
import 'package:tienda/bloc/search/search-states.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/search-result/product-list-page.dart';
import 'package:tienda/view/search/widget/recent-search-block.dart';
import 'package:tienda/view/search/widget/search-autocomplete.dart';
import 'package:tienda/view/search/widget/search-page-contents.dart';

class SearchPage extends StatelessWidget {
  final FocusNode searchFocus = new FocusNode();

  final TextEditingController searchTextController =
      new TextEditingController();

  final showRecentSearchController = new BehaviorSubject<bool>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showRecentSearchController.drain();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                focusNode: searchFocus,
                controller: searchTextController
                  ..addListener(() {
                    print("TEXT INPUT:${searchTextController.text}");
                    if (searchTextController.text.length > 1) {
                      BlocProvider.of<SearchBloc>(context)
                        ..add(ProductSearchAutocomplete(
                            searchTextController.text));
                      showRecentSearchController.sink.add(false);
                    }
                    if (searchTextController.text.length < 1) {
                      BlocProvider.of<SearchBloc>(context)
                        ..add(StopSuggestions());

                      ///user focus on search bar with nothing typed : show recent searches

                      showRecentSearchController.sink.add(true);
                    }
                  }),
                autofocus: false,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  print(value);
                  handleProductSearch(context, value);
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
          body: Stack(
            children: <Widget>[
              SearchPageContents(
                onScroll: (status) {
                  print("CALLBACK RECEIVED");

                  if (status == "START") searchFocus.unfocus();
                },
              ),
              BlocBuilder<SearchBloc, SearchStates>(builder: (context, state) {
                if (state is ProductSearchAutoCompleteSuccess)
                  return SearchAutoComplete(state.suggestions, (value) {
                    if (true) {
                      searchTextController.clear();
                      searchFocus.unfocus();
                    }
                  });
                else
                  return Container();
              }),
              StreamBuilder<bool>(
                  stream: showRecentSearchController,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data)
                      return RecentSearchBlock();
                    else
                      return Container();
                  })
            ],
          )),
    );
  }

  void handleProductSearch(context, String text) {
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
