import 'package:flutter/material.dart';
import 'package:tienda/view/seller-profile/profiles-view-grid.dart';
import 'package:tienda/view/seller-profile/profiles-view-list.dart';

class SellerProfileViewsMain extends StatefulWidget {
  @override
  _SellerProfileViewsMainState createState() => _SellerProfileViewsMainState();
}

class _SellerProfileViewsMainState extends State<SellerProfileViewsMain> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
