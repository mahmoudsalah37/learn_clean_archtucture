import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_clean_archtucture/core/error/exceptions.dart';
import 'package:learn_clean_archtucture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learn_clean_archtucture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  void setUpMockHttpClientSuccess200(int tNumber) {
    when(mockHttpClient.get(
      Uri(
        scheme: 'http',
        host: 'numbersapi.com',
        path: '/$tNumber',
      ),
      headers: {'Content-Type': 'application/json'},
    )).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(int tNumber) {
    when(mockHttpClient.get(
      Uri(
        scheme: 'http',
        host: 'numbersapi.com',
        path: '/$tNumber',
      ),
      headers: {'Content-Type': 'application/json'},
    )).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNUmberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with number being the endpoint and woth application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200(tNumber);
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
        mockHttpClient.get(
          Uri(
            scheme: 'http',
            host: 'numbersapi.com',
            path: '/$tNumber',
          ),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });
    test('should return numberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200(tNumber);

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should Throw a serverException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404(tNumber);

      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call, throwsA(TypeMatcher<ServerExceptions>()));
    });
  });
}
