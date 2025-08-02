import 'package:flutter/material.dart';
import 'package:qoute_generator/quote_generator_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      home: quote_generator_home_Page(),
    );
  }
}
