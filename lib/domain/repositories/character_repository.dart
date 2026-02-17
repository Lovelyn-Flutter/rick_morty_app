import 'package:dartz/dartz.dart';
import '../entities/character.dart';
import '../../core/utils/failure.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<Character>>> getCharacters({int page = 1});
  Future<Either<Failure, List<Character>>> searchCharacters(String query);
  Future<Either<Failure, Character>> getCharacterById(int id);
}
