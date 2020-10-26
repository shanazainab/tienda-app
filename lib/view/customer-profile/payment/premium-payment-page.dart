import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PremiumPaymentPage extends StatelessWidget {
  TextEditingController expiryDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildPaymentOptionBlock(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "100 AED",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RaisedButton(
                        onPressed: () {
                          ///call api to go premium
                        },
                        child: Text("PAY NOW"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildPaymentOptionBlock(BuildContext contextA) {
    return Container(
      height: MediaQuery.of(contextA).size.height - 100,
      child: ListView(
        physics: ScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'SAVED PAYMENT METHODS',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Emirates NBD',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'xxxxxxx3424',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/visa.png",
                height: 50,
                width: 60,
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "OTHER PAYMENT METHODS",
            style: TextStyle(color: Colors.grey),
          ),
          ListTile(
            title: Text('Pay on delivery'),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
          ExpansionTile(
            title: Text('Credit/Debit Card'),
            trailing: Icon(Icons.keyboard_arrow_down),
            children: [
              ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Card Number",
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Card Name",
                    ),
                  ),
                  SizedBox(height: 8,),

                  GestureDetector(
                    onTap: () {
                      showMonthPicker(
                        context: contextA,
                        firstDate: DateTime(DateTime.now().year - 1, 5),
                        lastDate: DateTime(DateTime.now().year + 1, 9),
                        initialDate: DateTime(DateTime.now().year - 1, 5),
                        locale: Locale("en"),
                      ).then((date) {
                        if (date != null) {
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
                          hintText: "Expiry Month",
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          ListTile(
            title: Text('Apple Pay'),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
          ListTile(
            title: Text('Net Banking'),
            trailing: Icon(Icons.keyboard_arrow_down),
          )
        ],
      ),
    );
  }
}
