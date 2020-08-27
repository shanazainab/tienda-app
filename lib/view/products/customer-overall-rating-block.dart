import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/localization.dart';

class CustomerOverallRatingBlock extends StatefulWidget {
  final double overallRating;
  final Map<String, int> ratings;
  final bool isPurchased;

  CustomerOverallRatingBlock(
      this.overallRating, this.ratings, this.isPurchased);

  @override
  _CustomerOverallRatingBlockState createState() =>
      _CustomerOverallRatingBlockState();
}

class _CustomerOverallRatingBlockState
    extends State<CustomerOverallRatingBlock> {
  double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: Column(
        children: [
          widget.overallRating != 0.0
              ? Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('customer-rating'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        widget.overallRating.toString(),
                                        style: TextStyle(fontSize: 28),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 20,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemCount: widget.ratings.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  widget.ratings.keys
                                                      .toList()[index],
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 4.0, right: 4),
                                                  child: Icon(
                                                    MdiIcons.star,
                                                    size: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                            StepProgressIndicator(
                                              totalSteps: 100,
                                              currentStep: 32,
                                              size: 8,
                                              padding: 0,
                                              selectedColor: Colors.grey[200],
                                              unselectedColor: Colors.black,
                                              roundedEdges: Radius.circular(10),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                widget.ratings.values
                                                    .toList()[index]
                                                    .toString(),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations.of(context)
                            .translate('customer-rating'), style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text("No rating given to this product"),
                        ),
                      ],
                    ),
                  ),
                ),

          ///rating section for purchased customers

          widget.isPurchased?Column(
            children: [
              Text('Tell us your opinion by assigning a rating'),

              SizedBox(
                height: 10,
              ),
              RatingBar(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.blueGrey,
                ),
                onRatingUpdate: (value) {
                  print(value);
                  rating = value;
                  print(rating);
                },
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width -100,
                child: RaisedButton(
                  color: rating != null ? Colors.black : Colors.grey,
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    if (double != null) {}
                  },
                  child: Text(
                    "Rate this product",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ):Container()


        ],
      ),
    );
  }
}
