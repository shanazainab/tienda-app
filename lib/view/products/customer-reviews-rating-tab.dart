import 'package:flutter/material.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/view/products/add-customer-review.dart';
import 'package:tienda/view/products/customer-reviews.dart';

class CustomerReviewRatingTab extends StatefulWidget {
  final Product product;

  CustomerReviewRatingTab(this.product);

  @override
  _CustomerReviewRatingTabState createState() =>
      _CustomerReviewRatingTabState();
}

class _CustomerReviewRatingTabState extends State<CustomerReviewRatingTab> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: TabBar(
                isScrollable: false,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                indicatorColor: Color(0xff50C0A8),
                labelColor: Color(0xff50C0A8),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0,
                ),
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0,
                ),
                tabs: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    child: Tab(
                      text: 'REVIEWS',
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Tab(
                        text: 'ADD REVIEW',
                      )),
                ],
              ),
            ),
            [
              CustomerReviews(
                product: widget.product,
              ),
              AddCustomerReviewContainer(
                widget.product.id,
              ),
            ][currentIndex],
          ],
        ),
      ),
    );
  }
}
