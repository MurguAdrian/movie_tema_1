// ignore_for_file: always_specify_types, use_decorated_box, duplicate_ignore

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MoviePage(),
    );
  }
}

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  bool isloading = true;
  final List<String> _titles = <String>[];
  final List<String> _img = <String>[];
  final List<String> _bck = <String>[];
  final List<int> _years = <int>[];
  final List<int> _run = <int>[];
  final List<String> _dt = <String>[];

  void _getMovies() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      response.body;
      final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
      final List<dynamic> movies = data['movies'] as List<dynamic>;

      for (int i = 0; i < movies.length; i++) {
        final Map<dynamic, dynamic> item = movies[i];
        _titles.add(item['title'] as String);
        _img.add(item['medium_cover_image'] as String);
        _bck.add(item['background_image'] as String);
        _years.add(item['year'] as int);
        _run.add(item['runtime'] as int);
        _dt.add(item['date_uploaded'] as String);
      }
      movies.map((dynamic item) => ['title']);
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext context) {
          if (isloading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return PageView.builder(
            itemCount: _titles.length,
            // ignore: avoid_types_as_parameter_names
            itemBuilder: (BuildContext buildContext, int index) {
              final String title = _titles[index];
              final String img = _img[index];
              final int years = _years[index];
              final int run = _run[index];
              final String dta = _dt[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.greenAccent.withOpacity(0.5),
                      Colors.blue,
                    ],
                  ),
                ),
                // ignore: use_decorated_box
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(img),
                      scale: 0.65,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.greenAccent,
                                Colors.lightBlueAccent,
                              ],
                            ),),
                        child: Column(
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Column(
                                  children: [const Text('Anul Aparitiei'), Text('$years')],
                                ),
                                const Spacer(),
                                Column(
                                  children: [const Text('runtime'), Text('$run times')],
                                ),
                                const Spacer(),
                                Column(
                                  children: [const Text('Data Aparitei pe Site'), Text(dta)],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
