import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';

import '../../app-language.dart';

class DealsBlock extends StatelessWidget {
  final List<Product> dealOfTheDayList;


  DealsBlock(this.dealOfTheDayList);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(AppLocalizations.of(context).translate('deals-of-the-day'),
            style: TextStyle(
              fontSize: 20
            ),),
          ),
          SizedBox(
             height: 4,
          ),
          Container(
    height: appLanguage.appLocal == Locale('en')?120:145,

            child:ListView.builder(
                itemCount: dealOfTheDayList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: index.isEven?Colors.grey:Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.only(top:24,left:8.0,right: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Up To",style: TextStyle(
                          fontSize: 14,
                            color:index.isEven?Colors.black:Colors.white
                        ),),
                        Text("${dealOfTheDayList[index].discount} % OFF",
                        style: TextStyle(
                          fontSize: 24,
                            color:index.isEven?Colors.black:Colors.white

                        ),),
                        Text("OFF",
                        style: TextStyle(
                          fontSize: 14,
                            color:index.isEven?Colors.black:Colors.white

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
