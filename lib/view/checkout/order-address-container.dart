import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/model/delivery-address.dart';

class OrderAddressContainer extends StatelessWidget {
  final List<DeliveryAddress> deliveryAddresses;

  OrderAddressContainer(this.deliveryAddresses);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressBloc()..add(LoadSavedAddress()),
      child: Container(
        child: buildDefaultAddressBlock(deliveryAddresses)
      ),
    );
  }

  buildDefaultAddressBlock(List<DeliveryAddress> savedAddresses) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: savedAddresses.length,
        itemBuilder: (BuildContext context, int index) {
          return savedAddresses[index].isDefault
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(savedAddresses[index].fullName),
                        Text(savedAddresses[index].phoneNumber),
                        Text(savedAddresses[index].longAddress),
                        Text(savedAddresses[index].buildingName),
                      ],
                    ),
                  ),
                )
              : Container();
        });
  }
}
