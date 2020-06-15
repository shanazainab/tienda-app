import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  GraphQLClient _client;

  GraphQLService() {
    HttpLink link = HttpLink(uri: 'https://countries.trevorblades.com/');

    _client = GraphQLClient(link: link, cache: InMemoryCache());
  }

  Future<QueryResult> performQuery(String query,
      {Map<String, dynamic> variables}) async {
    QueryOptions options =
        QueryOptions(documentNode: gql(query), variables: variables);

    final result = await _client.query(options);

    return result;
  }

  Future<QueryResult> performMutation(String query,
      {Map<String, dynamic> variables}) async {
    MutationOptions options =
        MutationOptions(documentNode: gql(query), variables: variables);

    final result = await _client.mutate(options);

    print(result);

    return result;
  }
}