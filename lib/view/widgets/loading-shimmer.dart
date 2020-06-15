import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) => new Container(
                color: Colors.grey[100],
                child: new Center(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text('$index'),
                  ),
                )),
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 2 : 3),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ));
  }
}
