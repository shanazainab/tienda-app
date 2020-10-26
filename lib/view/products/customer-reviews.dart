import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/states/review-states.dart';
import 'package:tienda/model/product.dart' as PR;
import 'package:transparent_image/transparent_image.dart';

class CustomerReviews extends StatelessWidget {
  final PR.Product product;

  CustomerReviews({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (!product.isReviewed && product.isPurchased) ||
                    product.reviews.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: Text("Write a review",
                        style: TextStyle(
                          color: Color(0xff008c84),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        )),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${product.reviews.length} Total Reviews",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${product.overallRating}/5",
                        style: TextStyle(
                          color: Color(0xff333c3e),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        )),
                    SizedBox(
                      width: 2,
                    ),
                    RatingBar(
                      initialRating: product.overallRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Color(0xff50C0A8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ReviewBloc, ReviewStates>(builder: (context, state) {
              if (state is LoadReviewSuccess)
                return buildReviewContents(state.reviews, context);
              if (state is AddReviewSuccess)
                return buildReviewContents(state.newReviews, context);
              else
                return Container();
            })
          ],
        ),
      ),
    );
  }

  buildReviewContents(List<PR.Review> reviews, context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          reviews.isEmpty || (reviews.length == 1 && reviews[0].body == "")
              ? Container()
              : ListView.separated(
                  padding: EdgeInsets.all(0),
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                        indent: 8,
                        endIndent: 8,
                      ),
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  itemBuilder: (BuildContext context, int index) => reviews[
                                  index]
                              .body ==
                          ""
                      ? Container()
                      : Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(reviews[index].customerName),
                                          Text(
                                            reviews[index].elapsedTime,
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Card(
                                      color: Color(0xff50C0A8),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:14,left:8,right:8.0,bottom: 8.0),
                                        child:
                                            Text(reviews[index].rating.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Gotham',
                                                  color: Color(0xffffffff),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing: 0,
                                                )),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Flexible(
                                  child: Text(
                                    reviews[index].body,
                                    softWrap: true,
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              reviews[index].images != null
                                  ? SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: reviews[index].images.length,
                                        itemBuilder: (BuildContext context,
                                                int subIndex) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              color: Colors.grey[200],
                                              child: FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image:
                                                    "${GlobalConfiguration().getString("imageURL")}/${reviews[index].images[subIndex].image}",
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : Container(),
                              reviews[index].fileImages != null
                                  ? SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              reviews[index].fileImages.length,
                                          itemBuilder: (BuildContext context,
                                                  int subIndex) =>
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: reviews[index]
                                                                  .fileImages[
                                                              subIndex] !=
                                                          null
                                                      ? Container(
                                                          height: 40,
                                                          width: 40,
                                                          color: Colors.grey[200],
                                                          child: Image.file(
                                                            reviews[index]
                                                                    .fileImages[
                                                                subIndex],
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit.cover,
                                                          ))
                                                      : Container(),
                                                ),
                                              )),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                      ))
        ],
      ),
    );
  }
}
