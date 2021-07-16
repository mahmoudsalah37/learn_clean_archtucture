import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http:Numbersapi.com/{number} endpoint.
  ///
  /// throws a [ServerException] for all error codes.
  Future<NumberTriviaModel?>? getConcreteNumberTrivia(int? number);

  /// Calls the http:Numbersapi.com/random endpoint.
  ///
  /// throws a [ServerException] for all error codes.
  Future<NumberTriviaModel?>? getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel?>? getConcreteNumberTrivia(int? number) async {
    final response = await client.get(
      Uri(
        scheme: 'http',
        host: 'numbersapi.com',
        path: '/$number',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200)
      return NumberTriviaModel.fromJson(json.decode(response.body));
    else {
      throw ServerExceptions();
    }
  }

  @override
  Future<NumberTriviaModel?>? getRandomNumberTrivia() async {
    final response = await client.get(
      Uri(
        scheme: 'http',
        host: 'numbersapi.com',
        path: '/random',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200)
      return NumberTriviaModel.fromJson(json.decode(response.body));
    else {
      throw ServerExceptions();
    }
  }
}
