import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            height: 3 * MediaQuery.of(context).size.height / 4 + 60,
            child: PageIndicatorContainer(
              child: PageView(
                children: <Widget>[
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        "DISCOVER",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        "TIENDA",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        "FEATURES",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ),
                  ),

                ],
                //  controller: controller,
              ),
              align: IndicatorAlign.bottom,
              length: 3,
              indicatorSpace: 20.0,
              padding: const EdgeInsets.all(10),
              indicatorColor: Colors.white,
              indicatorSelectorColor: Colors.lightBlue,
              shape: IndicatorShape.circle(size: 8),
              // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
              // shape: IndicatorShape.oval(size: Size(12, 8)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.grey[200],
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 4 - 60,
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                minWidth:  MediaQuery.of(context).size.width - 100,
                height: 46,
                child: RaisedButton(
                  onPressed: () {
                    handleNext(context);
                  },
                  child: Text("EXPLORE THE APP",style: TextStyle(
                    color: Colors.grey[200]
                  ),),
                ),
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
