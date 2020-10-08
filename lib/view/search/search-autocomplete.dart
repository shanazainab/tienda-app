import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/model/suggestion-response.dart';
import 'package:tienda/view/products/product-list-page.dart';

typedef CloseSearchAutoComplete(bool);

class SearchAutoComplete extends StatelessWidget {
  final List<Suggestion> suggestions;

  final CloseSearchAutoComplete closeSearchAutoComplete;

  SearchAutoComplete(this.suggestions, this.closeSearchAutoComplete);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Color(0xffeef2f3),
        indent: 16,
        endIndent: 16,
      ),
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: GestureDetector(
          onTap: () {
            closeSearchAutoComplete(true);

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
                                    query: suggestions[index].suggestion)),
                            )
                          ],
                          child: ProductListPage(
                            titleInEnglish: suggestions[index].suggestion,
                            query: suggestions[index].suggestion,
                            searchBody: new SearchBody(),
                          ),
                        )));
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(suggestions[index].suggestion),
                Text(
                  suggestions[index].categoryEn,
                  style: TextStyle(
                      color: Color(0xFF50C0A8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
