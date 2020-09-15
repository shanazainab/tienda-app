import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/filter-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/products/product-list-page.dart';

class TopCategories extends StatelessWidget {
  final List<Category> topCategories;

  TopCategories(this.topCategories);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            AppLocalizations.of(context)
                .translate('top-categories')
                .toUpperCase(),
            style: TextStyle(color: Colors.grey),
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 3),
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<FilterBloc>(
                              create: (BuildContext context) => FilterBloc(),
                            ),
                            BlocProvider(
                              create: (BuildContext context) => ProductBloc()
                                ..add(FetchProductList(
                                    query: 'get_category',
                                    searchBody: SearchBody(
                                        category: topCategories[index].id))),
                            )
                          ],
                          child: ProductListPage(
                            titleInEnglish:topCategories[index].nameEn,
                            titleInArabic: topCategories[index].nameEn,
                            query: 'get_category',
                            searchBody: new SearchBody(
                                category: topCategories[index].id),
                          ),
                        )));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                        width: 1
                    ),
                    bottom:BorderSide(
                      color: Colors.grey,
                        width: 1

                    ),
                    top: BorderSide(
                      color: Colors.grey,
                        width: 1

                    ),
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1
                    )
                  ),
                ),
                width: 10,
                alignment: Alignment.center,
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                  child: Text(
                    appLanguage.appLocal == Locale("en")
                        ? topCategories[index].nameEn
                        : topCategories[index].nameAr,
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
              ),
            ),
          ),
          itemCount: topCategories.length,
        ),
      ],
    );
  }
}
