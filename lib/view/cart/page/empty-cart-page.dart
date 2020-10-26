import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';

class EmptyCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        BlocProvider.of<BottomNavBarBloc>(context)
            .add(ChangeBottomNavBarState(0, false));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,

          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: (){
              BlocProvider.of<BottomNavBarBloc>(context)
                  .add(ChangeBottomNavBarState(0, false));
            },
          ),
          brightness: Brightness.light,
          title: Text("Shopping bag",
              style: TextStyle(
                color: Color(0xff282828),
                fontSize: 19,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: 0,

              )
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/svg/empty-cart.svg",
                ),
                Text("Your shopping bag is empty.",
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      color: Color(0xff637381),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
