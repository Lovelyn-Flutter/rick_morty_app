// model to serialization/deserialization the api response and also to convert the json data to the character entity

import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required int id,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required String image,
    required String originName,
    required String locationName,
    required List<String> episode,
  }) : super(
          id: id,
          name: name,
          status: status,
          species: species,
          type: type,
          gender: gender,
          image: image,
          originName: originName,
          locationName: locationName,
          episode: episode,
        );

  // Convert JSON response to CharacterModel

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'] ?? '',
      gender: json['gender'],
      image: json['image'],
      originName: json['origin']['name'],
      locationName: json['location']['name'],
      episode: List<String>.from(json['episode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'origin': {'name': originName},
      'location': {'name': locationName},
      'episode': episode,
    };
  }
}
