import 'package:flutter/material.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/video/product-video-page.dart';
import 'package:transparent_image/transparent_image.dart';

class PresenterProductsTab extends StatelessWidget {
  final Presenter presenter;

  PresenterProductsTab(this.presenter);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
              Text("${presenter.name}'s Products",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w700,
                      fontSize: 13.0),
                  textAlign: TextAlign.left),
              SizedBox(
                width: 4,
              ),
              Text(presenter.featuredProducts.length.toString(),
                  style: const TextStyle(
                      color: const Color(0xff000000), fontSize: 13.0),
                  textAlign: TextAlign.left),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width / 2 / 225,
                crossAxisCount: 2),
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            itemCount: presenter.featuredProducts.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                OverlayService().addVideoTitleOverlay(
                    context,
                    ProductVideoPage(presenter.featuredProducts[index].id),
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
                        image: "${presenter.featuredProducts[index].thumbnail}",
                        width: 154,
                        height: 140,
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
                    Text("AED ${presenter.featuredProducts[index].price}",
                        style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        )),
                    presenter.featuredProducts[index].lastVideo != "no-video"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    letterSpacing: 0.30000001192092896,
                                  ))
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
