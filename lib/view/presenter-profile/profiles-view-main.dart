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

class _SellerProfileViewsMainState extends State<SellerProfileViewsMain> {
  List<bool> isSelected = [true, false];
  PresenterBloc presenterBloc = new PresenterBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    presenterBloc.add(LoadPresenterList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => presenterBloc,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            isSelected[0] ? SellerProfilesGridView() : SellerProfilesListView(),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.grid_on),
                    Icon(Icons.list),
                  ],
                  onPressed: (int index) {
                    if (index == 0) {
                      isSelected[0] = true;
                      isSelected[1] = false;
                    } else {
                      isSelected[0] = false;
                      isSelected[1] = true;
                    }
                    setState(() {});
                  },
                  isSelected: isSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
