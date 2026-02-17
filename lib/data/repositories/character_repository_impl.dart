import 'package:dartz/dartz.dart';
import '../../core/utils/failure.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_data_source.dart';

// Repository implementation handling data layer operations

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Character>>> getCharacters({int page = 1}) async {
    try {
      final characters = await remoteDataSource.getCharacters(page: page);
      return Right(characters);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch characters: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> searchCharacters(
      String query) async {
    try {
      final characters = await remoteDataSource.searchCharacters(query);
      return Right(characters);
    } catch (e) {
      return Left(
          ServerFailure('Failed to search characters: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Character>> getCharacterById(int id) async {
    try {
      final character = await remoteDataSource.getCharacterById(id);
      return Right(character);
    } catch (e) {
      return Left(
          ServerFailure('Failed to fetch character details: ${e.toString()}'));
    }
  }
}
