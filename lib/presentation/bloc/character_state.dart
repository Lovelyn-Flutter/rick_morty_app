import 'package:equatable/equatable.dart';
import '../../domain/entities/character.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object> get props => [];
}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final bool hasReachedMax;
  final String? activeFilter;

  const CharacterLoaded({
    required this.characters,
    this.hasReachedMax = false,
    this.activeFilter,
  });

  CharacterLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
    String? activeFilter,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object> get props => [characters, hasReachedMax, activeFilter ?? ''];
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object> get props => [message];
}

class CharacterSearching extends CharacterState {}

class CharacterSearchLoaded extends CharacterState {
  final List<Character> characters;
  final String? activeFilter;

  const CharacterSearchLoaded(this.characters, {this.activeFilter});

  @override
  List<Object> get props => [characters, activeFilter ?? ''];
}
