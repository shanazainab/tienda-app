import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';

class WatchHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Watch History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        SizedBox(
          height: 16,
        ),
        BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
            builder: (context, state) {
          if (state is LoadWatchHistorySuccess)
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.watchHistory.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      "${GlobalConfiguration().getString("imageURL")}/${state.watchHistory[index].thumbnail}"),
                                )),
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: Center(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.play_arrow),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 2 + 30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.watchHistory[index].title,
                                  softWrap: true,
                                ),
                              ))
                        ],
                      ),
                    ));
          else
            return Container();
        })
      ],
    );
  }
}
