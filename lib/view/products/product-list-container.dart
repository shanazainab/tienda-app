import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product-list-response.dart' as PLR;
import 'package:tienda/model/search-body.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/products/single-product-page.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductListContainer extends StatelessWidget {
  final PLR.ProductListResponse productListResponse;

  final ScrollController scrollController = new ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final showProductCount = BehaviorSubject<bool>();

  final String query;
  final SearchBody searchBody;

  ProductListContainer(this.productListResponse, this.query, {this.searchBody});

  @override
  Widget build(BuildContext context) {

    var appLanguage = Provider.of<AppLanguage>(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = CircularProgressIndicator(
                  strokeWidth: 2,
                );
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
            ///from category
            if (productListResponse.navigator != null)
              BlocProvider.of<ProductBloc>(context).add(FetchMoreProductList(
                  products: productListResponse.products,
                  query: query,
                  searchBody: searchBody,
                  pageNumber: productListResponse.navigator.nextPage));

            print("LOADING");
            _refreshController.loadComplete();
          },
          child: GridView.builder(
            padding: EdgeInsets.only(top: 70, bottom: 100),
            shrinkWrap: true,
            controller: scrollController
              ..addListener(() {
                if (scrollController.offset >=
                        20 &&
                    !scrollController.position.outOfRange) {
                  showProductCount.sink.add(true);
                  debugPrint("reach the top");
                }
                if (scrollController.offset <=
                        scrollController.position.minScrollExtent &&
                    !scrollController.position.outOfRange) {
                  showProductCount.sink.add(false);

                  debugPrint("reach the top");
                }
              }),
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: productListResponse.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    (appLanguage.appLocal == Locale("en") ? 280 : 300),
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Stack(
                  children: <Widget>[
                    new Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleProductPage(
                                          productListResponse
                                              .products[index].id)),
                                );
                              },
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: productListResponse
                                    .products[index].thumbnail,
                                width: MediaQuery.of(context).size.width / 2,
                                height: 220,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 4, left: 8, right: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              appLanguage.appLocal ==
                                                      Locale('en')
                                                  ? productListResponse
                                                      .products[index].nameEn
                                                  : productListResponse
                                                      .products[index].nameAr,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "${AppLocalizations.of(context).translate("aed")} " +
                                                      productListResponse
                                                          .products[index].price
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                productListResponse
                                                            .products[index]
                                                            .discount !=
                                                        0
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4.0,
                                                                right: 4.0),
                                                        child: Text(
                                                          '${AppLocalizations.of(context).translate("aed")} ${productListResponse.products[index].price / productListResponse.products[index].discount * 100}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      )
                                                    : Container(),
                                                productListResponse
                                                            .products[index]
                                                            .discount !=
                                                        0
                                                    ? Container(
                                                        color: Colors.pink
                                                            .withOpacity(0.1),
                                                        child: Text(
                                                          '${productListResponse.products[index].discount}% OFF',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.pink),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),

                    ///overall rating
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          productListResponse.products[index].overallRating !=
                                  0.0
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        productListResponse
                                            .products[index].overallRating
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 14,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  FontAwesomeIcons.heart,
                                  size: 14,
                                  color: productListResponse.products[index]
                                                  .isWishListed !=
                                              null &&
                                          productListResponse
                                              .products[index].isWishListed
                                      ? Colors.pink
                                      : Colors.grey,
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  if (productListResponse
                                          .products[index].isWishListed ==
                                      null)
                                    productListResponse
                                        .products[index].isWishListed = true;
                                  else
                                    productListResponse
                                            .products[index].isWishListed =
                                        !productListResponse
                                            .products[index].isWishListed;

                                  if (productListResponse
                                      .products[index].isWishListed) {
                                    Fluttertoast.showToast(
                                        fontSize: 12,
                                        toastLength: Toast.LENGTH_LONG,
                                        msg: AppLocalizations.of(context)
                                            .translate("added-to-wishlist"),
                                        gravity: ToastGravity.BOTTOM);
                                    BlocProvider.of<WishListBloc>(context).add(
                                        AddToWishList(
                                            wishListItem: new WishListItem(
                                                product: productListResponse
                                                    .products[index])));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)
                                            .translate("removed-from-wishlist"),
                                        gravity: ToastGravity.BOTTOM);

                                    BlocProvider.of<WishListBloc>(context).add(
                                        DeleteWishListItem(
                                            wishListItem: new WishListItem(
                                                product: productListResponse
                                                    .products[index])));
                                  }

                                  context.bloc<ProductBloc>().add(
                                      UpdateMarkAsWishListed(
                                          productListResponse:
                                              productListResponse));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        StreamBuilder<bool>(
            stream: showProductCount,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data != null && snapshot.data)
                return Positioned(
                  top: 70,
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
                          "${productListResponse.productsCount} ${AppLocalizations.of(context).translate("products")}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                );
              return Container();
            }),
      ],
    );
  }
}

