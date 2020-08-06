import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/states/review-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/review-request.dart';
import 'package:tienda/view/widgets/image-option-dialogue.dart';

class AddCustomerReviewContainer extends StatefulWidget {
  final int productId;

  AddCustomerReviewContainer(this.productId);

  @override
  _AddCustomerReviewContainerState createState() =>
      _AddCustomerReviewContainerState();
}

class _AddCustomerReviewContainerState
    extends State<AddCustomerReviewContainer> {
  ReviewRequest reviewRequest = new ReviewRequest();

  double rating = 4.0;
  final TextEditingController reviewTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewStates>(builder: (context, state) {
      if (state is LoadReviewSuccess)
        return Container(
          color: Colors.white,
          child: ExpandableNotifier(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Expandable(
                  // <-- Driven by ExpandableController from ExpandableNotifier
                  collapsed: ExpandableButton(
                    // <-- Expands when tapped on the cover photo
                    child: Container(
                      height: 20,
                      child: Text(AppLocalizations.of(context)
                          .translate('add-your-review')),
                    ),
                  ),
                  expanded: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ExpandableButton(
                          // <-- Expands when tapped on the cover photo
                          child: Container(
                            height: 20,
                            child: Text(AppLocalizations.of(context)
                                .translate('add-your-review')),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: reviewTextEditingController,
                          minLines: 2,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[200])),
                          ),
                        ),
                        SizedBox(
                          height: 8,
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
                          height: 80,
                          child: reviewRequest.images != null &&
                                  reviewRequest.images.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: reviewRequest.images.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            print("tapped");
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext bc) {
                                                  return ImageOptionDialogue(
                                                    selectedImage:
                                                        (image) async {
                                                      print(
                                                          "CHOSEN IMAGE IS:$image");

                                                      File _image =
                                                          await getCompressedFile(
                                                              image, index);

                                                      if (reviewRequest
                                                              .images ==
                                                          null) {
                                                        reviewRequest.images = [null,null,null,null];
                                                      }
                                                      reviewRequest.images[index] = _image;

                                                      print(reviewRequest.images);
                                                      setState(() {});
                                                    },
                                                  );
                                                });
                                          },
                                          child: Container(
                                            height: 80,
                                            child: Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Container(
                                                    height: 80,
                                                    color: Colors.grey[200],
                                                    width: 60,

                                                    child:  reviewRequest.images[index]!=null?Image.file(
                                                      reviewRequest.images[index],
                                                      fit: BoxFit.cover,
                                                    ):Icon(Icons.add,),
                                                    // child: Image.file(),
                                                  ),
                                                ),
                                                reviewRequest.images[index]!=null?Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        reviewRequest.images[index] = null;
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.cancel,color: Colors.grey,)),
                                                ):Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            print("tapped");
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext bc) {
                                                  return ImageOptionDialogue(
                                                    selectedImage:
                                                        (image) async {
                                                      print(
                                                          "CHOSEN IMAGE IS:$image");

                                                      File _image =
                                                          await getCompressedFile(
                                                              image, 0);

                                                      if (reviewRequest
                                                              .images ==
                                                          null) {
                                                        reviewRequest.images = [null,null,null,null];
                                                      }
                                                      reviewRequest.images[0] = _image;
                                                      setState(() {});
                                                    },
                                                  );
                                                });
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              height: 80,
                                              color: Colors.grey[200],
                                              width: 60,
                                              child: index == 0
                                                  ? Icon(Icons.add)
                                                  : Container(),
                                              // child: Image.file(),
                                            ),
                                          ),
                                        ),
                                      )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              reviewRequest.productId = widget.productId;
                              reviewRequest.rating = rating;
                              reviewRequest.body =
                                  reviewTextEditingController.text;
                              reviewRequest.rating = rating;

                              BlocProvider.of<ReviewBloc>(context)
                                  .add(AddReview(state.reviews, reviewRequest));
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('submit'),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        );
      else
        return Container();
    });
  }

  Future<File> getCompressedFile(File image, int index) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File compressedImage = new File("$tempPath/image$index.jpg");

    ///compress image
    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      compressedImage.absolute.path,
      quality: 50,
    );

    print(image.lengthSync());
    print(result.lengthSync());

    return result;
  }
}
