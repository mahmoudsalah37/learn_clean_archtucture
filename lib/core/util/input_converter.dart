import 'package:dartz/dartz.dart';
import '../error/failures.dart';

class InputConverter {
  Either<Failure, int?>? stringTOunsignedInteger(String? str) {
    try {
      final integer = int.parse(str ?? "");
      return integer < 0 ? throw FormatException() : Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
