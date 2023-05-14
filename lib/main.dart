
import 'package:flutter/material.dart';

import 'Controller/FilmDetailsFormPage.dart';
import 'Controller/SavedMovieListUI.dart';
import 'package:showcaseview/showcaseview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowCaseWidget(
        builder:  Builder(builder: (context) =>FilmDetailsForm(),
      ))
    );
  }
}


