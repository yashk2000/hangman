import 'package:flutter/material.dart';
import 'package:sneakyhangman/ui/hangmanpage.dart';


import 'engine/hangman.dart';

void main() => runApp(HangmanApp());

class HangmanApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  HangmanGame _engine;

  @override
  void initState() {
    super.initState();

    _engine = HangmanGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HangmanPage(_engine),
    );
  }
}