import 'package:equatable/equatable.dart';

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

class FilterCharacters extends CharacterEvent {
  final String? status;

  const FilterCharacters({this.status});

  @override
  List<Object> get props => [status ?? ''];
}

class RefreshCharacters extends CharacterEvent {}
