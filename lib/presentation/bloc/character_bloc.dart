import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/character_repository.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  Timer? _debounce;
  String? _currentFilter;
  String _currentQuery = '';

  CharacterBloc({required this.repository}) : super(CharacterInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<SearchCharacters>(_onSearchCharacters);
    on<FilterCharacters>(_onFilterCharacters);
    on<RefreshCharacters>(_onRefreshCharacters);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (state is CharacterLoading) return;

    emit(CharacterLoading());

    final result = await repository.getCharacters(
        page: event.page, status: _currentFilter);

    result.fold(
      (failure) => emit(CharacterError(failure.message)),
      (characters) => emit(CharacterLoaded(
        characters: characters,
        activeFilter: _currentFilter,
      )),
    );
  }

  Future<void> _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _currentQuery = event.query;

    if (event.query.isEmpty) {
      add(const LoadCharacters());
      return;
    }

    final completer = Completer<void>();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      completer.complete();
    });

    await completer.future;

    if (emit.isDone) return;

    emit(CharacterSearching());

    final result =
        await repository.searchCharacters(event.query, status: _currentFilter);

    if (emit.isDone) return;

    result.fold(
      (failure) => emit(CharacterError(failure.message)),
      (characters) => emit(CharacterSearchLoaded(
        characters,
        activeFilter: _currentFilter,
      )),
    );
  }

  Future<void> _onFilterCharacters(
    FilterCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    _currentFilter = event.status;

    if (_currentQuery.isNotEmpty) {
      emit(CharacterSearching());
      final result = await repository.searchCharacters(_currentQuery,
          status: _currentFilter);

      result.fold(
        (failure) => emit(CharacterError(failure.message)),
        (characters) => emit(CharacterSearchLoaded(
          characters,
          activeFilter: _currentFilter,
        )),
      );
    } else {
      emit(CharacterLoading());
      final result =
          await repository.getCharacters(page: 1, status: _currentFilter);

      result.fold(
        (failure) => emit(CharacterError(failure.message)),
        (characters) => emit(CharacterLoaded(
          characters: characters,
          activeFilter: _currentFilter,
        )),
      );
    }
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final result =
        await repository.getCharacters(page: 1, status: _currentFilter);

    result.fold(
      (failure) => emit(CharacterError(failure.message)),
      (characters) => emit(CharacterLoaded(
        characters: characters,
        activeFilter: _currentFilter,
      )),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
