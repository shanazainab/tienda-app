import 'package:flutter/material.dart';

class DealsBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Deals Of The Day",
            style: TextStyle(
              fontSize: 20
            ),),
            SizedBox(
               height: 4,
            ),
            Container(
              height: 150,
              child:ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 100,
                      width: 80,
                      color: Colors.grey[200],
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
                  ),
                );
              })
              ,
            )
          ],
        ),
      )
    );
  }
}
