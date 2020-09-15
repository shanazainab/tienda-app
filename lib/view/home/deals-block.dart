import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/view/products/product-list-page.dart';

import '../../app-language.dart';

class DealsBlock extends StatelessWidget {
  final List<Product> dealOfTheDayList;


  DealsBlock(this.dealOfTheDayList);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(AppLocalizations.of(context).translate('deals-of-the-day').toUpperCase(),
            style: TextStyle(
              color: Colors.grey
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
                child: GestureDetector(
                  onTap: (){
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
      )
    );
  }
}
