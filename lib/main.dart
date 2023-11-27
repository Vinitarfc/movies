import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:movies/movies_list.dart';

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

  Future<void> _getListagemAPI() async {
    await Future.delayed(Duration(seconds: 5));
    http.get(
      Uri.https('api.themoviedb.org', '/4/list/1'),
      headers: {
        'Authorization': 'Bearer <<token>>',
        'accept': 'application/json',
      },
    ).then(
      (Response value) {
        if (value.statusCode == 200) {
          movies = MoviesList.fromJson(
            jsonDecode(value.body),
          );
          print(movies.toString());
          setState(() {});
        }
      },
    );
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
          child: Text('Movie: ${movies?.name ?? "Erro"}'),
        ),
      ),
    );
  }
}
