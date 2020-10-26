import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/model/live-video.dart';
import 'package:tienda/view/live-stream/page/live-main-page.dart';

class LiveVideoList extends StatelessWidget {
  final List<LiveVideo> liveContents;

  LiveVideoList(this.liveContents);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Live Videos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) =>
                                LiveContentsBloc()..add(LoadCurrentLiveVideoList()),
                            child: LiveMainPage(),
                          )),
                );
              },
              child: Text("See All".toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    color: Color(0xffc30045),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0,
                  )),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 140,
          child: ListView.builder(
            itemCount: liveContents.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) => Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      height: 100,
                      width: 180,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${GlobalConfiguration().getString("imageURL")}/media/${liveContents[index].thumbnail}",
                        height: 100,
                        width: 180,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            height: 100,
                            width: 180,
                            color: Color(0xFFFFDC98),
                          );
                        },
                        //  placeholder:
                        //  kTransparentImage,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(liveContents[index].presenter.name,
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.30000001192092896,
                      )),
                  Text(liveContents[index].programTitle,
                      style: TextStyle(
                        color: Color(0xff282828),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.30000001192092896,
                      ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
