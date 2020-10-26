import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/address/google-maps-container.dart';

class ChooseAddressPage extends StatefulWidget {
  ChooseAddressPage();

  @override
  _ChooseAddressPageState createState() => _ChooseAddressPageState();
}

class _ChooseAddressPageState extends State<ChooseAddressPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contextA) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: GoogleMapsContainer((deliveryAddress) {
          if (deliveryAddress != null) {
            Navigator.pushReplacement(
                contextA,
                MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<AddressBloc>(contextA),
                        child: AddAddressPage(
                          isEditMode: false,
                          deliveryAddress: deliveryAddress,
                        ))));
          }
        }));
  }
}
