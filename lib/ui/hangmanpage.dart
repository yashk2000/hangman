import 'package:flutter/material.dart';

import 'dart:math';

import 'package:sneakyhangman/engine/hangman.dart';

Random random = new Random();

const List<String> progressImages = const [
  'assets/img/progress_0.png',
  'assets/img/progress_1.png',
  'assets/img/progress_2.png',
  'assets/img/progress_3.png',
  'assets/img/progress_4.png',
  'assets/img/progress_5.png',
  'assets/img/progress_6.png',
  'assets/img/progress_7.png',
];

const String victoryImage = 'assets/img/victory.png';

const List<String> alphabet = const [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];

const TextStyle activeWordStyle = TextStyle(
  fontSize: 30.0,
  letterSpacing: 5.0,
);

class HangmanPage extends StatefulWidget {
  final HangmanGame _engine;

  HangmanPage(this._engine);

  @override
  State<StatefulWidget> createState() => _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  bool _showNewGame;
  String _activeImage;
  String _activeWord;
  List<String> _word;
  bool _pressHint = true;

  @override
  void initState() {
    super.initState();

    widget._engine.onChange.listen(this._updateWordDisplay);
    widget._engine.onWrong.listen(this._updateGallowsImage);
    widget._engine.onWin.listen(this._win);
    widget._engine.onLose.listen(this._gameOver);

    this._newGame();
  }

  void _updateWordDisplay(String word) {
    this.setState(() {
      _activeWord = word;
    });
  }

  void _updateGallowsImage(int wrongGuessCount) {
    this.setState(() {
      _activeImage = progressImages[wrongGuessCount];
    });
  }

  void _win([_]) {
    this.setState(() {
      _activeImage = victoryImage;
      this._gameOver();
    });
  }

  void _gameOver([_]) {
    this.setState(() {
      _showNewGame = true;
    });
  }

  void _newGame() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showAlertDialog(context);
    });

    this.setState(() {
      _activeWord = '';
      _activeImage = progressImages[0];
      _showNewGame = false;
      _pressHint = true;
    });
  }

  Widget _renderBottomContent() {
    if (_showNewGame) {
      return RaisedButton(
        child: Text('New Game'),
        onPressed: this._newGame,
      );
    } else {
      final Set<String> lettersGuessed = widget._engine.lettersGuessed;
      return Column(
        children: [
          MaterialButton(
            child: Text("Hint"),
            padding: EdgeInsets.all(2.0),
            onPressed: () {
              if (_pressHint) {
                int rnd = random.nextInt(_activeWord.length);
                print(rnd);
                widget._engine.guessLetter(_word[rnd]);
                log(rnd);
                print(_activeWord.substring(rnd, rnd + 1));
                setState(() {
                  _pressHint = false;
                });
              } else null;
            },
          ),
          Wrap(
            spacing: 1.0,
            runSpacing: 1.0,
            alignment: WrapAlignment.center,
            children: alphabet
                .map(
                  (letter) => MaterialButton(
                  child: Text(letter),
                  padding: EdgeInsets.all(2.0),
                  onPressed: lettersGuessed.contains(letter)
                      ? null
                      : () {
                    widget._engine.guessLetter(letter);
                  }),
            )
                .toList(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sneaky Hangman'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image
            Expanded(
              child: Image.asset(_activeImage),
            ),
            // Word
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(_activeWord, style: activeWordStyle),
              ),
            ),
            // Controls
            Expanded(
              child: Center(
                child: this._renderBottomContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    TextEditingController _controller = new TextEditingController();

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { setState(() {
        _word = _controller.text.toUpperCase().split('');
        widget._engine.newGame(_word);
      });
      Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Word to be guessed!"),
      content: TextFormField(
        keyboardType: TextInputType.number,
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Enter the word:',
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}