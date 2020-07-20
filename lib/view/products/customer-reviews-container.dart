import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tienda/model/product.dart';

class CustomerReviewContainer extends StatelessWidget {
  List<Review> reviews;

  CustomerReviewContainer(this.reviews);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("CUSTOMER REVIEWS"),
            SizedBox(
              height: 16,
            ),
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => Divider(
                      indent: 8,
                      endIndent: 8,
                    ),
                shrinkWrap: true,
                itemCount: reviews.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(reviews[index].customerName),
                              Text(
                                reviews[index].elapsedTime,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(reviews[index].body,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left:20.0),
                                  child: Text(reviews[index].rating.toString()),
                                )
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 8,
                          ),
                          ///Image carousel
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                    )),
                          )
                        ],
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
