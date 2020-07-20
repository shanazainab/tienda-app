import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/filter/product-filter.dart';
import 'package:tienda/view/filter/product-sort.dart';
import 'package:tienda/view/products/product-list-container.dart';
import 'package:tienda/view/products/single-product-page.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class ProductListPage extends StatefulWidget {
  final String categoryId;

  ProductListPage({this.categoryId});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductBloc productBloc = new ProductBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Logger().d("CATEGORY ID:${widget.categoryId}");
    productBloc.add(FetchProductList(categoryId: widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => productBloc,
        child: BlocListener<WishListBloc, WishListStates>(
            listener: (context, state) {
              if (state is AuthorizationFailed) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginMainPage()),
                );
              }
            },
            child: DefaultTabController(
                length: 2,
                child: Scaffold(
                    extendBodyBehindAppBar: true,
                    bottomNavigationBar: Column(
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
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ProductSort();
                                      });
                                },
                                child: Text("Sort"),
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
                                        builder: (context) => ProductFilter()),
                                  );
                                },
                                child: Text("Filter"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
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
                            ProductListContainer(state.productListResponse,productBloc),
                            ProductListContainer(state.productListResponse,productBloc)
                          ],
                        );
                      }
                      if (state is UpdateProductListSuccess) {
                        return TabBarView(
                          children: [
                            ProductListContainer(state.productListResponse,productBloc),
                            ProductListContainer(state.productListResponse,productBloc)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    })))));
  }


}
