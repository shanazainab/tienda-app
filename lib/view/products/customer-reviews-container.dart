import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/states/review-states.dart';
import 'package:tienda/model/product.dart' as PR;
import 'package:transparent_image/transparent_image.dart';

class CustomerReviewContainer extends StatelessWidget {
  final List<PR.Review> reviews;

  CustomerReviewContainer(this.reviews);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewStates>(builder: (context, state) {
      if (state is LoadReviewSuccess)
        return buildReviewContents(state.reviews, context);
      if (state is AddReviewSuccess)
        return buildReviewContents(state.newReviews, context);
      else
        return Container();
    });
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
                  itemBuilder: (BuildContext context, int index) =>

                      reviews[index].body == ""?Container():Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      reviews[index].body,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(reviews[index].rating.toString()),
                                        Icon(
                                          Icons.star,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                  )
                                ],
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
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  color: Colors.grey[200],
                                                  child:
                                                  FadeInImage.memoryNetwork(
                                                    placeholder: kTransparentImage,
                                                    image:  "${GlobalConfiguration().getString("imageURL")}/${reviews[index].images[subIndex].image}",
                                                    height: 40,
                                                    fit: BoxFit.cover,

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                  )
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ))
        ],
      ),
    );
  }
}
