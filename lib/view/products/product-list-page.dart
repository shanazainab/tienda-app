import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:tienda/view/products/single-product-page.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductBloc productBloc = new ProductBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBloc.add(FetchProductList());
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
                            showProductList(state.products),
                            showProductList(state.products)
                          ],
                        );
                      }
                      if (state is UpdateProductListSuccess) {
                        return TabBarView(
                          children: [
                            showProductList(state.products),
                            showProductList(state.products)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    })))));
  }

  showProductList(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.3),
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
                            SingleProductPage(products[index])),
                  );
                },
                child: Image.asset(
                  'assets/images/image1.jpg',
                  height: 180,
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.cover,
                )

//              CachedNetworkImage(
//
//                imageUrl: products[index].thumbnail,
//                width: MediaQuery.of(context).size.width / 2,
//                height: 180,
//                fit: BoxFit.cover,
//                placeholder: (context, url) => Container(
//                  height: 180,
//                  color: Color(0xfff2f2e4),
//                ),
//                errorWidget: (context, url, error) => Icon(Icons.error),
//              ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Brand"),
                          GestureDetector(
                            onTap: () {
                              if (products[index].isWishListed == null)
                                products[index].isWishListed = true;
                              else
                                products[index].isWishListed =
                                    !products[index].isWishListed;

                              if (products[index].isWishListed) {
                                Fluttertoast.showToast(
                                    msg: "Added to wishlist",
                                    gravity: ToastGravity.BOTTOM);
                                BlocProvider.of<WishListBloc>(context).add(
                                    AddToWishList(
                                        wishListItem: new WishListItem(
                                            product: products[index])));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Removed from wishlist",
                                    gravity: ToastGravity.BOTTOM);

                                BlocProvider.of<WishListBloc>(context).add(
                                    DeleteWishListItem(
                                        wishListItem: new WishListItem(
                                            product: products[index])));
                              }

                              context
                                  .bloc<ProductBloc>()
                                  .add(UpdateMarkAsWishListed(
                                    products: products,
                                  ));
                            },
                            child: Icon(
                              Icons.bookmark,
                              size: 18,
                              color: products[index].isWishListed != null &&
                                      products[index].isWishListed
                                  ? Colors.pink
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "product.nameEnglish",
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: index == 0
                            ? FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "AED " + products[index].price.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 4.0),
                                      child: Text(
                                        "AED " +
                                            products[index].price.toString(),
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Text(
                                      "50 % OFF",
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                  ],
                                ),
                              )
                            : FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                    "AED " + products[index].price.toString()),
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
    );
  }
}
