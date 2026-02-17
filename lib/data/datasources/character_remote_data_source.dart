import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters({int page = 1});
  Future<List<CharacterModel>> searchCharacters(String query);
  Future<CharacterModel> getCharacterById(int id);
}
