import 'package:flutter/material.dart';
import 'package:tienda/model/customer.dart';

class CustomerProfileCard extends StatelessWidget {
  final Customer customerDetails;

  CustomerProfileCard(this.customerDetails);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:100.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                radius: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${customerDetails.name}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.edit,
                      size: 8,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
