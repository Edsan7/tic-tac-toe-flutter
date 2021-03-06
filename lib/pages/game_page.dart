import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tictactoe/controller/game_controller.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/dialogs/custom_dialog.dart';
import 'package:tictactoe/enums/player_type.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/models/game_tile.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GAME_TITLE),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () => Share.share(GITHUB),
            child: Text(SHARE, style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPlayerTurn(),
            _buildBoard(),
            _buildScore(),
            _buildPlayerMode(),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  _buildResetButton() {
    return RaisedButton(
      padding: EdgeInsets.all(20),
      child: Text(RESET_BUTTON_LABEL),
      onPressed: _onResetGame,
    );
  }

  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: BOARD_SIZE,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          final tile = _controller.tiles[index];
          return _buildTile(tile);
        },
      ),
    );
  }

  _buildTile(GameTile tile) {
    return GestureDetector(
      onTap: () => _onMarkTile(tile),
      child: Container(
        color: tile.color,
        child: Center(
          child: tile.symbol.isEmpty
              ? Text(tile.symbol)
              : Image.asset(
                  tile.symbol,
                ),
        ),
      ),
    );
  }

  _onMarkTile(GameTile tile) {
    if (!tile.enable) return;

    setState(() {
      _controller.mark(tile);
    });
    _checkWinner();
  }

  _buildPlayerTurn() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Center(
        child: Text(
          _controller.currentPlayer == PlayerType.player1
              ? PLAYER_TURN.replaceAll('[PLAYER]', PLAYER_1_SYMBOL)
              : PLAYER_TURN.replaceAll('[PLAYER]', PLAYER_2_SYMBOL),
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  _buildScore() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            _buildTextScore(PLAYER_1_SYMBOL, 0),
            _buildTextScore(PLAYER_2_SYMBOL, 1),
          ],
        ),
      ),
    );
  }

  Text _buildTextScore(String player, int index) {
    return Text(
      PLAYER_SCORE.replaceAll('[PLAYER]', player) +
          _controller.score[index].toString(),
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold),
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(
          _controller.isSinglePlayer ? SINGLE_PLAYER_MODE : MULTIPLAYER_MODE),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : Icons.group),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      },
    );
  }

  _checkWinner() {
    var winner = _controller.checkWinner();
    if (winner == WinnerType.none) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isSinglePlayer &&
          _controller.currentPlayer == PlayerType.player2) {
        final id = _controller.automaticMoves();
        final tile =
            _controller.tiles.firstWhere((element) => element.id == id);
        _onMarkTile(tile);
      }
    } else {
      var symbol =
          winner == WinnerType.player1 ? PLAYER_1_SYMBOL : PLAYER_2_SYMBOL;
      _showWinnerDialog(symbol);
    }
  }

  _showWinnerDialog(String symbol) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: WIN_TITLE.replaceAll('[SYMBOL]', symbol),
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _showTiedDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: TIED_TITLE,
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _onResetGame() {
    setState(() {
      _controller.initialize();
    });
  }
}
