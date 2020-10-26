import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/video/product-video-page.dart';
import 'package:transparent_image/transparent_image.dart';

typedef OnSwitchTabEvent = Function(int index);

class PresenterBioTab extends StatelessWidget {
  final Presenter presenter;
  final OnSwitchTabEvent onSwitchTabEvent;

  PresenterBioTab({this.presenter, this.onSwitchTabEvent});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                presenter.bio == null?"":presenter.bio,
                style: TextStyle(color: Color(0xFF555555), fontSize: 13),
                softWrap: true,
              ),
              SizedBox(
                height: 32,
              ),
              presenter.interests.isNotEmpty?Text("Categories",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)):Container(),
              SizedBox(
                height: 8,
              ),
              Container(
                  child: Wrap(
                children: getCategoryList(presenter.interests),
              )),
              Visibility(
                visible: presenter.videos.isNotEmpty,
                child: Padding(
                    padding: const EdgeInsets.only(top: 42.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${presenter.name}'s Live Videos",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            onSwitchTabEvent(1);
                          },
                          child: Text(
                            "SEE ALL",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC30045)),
                          ),
                        )
                      ],
                    )),
              ),
              Visibility(
                visible: presenter.videos.isNotEmpty,
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                      itemCount: presenter.featuredProducts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Container(
                              width: 181,
                              height: 102,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      OverlayService().addVideoTitleOverlay(
                                          context,
                                          ProductVideoPage(
                                              presenter.videos[index].id),
                                          false,
                                          false);
                                    },
                                    child: FadeInImage.memoryNetwork(
                                      image:
                                          "${presenter.videos[index].lastVideo}",
                                      width: 181,
                                      height: 102,
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("All About Hivebox Freezer",
                                        style: TextStyle(
                                          fontFamily: 'SFProDisplay',
                                          color: Color(0xff282828),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 0.30000001192092896,
                                        )),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "Shonda describes what fuels her passion",
                                          style: TextStyle(
                                            fontFamily: 'SFProDisplay',
                                            color: Color(0xff282828),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 0.30000001192092896,
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("1h 32m",
                                        style: TextStyle(
                                          color: Color(0xff282828),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 0.30000001192092896,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          )),
                ),
              ),
              Visibility(
                visible: presenter.featuredProducts.isNotEmpty,
                child: Padding(
                    padding: const EdgeInsets.only(top: 42.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${presenter.name}'s Products",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            onSwitchTabEvent(2);
                          },
                          child: Text(
                            "SEE ALL",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC30045)),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                    itemCount: presenter.featuredProducts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.only(right: 17),
                          child: GestureDetector(
                            onTap: () {
                              OverlayService().addVideoTitleOverlay(
                                  context,
                                  ProductVideoPage(
                                      presenter.featuredProducts[index].id),
                                  false,
                                  false);
                            },
                            child: Container(
                              width: 154,
                              height: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: FadeInImage.memoryNetwork(
                                      image:
                                          "${presenter.featuredProducts[index].thumbnail}",
                                      width: 117,
                                      height: 117,
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 13.0),
                                    child: Text(
                                      presenter.featuredProducts[index].nameEn,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                      "AED ${presenter.featuredProducts[index].price}",
                                      style: TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 0,
                                      )),
                                  presenter.featuredProducts[index].lastVideo !=
                                          "no-video"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // SvgPicture.asset(
                                            //   "assets/svg/eye.svg",
                                            //   width: 15.999882698059082,
                                            //   height: 12,
                                            //   color: Color(0xffc30045),
                                            // ),
                                            Image.asset(
                                              "assets/icons/eye.png",
                                              width: 15.999882698059082,
                                              height: 12,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text("Watch Review",
                                                style: TextStyle(
                                                  color: Color(0xffc30045),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing:
                                                      0.30000001192092896,
                                                ))
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        )),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  getCategoryList(List<Category> interests) {
    List<Widget> widgets = new List();

    for (final interest in interests) {
      widgets.add(Card(
          elevation: 0,
          color: Color(0xFFF2F3F5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(39)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/svg/chat.svg",
                  height: 12,
                  width: 12,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  interest.nameEn,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          )));
    }
    return widgets;
  }
}
