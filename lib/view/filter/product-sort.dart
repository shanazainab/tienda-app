import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/model/search-body.dart';

import '../../localization.dart';

class ProductSort extends StatelessWidget {
  final String query;

  final SearchBody searchBody;

  ProductSort(this.query, this.searchBody);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context).translate('sort-by'),
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            onTap: () {
              searchBody.sortBy = SearchBody.RATING_HIGH_LOW;
              BlocProvider.of<ProductBloc>(context)
                ..add(FetchFilteredProductList(
                    query: query, searchBody: searchBody));
              Navigator.of(context).pop();
            },
            title: Text(AppLocalizations.of(context).translate('rating')),
          ),
          ListTile(
            onTap: () {
              searchBody.sortBy = SearchBody.PRICE_LOW_HIGH;
              BlocProvider.of<ProductBloc>(context)
                ..add(FetchFilteredProductList(
                    query: query, searchBody: searchBody));
              Navigator.of(context).pop();
            },
            title: Text(
                AppLocalizations.of(context).translate('price-low-to-high')),
          ),
          ListTile(
            onTap: () {
              searchBody.sortBy = SearchBody.PRICE_HIGH_LOW;
              BlocProvider.of<ProductBloc>(context)
                ..add(FetchFilteredProductList(
                    query: query, searchBody: searchBody));
              Navigator.of(context).pop();
            },
            title: Text(
                AppLocalizations.of(context).translate('price-high-to-low')),
          )
        ],
      ),
    );
  }
}
