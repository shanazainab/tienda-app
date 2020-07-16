import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CustomerOverallRatingBlock extends StatelessWidget {
  final List<String> ratings = ['2', '3', '4', '5'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Overall Rating"),
                      Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: RatingBar(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemSize: 16,
                          //unratedColor: Colors.grey,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: null
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                      itemCount: ratings.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ratings[index],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 4),
                                      child: Icon(
                                        MdiIcons.star,
                                        color: Colors.amber,
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
                                  selectedColor: Colors.yellow,
                                  unselectedColor: Colors.cyan,
                                  roundedEdges: Radius.circular(10),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("100"),
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
    );
  }
}
