import 'bovespa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async => runApp(MaterialApp(
    debugShowCheckedModeBanner: false, home: Bovespa(), theme: _themeData));

ThemeData get _themeData {
  return ThemeData(
      hintColor: Colors.blue,
      primaryColor: Colors.amber,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFA9C159))),
        hintStyle: TextStyle(color: Color(0xFFA9C159)),
      ));
}
