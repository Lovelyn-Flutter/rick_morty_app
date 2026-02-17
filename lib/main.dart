import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'core/theme/app_theme.dart';
import 'data/datasources/character_remote_data_source_impl.dart';
import 'data/repositories/character_repository_impl.dart';
import 'presentation/bloc/character_bloc.dart';
import 'presentation/pages/character_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterBloc(
        repository: CharacterRepositoryImpl(
          remoteDataSource: CharacterRemoteDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
      child: MaterialApp(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const CharacterListPage(),
      ),
    );
  }
}
