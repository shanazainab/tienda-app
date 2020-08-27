import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/category.dart';

class TopCategories extends StatelessWidget {
  final List<Category> topCategories;

  TopCategories(this.topCategories);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Column(
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('top-categories'),
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        GridView.builder(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 40/50),
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(
                    topCategories[index].thumbnail,
                  ),
                ),
                Text(appLanguage.appLocal == Locale("en")
                    ? topCategories[index].nameEn
                    : topCategories[index].nameAr,style: TextStyle(
                  fontSize: 10
                ),)
              ],
            ),
          ),
          itemCount: topCategories.length,
        ),
      ],
    );
  }
}
