import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/view/presenter/widget/profiles-floating-gridview.dart';
import 'package:tienda/view/presenter/widget/profiles-listview.dart';

class ProfilesListingPage extends StatefulWidget {
  @override
  _ProfilesListingPageState createState() => _ProfilesListingPageState();
}

class _ProfilesListingPageState extends State<ProfilesListingPage>
    with AutomaticKeepAliveClientMixin<ProfilesListingPage> {
  List<bool> isSelected = [true, false];
  PresenterBloc presenterBloc = new PresenterBloc();
  ProfilesFloatingGridView sellerProfilesGridView = ProfilesFloatingGridView();
  ProfilesListView sellerProfileListView = ProfilesListView();
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
          centerTitle: false,
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
