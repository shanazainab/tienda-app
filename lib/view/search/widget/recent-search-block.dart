import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/search/search-bloc.dart';
import 'package:tienda/bloc/search/search-events.dart';
import 'package:tienda/bloc/search/search-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/search-result/product-list-page.dart';

class RecentSearchBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchHistoryBloc, SearchStates>(
        cubit: SearchHistoryBloc()..add(LoadSearchHistory()),
        builder: (context, state) {
          if (state is LoadSearchHistoryComplete)
            return state.searchHistoryResponse.history.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("recent-searches"),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            color: Color(0xffeef2f3),
                            indent: 16,
                            endIndent: 16,
                          ),
                          shrinkWrap: true,
                          itemCount: state.searchHistoryResponse.history.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 16.0, right: 16),
                            child: GestureDetector(
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
                                                            query: state
                                                                .searchHistoryResponse
                                                                .history[index]
                                                                .query)),
                                                )
                                              ],
                                              child: ProductListPage(
                                                titleInEnglish: state
                                                    .searchHistoryResponse
                                                    .history[index]
                                                    .query,
                                                query: state
                                                    .searchHistoryResponse
                                                    .history[index]
                                                    .query,
                                                searchBody: new SearchBody(),
                                              ),
                                            )));
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(state.searchHistoryResponse
                                    .history[index].query),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          else
            return Container();
        });
  }
}
