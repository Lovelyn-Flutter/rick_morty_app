import 'package:equatable/equatable.dart';

// Events that trigger state changes in CharacterBloc, such as loading character, searchinga and also refreshing characters

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

class LoadCharacters extends CharacterEvent {
  final int page;

  const LoadCharacters({this.page = 1});

  @override
  List<Object> get props => [page];
}

class SearchCharacters extends CharacterEvent {
  final String query;

  const SearchCharacters(this.query);

  @override
  List<Object> get props => [query];
}

class RefreshCharacters extends CharacterEvent {}
