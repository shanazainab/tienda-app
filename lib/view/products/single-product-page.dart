import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
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
  final Product product;

  SingleProductPage(this.product);

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  final List<String> imgList = [
    'assets/images/image1.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg'
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: Row(
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
                        product: widget.product,
                        quantity: 1,
                        size: null)));
              },
              child: Text("ADD TO BAG"),
            ),
          ),
        ],
      ),
      body: Container(
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
                    items: imgList
                        .map((item) => Container(
                              child: Image.asset(
                                item,
                                fit: BoxFit.cover,
                                width: 800,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.map((url) {
                      int index = imgList.indexOf(url);
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
            ProductInfoContainer(),
            SizedBox(
              height: 10,
            ),
            SizeChartContainer(),
            SizedBox(
              height: 10,
            ),
            ColorChartContainer(),
            SizedBox(
              height: 10,
            ),
            ProductDescriptionContainer(),
            SizedBox(
              height: 10,
            ),
            CustomerOverallRatingBlock(),
            SizedBox(
              height: 10,
            ),
            AddCustomerReviewContainer(),
            SizedBox(
              height: 10,
            ),
            CustomerReviewContainer(),
          ],
        ),
      ),
    );
  }
}
