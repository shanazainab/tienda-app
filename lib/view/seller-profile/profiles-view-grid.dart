import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/seller-profile/seller-profile-main-page.dart';
import 'package:zoom_widget/zoom_widget.dart';

class SellerProfilesGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3000,
      child: Zoom(
          opacityScrollBars: 0.0,
          backgroundColor: Colors.white,
          canvasColor: Colors.white,
          centerOnScale: true,
          enableScroll: true,
          doubleTapZoom: true,
          zoomSensibility: 2.3,
          initZoom: 0.0,
          width: 1000,
          height: 2000,
          child: Center(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 100.0, bottom: 100),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 6,
                  itemCount: 50,
                  shrinkWrap: true,

                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: () {
                          print("CHOSEN");

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SellerProfilePage()),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                           ClipRRect(
                             borderRadius: BorderRadius.circular(15.0),
                             child: Container(
                               color: Colors.grey[200],
                               height: 400,
                               width:350
                             ),
                           ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: new Text(
                                AppLocalizations.of(context).translate("sellers"),
                                style: TextStyle(
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(
                      2, 2),
                  padding: EdgeInsets.all(100),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
              ))),
    );
  }
}
