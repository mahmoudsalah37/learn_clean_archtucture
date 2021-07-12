import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learn_clean_archtucture/core/error/failures.dart';
import 'package:learn_clean_archtucture/core/usecases/usecase.dart';
import 'package:learn_clean_archtucture/core/util/input_converter.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_clean_archtucture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure',
    cacheFailureMessage = 'Cache Failure',
    invaildInputFailureMessage =
        'Invaild Input -the number mut be apositive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConreteNumber) {
      final inputEither =
          inputConverter.stringTOunsignedInteger(event.numberString);
      yield* inputEither!.fold((failure) async* {
        yield Error(message: invaildInputFailureMessage);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(params: Params(number: integer ?? 0));
        yield failureOrTrivia!.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia!));
      });
    } else if (event is GetRandomNumberTrivia) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(params: NoParams());
      yield failureOrTrivia!.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (trivia) => Loaded(trivia: trivia!));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'UnExpected error';
    }
  }
}
