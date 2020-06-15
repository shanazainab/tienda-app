import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/view/home/graph-page.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CategorySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Zoom(
            opacityScrollBars: 0.0,
            backgroundColor: Colors.white,
            canvasColor: Colors.white,
            centerOnScale: true,
            enableScroll: true,
            doubleTapZoom: true,
            zoomSensibility: 2.3,
            initZoom: 0.0,
            width: 1000,
            height: 1800,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 500.0, bottom: 500),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: 25,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      onTap: (){
                         handleNext(context);
                      },
                      child: new CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: new Text('$index'),
                ),
                    ),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 2 : 3),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 16.0,
              ),
            ))));
  }

  void handleNext(context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/categorySelectionPage"));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GraphPage()),
    );
  }

  buildCircularAvatars() {
    return CircleAvatar(
      maxRadius: 20,
      backgroundColor: Colors.grey[200],
    );
  }
}
