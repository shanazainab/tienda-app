import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/address/choose-address-page.dart';
import 'package:tienda/view/login/login-main-page.dart';

class OrderAddressContainer extends StatelessWidget {
  final chosenAddress = new BehaviorSubject<int>();

  @override
  Widget build(BuildContext contextA) {
    return BlocListener<AddressBloc, AddressStates>(listener: (context, state) {
      if (state is LoadAddressSuccess) {
        if (state.deliveryAddresses.length == 1) {
          chosenAddress.add(state.deliveryAddresses[0].id);
        } else {
          for (final address in state.deliveryAddresses) {
            if (address.isDefault) {
              chosenAddress.add(address.id);
            }
          }
        }
      } else if (state is AuthorizationFailed) {
        Navigator.push(
          contextA,
          MaterialPageRoute(builder: (context) => LoginMainPage()),
        );
      } else if (state is AddressEmpty) {
        Navigator.push(
          contextA,
          MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<AddressBloc>(contextA),
                    child: ChooseAddressPage(),
                  )),
        );
      }
    }, child:
        BlocBuilder<AddressBloc, AddressStates>(builder: (context, state) {
      if (state is LoadAddressSuccess)
        return Stack(
          children: <Widget>[
            Container(
                child: buildDefaultAddressBlock(
                    state.deliveryAddresses, contextA)),
            BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
              if (state is LoadCartSuccess) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "TOTAL: AED ${state.cart.cartPrice - 0}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: RaisedButton(
                              onPressed: () {
                                if (chosenAddress.value == null) {
                                  Fluttertoast.showToast(
                                      msg: "Choose a delivery address");
                                } else
                                  BlocProvider.of<CheckOutBloc>(context).add(
                                      DoUpdateCheckOutProgress(
                                          order: new Order(
                                              addressId: chosenAddress.value),
                                          status: "PAYMENT"));
                              },
                              child: Text("CONTINUE"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return Container();
            })
          ],
        );
//      else if (state is AddressEmpty)
//        return Container(
//          child: Column(
//            children: [
//              Text("Add delivery address"),
//              OutlineButton(
//                onPressed: () {
//                  Navigator.push(
//                    contextA,
//                    MaterialPageRoute(
//                        builder: (context) => BlocProvider.value(
//                              value: BlocProvider.of<AddressBloc>(contextA),
//                              child: ChooseAddressPage(),
//                            )),
//                  );
//                },
//                child: Text(
//                  "+ ADD NEW ADDRESS",
//                  style: TextStyle(fontSize: 12),
//                ),
//              ),
//            ],
//          ),
//        );
      else
        return Container();
    }));
  }

  buildDefaultAddressBlock(List<DeliveryAddress> savedAddresses, contextA) {
    return ListView(
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Delivery Address",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: savedAddresses.length,
            itemBuilder: (BuildContext context, int index) {
              return savedAddresses.isNotEmpty
                  ? StreamBuilder<int>(
                      stream: chosenAddress,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        return GestureDetector(
                          onTap: () {
                            chosenAddress.add(savedAddresses[index].id);
                          },
                          child: Container(
                              color: snapshot.data == savedAddresses[index].id
                                  ? Colors.grey[200]
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            child: Icon(
                                              savedAddresses[index]
                                                          .addressType ==
                                                      "villa"
                                                  ? Icons.home
                                                  : Icons.location_city,
                                              size: 16,
                                            )),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              182,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(savedAddresses[index]
                                                .longAddress),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              savedAddresses[index].isDefault
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Text("Default"),
                                                      ),
                                                    )
                                                  : Container(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    contextA,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BlocProvider.value(
                                                              value: BlocProvider
                                                                  .of<AddressBloc>(
                                                                      contextA),
                                                              child:
                                                                  AddAddressPage(
                                                                isEditMode:
                                                                    true,
                                                                fromCheckOut:
                                                                    true,
                                                                deliveryAddress:
                                                                    savedAddresses[
                                                                        index],
                                                              ),
                                                            )),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                    "EDIT",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            child: Icon(
                                              Icons.phone,
                                              size: 16,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                90,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(savedAddresses[index]
                                                      .fullName),
                                                  Text(savedAddresses[index]
                                                      .phoneNumber),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    savedAddresses[index].apartment != "null"
                                        ? Row(
                                            children: <Widget>[
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 50,
                                                  child: Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                  )),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                      savedAddresses[index]
                                                          .apartment),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              )),
                        );
                      })
                  : Container(
                      child: Text("Looks like no address, Add new"),
                    );
            }),
        OutlineButton(
          onPressed: () {
            Navigator.push(
              contextA,
              MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<AddressBloc>(contextA),
                        child: AddAddressPage(
                            isEditMode: true,
                            fromCheckOut: true,
                            deliveryAddress: new DeliveryAddress()),
                      )),
            );
          },
          child: Text(
            "+ ADD NEW ADDRESS",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
