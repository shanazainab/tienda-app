import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/single-product-bloc.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/view/products/add-customer-review-container.dart';
import 'package:tienda/view/products/color-chart-container.dart';
import 'package:tienda/view/products/customer-overall-rating-block.dart';
import 'package:tienda/view/products/customer-reviews-container.dart';
import 'package:tienda/view/products/product-description-container.dart';
import 'package:tienda/view/products/product-info-container.dart';
import 'package:tienda/view/products/size-chart-container.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class SingleProductPage extends StatefulWidget {
  final int productId;

  SingleProductPage(this.productId);

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  SingleProductBloc singleProductBloc = new SingleProductBloc();

  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleProductBloc.add(FetchProductDetails(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => singleProductBloc,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(44.0), // here the desired height
                child: CustomAppBar(
                  title: "",
                  showWishList: true,
                  showSearch: false,
                  showCart: true,
                  showNotification: false,
                  showLogo: false,
                )),
            bottomNavigationBar: BlocBuilder<SingleProductBloc, ProductStates>(
                builder: (context, state) {
              if (state is FetchProductDetailsSuccess) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        onPressed: () {},
                        child: Text("WISHLIST"),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context).add(AddCartItem(
                              cartItem: new CartItem(
                                  color: null,
                                  product: state.product,
                                  quantity: 1,
                                  size: null)));
                        },
                        child: Text("ADD TO BAG"),
                      ),
                    ),
                  ],
                );
              } else
                return Container();
            }),
            body: BlocBuilder<SingleProductBloc, ProductStates>(
                builder: (context, state) {
              if (state is FetchProductDetailsSuccess) {
                return Container(
                  color: Colors.grey[200],
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            height: 430,
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  autoPlay: true,
                                  height: 430,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              items: state.product.images
                                  .map((item) => Container(
                                        child: CachedNetworkImage(
                                          imageUrl: item,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
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
                                      ))
                                  .toList(),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: state.product.images.map((url) {
                                int index = state.product.images.indexOf(url);
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Colors.grey
                                        : Colors.grey[200],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      ProductInfoContainer(state.product),
                      SizedBox(
                        height: 10,
                      ),
//                      SizeChartContainer(),
//                      SizedBox(
//                        height: 10,
//                      ),
//                      ColorChartContainer(),
                      SizedBox(
                        height: 10,
                      ),
                      ProductDescriptionContainer(state.product),
                      SizedBox(
                        height: 10,
                      ),
                      CustomerOverallRatingBlock(state.product.overallRating,state.product.ratings),
                      SizedBox(
                        height: 10,
                      ),
                      AddCustomerReviewContainer(),
                      SizedBox(
                        height: 10,
                      ),
                      CustomerReviewContainer(state.product.reviews),
                    ],
                  ),
                );
              } else
                return Container();
            })));
  }
}
