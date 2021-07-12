import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_clean_archtucture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tnumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
  test('should be a subclass of NumberTrivia entity', () async {
    expect(tnumberTriviaModel, isA<NumberTrivia>());
  });
  group('feomJson', () {
    test('should return a valid model when the json number is a integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tnumberTriviaModel);
    });
    test(
        'should return a valid model when the json number is reqarded as a double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tnumberTriviaModel);
    });
  });
  group('toJson', () {
    test('sould return a json map containing the proper data', () async {
      //arrange
      //act
      final result = tnumberTriviaModel.toJson();
      //assert
      final expectMap = {
        "text": "test text",
        "number": 1,
      };
      expect(result, expectMap);
    });
  });
}
