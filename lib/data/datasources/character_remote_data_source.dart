import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters({int page = 1, String? status});
  Future<List<CharacterModel>> searchCharacters(String query, {String? status});
  Future<CharacterModel> getCharacterById(int id);
}
