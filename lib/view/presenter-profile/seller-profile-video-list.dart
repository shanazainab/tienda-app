import 'package:flutter/material.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/presenter-profile/seller-product-video-page.dart';

class SellerProfileVideoList extends StatelessWidget {
  final GlobalKey pageViewGlobalKey;
  final Presenter presenter;

  SellerProfileVideoList(this.presenter, this.pageViewGlobalKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellerProductVideoPage()),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 90,
                        height: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Video $index"),
                        Text("Seller name"),
                        Text(
                          "2M views",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
