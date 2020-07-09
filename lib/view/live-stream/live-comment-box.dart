import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';

class LiveCommentBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top:16),
        shrinkWrap: true,
        separatorBuilder: (BuildContext context,int index) => Divider(
          indent: 8,
          endIndent: 8,
        ),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) => Container(
          height: appLanguage.appLocal != Locale('en')?52:40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey,
              ),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "message",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Text(
                  '2 mins ago',
                  style: TextStyle(fontSize: 8,
                  fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
