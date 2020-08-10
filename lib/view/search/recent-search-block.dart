import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/search-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/search-bloc.dart';
import 'package:tienda/bloc/states/search-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/product-list-page.dart';

class RecentSearchBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchHistoryBloc, SearchStates>(
        bloc: SearchHistoryBloc()..add(LoadSearchHistory()),
        builder: (context, state) {
          if (state is LoadSearchHistoryComplete)
            return state.searchHistoryResponse.history.isNotEmpty
                ? Container(
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                              itemCount:
                                  state.searchHistoryResponse.history.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext cxt, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      ///fetch products with recent search as query
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
                                                                  query: state
                                                                      .searchHistoryResponse
                                                                      .history[
                                                                          index]
                                                                      .query)),
                                                      )
                                                    ],
                                                    child: ProductListPage(
                                                      title: state
                                                          .searchHistoryResponse
                                                          .history[index]
                                                          .query,
                                                      query: state
                                                          .searchHistoryResponse
                                                          .history[index]
                                                          .query,
                                                      searchBody:
                                                          new SearchBody(),
                                                    ),
                                                  )));
                                    },
                                    child: Container(
                                      width: 120,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                              height: 160,
                                              width: 120,
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                state.searchHistoryResponse
                                                    .history[index].query,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  )
                : Container();
          else
            return Container();
        });
  }
}