///staggered view if wanted
//            new StaggeredGridView.countBuilder(
//              padding: EdgeInsets.only(top:100,bottom: 100),
//              primary: false,
//              crossAxisCount: 4,
//              mainAxisSpacing: 4.0,
//              crossAxisSpacing: 4.0,
//              itemCount: productListResponse.products.length,
//              itemBuilder: (BuildContext context, int index) => Stack(
//                children: <Widget>[
//                  new Container(
//                      color: Colors.white,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          GestureDetector(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => SingleProductPage(
//                                        productListResponse
//                                            .products[index].id)),
//                              );
//                            },
//                            child: CachedNetworkImage(
//                              imageUrl:
//                                  productListResponse.products[index].thumbnail,
//                              width: MediaQuery.of(context).size.width / 2,
//                              height: index/ 2 == 0?220:index/3==0?200:290,
//                              fit: BoxFit.cover,
//                              placeholder: (context, url) => Container(
//                                height: index/ 2 == 0?220:index/3==0?200:290,
//                                color: Color(0xfff2f2e4),
//                              ),
//                              errorWidget: (context, url, error) => Container(
//                                height: index/ 2 == 0?220:index/3==0?200:290,
//                                color: Color(0xfff2f2e4),
//                              ),
//                            ),
//                          ),
//                          Container(
//                            child: Padding(
//                              padding: const EdgeInsets.only(
//                                  top: 8, bottom: 4, left: 8, right: 8),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Flexible(
//                                        child: Text(
//                                          appLanguage.appLocal == Locale('en')
//                                              ? productListResponse
//                                                  .products[index].nameEn
//                                              : productListResponse
//                                                  .products[index].nameAr,
//                                          overflow: TextOverflow.ellipsis,
//                                          softWrap: false,
//                                          maxLines: 1,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                  Padding(
//                                      padding:
//                                          const EdgeInsets.only(top: 4.0),
//                                      child: FittedBox(
//                                        fit: BoxFit.fitWidth,
//                                        child: Row(
//                                          children: <Widget>[
//                                            Text(
//                                              "${AppLocalizations.of(context).translate("aed")} " +
//                                                  productListResponse
//                                                      .products[index].price
//                                                      .toString(),
//                                              style: TextStyle(
//                                                  fontWeight:
//                                                      FontWeight.w700),
//                                            ),
//                                            productListResponse
//                                                        .products[index]
//                                                        .discount !=
//                                                    0
//                                                ? Padding(
//                                                    padding:
//                                                        const EdgeInsets.only(
//                                                            left: 4.0,
//                                                            right: 4.0),
//                                                    child: Text(
//                                                      '${AppLocalizations.of(context).translate("aed")} ${productListResponse.products[index].price / productListResponse.products[index].discount * 100}',
//                                                      style: TextStyle(
//                                                          decoration:
//                                                              TextDecoration
//                                                                  .lineThrough),
//                                                    ),
//                                                  )
//                                                : Container(),
//                                            productListResponse
//                                                        .products[index]
//                                                        .discount !=
//                                                    0
//                                                ? Container(
//                                                    color: Colors.pink
//                                                        .withOpacity(0.1),
//                                                    child: Text(
//                                                      '${productListResponse.products[index].discount}% OFF',
//                                                      style: TextStyle(
//                                                          color: Colors.pink),
//                                                    ),
//                                                  )
//                                                : Container(),
//                                          ],
//                                        ),
//                                      ))
//                                ],
//                              ),
//                            ),
//                          )
//                        ],
//                      )),
//
//                  ///overall rating
//                  Align(
//                    alignment: Alignment.topRight,
//                    child: Column(
//                      mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: [
//                        productListResponse.products[index].overallRating != 0.0
//                            ? Padding(
//                                padding: const EdgeInsets.all(4.0),
//                                child: Row(
//                                  mainAxisSize: MainAxisSize.min,
//                                  children: <Widget>[
//                                    Text(
//                                      productListResponse
//                                          .products[index].overallRating
//                                          .toString(),
//                                      style: TextStyle(
//                                          color: Colors.grey, fontSize: 12),
//                                    ),
//                                    Icon(
//                                      Icons.star,
//                                      size: 14,
//                                      color: Colors.grey,
//                                    ),
//                                  ],
//                                ),
//                              )
//                            : Container(),
//                        Padding(
//                          padding: const EdgeInsets.all(4.0),
//                          child: CircleAvatar(
//                            backgroundColor: Colors.white,
//                            radius: 14,
//                            child: IconButton(
//                              padding: EdgeInsets.zero,
//                              icon: Icon(
//                                FontAwesomeIcons.heart,
//                                size: 14,
//                                color: productListResponse
//                                                .products[index].isWishListed !=
//                                            null &&
//                                        productListResponse
//                                            .products[index].isWishListed
//                                    ? Colors.pink
//                                    : Colors.grey,
//                              ),
//                              color: Colors.white,
//                              onPressed: () {
//                                if (productListResponse
//                                        .products[index].isWishListed ==
//                                    null)
//                                  productListResponse
//                                      .products[index].isWishListed = true;
//                                else
//                                  productListResponse
//                                          .products[index].isWishListed =
//                                      !productListResponse
//                                          .products[index].isWishListed;
//
//                                if (productListResponse
//                                    .products[index].isWishListed) {
//                                  Fluttertoast.showToast(
//                                      fontSize: 12,
//                                      toastLength: Toast.LENGTH_LONG,
//                                      msg: AppLocalizations.of(context)
//                                          .translate("added-to-wishlist"),
//                                      gravity: ToastGravity.BOTTOM);
//                                  BlocProvider.of<WishListBloc>(context).add(
//                                      AddToWishList(
//                                          wishListItem: new WishListItem(
//                                              product: productListResponse
//                                                  .products[index])));
//                                } else {
//                                  Fluttertoast.showToast(
//                                      msg: AppLocalizations.of(context)
//                                          .translate("removed-from-wishlist"),
//                                      gravity: ToastGravity.BOTTOM);
//
//                                  BlocProvider.of<WishListBloc>(context).add(
//                                      DeleteWishListItem(
//                                          wishListItem: new WishListItem(
//                                              product: productListResponse
//                                                  .products[index])));
//                                }
//
//                                context.bloc<ProductBloc>().add(
//                                    UpdateMarkAsWishListed(
//                                        productListResponse:
//                                            productListResponse));
//                              },
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//              staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
//            )
