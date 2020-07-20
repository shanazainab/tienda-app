import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/product-list-response.dart' as PLR;
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/products/single-product-page.dart';

class ProductListContainer extends StatelessWidget {
  final PLR.ProductListResponse productListResponse;

  final ProductBloc productBloc;

  final ScrollController scrollController = new ScrollController();

  final showProductsCount = new BehaviorSubject<int>();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  ProductListContainer(this.productListResponse, this.productBloc);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: (info) {
            if (info is ScrollStartNotification) {
              print("SCROLL START");
              showProductsCount.sink.add(4);
            }
            return true;
          },
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,

            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),

            controller: _refreshController,
            onRefresh: () async {
              print("REFRESH");
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              productBloc.add(FetchMoreProductList(
                products: productListResponse.products,
                  categoryId: productListResponse.catId.toString(),
                  pageNumber: productListResponse.navigator.nextPage));
              print("LOADING");
              _refreshController.loadComplete();
            },
            child: GridView.builder(
              padding: EdgeInsets.only(top: 100),
              shrinkWrap: true,
              itemCount: productListResponse.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery
                      .of(context)
                      .size
                      .width /
                      (MediaQuery
                          .of(context)
                          .size
                          .height / 1.3),
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SingleProductPage(
                                          productListResponse.products[index].id)),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: productListResponse.products[index]
                                .thumbnail,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 2,
                            height: 180,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(
                                  height: 180,
                                  color: Color(0xfff2f2e4),
                                ),
                            errorWidget: (context, url, error) =>
                                Container(
                                  height: 180,
                                  color: Color(0xfff2f2e4),
                                ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 4, left: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        productListResponse
                                            .products[index].nameEn,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (productListResponse
                                              .products[index].isWishListed ==
                                              null)
                                            productListResponse.products[index]
                                                .isWishListed = true;
                                          else
                                            productListResponse
                                                .products[index].isWishListed =
                                            !productListResponse
                                                .products[index].isWishListed;

                                          if (productListResponse
                                              .products[index].isWishListed) {
                                            Fluttertoast.showToast(
                                                msg: "Added to wishlist",
                                                gravity: ToastGravity.BOTTOM);
                                            BlocProvider.of<WishListBloc>(
                                                context)
                                                .add(AddToWishList(
                                                wishListItem: new WishListItem(
                                                    product: productListResponse
                                                        .products[index])));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Removed from wishlist",
                                                gravity: ToastGravity.BOTTOM);

                                            BlocProvider.of<WishListBloc>(
                                                context)
                                                .add(DeleteWishListItem(
                                                wishListItem: new WishListItem(
                                                    product: productListResponse
                                                        .products[index])));
                                          }

                                          context.bloc<ProductBloc>().add(
                                              UpdateMarkAsWishListed(
                                                  productListResponse:
                                                  productListResponse));
                                        },
                                        child: Icon(
                                          Icons.bookmark,
                                          size: 18,
                                          color: productListResponse
                                              .products[index]
                                              .isWishListed !=
                                              null &&
                                              productListResponse
                                                  .products[index].isWishListed
                                              ? Colors.pink
                                              : Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: index == 0
                                        ? FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "AED " +
                                                productListResponse
                                                    .products[index].price
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Text(
                                              "AED " +
                                                  productListResponse
                                                      .products[index].price
                                                      .toString(),
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ),
                                          Text(
                                            "50 % OFF",
                                            style:
                                            TextStyle(color: Colors.pink),
                                          ),
                                        ],
                                      ),
                                    )
                                        : FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text("AED " +
                                          productListResponse
                                              .products[index].price
                                              .toString()),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
              },
            ),
          ),
        ),

        ///Product count
        StreamBuilder(
            stream: showProductsCount,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Positioned(
                  top: 100,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Colors.black.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 4, bottom: 4),
                        child: Text(
                          "PRODUCTS 1/2",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                );
              else
                return Container();
            }),
      ],
    );

