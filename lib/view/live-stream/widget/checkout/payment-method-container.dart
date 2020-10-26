import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/saved-cards-state.dart';
import 'package:tienda/model/payment-card.dart';
import 'package:tienda/view/utils/card-number-formatter.dart';

typedef OnRedirection = Function(int index);
typedef OnChosenPayment = Function(PaymentCard paymentCard);

class PaymentMethodContainer extends StatefulWidget {
  final OnRedirection onRedirection;
  final OnChosenPayment onChosenPayment;

  PaymentMethodContainer({this.onRedirection, this.onChosenPayment});

  @override
  _PaymentMethodContainerState createState() => _PaymentMethodContainerState();
}

class _PaymentMethodContainerState extends State<PaymentMethodContainer> {
  TextEditingController expiryDateController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<GlobalKey<FormState>> _cvvKeys = new List();
  bool showCardFields = false;

  String _paymentMethod;
  PaymentCard paymentCard = new PaymentCard();

  int cardId;
  int selectedCard;

  FocusNode textSecondFocusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contextA) {
    return BlocListener<SavedCardBloc, SavedCardStates>(
      listener: (context, state) {
        if (state is LoadSavedCardSuccess) {
          if (state.paymentCards.length == 1)
            paymentCard = state.paymentCards[0];

          for (final card in state.paymentCards) {
            _cvvKeys.add(new GlobalKey<FormState>());
          }
        }
      },
      child: buildPaymentOptionBlock(contextA),
    );
  }

  buildPaymentOptionBlock(BuildContext contextA) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100),
        children: <Widget>[
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                color: Colors.white,
                onPressed: () {
                  widget.onRedirection(0);
                },
              ),
              Text("Choose Your Payment Method")
            ],
          ),
          BlocBuilder<SavedCardBloc, SavedCardStates>(
              builder: (context, state) {
            if (state is LoadSavedCardSuccess) {
              return ListView(
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    'Saved Payment Card',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    itemCount: state.paymentCards.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        RadioListTile(
                          value: "SAVED-CARD-$index",
                          groupValue: _paymentMethod,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text(
                              //   state.paymentCards[index].name,
                              //   style: TextStyle(fontSize: 16),
                              // ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "XXXX XXXX XXXX ${state.paymentCards[index].lastDigits}",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              // Text(
                              //   state.paymentCards[index].bankName,
                              //   style: TextStyle(fontSize: 16),
                              // ),
                            ],
                          ),
                          onChanged: (value) {
                            setState(() {
                              _paymentMethod = value;
                              showCardFields = false;
                              paymentCard = state.paymentCards[index];
                              cardId = state.paymentCards[index].id;
                              selectedCard = index;
                            });
                          },
                          secondary: Image.asset(
                            state.paymentCards[index].cardScheme == "Visa"
                                ? "assets/images/visa.png"
                                : "assets/images/mastercard.png",
                            height: 50,
                            width: 60,
                          ),
                          selected: true,
                        ),
                        Visibility(
                          visible: cardId == state.paymentCards[index].id,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Form(
                              key: _cvvKeys[index],
                              child: Row(
                                children: [
                                  Text("CVV : "),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: TextFormField(
                                      ///TODO: CVV VALIDATION
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(8),
                                        hintStyle: TextStyle(fontSize: 12),
                                        hintText: "CVV",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter CVV';
                                        }
                                        print("ENTERED CVV:${value}");
                                        paymentCard.cvv = value;
                                        print("ENTERED CVV:${paymentCard.cvv}");

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              );
            } else
              return Container();
          }),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Payment Methods",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          RadioListTile(
            value: "COD",
            groupValue: _paymentMethod,
            title: Text('Pay on Delivery'),
            subtitle:
                Text("Cash or card on delivery with service fee of AED 15"),
            onChanged: (value) {
              setState(() {
                _paymentMethod = value;
                showCardFields = false;
                cardId = null;
              });
            },
            selected: false,
          ),
          RadioListTile(
            value: "NEW-CARD",
            groupValue: _paymentMethod,
            title: Text('Credit/Debit Card'),
            subtitle: Text("We accept Visa and MasterCard"),
            onChanged: (value) {
              setState(() {
                paymentCard.type = 'card';
                _paymentMethod = value;
                showCardFields = true;
                cardId = null;
              });
            },
            selected: false,
          ),
          Visibility(
            visible: showCardFields,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Card Number",
                      contentPadding: EdgeInsets.all(8),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(textSecondFocusNode);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      CardNumberInputFormatter()
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter card number';
                      } else {
                        validateTheCardNumber(value);

                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    focusNode: textSecondFocusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Card Name",
                      contentPadding: EdgeInsets.all(8),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        paymentCard.name = value;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showMonthPicker(
                              context: contextA,
                              firstDate: DateTime(
                                  DateTime.now().year, DateTime.now().month),
                              lastDate: DateTime(DateTime.now().year + 2, 12),
                              initialDate: DateTime(
                                  DateTime.now().year, DateTime.now().month),
                              locale: Locale("en"),
                            ).then((date) {
                              if (date != null) {
                                paymentCard.expiryMonth = date.month.toString();
                                paymentCard.expiryYear = date.year.toString();
                                expiryDateController.text =
                                    DateFormat('MM/yyyy').format(date);
                              }
                            });
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: expiryDateController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                                hintStyle: TextStyle(fontSize: 12),
                                hintText: "Expiry Month",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8),
                            hintStyle: TextStyle(fontSize: 12),
                            hintText: "CVV",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter CVV';
                            }
                            paymentCard.cvv = value;
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handlePayNowButton() {
    // BlocProvider.of<LoadingBloc>(context)..add(StartLoading());
    //
    // if (_paymentMethod == "NEW-CARD") {
    //   if (_formKey.currentState.validate()) {
    //     FocusScope.of(context).unfocus();
    //
    //     BlocProvider.of<CheckOutBloc>(context).add(DoCartCheckoutProgressUpdate(
    //         fromLiveStream: true,
    //         addressId: widget.addressId,
    //         card: paymentCard,
    //         presenterId: widget.presenterId));
    //   }
    // } else if (_paymentMethod.startsWith("SAVED-CARD")) {
    //   ///validate cvv
    //   if (_cvvKeys[selectedCard].currentState.validate()) {
    //     FocusScope.of(context).unfocus();
    //
    //     BlocProvider.of<CheckOutBloc>(context).add(DoCartCheckoutProgressUpdate(
    //       addressId: widget.addressId,
    //       card: paymentCard,
    //       fromLiveStream: true,
    //       presenterId: widget.presenterId,
    //     ));
    //   }
    // }
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  validateTheCardNumber(String value) {
    value = getCleanedNumber(value);

    int sum = 0;
    int length = value.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(value[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      paymentCard.number = value;

      return null;
    }

    return "Please Enter a valid number";
  }
}
