import 'package:flutter/material.dart';

class DealsBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Deals Of The Day",
            style: TextStyle(
              fontSize: 20
            ),),
          ),
          SizedBox(
             height: 4,
          ),
          Container(
            height: 120,
            child:ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.only(top:24,left:8.0,right: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Up To",style: TextStyle(
                          fontSize: 14
                        ),),
                        Text("50%",
                        style: TextStyle(
                          fontSize: 24
                        ),),
                        Text("OFF",
                        style: TextStyle(
                          fontSize: 14
                        ),)
                      ],
                    ),
                  ),
                ),
              );
            })
            ,
          )
        ],
      )
    );
  }
}
