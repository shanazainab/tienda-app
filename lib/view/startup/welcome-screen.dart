import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            height: 3 * MediaQuery.of(context).size.height / 4,
            child: PageIndicatorContainer(
              child: PageView(
                children: <Widget>[
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        "Tienda feature",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                  ),
                  Container(
                    color: Colors.grey[200],
                  ),
                  Container(
                    color: Colors.grey[200],
                  )
                ],
                //  controller: controller,
              ),
              align: IndicatorAlign.bottom,
              length: 4,
              indicatorSpace: 20.0,
              padding: const EdgeInsets.all(10),
              indicatorColor: Colors.white,
              indicatorSelectorColor: Colors.blue,
              shape: IndicatorShape.circle(size: 12),
              // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
              // shape: IndicatorShape.oval(size: Size(12, 8)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 4,
              child: RaisedButton(
                onPressed: () {
                  handleNext(context);
                },
                child: Text("LETS START SHOPPING"),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void handleNext(context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/welcomeScreen"));

    Navigator.pushNamed(context, '/languagePreferencePage');
  }
}
