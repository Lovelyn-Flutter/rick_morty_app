import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/character_repository.dart';
import 'character_event.dart';
import 'character_state.dart';

// Bloc handling character-related events and states, including loading, searching, and refreshing characters

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  Timer? _debounce;

  CharacterBloc({required this.repository}) : super(CharacterInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<SearchCharacters>(_onSearchCharacters);
    on<RefreshCharacters>(_onRefreshCharacters);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (state is CharacterLoading) return;

    emit(CharacterLoading());

    final result = await repository.getCharacters(page: event.page);

    result.fold(
      (failure) => emit(CharacterError(failure.message)),
      (characters) => emit(CharacterLoaded(characters: characters)),
    );
  }

  Future<void> _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

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

    final result = await repository.searchCharacters(event.query);

    if (emit.isDone) return;

    result.fold(
      (failure) => emit(CharacterError(failure.message)),
      (characters) => emit(CharacterSearchLoaded(characters)),
    );
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final result = await repository.getCharacters(page: 1);

    result.fold(
      (failure) => emit(CharacterError(failure.message)),
      (characters) => emit(CharacterLoaded(characters: characters)),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
