import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter.dart';

class LiveStreamBottomBar extends StatelessWidget {
  LiveStreamBottomBar({
    Key key,
    @required this.productsVisibility,
    @required this.presenter,
  }) : super(key: key);

  final BehaviorSubject<bool> productsVisibility;
  final FocusNode textFocusNode = new FocusNode();
  RealTimeController realTimeController = new RealTimeController();
  final Presenter presenter;
  ScrollController scrollController = new ScrollController();
  TextEditingController textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,

      child: SingleChildScrollView(

        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 3 * MediaQuery.of(context).size.width / 4,
                height: 40,
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  focusNode: textFocusNode,
                  controller: textEditingController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (textEditingController.text != null && textEditingController.text.length != 0) {
                              new RealTimeController()
                                  .emitLiveMessage(textEditingController.text, presenter.id);
                              textEditingController.clear();
                            }
                          },
                          icon: Icon(Icons.send)),
                      hintStyle: TextStyle(fontSize: 12, color: Colors.white),
                      contentPadding: EdgeInsets.only(
                          left: 16, top: 0, bottom: 0, right: 0),
                      fillColor: Colors.black54,
                      focusColor: Colors.black.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                          gapPadding: 2,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black54,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.1))),
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.1))),
                      hintText: AppLocalizations.of(context)
                          .translate("type-your-comment")),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.black54,
              radius: 20,
              child: IconButton(
                constraints: BoxConstraints.tight(Size.square(40)),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  productsVisibility.add(!productsVisibility.value);
                },
                icon: Icon(
                  FontAwesomeIcons.box,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              constraints: BoxConstraints.tight(Size.square(40)),
              padding: EdgeInsets.all(0),
              onPressed: () {
                realTimeController.showLiveReaction(presenter.id);
              },
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 16,
                color: Colors.red,
              ),
            ),
            IconButton(
              constraints: BoxConstraints.tight(Size.square(40)),
              padding: EdgeInsets.all(0),
              onPressed: () {
                realTimeController.showLiveReaction(presenter.id);
              },
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 16,
                color: Colors.red,
              ),
            ),
            IconButton(
              constraints: BoxConstraints.tight(Size.square(40)),
              padding: EdgeInsets.all(0),
              onPressed: () {
                realTimeController.showLiveReaction(presenter.id);
              },
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