//      Stack(
//      children: <Widget>[
//        NotificationListener<ScrollNotification>(
//          onNotification: (ScrollNotification scrollInfo) {
//            if (scrollInfo is ScrollStartNotification) {
//              showProductsCount.add(4);
//            }
//            if (scrollInfo.metrics.pixels ==
//                scrollInfo.metrics.maxScrollExtent) {
//              print("SCROLL END");
//            }
//            return true;
//          },
//          child: GridView.builder(
//            physics: NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            itemCount: productListResponse.products.length,
//            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                childAspectRatio: MediaQuery.of(context).size.width /
//                    (MediaQuery.of(context).size.height / 1.3),
//                crossAxisCount: 2),
//            itemBuilder: (BuildContext context, int index) {
//              return new Card(
//                  child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => SingleProductPage(
//                                productListResponse.products[index])),
//                      );
//                    },
//                    child: CachedNetworkImage(
//                      imageUrl: productListResponse.products[index].thumbnail,
//                      width: MediaQuery.of(context).size.width / 2,
//                      height: 180,
//                      fit: BoxFit.cover,
//                      placeholder: (context, url) => Container(
//                        height: 180,
//                        color: Color(0xfff2f2e4),
//                      ),
//                      errorWidget: (context, url, error) => Icon(Icons.error),
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            top: 8, bottom: 4, left: 8, right: 8),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Text(
//                                  productListResponse
//                                      .products[index].nameEnglish,
//                                  overflow: TextOverflow.fade,
//                                  softWrap: false,
//                                  maxLines: 1,
//                                ),
//                                GestureDetector(
//                                  onTap: () {
//                                    if (productListResponse
//                                            .products[index].isWishListed ==
//                                        null)
//                                      productListResponse
//                                          .products[index].isWishListed = true;
//                                    else
//                                      productListResponse
//                                              .products[index].isWishListed =
//                                          !productListResponse
//                                              .products[index].isWishListed;
//
//                                    if (productListResponse
//                                        .products[index].isWishListed) {
//                                      Fluttertoast.showToast(
//                                          msg: "Added to wishlist",
//                                          gravity: ToastGravity.BOTTOM);
//                                      BlocProvider.of<WishListBloc>(context)
//                                          .add(AddToWishList(
//                                              wishListItem: new WishListItem(
//                                                  product: productListResponse
//                                                      .products[index])));
//                                    } else {
//                                      Fluttertoast.showToast(
//                                          msg: "Removed from wishlist",
//                                          gravity: ToastGravity.BOTTOM);
//
//                                      BlocProvider.of<WishListBloc>(context)
//                                          .add(DeleteWishListItem(
//                                              wishListItem: new WishListItem(
//                                                  product: productListResponse
//                                                      .products[index])));
//                                    }
//
//                                    context.bloc<ProductBloc>().add(
//                                        UpdateMarkAsWishListed(
//                                            productListResponse:
//                                                productListResponse));
//                                  },
//                                  child: Icon(
//                                    Icons.bookmark,
//                                    size: 18,
//                                    color: productListResponse.products[index]
//                                                    .isWishListed !=
//                                                null &&
//                                            productListResponse
//                                                .products[index].isWishListed
//                                        ? Colors.pink
//                                        : Colors.grey,
//                                  ),
//                                )
//                              ],
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(top: 4.0),
//                              child: index == 0
//                                  ? FittedBox(
//                                      fit: BoxFit.fitWidth,
//                                      child: Row(
//                                        children: <Widget>[
//                                          Text(
//                                            "AED " +
//                                                productListResponse
//                                                    .products[index].price
//                                                    .toString(),
//                                            style: TextStyle(
//                                                fontWeight: FontWeight.bold),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.only(
//                                                left: 4.0, right: 4.0),
//                                            child: Text(
//                                              "AED " +
//                                                  productListResponse
//                                                      .products[index].price
//                                                      .toString(),
//                                              style: TextStyle(
//                                                  decoration: TextDecoration
//                                                      .lineThrough),
//                                            ),
//                                          ),
//                                          Text(
//                                            "50 % OFF",
//                                            style:
//                                                TextStyle(color: Colors.pink),
//                                          ),
//                                        ],
//                                      ),
//                                    )
//                                  : FittedBox(
//                                      fit: BoxFit.fitWidth,
//                                      child: Text("AED " +
//                                          productListResponse
//                                              .products[index].price
//                                              .toString()),
//                                    ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//              ));
//            },
//          ),
//        ),
//        StreamBuilder(
//            stream: showProductsCount,
//            builder: (context, snapshot) {
//              if (snapshot.hasData)
//                return Positioned(
//                  top: 100,
//                  child: Align(
//                    alignment: Alignment.topCenter,
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(16)),
//                      color: Colors.black.withOpacity(0.1),
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 16.0, right: 16, top: 4, bottom: 4),
//                        child: Text(
//                          "PRODUCTS 1/2",
//                          style: TextStyle(color: Colors.white, fontSize: 12),
//                        ),
//                      ),
//                    ),
//                  ),
//                );
//              else
//                return Container();
//            }),
//
//      ],
//    );
  }
}
