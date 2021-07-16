import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_clean_archtucture/core/error/failures.dart';
import 'package:learn_clean_archtucture/core/usecases/usecase.dart';
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
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringTOunsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
    test(
        'Should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
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
    test('Should get data from concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(
              params: Params(number: tNumberParsed)))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConreteNumber(tNumberString));
      await untilCalled(
          mockGetConcreteNumberTrivia(params: Params(number: tNumberParsed)));
      // assert
      verify(
          mockGetConcreteNumberTrivia(params: Params(number: tNumberParsed)));
    });

    test('Should emit [Loading, loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(
              params: Params(number: tNumberParsed)))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForConreteNumber(tNumberString));
    });
    test('Should emit [Loading, Error] when Getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(
              params: Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: serverFailureMessage)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForConreteNumber(tNumberString));
    });
    test(
        'Should emit [Loading, Error] wwith a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(
              params: Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: cacheFailureMessage)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForConreteNumber(tNumberString));
    });
  });
  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('Should get data from random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia.call(params: NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(params: NoParams()));
      // assert
      verify(mockGetRandomNumberTrivia(params: NoParams()));
    });

    test('Should emit [Loading, loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia.call(params: NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('Should emit [Loading, Error] when Getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia.call(params: NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: serverFailureMessage)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test(
        'Should emit [Loading, Error] wwith a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia.call(params: NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: cacheFailureMessage)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
