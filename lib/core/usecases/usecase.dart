import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type?>>? call({required Params params});
}

class NoParams extends Equatable {
  List<Object?> get props => [];
}
