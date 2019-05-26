import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum BoardState { Empty, Circle, Cross }

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  List<List<BoardState>> _board;

  bool _firstPlayer;

  _MainPage() {
    _board = [
      [BoardState.Empty, BoardState.Empty, BoardState.Empty],
      [BoardState.Empty, BoardState.Empty, BoardState.Empty],
      [BoardState.Empty, BoardState.Empty, BoardState.Empty]
    ];

    _firstPlayer = true;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('> _MainPage.build');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tiny Tic-Tac-Toe'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildElement(0, 0),
              _buildElement(0, 1),
              _buildElement(0, 2)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildElement(1, 0),
              _buildElement(1, 1),
              _buildElement(1, 2)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildElement(2, 0),
              _buildElement(2, 1),
              _buildElement(2, 2)
            ],
          )
        ],
      )),
    );
  }

  // private helper methods
  GestureDetector _buildElement(int row, int col) {
    Border border;
    if (row == 2 && col == 2) {
      border = Border(
          left: BorderSide(width: 6, color: Colors.black),
          top: BorderSide(width: 6, color: Colors.black),
          right: BorderSide(width: 6, color: Colors.black),
          bottom: BorderSide(width: 6, color: Colors.black));
    } else if (row == 2) {
      border = Border(
          left: BorderSide(width: 6, color: Colors.black),
          top: BorderSide(width: 6, color: Colors.black),
          bottom: BorderSide(width: 6, color: Colors.black));
    } else if (col == 2) {
      border = Border(
          left: BorderSide(width: 6, color: Colors.black),
          top: BorderSide(width: 6, color: Colors.black),
          right: BorderSide(width: 6, color: Colors.black));
    } else {
      border = Border(
          left: BorderSide(width: 6, color: Colors.black),
          top: BorderSide(width: 6, color: Colors.black));
    }

    debugPrint('> building element at $row:$col');
    return GestureDetector(
        onTap: () {
          debugPrint('> player clicked on $row:$col');
          _setStone(row, col); // update logic

          // check for end of game
          if (_gameOver()) {
            String who = (_firstPlayer) ? "1." : "2.";
            _showDialog('$who Player has won!');
            _resetGame();
          } else {
            _firstPlayer = !_firstPlayer;
          }
        },
        child: Container(
            width: 90,
            decoration:
                BoxDecoration(shape: BoxShape.rectangle, border: border),
            child: Text(_stoneToChar(_board[row][col]),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 92.0))));
  }

  String _stoneToChar(BoardState state) => (state == BoardState.Cross)
      ? 'X'
      : (state == BoardState.Circle) ? 'O' : ' ';

  void _setStone(int row, int col) {
    if (_board[row][col] != BoardState.Empty) {
      return; // there is already a stone, do nothing
    }

    setState(() {
      _board[row][col] = (_firstPlayer) ? BoardState.Circle : BoardState.Cross;
    });

    _dumpBoard();
  }

  bool _gameOver() {
    BoardState stone = (_firstPlayer) ? BoardState.Circle : BoardState.Cross;

    // test columns
    for (int row = 0; row < 3; row++) {
      if (_board[row][0] == stone &&
          _board[row][1] == stone &&
          _board[row][2] == stone) return true;
    }

    // test rows
    for (int col = 0; col < 3; col++) {
      if (_board[0][col] == stone &&
          _board[1][col] == stone &&
          _board[2][col] == stone) return true;
    }

    // test diagonals
    if (_board[0][0] == stone && _board[1][1] == stone && _board[2][2] == stone)
      return true;
    if (_board[2][0] == stone && _board[1][1] == stone && _board[0][2] == stone)
      return true;

    // could be remis
    int emtpyStones = 0;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (_board[row][col] == BoardState.Empty) {
          emtpyStones++;
          break;
        }
      }
    }
    if (emtpyStones == 0) {
      _showDialog('Remis - Please play again!');
      _resetGame();
    }

    return false;
  }

  void _resetGame() {
    setState(() {
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          _board[row][col] = BoardState.Empty;
        }
      }
      _firstPlayer = true;
    });
  }

  // dialog helper method
  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Tic-Tac-Toe"),
              content: new Text(msg),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  void _dumpBoard() {
    for (int row = 0; row < 3; row++) {
      String line = '';
      for (int col = 0; col < 3; col++) {
        String ch = _stoneToChar(_board[row][col]);
        line += ch;
      }
      print(line);
    }
    print('');
  }
}
