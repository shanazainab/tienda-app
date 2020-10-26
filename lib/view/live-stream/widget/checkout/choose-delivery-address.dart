import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/widgets/loading-widget.dart';
typedef OnRedirection = Function(int index);
typedef OnSelectedAddress = Function(DeliveryAddress deliveryAddress);

class ChooseDeliveryAddress extends StatelessWidget {

  final OnRedirection onRedirection;
  final OnSelectedAddress onSelectedAddress;

  ChooseDeliveryAddress({this.onRedirection,this.onSelectedAddress});

  @override
  Widget build(BuildContext contextA) {
    return BlocBuilder<AddressBloc, AddressStates>(builder: (context, state) {
      if (state is LoadAddressSuccess)
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Delivery Address",
              style: TextStyle(
                color: Color(0xff282828),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            itemCount: state.deliveryAddresses.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Slidable(
                  // key: slidableKeys[index],
                  // controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    onTap: (){
                      onSelectedAddress(state.deliveryAddresses[index]);
                    },
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(state.deliveryAddresses[index].fullName),
                        Text(state.deliveryAddresses[index].phoneNumber),
                      ],
                    ),
                    title: Text(state.deliveryAddresses[index].longAddress),
                    // trailing: state.deliveryAddresses[index].isDefault
                    //     ? Text("Default")
                    //     : Container(),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      foregroundColor: Colors.white,
                      caption: 'Edit',
                      color: Color(0xff50c0a8),
                      icon: Icons.edit,
                      onTap: () {},
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      foregroundColor: Colors.white,
                      color: Color(0xfff15223),
                      icon: Icons.delete,
                      onTap: () {},
                    ),
                  ],
                ),
              ));
            }),
        FlatButton(
          onPressed: () {

          },
          child: Text(
            "ADD NEW ADDRESS",
              style: TextStyle(
                color: Color(0xff149579),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: 0,

              )
          ),
        ),
      ],
    );
      else
    return Container(
      child: Center(
        child: spinKit,
      ),
    );
    });
  }
}
