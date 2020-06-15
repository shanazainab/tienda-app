import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/bloc/events/home-events.dart';
import 'package:tienda/bloc/home-bloc.dart';
import 'package:tienda/bloc/states/home-states.dart';

class GraphPage extends StatefulWidget {
  GraphPage({Key key}) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List data = [];
  String query;

  @override
  void initState() {
    super.initState();
    query = r'''
        query {
    countries {
      name
    }
}
''';
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('GraphQL Demo'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/loginMainPage');
          },
          icon: FaIcon(
            FontAwesomeIcons.sign,
            size: 16,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (BuildContext context) => HomeBloc()..add(FetchHomeData(query)),
        child: BlocBuilder<HomeBloc, HomeStates>(
          builder: (BuildContext context, HomeStates state) {
            if (state is Loading) {
              return Scaffold(
                appBar: _buildAppBar(),
                body: LinearProgressIndicator(),
              );
            } else if (state is LoadDataFail) {
              return Scaffold(
                appBar: _buildAppBar(),
                body: Center(child: Text(state.error)),
              );
            } else {
              data = (state as LoadDataSuccess).data['countries'];
              return Scaffold(
                appBar: _buildAppBar(),
                body: _buildBody(),
              );
            }
          },
        ));
  }

  Widget _buildBody() {
    return Container(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var item = data[index];
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item['name']),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
