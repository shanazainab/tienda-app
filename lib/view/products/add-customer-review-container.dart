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

typedef IsExpanded = Function(bool value);

class AddCustomerReviewContainer extends StatefulWidget {
  final int productId;

  final IsExpanded isExpanded;

  AddCustomerReviewContainer(this.productId, this.isExpanded);

  @override
  _AddCustomerReviewContainerState createState() =>
      _AddCustomerReviewContainerState();
}

class _AddCustomerReviewContainerState
    extends State<AddCustomerReviewContainer> {
  ReviewRequest reviewRequest = new ReviewRequest();

  final TextEditingController reviewTextEditingController =
      new TextEditingController();

  double rating = null;
  ExpandableController expandableController = new ExpandableController();
  final _formKey = GlobalKey<FormState>();
  bool showMessage = false;

  bool valid = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewRequest.images = [null, null, null, null];

    reviewTextEditingController.addListener(() {
      if (reviewTextEditingController.text.length == 0) {
        valid = false;
        setState(() {});
      } else {
        valid = true;
        setState(() {});
      }
    });
    expandableController.addListener(() async {
      if (expandableController.expanded) {
        await Future.delayed(Duration(milliseconds: 200));
        widget.isExpanded(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewStates>(builder: (context, state) {
      if (state is LoadReviewSuccess)
        return Container(
          color: Colors.white,
          child: ExpandableNotifier(
            controller: expandableController,
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Expandable(
                  collapsed: ExpandableButton(
                    child: Container(
                      height: 20,
                      child: Text(AppLocalizations.of(context)
                          .translate('add-your-review')),
                    ),
                  ),
                  expanded: Form(
                    key: _formKey,
                    child: ListView(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ExpandableButton(
                            child: Container(
                              height: 20,
                              child: Text(AppLocalizations.of(context)
                                  .translate('add-your-review')),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: RatingBar(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.blueGrey,
                              ),
                              onRatingUpdate: (value) {
                                print(value);
                                rating = value;
                                print(rating);
                                setState(() {
                                  showMessage = false;
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: showMessage,
                            child: Padding(
                              padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                              child: Text(
                                'Tell us your opinion by assigning a rating',
                                style: TextStyle(
                                    color: Colors.redAccent
                                ),),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: reviewTextEditingController,
                            minLines: 1,
                            maxLines: 2,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please provide your comment";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[200])),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: 80,
                              child: ListView.builder(
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
                                                      imageCache.clear();

                                                      File _image =
                                                          await getCompressedFile(
                                                              image, index);

                                                      reviewRequest
                                                              .images[index] =
                                                          _image;

                                                      print(
                                                          reviewRequest.images);
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

                                                    child: reviewRequest.images[
                                                                index] !=
                                                            null
                                                        ? Image.file(
                                                            reviewRequest
                                                                .images[index],
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Icon(
                                                            Icons.add,
                                                          ),
                                                    // child: Image.file(),
                                                  ),
                                                ),
                                                reviewRequest.images[index] !=
                                                        null
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              reviewRequest
                                                                      .images[
                                                                  index] = null;
                                                              setState(() {});
                                                            },
                                                            child: Icon(
                                                              Icons.cancel,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: RaisedButton(
                                color: valid ? Colors.black : Colors.grey,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  if (rating != null) {
                                    reviewRequest.productId = widget.productId;
                                    reviewRequest.body =
                                        reviewTextEditingController.text;
                                    reviewRequest.rating = rating;
                                    BlocProvider.of<ReviewBloc>(context).add(
                                        AddReview(
                                            state.reviews, reviewRequest));
                                  } else {
                                    setState(() {
                                      showMessage = true;
                                    });
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('submit'),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
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
    Directory tempDir = await getApplicationSupportDirectory();
    String tempPath = tempDir.path;
    final targetPath = "$tempPath/image$index.jpg";

    ///compress image
    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,
      quality: 50,
    );

    print(image.lengthSync());
    print(result.lengthSync());

    return result;
  }
}
