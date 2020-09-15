import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/view/presenter-profile/profiles-view-grid.dart';
import 'package:tienda/view/presenter-profile/profiles-view-list.dart';

class SellerProfileViewsMain extends StatefulWidget {
  @override
  _SellerProfileViewsMainState createState() => _SellerProfileViewsMainState();
}

class _SellerProfileViewsMainState extends State<SellerProfileViewsMain>
    with AutomaticKeepAliveClientMixin<SellerProfileViewsMain> {
  List<bool> isSelected = [true, false];
  PresenterBloc presenterBloc = new PresenterBloc();
  SellerProfilesGridView sellerProfilesGridView = SellerProfilesGridView();
  SellerProfileListView sellerProfileListView = SellerProfileListView();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    presenterBloc.add(LoadPresenterList());
    selectedIndex = 0;
    setState(() {

    });
  }

  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (BuildContext context) => presenterBloc,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          title: ToggleButtons(
             color: Colors.black,

            disabledColor: Colors.black,
            fillColor: Colors.black,
            children: <Widget>[
              Icon(Icons.grid_on,size: 18,
              color: selectedIndex ==0?Colors.white:Colors.grey,),
              Icon(Icons.list,size: 18,color: selectedIndex ==1?Colors.white:Colors.grey,),
            ],
            onPressed: (int index) {
              if (index == 0) {
                selectedIndex= 0;
                isSelected = [true,false];
              } else {
                selectedIndex = 1;
                isSelected = [false,true];

              }
              setState(() {});
            },
            isSelected: isSelected,
          ),
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: [sellerProfilesGridView, sellerProfileListView],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
