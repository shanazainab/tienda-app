import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/single-product-page.dart';
import 'package:transparent_image/transparent_image.dart';

class PresenterProfileContents extends StatefulWidget {
  final GlobalKey pageViewGlobalKey;

  final Presenter presenter;

  PresenterProfileContents(this.presenter, this.pageViewGlobalKey);

  @override
  _PresenterProfileContentsState createState() =>
      _PresenterProfileContentsState();
}

class _PresenterProfileContentsState extends State<PresenterProfileContents> {
  FollowBloc followBloc = new FollowBloc();

  bool following = false;

  @override
  void initState() {
    super.initState();
    following = widget.presenter.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height / 2,
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl:"${GlobalConfiguration().getString("imageURL")}${widget.presenter.profilePicture}",
              fit: BoxFit.cover,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.presenter.name),
                    Text(
                      widget.presenter.shortDescription,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ButtonTheme(
                    height: 25,
                    minWidth: 30,
                    child: RaisedButton(
                      padding:
                      EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          following = !following;
                        });
                        followBloc.add(ChangeFollowStatus(widget.presenter.id));
                      },
                      child: following
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Following",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          )
                        ],
                      )
                          : Text(
                        AppLocalizations.of(context).translate("follow"),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                )
              ],
            ),
            centerTitle: false,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          widget.presenter.products.toString(),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w200),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("products")
                                .toUpperCase(),
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          widget.presenter.videos.toString(),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w200),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("videos")
                                .toUpperCase(),
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          widget.presenter.followers.toString(),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w200),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("followers")
                                .toUpperCase(),
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Text(
                  widget.presenter.bio,
                  style: TextStyle(color: Colors.grey),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: widget.presenter.popularVideos.isNotEmpty,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("popular-videos")
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold))),
              ),

              ///NOTE: only https video

              Visibility(
                visible: widget.presenter.popularVideos.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        color: Colors.grey,
                        child: Center(
                          child: Icon(Icons.play_circle_outline),
                        ),
                      )),
                ),
              ),

              Visibility(
                visible: widget.presenter.popularVideos.isNotEmpty,
                child: Center(
                    child: FlatButton(
                        onPressed: () {
                          PageView pageView =
                              widget.pageViewGlobalKey.currentWidget;
                          pageView.controller.animateToPage(1,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("see-all"),
                          style: TextStyle(color: Colors.lightBlue),
                        ))),
              ),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
              Visibility(
                visible: widget.presenter.featuredProducts.isNotEmpty,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("featured-products")
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold))),
              ),
            ])),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            ///no.of items in the horizontal axis
            crossAxisCount: 2,
            childAspectRatio: (MediaQuery.of(context).size.width / 2) / 220,
          ),
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            /// To convert this infinite list to a list with "n" no of items,
            /// uncomment the following line:
            /// if (index > n) return null;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        OverlayService().addVideoTitleOverlay(context,SingleProductPage(
                            widget.presenter.featuredProducts[index].id),false);

                      },
                      child: FadeInImage.memoryNetwork(
                        image:
                        "${widget.presenter.featuredProducts[index].thumbnail}",
                        height: 160,
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.presenter.featuredProducts[index].nameEn,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "AED ${widget.presenter.featuredProducts[index].price}"),
                    )
                  ],
                ),
              ),
            );
          }, childCount: widget.presenter.featuredProducts.length),
        )
      ],
    );
  }

}
