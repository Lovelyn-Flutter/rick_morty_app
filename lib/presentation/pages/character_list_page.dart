import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../bloc/character_bloc.dart';
import '../bloc/character_event.dart';
import '../bloc/character_state.dart';
import '../widgets/character_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import 'character_detail_page.dart';

//Where the charcter's are deisplayed in a listview with search and filter options

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<CharacterBloc>().add(const LoadCharacters());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<CharacterBloc>().add(const SearchCharacters(''));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(dialogContext, null, 'All'),
            _buildFilterOption(dialogContext, 'alive', 'Alive'),
            _buildFilterOption(dialogContext, 'dead', 'Dead'),
            _buildFilterOption(dialogContext, 'unknown', 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
      BuildContext dialogContext, String? value, String label) {
    final isSelected = _selectedFilter == value;
    return ListTile(
      title: Text(label),
      leading: Radio<String?>(
        value: value,
        groupValue: _selectedFilter,
        activeColor: AppColors.primary,
        onChanged: (newValue) {
          setState(() {
            _selectedFilter = newValue;
          });
          context.read<CharacterBloc>().add(FilterCharacters(status: newValue));
          Navigator.pop(dialogContext);
        },
      ),
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        context.read<CharacterBloc>().add(FilterCharacters(status: value));
        Navigator.pop(dialogContext);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _selectedFilter != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search characters...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textPrimary),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
                context.read<CharacterBloc>().add(SearchCharacters(value));
              },
            ),
          ),
          if (_selectedFilter != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      'Status: ${_selectedFilter![0].toUpperCase()}${_selectedFilter!.substring(1)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                    deleteIcon:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                    onDeleted: () {
                      setState(() {
                        _selectedFilter = null;
                      });
                      context
                          .read<CharacterBloc>()
                          .add(const FilterCharacters(status: null));
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: BlocBuilder<CharacterBloc, CharacterState>(
              builder: (context, state) {
                if (state is CharacterLoading || state is CharacterSearching) {
                  return const LoadingShimmer();
                } else if (state is CharacterLoaded) {
                  if (state.characters.isEmpty) {
                    return const EmptyState(
                      message: 'No characters found',
                      icon: Icons.person_off,
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      context.read<CharacterBloc>().add(RefreshCharacters());
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.characters.length,
                      itemBuilder: (context, index) {
                        final character = state.characters[index];
                        return CharacterCard(
                          character: character,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CharacterDetailPage(
                                  character: character,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is CharacterSearchLoaded) {
                  if (state.characters.isEmpty) {
                    return const EmptyState(
                      message: 'No characters match your search',
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.characters.length,
                    itemBuilder: (context, index) {
                      final character = state.characters[index];
                      return CharacterCard(
                        character: character,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CharacterDetailPage(
                                character: character,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is CharacterError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<CharacterBloc>().add(const LoadCharacters());
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
