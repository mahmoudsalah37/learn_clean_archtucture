import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/netowrk_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_model.dart';

typedef Future<NumberTriviaModel?>? _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia?>>? getConcreteNumberTrivia(
      int? number) async {
    return _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia?>>? getRandomNumberTrivia() async {
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia?>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    final isconnected = await networkInfo.isConnected ?? false;
    if (isconnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CasheExceptions {
        return Left(CacheFailure());
      }
    }
  }
}
