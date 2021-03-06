import 'dart:async';
import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Film> fetchFilm() async {
  print('Getting Film');

 // var url = 'http://kflihan.dynu.net:8083/films/3';    // working web client
 // final response = await http
 // .get(Uri.parse( url)); //,
    //  headers: {
    //    "Accept": "application/json",
    //    "Access-Control-Allow-Origin": "*"
    //  });


  var url = new Uri.http("localhost:8083", "films/6"); // working web client
  print(url);
  var client = http.Client();
  http.Response response = await client.get(url);

   //.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/66'));
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
