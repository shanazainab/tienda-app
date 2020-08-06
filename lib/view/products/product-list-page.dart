import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/filter-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';

import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/filter-states.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product-list-response.dart' as PLR;
import 'package:tienda/model/search-body.dart';

import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/filter/product-filter.dart';
import 'package:tienda/view/filter/product-sort.dart';
import 'package:tienda/view/products/product-list-container.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class ProductListPage extends StatefulWidget {
  final String query;
  final SearchBody searchBody;

  ProductListPage({this.query, this.searchBody});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contextA) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductStates>(listener: (context, state) {
            if (state is LoadProductListSuccess) {
              BlocProvider.of<FilterBloc>(context)
                  .add(LoadFilters(state.productListResponse.filters));
            }
          }),
          BlocListener<WishListBloc, WishListStates>(
              listener: (context, state) {
            if (state is AuthorizationFailed) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginMainPage()),
              );
            }
          })
        ],
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
                extendBodyBehindAppBar: true,
                bottomNavigationBar: BlocBuilder<FilterBloc, FilterStates>(
                    builder: (context, state) {
                  if (state is LoadFilterSuccess) {
                    return buildSortFilterMenu(state.filters, contextA);
                  } else
                    return Container();
                }),
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(80.0),
                    // here the desired height
                    child: CustomAppBar(
                      bottom: TabBar(
                        labelColor: Colors.lightBlue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.lightBlue,
                        tabs: [
                          Tab(
                            icon: Icon(Icons.line_style),
                          ),
                          Tab(icon: Icon(Icons.videocam)),
                        ],
                      ),
                      title: "Products",
                      showWishList: true,
                      showSearch: false,
                      showCart: true,
                      showLogo: false,
                    )),
                body: BlocBuilder<ProductBloc, ProductStates>(
                    builder: (context, state) {
                  if (state is LoadProductListSuccess) {
                    return TabBarView(
                      children: [
                        ProductListContainer(
                            state.productListResponse, widget.query,
                            searchBody: widget.searchBody),
                        Container(),
                      ],
                    );
                  }
                  if (state is UpdateProductListSuccess) {
                    return TabBarView(
                      children: [
                        ProductListContainer(
                          state.productListResponse,
                          widget.query,
                          searchBody: widget.searchBody,
                        ),
                        Container()
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.black,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }
                }))));
  }

  buildSortFilterMenu(List<PLR.Filter> filters, contextA) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: contextA,
                      builder: (BuildContext bc) {
                        return BlocProvider.value(
                            value: BlocProvider.of<ProductBloc>(contextA),
                            child:
                                ProductSort(widget.query, widget.searchBody));
                      });
                },
                child: Text(AppLocalizations.of(context).translate('sort')),
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                              value: BlocProvider.of<ProductBloc>(contextA),
                              child: ProductFilter(
                                filters,
                                widget.query,
                                searchBody: widget.searchBody,
                              ),
                            )),
                  );
                },
                child: Text(AppLocalizations.of(context).translate('filter')),
              ),
            )
          ],
        ),
      ],
    );
  }
}
