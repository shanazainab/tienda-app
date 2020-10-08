import 'package:firebase_analytics/firebase_analytics.dart';
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

    return Padding(
      padding: const EdgeInsets.only(left:12,right:12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('deals-of-the-day'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                padding: const EdgeInsets.only(right:8.0),
                child: GestureDetector(
                  onTap: (){

                    FirebaseAnalytics()
                        .logEvent(name: "HOME_PAGE_CLICK", parameters: {
                      'section_name': 'deals-of-the-day',
                      'item_type': 'discount',
                      'item_id': dealOfTheDayList[index].discount
                    });

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MultiBlocProvider(
                    //           providers: [
                    //             BlocProvider<FilterBloc>(
                    //               create: (BuildContext context) => FilterBloc(),
                    //             ),
                    //             BlocProvider(
                    //               create: (BuildContext context) =>
                    //               ProductBloc()..add(FetchProductList(
                    //                   query: suggestions[index].suggestion)),
                    //             )
                    //           ],
                    //           child: ProductListPage(
                    //             titleInEnglish: suggestions[index].suggestion,
                    //             query: suggestions[index].suggestion,
                    //             searchBody: new SearchBody(),
                    //           ),
                    //         )));
                  },
                  child: Card(
                    elevation: 0,
                    color: index.isEven?Colors.grey:Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(top:24,left:8.0,right: 8),
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
                ),
              );
            })
            ,
          )
        ],
      ),
    );
  }
}
