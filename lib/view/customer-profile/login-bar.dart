import 'package:flutter/material.dart';
import 'package:tienda/view/login/login-main-page.dart';

class CustomerLoginMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              "Welcome to Tienda",
              style: TextStyle(fontSize: 20),
            ),
            Text("The world's leading shopping site"),
            Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginMainPage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                        ),
                        Text("Login")
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginMainPage()),
                            );
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.person_add),
                          ),
                        ),
                        Text("Sign Up")
                      ],
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
