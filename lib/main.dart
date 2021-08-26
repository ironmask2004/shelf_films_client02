import 'dart:async';
import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Film> fetchFilm() async {
  print('Getting Film');
  final ipv4 = await Ipify.ipv4();
  print(ipv4); // 98.207.254.136

  final ipv6 = await Ipify.ipv64();
  print(ipv6); // 98.207.254.136 or 2a00:1450:400f:80d::200e

  final ipv4json = await Ipify.ipv64(format: Format.JSON);
  print(ipv4json);

  final response = await http
   .get(Uri.parse('http://kflino.ics.com:8083/films/2'));
  //  .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/66'));
  print("returned " +  response.body.toString());
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Film.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Film');
  }
}

class Film {
 // final int userId;
  final int id;
  final String title;

  Film({
   // required this.userId,
    required this.id,
    required this.title,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
     // userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Film> futureFilm;

  @override
  void initState() {
    super.initState();
    futureFilm = fetchFilm();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Film>(
            future: futureFilm,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
