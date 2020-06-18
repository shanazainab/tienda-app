import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/view/products/product-thubnail-details.dart';

class ProductListPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ProductListPage> {
  final ProductBloc productBloc = new ProductBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBloc.add(FetchProductList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<ProductBloc, ProductStates>(
            bloc: productBloc,
            builder: (context, state) {
              if (state is LoadProductListSuccess) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 860,
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: state.products[index].thumbnail,
                          width: MediaQuery.of(context).size.width / 2,
                          height: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Color(0xfff2f2e4),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        ProductThumbnailDetails(
                          product: state.products[index],
                        )
                      ],
                    ));
                  },
                );
              } else {
                return Container();
              }
            }));
  }
}
