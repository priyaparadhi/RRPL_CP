import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rrpl_app/Views/HomePage.dart';
import 'package:rrpl_app/Views/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RRPL CP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
        });
  }
}
