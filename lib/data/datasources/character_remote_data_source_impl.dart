import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../../core/constants/app_constants.dart';
import 'character_remote_data_source.dart';

// Implementation of remote data source using the Rick and Morty API

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;

  CharacterRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CharacterModel>> getCharacters({int page = 1}) async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.characterEndpoint}?page=$page'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'] as List;
      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Future<List<CharacterModel>> searchCharacters(String query) async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.characterEndpoint}?name=$query'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'] as List;
      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to search characters');
    }
  }

  @override
  Future<CharacterModel> getCharacterById(int id) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.characterEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      return CharacterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load character details');
    }
  }
}
