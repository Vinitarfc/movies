import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:movies/movies_list.dart';
import 'package:movies/movies_list_error.dart';
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MoviesList? movies;
  MoviesListError? moviesListError;

  Future<void> _getListagemAPI() async {
    await Future.delayed(Duration(seconds: 5));

    http.get(
      Uri.https('api.themoviedb.org', '/4/list/1'),
      headers: {
        'Authorization': 'Bearer ${Config.apiToken}',
        'accept': 'application/json',
      },
    ).then(
      (Response value) {
        if (value.statusCode == 200) {
          movies = MoviesList.fromJson(
            jsonDecode(value.body),
          );
        } else if ([401, 404, 500].contains(value.statusCode)) {
          moviesListError = MoviesListError.fromJson(jsonDecode(value.body));
        }
      },
    ).whenComplete(() => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    _getListagemAPI();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: moviesListError != null
              ? Text(moviesListError.toString())
              : Text('Movie: ${movies?.name ?? "Erro"}'),
        ),
      ),
    );
  }
}
