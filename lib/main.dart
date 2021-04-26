import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/homepage',
      routes: {
        '/homepage': (context) => home(),
        '/searchAndUpdate': (context) => searchAndUpdate()
      },
    )
  );
}