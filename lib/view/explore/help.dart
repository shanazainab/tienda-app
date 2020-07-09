import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: CustomAppBar(
          showWishList: false,
          showSearch: false,
          showCart: false,
          showLogo: false,
          title: AppLocalizations.of(context).translate("help"),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200])),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (BuildContext contxt, int index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandableNotifier(
                          // <-- Provides ExpandableController to its children
                          child: Column(
                            children: [
                              Expandable(
                                collapsed: ExpandableButton(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Frequent question ?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),

                                expanded: Column(children: [
                                  ExpandableButton(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "Frequent question ?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "answer answer answer answer answer answer answer answer answer",
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
