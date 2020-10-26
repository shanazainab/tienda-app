import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/saved-cards-state.dart';
import 'package:tienda/model/payment-card.dart';
import 'package:tienda/view/widgets/loading-widget.dart';

class SavedCardPage extends StatelessWidget {
  SavedCardBloc savedCardBloc = new SavedCardBloc();

  @override
  Widget build(BuildContext contextB) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: MediaQuery.of(contextB).size.height,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Saved Card",
                        style: Theme.of(contextB).textTheme.headline2),
                  ),
                  BlocBuilder<SavedCardBloc, SavedCardStates>(
                      cubit: savedCardBloc..add(LoadSavedCards()),
                      builder: (context, state) {
                        if (state is LoadSavedCardSuccess)
                          return cardWidget(context, state.paymentCards);
                        if (state is SavedCardEmpty)
                          return Container(
                            height: 400,
                            child: Center(child: Text("No Saved Cards !!")),
                          );
                        else
                          return Center(child: spinKit);
                      }),
                ],
              ),
            ),

          ],
        ));
  }

  cardWidget(contextA, List<PaymentCard> paymentCards) {
    return new ListView.builder(
        shrinkWrap: true,
        itemCount: paymentCards.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      paymentCards[index].cardScheme == "Visa"
                          ? "assets/images/visa.png"
                          : "assets/images/mastercard.png",
                      height: 40,
                      width: 40,
                    ),
                    Text(
                      "XXXX XXXX XXXX ${paymentCards[index].lastDigits}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 4,
                    ),

                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () {
                          savedCardBloc..add(DeleteSavedCard(
                            paymentCards: paymentCards,
                            cardId: paymentCards[index].id
                          ));
                        },
                        child: Text("REMOVE"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
