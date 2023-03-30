import 'package:flutter/material.dart';
import 'package:notes/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

ColorScheme colorScheme = const ColorScheme(
  primary:Color.fromARGB(30, 0, 0, 200),
  secondary: Color.fromARGB(250, 100, 120, 200),
  surface: Color.fromARGB(250, 250, 200, 200),
  background: Color.fromARGB(110, 200, 90, 210),
  error: Color.fromARGB(200, 250, 0, 0),
  onPrimary: Color.fromARGB(90, 200, 150, 200),
  onSecondary: Color.fromARGB(150, 60, 100, 150),
  onSurface: Color.fromARGB(200, 200, 100, 100),
  onBackground: Color.fromARGB(100, 20, 20, 200),
  onError: Color.fromARGB(180, 100, 150, 100),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',

      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: colorScheme,
        primaryColor: const Color.fromARGB(90, 90, 90, 90),
        fontFamily: 'Raleway',
      ),
      home: const HomePage(title: ' '),
    );
  }
}
