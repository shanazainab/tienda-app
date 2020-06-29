import 'package:flutter/material.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/customer-profile/edit-customer-profile.dart';

class CustomerProfileCard extends StatelessWidget {
  final Customer customerDetails;

  CustomerProfileCard(this.customerDetails);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                radius: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Text("${customerDetails.name}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCustomerProfilePage()),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
