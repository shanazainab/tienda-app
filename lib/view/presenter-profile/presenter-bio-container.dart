import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/product-review-page.dart';
import 'package:transparent_image/transparent_image.dart';

class PresenterBioContainer extends StatelessWidget {
  final Presenter presenter;

  PresenterBioContainer(this.presenter);

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
                presenter.bio,
                style: TextStyle(color: Color(0xFF555555), fontSize: 13),
                softWrap: true,
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                    "SEE ALL",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC30045)),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                  child: Wrap(
                children: getCategoryList(presenter.interests),
              )),
              Visibility(
                //visible: presenter.popularVideos.isNotEmpty,
                visible: true,

                child: Padding(
                    padding: const EdgeInsets.only(top: 42.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${presenter.name}'s Live Videos",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                          "SEE ALL",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC30045)),
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
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            height: 160,
                            width: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    OverlayService().addVideoTitleOverlay(
                                        context,
                                        ProductReviewPage(presenter
                                            .featuredProducts[index].id),
                                        false,
                                        false);
                                  },
                                  child: FadeInImage.memoryNetwork(
                                    image:
                                        "${presenter.featuredProducts[index].thumbnail}",
                                    height: 154,
                                    width: 140,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    presenter.featuredProducts[index].nameEn,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                      "AED ${presenter.featuredProducts[index].price}"),
                                )
                              ],
                            ),
                          ),
                        )),
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
                        Text(
                          "SEE ALL",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC30045)),
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
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            height: 160,
                            width: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    OverlayService().addVideoTitleOverlay(
                                        context,
                                        ProductReviewPage(presenter
                                            .featuredProducts[index].id),
                                        false,
                                        false);
                                  },
                                  child: FadeInImage.memoryNetwork(
                                    image:
                                        "${presenter.featuredProducts[index].thumbnail}",
                                    height: 154,
                                    width: 140,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    presenter.featuredProducts[index].nameEn,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                      "AED ${presenter.featuredProducts[index].price}"),
                                )
                              ],
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
