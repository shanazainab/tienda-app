import 'package:flutter/material.dart';

class ProductFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text("CLEAR ALL"),
          )
        ],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text('CANCEL'),
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text('APPLY'),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) => Container(
                  color: Colors.grey[200],
                  child: ListTile(

                    title: Text("Filter $index"),
                    onTap: (){},
                  ),
                ),
              ),
            ),
            Container(
              width: 3 * MediaQuery.of(context).size.width / 4,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>Divider(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text("Sub-Filter $index"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
