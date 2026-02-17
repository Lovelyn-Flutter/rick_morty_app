import 'package:equatable/equatable.dart';
import '../../domain/entities/character.dart';

// States for the different states of the CharacterBloc

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

  const CharacterLoaded({
    required this.characters,
    this.hasReachedMax = false,
  });

  CharacterLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [characters, hasReachedMax];
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

  const CharacterSearchLoaded(this.characters);

  @override
  List<Object> get props => [characters];
}
