import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_clean_archtucture/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('StringToUnsignedInteger', () {
    test(
        'should return an integer when the string presents an unsigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = inputConverter.stringTOunsignedInteger(str);
      // assert
      expect(result, Right(123));
    });
    test('should return a failure when the string is not an integer', () async {
      // arrange
      final str = 'abc';
      // act
      final result = inputConverter.stringTOunsignedInteger(str);
      // assert
      expect(result, left(InvalidInputFailure()));
    });
    test('should return a failure when the string is not a negative integer',
        () async {
      // arrange
      final str = '-123';
      // act
      final result = inputConverter.stringTOunsignedInteger(str);
      // assert
      expect(result, left(InvalidInputFailure()));
    });
  });
}
