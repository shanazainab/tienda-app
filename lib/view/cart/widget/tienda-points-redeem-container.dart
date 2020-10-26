import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';

class TiendaPointsRedeemContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
        builder: (context, subState) {
      if (subState is LoadCustomerProfileSuccess && subState.customerDetails.points == 0) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Color(0xffF15223),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left:8.0,right:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/points.svg",
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${subState.customerDetails.points} Tienda Points available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                ButtonTheme(
                  height: 24,
                  child: RaisedButton(
                      color: Color(0xffD63B0E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)
                      ),
                      child: Text(
                        'REDEEM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {}),
                )
              ],
            ),
          ),
          height: 42,
        );
      } else
        return Container();
    });
  }
}
