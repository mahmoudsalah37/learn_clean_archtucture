import 'package:learn_clean_archtucture/core/error/exceptions.dart';
import 'package:learn_clean_archtucture/core/network/netowrk_info.dart';
import 'package:learn_clean_archtucture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:learn_clean_archtucture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:learn_clean_archtucture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/number_trivia_repository.dart';

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
  Future<Either<Failure, NumberTriviaModel?>>? getRandomNumberTrivia() async {
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTriviaModel?>> _getTrivia(
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
