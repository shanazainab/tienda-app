import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/model/presenter.dart';

class PresenterVideoTab extends StatelessWidget {
  final Presenter presenter;

  PresenterVideoTab(this.presenter);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
              Text("${presenter.name}'s Videos",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w700,
                      fontSize: 13.0),
                  textAlign: TextAlign.left),
              SizedBox(
                width: 4,
              ),
              Text(presenter.videos.length.toString(),
                  style: const TextStyle(
                      color: const Color(0xff000000), fontSize: 13.0),
                  textAlign: TextAlign.left),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          presenter.videos.length == 0
              ? Container(
                  height: MediaQuery.of(context).size.height,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: presenter.videos.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Container(
                                color: Colors.grey[200],
                                width: 156,
                                height: 102,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${GlobalConfiguration().getString("imageURL")}/media/${presenter.videos[index].thumbnail}",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "title",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.30000001192092896,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "Shonda describes what fuels her passion. Salt enhances dishes, pepper changes them.",
                                          style: TextStyle(
                                            fontFamily: 'SFProDisplay',
                                            color: Color(0xff282828),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 0.30000001192092896,
                                          ))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
