import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets('GraphQL Widget Test', (WidgetTester tester) async {
    // Set up the GraphQL client
    // final HttpLink httpLink = HttpLink(
    //   uri: 'https://api.example.com/graphql',
    // );
    // final ValueNotifier<GraphQLClient> client = ValueNotifier(
    //   GraphQLClient(
    //     cache: GraphQLCache(),
    //     link: httpLink,
    //   ),
    // );

    // Set up the mock GraphQL response
    final mockResponse = {
      'data': {
        'message': 'Hello, World!',
      },
    };

    // Define the GraphQL query
    const String query = r'''
      query {
        message
      }
    ''';

    // Mock the GraphQL query response
    // final mockQuery = MockQuery(
    //   request: QueryRequest(document: gql(query)),
    //   data: mockResponse,
    // );

    // Build the widget and provide the mock GraphQL client
    // await tester.pumpWidget(GraphQLProvider(
    //   client: client,
    //   child: MyWidget(),
    // ));

    // Use `tester` to interact with the widget and perform assertions
    expect(find.text('Loading...'), findsOneWidget);

    // Wait for the GraphQL query to complete
    await tester.pumpAndSettle();

    // Verify that the widget displays the correct data
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}
