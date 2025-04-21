import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_tv/screens/home.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 58, 209, 88),
      brightness: Brightness.dark),
  textTheme: GoogleFonts.latoTextTheme(),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.green.shade300,
  ),
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
