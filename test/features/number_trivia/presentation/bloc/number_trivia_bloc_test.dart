import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_clean_archtucture/core/util/input_converter.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:learn_clean_archtucture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initalState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });
  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParse = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    test(
        'Should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringTOunsignedInteger(any))
          .thenReturn(Right(tNumberParse));
      // act
      bloc.add(GetTriviaForConreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringTOunsignedInteger(any));
      // assert
      verify(mockInputConverter.stringTOunsignedInteger(tNumberString));
    });
    test('Should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringTOunsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [Empty(), Error(message: invaildInputFailureMessage)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForConreteNumber(tNumberString));
    });
  });
}
